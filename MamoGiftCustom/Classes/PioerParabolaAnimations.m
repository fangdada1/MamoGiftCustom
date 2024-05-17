//
//  PioerParabolaAnimations.m
//  Pioer
//
//  Created by Pioer on 27/03/24.
//
#define  PioerOCWidth [[UIScreen mainScreen] bounds].size.width
#define  PioerOCHeight [[UIScreen mainScreen] bounds].size.height
#import "PioerParabolaAnimations.h"

@implementation PioerParabolaAnimations


+ (void)parabolaAnimationsWithX:(CGFloat)nowX withY:(CGFloat)nowY {
    for (int index = 0; index < 12; index ++) {
//        NSLog(@"当前view x = %f 当前view y = %f", nowX, nowY);
        [PioerParabolaAnimations startAnimationForIndex: nowX withY: nowY withIndex: index];
    }
}

+ (void)startAnimationForIndex:(CGFloat)nowX withY:(CGFloat)nowY withIndex:(int)index {
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"PioerLivingLookEffects"]) {
        return;
    }
    UIImageView *parabolaView = [[UIImageView alloc] init];
    parabolaView.frame = CGRectMake(20, 0, 20, 20);
    parabolaView.image = [UIImage imageNamed: @"person_top_diamond"];

    UIWindow *keyWindow = [[UIApplication sharedApplication].windows filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(UIWindow *evaluatedObject, NSDictionary *bindings) {
        return [evaluatedObject isKeyWindow];
    }]].firstObject;

//    NSLog(@"看看内容 = %@",keyWindow.rootViewController.view);
    [keyWindow addSubview: parabolaView];
    [keyWindow bringSubviewToFront: parabolaView];
    // 抛物线关键帧动画
    CAKeyframeAnimation *keyframeAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, 90, nowY);//移动到起始点 babyView.layer.position.x, babyView.layer.position.y
//    CGPathMoveToPoint(path, NULL, parabolaView.layer.position.x, parabolaView.layer.position.y);//移动到起始点

    //当前view x = -187.500000 当前view y = 300.000000
    
    //(参数3,参数4)最高点;(参数5,参数6)中间点 (参数7,参数8)掉落最低点
    if (index == 0) {
        CGPathAddCurveToPoint(path, NULL, 90, nowY, 180, nowY - 80, PioerOCWidth, PioerOCHeight);
    } else if (index == 1) {
        CGPathAddCurveToPoint(path, NULL, 90, nowY, 280, nowY - 120, PioerOCWidth, PioerOCHeight);
    } else if (index == 2) {
        CGPathAddCurveToPoint(path, NULL, 90, nowY, 230, nowY - 30, PioerOCWidth, PioerOCHeight);
    } else if (index == 3) {
        CGPathAddCurveToPoint(path, NULL, 90, nowY, 300, nowY - 160, PioerOCWidth, PioerOCHeight);
    } else if (index == 4) {
        CGPathAddCurveToPoint(path, NULL, 90, nowY, 130, nowY , PioerOCWidth, PioerOCHeight);
    } else if (index == 5) {
        CGPathAddCurveToPoint(path, NULL, 90, nowY, 330, nowY - 90, PioerOCWidth, PioerOCHeight);
    } else if (index == 6) {
        CGPathAddCurveToPoint(path, NULL, 90, nowY, 210, nowY - 30, PioerOCWidth, PioerOCHeight);
    } else if (index == 7) {
        CGPathAddCurveToPoint(path, NULL, 90, nowY, 100, nowY - 90, PioerOCWidth, PioerOCHeight);
    } else if (index == 8) {
        CGPathAddCurveToPoint(path, NULL, 90, nowY, 280, nowY - 130, PioerOCWidth, PioerOCHeight);
    } else if (index == 9) {
        CGPathAddCurveToPoint(path, NULL, 90, nowY, 90, nowY - 100, PioerOCWidth, PioerOCHeight);
    } else if (index == 10) {
        CGPathAddCurveToPoint(path, NULL, 90, nowY, 170, nowY - 170, PioerOCWidth, PioerOCHeight);
    } else if (index == 11) {
        CGPathAddCurveToPoint(path, NULL, 90, nowY, 350, nowY - 30, PioerOCWidth, PioerOCHeight);
    }
    
    keyframeAnimation.path = path;
    CGPathRelease(path);
    keyframeAnimation.duration = 1.0f;
    keyframeAnimation.removedOnCompletion = NO;//动画结束不返回原位置
    keyframeAnimation.fillMode = kCAFillModeForwards;
    [parabolaView.layer addAnimation:keyframeAnimation forKey:@"KCKeyframeAnimation_Position"];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 在这里执行需要延迟执行的操作
        [parabolaView removeFromSuperview];
    });
    
}

@end
