#include "nem_glog.h"

NEMGlog::NEMGlog(char *argv[])
{
    google::InitGoogleLogging(argv[0]);
    configureGoogleLog();
}

NEMGlog::~NEMGlog()
{
    google::ShutdownGoogleLogging();
}

void NEMGlog::setlogInfo(const QString &logMessage)
{
    LOG(INFO) << logMessage.toStdString();
}

void NEMGlog::configureGoogleLog()
{
    FLAGS_log_dir = "";
    google::SetLogDestination(google::GLOG_INFO, "INFO_");
    google::SetStderrLogging(google::GLOG_INFO);

    FLAGS_logtostderr = false;
    FLAGS_alsologtostderr = false;
    FLAGS_logbufsecs = 0;       //
    FLAGS_max_log_size = 10;    // MB
    FLAGS_stop_logging_if_full_disk = true;
}
