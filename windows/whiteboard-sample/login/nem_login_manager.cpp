#include "nem_login_manager.h"
#include <QApplication>
#include <QCryptographicHash>
#include <QDebug>
#include <QRandomGenerator>
#include "http/nem_http_api.h"

NEMLoginManager::NEMLoginManager() {}

NEMLoginManager::~NEMLoginManager() {}

bool NEMLoginManager::init() {
    SDKConfig sdkConfig;
    sdkConfig.database_encrypt_key_ = "Netease";
    if (!Client::Init(m_appKey.toStdString(), "", "", sdkConfig)) {
        return false;
    }

    qInfo() << "Client::GetSDKVersion()" << QString::fromStdString(Client::GetSDKVersion());

    qInfo() << "NEMLoginManager::init success";

    Client::RegKickoutCb([](const KickoutRes& kickout_res) {
        qInfo() << "Client::RegKickoutCb";
        qInfo() << kickout_res.kick_reason_;
    });

    Client::RegReloginCb([](const LoginRes& loginResult) {
        qInfo() << "Client::RegReloginCb";
        qInfo() << loginResult.res_code_;
    });

    Client::RegDisconnectCb([]() { qInfo() << "Client::RegDisconnectCb"; });

    Client::RegMultispotLoginCb([](const MultiSpotLoginRes& result) { qInfo() << "Client::RegMultispotLoginCb" << result.notify_type_; });

    //初始化成功后，先注册后登陆
    auto randomNumber = QRandomGenerator::global()->bounded(100000, 999999);
    QString userName = "user" + QString::number(randomNumber);
    QString nickName = userName;
    QString strPassword = "123456";
    strPassword = QCryptographicHash::hash(strPassword.toUtf8(), QCryptographicHash::Md5).toHex();

    NEMRequest* request = NEMHttpApi::registerAccount(userName, nickName, strPassword, m_appKey);
    connect(request, &NEMRequest::onSuccess, [=](const QString& response) { login(userName, strPassword); });
    connect(request, &NEMRequest::onFail, [=](int errType, int errCode, const QString& err) {
        qInfo() << "registerAccount Fail";
        if (err == "already register") {
            login(userName, strPassword);
            return;
        }

        emit loginFailed();
    });

    return true;
}

void NEMLoginManager::release() {
    Client::Cleanup2();
}

void NEMLoginManager::login(const QString& user, const QString& password) {
    m_account = user;
    m_password = password;

    Client::Login(m_appKey.toStdString(), user.toStdString(), password.toStdString(), [this](const LoginRes& loginResult) {
        qInfo() << "loginResult.res_code_: " << loginResult.res_code_;

        if (loginResult.res_code_ == kNIMResSuccess && loginResult.login_step_ == kNIMLoginStepLogin) {
            emit loginFinished();
        } else if (loginResult.res_code_ != kNIMResSuccess && loginResult.login_step_ == kNIMLoginStepLogin) {
            emit loginFailed();
        }
    });
}

void NEMLoginManager::logout() {
    Client::Logout(kNIMLogoutChangeAccout, [=](NIMResCode logoutCode) {
        qInfo() << "Client::Logout";
        qInfo() << logoutCode;
    });
}

QString NEMLoginManager::getAccount() const {
    return m_account;
}

QString NEMLoginManager::getPassword() const {
    return m_password;
}

QString NEMLoginManager::getAppKey() const {
    return m_appKey;
}
