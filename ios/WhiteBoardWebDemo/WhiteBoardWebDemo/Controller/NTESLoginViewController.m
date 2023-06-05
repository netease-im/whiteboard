//
//  NTESLoginViewController.m
//  WhiteBoardWebDemo
//
//  Created by zhangchenliang on 2021/7/7.
//

#import "NTESLoginViewController.h"
#import "NTESWhiteBoardViewController.h"
#import "NTESContentView.h"
#import "WhiteBoardConfig.h"
#import "UIImage+NTES.h"

#import <Masonry/Masonry.h>
#import <Toast/UIView+Toast.h>

//    sample code 中获取 auth 的流程如下：
//    1. webview 通过 webGetAuth 请求 auth
//    2. 客户端请求自己的服务获取 auth
//    3. 客户端通过 jsSendAuth 返回 auth

static NSString * const kWhiteBoardWebViewUrl = @"https://app.yunxin.163.com/webdemo/whiteboard/webview.html";

@interface NTESLoginViewController ()

@property (nonatomic, strong) UIImageView *backgroundView;
@property (nonatomic, strong) UIScrollView *containerView;

@property (nonatomic, strong) NTESContentView *channelNameView;
@property (nonatomic, strong) UIButton *joinButton;

@property (nonatomic, assign) NSUInteger uid;

@property (nonatomic, strong) NSURLSessionDataTask *dataTask;

@end

@implementation NTESLoginViewController

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (@available(iOS 11.0, *)) {
        
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    [self setupLayout];
    [self triggerNetworkAuthorization];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    UIEdgeInsets safeAreaInsets = UIEdgeInsetsZero;
    if (@available(iOS 11.0, *)) {
        safeAreaInsets = [UIApplication sharedApplication].keyWindow.safeAreaInsets;
    } else {
        if ([UIDevice currentDevice].orientation == UIDeviceOrientationPortrait) {
            safeAreaInsets = UIEdgeInsetsMake(20, 0, 0, 0);
        }
    }
    
    [_containerView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(safeAreaInsets.top);
        make.left.equalTo(self.view).offset(safeAreaInsets.left);
        make.bottom.equalTo(self.view).offset(-safeAreaInsets.bottom);
        make.right.equalTo(self.view).offset(-safeAreaInsets.right);
    }];
    [_containerView setNeedsLayout];
    [_containerView layoutIfNeeded];
}

#pragma mark - Private

- (void)setupLayout {
    UIEdgeInsets safeAreaInsets = UIEdgeInsetsZero;
    if (@available(iOS 11.0, *)) {
        safeAreaInsets = [UIApplication sharedApplication].keyWindow.safeAreaInsets;
    } else {
        if ([UIDevice currentDevice].orientation == UIDeviceOrientationPortrait) {
            safeAreaInsets = UIEdgeInsetsMake(20, 0, 0, 0);
        }
    }
    
    [self.view addSubview:self.backgroundView];
    [_backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.size.equalTo(self.view);
    }];
    
    [self.view addSubview:self.containerView];
    [_containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(safeAreaInsets.top);
        make.left.equalTo(self.view).offset(safeAreaInsets.left);
        make.bottom.equalTo(self.view).offset(-safeAreaInsets.bottom);
        make.right.equalTo(self.view).offset(-safeAreaInsets.right);
    }];
    
    [self fillUpDefaultValue];
    
    NSArray<UIView *> *viewArray = @[_channelNameView,
                                     self.joinButton];
    
    [_containerView addSubview:_channelNameView];
    [_containerView addSubview:_joinButton];
    
    [_channelNameView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_containerView).offset(-30);
        make.centerX.equalTo(_containerView);
        make.width.equalTo(_containerView);
        make.height.mas_equalTo(50);
    }];
    [_joinButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_containerView).offset(30);
        make.centerX.equalTo(_containerView);
        make.width.mas_equalTo(240);
        make.height.mas_equalTo(50);
    }];
    
    [_containerView setContentSize:CGSizeMake(_containerView.frame.size.width, viewArray.count * 50 + (viewArray.count - 1) * 10)];
}

- (void)fillUpDefaultValue {
    _uid = arc4random() % RAND_MAX;
    
    [self.channelNameView refreshWithTitle:@"房间号" content:@""];
}

- (void)triggerNetworkAuthorization {
    // 触发网络权限弹窗
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"https://cn.bing.com"]];
    NSURLSession *session = [NSURLSession sharedSession];
    __weak typeof(self) weakSelf = self;
    _dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error == nil) {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
            NSLog(@"%@",dict);
        }
        
        weakSelf.dataTask = nil;
    }];
    [_dataTask resume];
}

#pragma mark - Actions

- (void)joinRoomAction:(id)sender {
    NSString *channelName = [_channelNameView getContent];
    if (channelName.length == 0) {
        [self.view makeToast:@"参数不能为空" duration:1.0 position:CSToastPositionCenter];
        
        return;
    }
    
    NTESWhiteBoardParam *param = [[NTESWhiteBoardParam alloc] init];
    param.channelName = channelName;
    param.appKey = kAppKey;
    param.uid = _uid;
    param.webViewUrl = kWhiteBoardWebViewUrl;
    
    NTESWhiteBoardViewController *whiteBoardVC = [[NTESWhiteBoardViewController alloc] initWithWhiteBoardParam:param];
    [self presentViewController:whiteBoardVC animated:YES completion:nil];
}

#pragma mark - Getter

- (UIImageView *)backgroundView {
    if (!_backgroundView) {
        _backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"login_bg"]];
    }
    
    return _backgroundView;
}

- (UIScrollView *)containerView {
    if (!_containerView) {
        _containerView = [[UIScrollView alloc] initWithFrame:CGRectZero];
        _containerView.backgroundColor = [UIColor clearColor];
        _containerView.contentInset = UIEdgeInsetsMake(0, 0, 20, 0);
        _containerView.showsHorizontalScrollIndicator = NO;
        _containerView.showsVerticalScrollIndicator = NO;
        if (@available(iOS 11.0, *)) {
            _containerView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    
    return _containerView;
}

- (NTESContentView *)channelNameView {
    if (!_channelNameView) {
        _channelNameView = [[NTESContentView alloc] initWithFrame:CGRectZero];
    }
    
    return _channelNameView;
}

- (UIButton *)joinButton {
    if (!_joinButton) {
        UIColor *buttonColor = [UIColor colorWithRed:0 green:122/255.0f blue:1 alpha:1];
        _joinButton = [[UIButton alloc] initWithFrame:CGRectZero];
        _joinButton.layer.cornerRadius = 5;
        _joinButton.layer.masksToBounds = YES;
        [_joinButton setTitle:@"加入房间" forState:UIControlStateNormal];
        [_joinButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_joinButton setBackgroundImage:[UIImage imageWithColor:buttonColor] forState:UIControlStateNormal];
        [_joinButton setBackgroundImage:[UIImage imageWithColor:[buttonColor colorWithAlphaComponent:0.5]] forState:UIControlStateHighlighted];
        [_joinButton.titleLabel setFont:[UIFont systemFontOfSize:16.0]];
        [_joinButton addTarget:self action:@selector(joinRoomAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _joinButton;
}

@end
