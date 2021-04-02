//
//  NTESHeaderView.m
//  NIMWhiteBoardWebDemo
//
//  Created by taojinliang on 2020/12/31.
//

#import "NTESHeaderView.h"
#import "UIView+NTES.h"

@interface NTESHeaderView()
@property (strong, nonatomic) UILabel *roomLabel;
@property (strong, nonatomic) UILabel *roomIDLabel;
@property (strong, nonatomic) UIButton *pasteButton;
@property (strong, nonatomic) UILabel *userLabel;
@property (strong, nonatomic) UIButton *exitButton;
@end

@implementation NTESHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.roomLabel];
        [self addSubview:self.roomIDLabel];
        [self addSubview:self.pasteButton];
        [self addSubview:self.userLabel];
        [self addSubview:self.exitButton];
    }
    return self;
}



- (void)refreshWithRoomId:(NSString *)roomId user:(NSString *)userName {
    self.roomIDLabel.text = roomId;
    self.userLabel.text = userName;
    float left =10 , right = 10;
    [self.roomLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.mas_equalTo(self.mas_left).offset(left);
    }];
    
    [self.roomIDLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self.roomLabel.mas_right);
    }];
    
    [self.pasteButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self.roomIDLabel.mas_right);
        make.width.equalTo(@40);
        make.height.equalTo(@(50));
    }];
    
    [self.exitButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.right.mas_equalTo(self.mas_right).offset(-right);
        make.width.equalTo(@100);
        make.height.equalTo(@(50));
    }];
    
    [self.userLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.right.equalTo(self.exitButton.mas_left);
    }];
}


- (void)onTouchExitRoom:(id)sender {
    if (self.deleagte && [self.deleagte respondsToSelector:@selector(onExitRoom:)]) {
        [self.deleagte onExitRoom:@"退出房间？"];
    }
}

- (void)onTouchCopy:(id)sender {
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = self.roomIDLabel.text;
    NSLog(@"复制：%@", pasteboard.string);
}


- (void)layoutSubviews {
    [super layoutSubviews];
}

- (UILabel*)roomLabel{
    if (!_roomLabel) {
        _roomLabel = [[UILabel alloc] init];
        _roomLabel.text = @"房间号：";
        _roomLabel.textColor = [UIColor blackColor];
        _roomLabel.font= [UIFont systemFontOfSize:18.f];
    }
    return _roomLabel;
}

- (UILabel*)roomIDLabel{
    if (!_roomIDLabel) {
        _roomIDLabel = [[UILabel alloc] init];
        _roomIDLabel.text = @"";
        _roomIDLabel.textColor = [UIColor blackColor];
        _roomIDLabel.font= [UIFont systemFontOfSize:18.f];
    }
    return _roomIDLabel;
}

- (UIButton*)pasteButton{
    if (!_pasteButton) {
        _pasteButton = [[UIButton alloc] init];
        [_pasteButton setTitle:@"复制" forState:UIControlStateNormal];
        [_pasteButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [_pasteButton addTarget:self action:@selector(onTouchCopy:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _pasteButton;
}

- (UILabel*)userLabel{
    if (!_userLabel) {
        _userLabel = [[UILabel alloc] init];
        _userLabel.text = @"";
        _userLabel.textColor = [UIColor blackColor];
        _userLabel.font= [UIFont systemFontOfSize:18.f];
    }
    return _userLabel;
}

- (UIButton*)exitButton{
    if (!_exitButton) {
        _exitButton = [[UIButton alloc] init];
        [_exitButton setTitle:@"退出房间" forState:UIControlStateNormal];
        [_exitButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [_exitButton addTarget:self action:@selector(onTouchExitRoom:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _exitButton;
}

@end
