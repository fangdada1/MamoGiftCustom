//
//  PioerParabolaAnimations.h
//  Pioer
//
//  Created by Pioer on 27/03/24.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PioerParabolaAnimations : UIView

// 显示金币掉落动画
+ (void)parabolaAnimationsWithX:(CGFloat)nowX withY:(CGFloat)nowY parabolaView:(UIView *)parabolaSuperview;

+ (void)startAnimationForIndex:(CGFloat)nowX withY:(CGFloat)nowY withIndex:(int)index parabolaSuperview:(UIView *)parabolaSuperview;

+ (void)boxAnimationsWithX:(CGFloat)nowX withY:(CGFloat)nowY parabolaView:(UIView *)parabolaSuperview withUrls:(NSArray *)urls;

@end

NS_ASSUME_NONNULL_END
