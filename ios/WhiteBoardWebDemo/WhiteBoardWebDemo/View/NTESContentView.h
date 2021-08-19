//
//  NTESContentView.h
//  WhiteBoardWebDemo
//
//  Created by zhangchenliang on 2021/7/8.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NTESContentView : UIView

- (void)refreshWithTitle:(NSString *)title content:(NSString *)content;

- (NSString *)getContent;

@end

NS_ASSUME_NONNULL_END
