//
//  NTESContentView.m
//  WhiteBoardWebDemo
//
//  Created by zhangchenliang on 2021/7/8.
//

#import "NTESContentView.h"

#import <Masonry/Masonry.h>

@interface NTESContentView ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *contentButton;
@property (nonatomic, strong) UIView *bottomLineView;

@end

@implementation NTESContentView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self addSubview:self.titleLabel];
        [self addSubview:self.contentButton];
        [self addSubview:self.bottomLineView];
    }
    
    return self;
}

- (void)refreshWithTitle:(NSString *)title content:(NSString *)content {
    [self.titleLabel setText:title];
    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_centerX).offset(-70);
        make.left.equalTo(self.mas_left).offset(30);
        make.top.equalTo(self);
        make.bottom.equalTo(self);
    }];
    
    [self.contentButton setTitle:content forState:UIControlStateNormal];
    [self.contentButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_centerX).offset(-60);
        make.right.equalTo(self.mas_centerX).offset(120);
        make.top.equalTo(self);
        make.bottom.equalTo(self.mas_bottom).offset(-1);
    }];
    
    [self.bottomLineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentButton);
        make.top.equalTo(self.contentButton.mas_bottom);
        make.bottom.equalTo(self);
    }];
}

- (NSString *)getContent {
    return self.contentButton.currentTitle;
}

- (void)didTriggerChangeContentAction:(id)sender {
    UIViewController *currentVC = nil;
    for (UIView *next = self.superview; next; next = next.superview) {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            currentVC = (UIViewController*)nextResponder;
            
            break;
        }
    }
    
    if (!currentVC) {
        return;
    }
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:[NSString stringWithFormat:@"修改 %@", self.titleLabel.text] preferredStyle:UIAlertControllerStyleAlert];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
//        textField.textColor = [UIColor blackColor];
        textField.text = self.contentButton.currentTitle;
        textField.placeholder = self.contentButton.currentTitle;
    }];
    __weak typeof(alert) weakAlert = alert;
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        __strong typeof(weakAlert) strongAlert = weakAlert;
        UITextField *textField = strongAlert.textFields.firstObject;
        [self.contentButton setTitle:textField.text forState:UIControlStateNormal];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }]];
    [currentVC presentViewController:alert animated:YES completion:NULL];
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.font = [UIFont systemFontOfSize:16];
        _titleLabel.textAlignment = NSTextAlignmentRight;
    }
    
    return _titleLabel;
}

- (UIButton *)contentButton {
    if (!_contentButton) {
        _contentButton = [[UIButton alloc] initWithFrame:CGRectZero];
        _contentButton.backgroundColor = [UIColor clearColor];
        _contentButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        _contentButton.titleLabel.textAlignment = NSTextAlignmentLeft;
        [_contentButton.titleLabel setFont:[UIFont systemFontOfSize:15]];
        [_contentButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_contentButton addTarget:self action:@selector(didTriggerChangeContentAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _contentButton;
}

- (UIView *)bottomLineView {
    if (!_bottomLineView) {
        _bottomLineView = [[UIView alloc] initWithFrame:CGRectZero];
        _bottomLineView.backgroundColor = [UIColor whiteColor];
    }
    
    return _bottomLineView;
}

@end
