//
//  NTESEnterRoomViewController.m
//  NIMEducationDemo
//
//  Created by fenric on 16/4/6.
//  Copyright © 2016年 Netease. All rights reserved.
//

#import "NTESEnterRoomViewController.h"
#import "NTESLoginManager.h"
#import "NTESLoginViewController.h"
#import "NTESPageContext.h"
#import <NIMSDK/NIMSDK.h>
#import "NTESLogManager.h"
#import "UIView+NTES.h"
#import "UIView+Toast.h"
#import "SVProgressHUD.h"
#import "NTESMeetingViewController.h"
#import "AppDelegate.h"
#import <UIKit/UIKit.h>
#import "UIDevice+Orientation.h"

@interface NTESEnterRoomViewController ()
@property (weak, nonatomic) IBOutlet UITextField *joinRoomTextField;
@property (weak, nonatomic) IBOutlet UIImageView *logo;
@end

@implementation NTESEnterRoomViewController

NTES_USE_CLEAR_BAR

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self configStatusBar];
    
    //点击导航栏返回按钮的时候调用，所以Push出的控制器最好禁用侧滑手势：
    AppDelegate * appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    appDelegate.allowRotation = NO;//关闭横屏仅允许竖屏
    //切换到竖屏
    [UIDevice switchNewOrientation:UIInterfaceOrientationPortrait];
}

#pragma mark - Notification
- (void)keyboardWillShow:(NSNotification*)notification{
    NSDictionary* userInfo = [notification userInfo];
    NSTimeInterval animationDuration;
    UIViewAnimationCurve animationCurve;
    CGRect keyboardFrame;
    [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
    [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];
    [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardFrame];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:animationDuration];
    [UIView setAnimationCurve:animationCurve];
    CGFloat bottomSpacing = 10.f;
    UIView *inputView = self.joinRoomTextField.superview;
    if (inputView.bottom + bottomSpacing > CGRectGetMinY(keyboardFrame)) {
        CGFloat delta = inputView.bottom + bottomSpacing - CGRectGetMinY(keyboardFrame);
        inputView.bottom -= delta;
    }
    [UIView commitAnimations];
}

#pragma mark - Private
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    [_joinRoomTextField resignFirstResponder];
}

- (BOOL)checkRoomId{
    NSString *roomId = [_joinRoomTextField text];
    return roomId.length != 0;
}

- (IBAction)onJoinRoom:(id)sender {
    [_joinRoomTextField resignFirstResponder];
    
    if (!self.checkRoomId) {
        [self.view makeToast:@"房间号为空"
                    duration:2
                    position:CSToastPositionCenter];
        
        return;
    }

    [self enterChatroomWithRoomId:[_joinRoomTextField text]];
}

- (void)enterChatroomWithRoomId:(NSString *)roomId {
    [SVProgressHUD show];
    
    [self exitChatroomWithRoomId:roomId completion:^(NSError * _Nullable error) {
        NIMChatroomEnterRequest *request = [[NIMChatroomEnterRequest alloc] init];
        request.roomId = roomId;
        __weak typeof(self) weakSelf = self;
        [[NIMSDK sharedSDK].chatroomManager enterChatroom:request
                                               completion:^(NSError * _Nullable error, NIMChatroom * _Nullable chatroom, NIMChatroomMember * _Nullable me) {
            [SVProgressHUD dismiss];
            if (!error) {
                NTESMeetingViewController *vc = [[NTESMeetingViewController alloc] initWithChatroom:chatroom];
                [weakSelf.navigationController pushViewController:vc animated:YES];
            } else {
                [weakSelf.view makeToast:@"进入聊天室失败，请重试" duration:2.0 position:CSToastPositionCenter];
            }
        }];
    }];
}

- (void)exitChatroomWithRoomId:(NSString *)roomId completion:(NIMChatroomHandler)completion{
    [[NIMSDK sharedSDK].chatroomManager exitChatroom:roomId completion:^(NSError * _Nullable error) {
        if (completion) {
            completion(error);
        }
    }];
}

- (void)onTouchLogout:(id)sender
{
    [[NIMSDK sharedSDK].loginManager logout:^(NSError *error) {
        [[NTESLoginManager sharedManager] setCurrentNTESLoginData:nil];
        [[NTESPageContext sharedInstance] setupMainViewController];
    }];
}

- (void)configStatusBar{
    UIStatusBarStyle style = [self preferredStatusBarStyle];
    [[UIApplication sharedApplication] setStatusBarStyle:style
                                                animated:NO];
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}


@end
