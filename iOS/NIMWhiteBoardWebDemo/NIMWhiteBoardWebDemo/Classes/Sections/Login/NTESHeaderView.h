//
//  NTESHeaderView.h
//  NIMWhiteBoardWebDemo
//
//  Created by taojinliang on 2020/12/31.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol NTESHeaderViewDelegate <NSObject>
- (void)onExitRoom:(NSString *)text;
@end

@interface NTESHeaderView : UIView
@property(nonatomic, weak) id<NTESHeaderViewDelegate> deleagte;
- (void)refreshWithRoomId:(NSString *)roomId user:(NSString *)userName;
@end

NS_ASSUME_NONNULL_END
