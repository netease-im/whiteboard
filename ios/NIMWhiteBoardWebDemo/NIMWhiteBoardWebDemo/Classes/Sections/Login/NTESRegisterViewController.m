//
//  NTESRegisterViewController.m
//  NIM
//
//  Created by amao on 8/10/15.
//  Copyright (c) 2015 Netease. All rights reserved.
//

#import "NTESRegisterViewController.h"
#import "NTESDemoService.h"
#import "NSString+NTES.h"
#import "UIView+Toast.h"
#import "UIView+NTES.h"
#import "SVProgressHUD.h"
#import "UIViewController+NTES.h"

@interface NTESRegisterViewController ()

@end

@implementation NTESRegisterViewController

NTES_USE_CLEAR_BAR
- (void)viewDidLoad {
    [super viewDidLoad];
    [self resetTextField:self.accountTextfield placeholder:@"帐号：限20位字母或者数字"];
    [self resetTextField:self.nicknameTextfield placeholder:@"昵称：限10位汉字、字母或者数字"];
    [self resetTextField:self.passwordTextfield placeholder:@"密码：6~20位字母或者数字"];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (IBAction)onChanged:(id)sender
{
    BOOL enabled = [[_accountTextfield text] length] &&
    [[_nicknameTextfield text] length] &&
    [[_passwordTextfield text] length];
    [self.navigationItem.rightBarButtonItem setEnabled:enabled];
}

- (void)onRegister:(id)sender
{
    NTESRegisterData *data = [[NTESRegisterData alloc] init];
    data.account = [_accountTextfield text];
    data.nickname= [_nicknameTextfield text];
    data.token = [[_passwordTextfield text] tokenByPassword];
    if (![self check]) {
        return;
    }
    [SVProgressHUD show];
    __weak typeof(self) weakSelf = self;
    
    [[NTESDemoService sharedService] registerUser:data
                                       completion:^(NSError *error, NSString *errorMsg) {
                                           [SVProgressHUD dismiss];
                                           if (error == nil) {
                                               [weakSelf.navigationController.view makeToast:@"注册成功"
                                                                                    duration:2
                                                                                    position:CSToastPositionCenter];
                                               if ([weakSelf.delegate respondsToSelector:@selector(registDidComplete:password:)]) {
                                                   [weakSelf.delegate registDidComplete:data.account password:[_passwordTextfield text]];
                                               }
                                               [weakSelf.navigationController popViewControllerAnimated:YES];
                                           }
                                           else
                                           {
                                               if ([weakSelf.delegate respondsToSelector:@selector(registDidComplete:password:)]) {
                                                   [weakSelf.delegate registDidComplete:nil password:nil];
                                               }
                                               
                                               NSString *toast = [NSString stringWithFormat:@"注册失败"];
                                               if ([errorMsg isKindOfClass:[NSString class]] &&errorMsg.length) {
                                                   toast = [toast stringByAppendingFormat:@": %@",errorMsg];
                                               }
                                               [weakSelf.view makeToast:toast
                                                               duration:2
                                                               position:CSToastPositionCenter];
                                               
                                           }

                                       }];
}

- (IBAction)onTouchRegister:(id)sender {
    [self onRegister:sender];
}


- (IBAction)exist:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)keyboardWillChangeFrame:(NSNotification *)notification{
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
    CGFloat bottomSpacing = -5.f;
    UIView *inputView = self.passwordTextfield.superview;
    if (inputView.bottom + bottomSpacing > CGRectGetMinY(keyboardFrame)) {
        CGFloat delta;
        if (UIScreenHeight >= 568) {
            delta = self.existedButton.bottom + bottomSpacing - CGRectGetMinY(keyboardFrame);
            self.existedButton.bottom -= delta;
        }else{
            delta = inputView.bottom + bottomSpacing - CGRectGetMinY(keyboardFrame);
        }
        inputView.bottom -= delta;
    }
    if (self.logo.bottom > self.navigationController.navigationBar.bottom) {
        self.logo.bottom = self.navigationController.navigationBar.bottom;
        self.logo.alpha  = 0;
        self.navigationItem.title = @"注册";
    }
    [UIView commitAnimations];
    
}

#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if ([string isEqualToString:@"\n"]) {
        [self onRegister:nil];
        return NO;
    }
    return YES;
}

#pragma mark - Private
- (void)resetTextField:(UITextField *)textField  placeholder:(NSString *)placeholder {
    textField.tintColor = [UIColor whiteColor];
    NSDictionary *attrs = @{NSForegroundColorAttributeName: UIColorFromRGBA(0xffffff, .6f)};
    textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:placeholder attributes:attrs];
    textField.tintColor = [UIColor whiteColor];
    UIButton *clearButton = [textField valueForKey:@"_clearButton"];
    [clearButton setImage:[UIImage imageNamed:@"login_icon_clear"] forState:UIControlStateNormal];
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    [_accountTextfield resignFirstResponder];
    [_nicknameTextfield resignFirstResponder];
    [_passwordTextfield resignFirstResponder];
}


- (BOOL)check{
    if (!self.checkAccount) {
        [self.view makeToast:@"账号长度有误"
                    duration:2
                    position:CSToastPositionCenter];
        
        return NO;
    }
    if (!self.checkPassword) {
        [self.view makeToast:@"密码长度有误"
                    duration:2
                    position:CSToastPositionCenter];
        
        return NO;
    }
    if (!self.checkNickname) {
        [self.view makeToast:@"昵称长度有误"
                    duration:2
                    position:CSToastPositionCenter];
        
        return NO;
    }
    return YES;
}

- (BOOL)checkAccount{
    NSString *account = [_accountTextfield text];
    return account.length > 0 && account.length <= 20;
}

- (BOOL)checkPassword{
    NSString *checkPassword = [_passwordTextfield text];
    return checkPassword.length >= 6 && checkPassword.length <= 20;
}

- (BOOL)checkNickname{
    NSString *nickname= [_nicknameTextfield text];
    return nickname.length > 0 && nickname.length <= 10;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

@end
