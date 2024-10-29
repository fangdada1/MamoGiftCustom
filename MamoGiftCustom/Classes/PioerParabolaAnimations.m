//
//  PioerParabolaAnimations.m
//  Pioer
//
//  Created by Pioer on 27/03/24.
//
#define  PioerOCWidth [[UIScreen mainScreen] bounds].size.width
#define  PioerOCHeight [[UIScreen mainScreen] bounds].size.height
#import "PioerParabolaAnimations.h"
#import "SDWebImage.h"

@implementation PioerParabolaAnimations


+ (void)parabolaAnimationsWithX:(CGFloat)nowX withY:(CGFloat)nowY parabolaView:(UIView *)parabolaSuperview {
    for (int index = 0; index < 12; index ++) {
//        NSLog(@"当前view x = %f 当前view y = %f", nowX, nowY);
        [PioerParabolaAnimations startAnimationForIndex: nowX withY: nowY withIndex: index parabolaSuperview: parabolaSuperview];
    }
}

+ (void)startAnimationForIndex:(CGFloat)nowX withY:(CGFloat)nowY withIndex:(int)index parabolaSuperview:(UIView *)parabolaSuperview {
//    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"PioerLivingLookEffects"]) {
//        return;
//    }
    UIImageView *parabolaView = [[UIImageView alloc] init];
    parabolaView.frame = CGRectMake(20, 0, 20, 20);
    parabolaView.image = [UIImage imageNamed: @"person_top_diamond"];

//    UIWindow *keyWindow = [[UIApplication sharedApplication].windows filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(UIWindow *evaluatedObject, NSDictionary *bindings) {
//        return [evaluatedObject isKeyWindow];
//    }]].firstObject;

//    NSLog(@"看看内容 = %@",keyWindow.rootViewController.view);
    [parabolaSuperview addSubview: parabolaView];
    [parabolaSuperview bringSubviewToFront: parabolaView];
    
    int newX = 120;
    // 抛物线关键帧动画
    CAKeyframeAnimation *keyframeAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, newX, nowY);//移动到起始点 babyView.layer.position.x, babyView.layer.position.y
//    CGPathMoveToPoint(path, NULL, parabolaView.layer.position.x, parabolaView.layer.position.y);//移动到起始点

    //当前view x = -187.500000 当前view y = 300.000000
    
    //(参数3,参数4)最高点;(参数5,参数6)中间点 (参数7,参数8)掉落最低点
    if (index == 0) {
        CGPathAddCurveToPoint(path, NULL, newX, nowY, 280, nowY - 280, PioerOCWidth, PioerOCHeight);
    } else if (index == 1) {
        CGPathAddCurveToPoint(path, NULL, newX, nowY, 380, nowY - 320, PioerOCWidth, PioerOCHeight);
    } else if (index == 2) {
        CGPathAddCurveToPoint(path, NULL, newX, nowY, 330, nowY - 230, PioerOCWidth, PioerOCHeight);
    } else if (index == 3) {
        CGPathAddCurveToPoint(path, NULL, newX, nowY, 400, nowY - 360, PioerOCWidth, PioerOCHeight);
    } else if (index == 4) {
        CGPathAddCurveToPoint(path, NULL, newX, nowY, 230, nowY - 200 , PioerOCWidth, PioerOCHeight);
    } else if (index == 5) {
        CGPathAddCurveToPoint(path, NULL, newX, nowY, 430, nowY - 290, PioerOCWidth, PioerOCHeight);
    } else if (index == 6) {
        CGPathAddCurveToPoint(path, NULL, newX, nowY, 310, nowY - 230, PioerOCWidth, PioerOCHeight);
    } else if (index == 7) {
        CGPathAddCurveToPoint(path, NULL, newX, nowY, 200, nowY - 290, PioerOCWidth, PioerOCHeight);
    } else if (index == 8) {
        CGPathAddCurveToPoint(path, NULL, newX, nowY, 380, nowY - 330, PioerOCWidth, PioerOCHeight);
    } else if (index == 9) {
        CGPathAddCurveToPoint(path, NULL, newX, nowY, 190, nowY - 300, PioerOCWidth, PioerOCHeight);
    } else if (index == 10) {
        CGPathAddCurveToPoint(path, NULL, newX, nowY, 270, nowY - 370, PioerOCWidth, PioerOCHeight);
    } else if (index == 11) {
        CGPathAddCurveToPoint(path, NULL, newX, nowY, 450, nowY - 230, PioerOCWidth, PioerOCHeight);
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

+ (void)boxAnimationsWithX:(CGFloat)nowX withY:(CGFloat)nowY parabolaView:(UIView *)parabolaSuperview withUrls:(NSArray *)urls {
    int withIndex = 0;
    for (int index = 0; index < urls.count; index ++) {
        NSNumber *number = urls[index][@"number"];
        NSInteger num = [number intValue];
        if (num > 3) { num = 3; }
        NSNumber *gid = urls[index][@"gid"];
        NSInteger gidNum = [gid intValue];
        // 纯钻石
        if (gidNum == 0) { num = 1; }
        for (int i = 0; i < num; i ++) {
            [PioerParabolaAnimations startAnimationForIndex: nowX withY: nowY withIndex: withIndex withUrl: urls[index][@"icon"] parabolaSuperview: parabolaSuperview];
            withIndex ++;
        }
    }
}

+ (void)startAnimationForIndex:(CGFloat)nowX withY:(CGFloat)nowY withIndex:(int)index withUrl:(NSString *)url parabolaSuperview:(UIView *)parabolaSuperview {
//    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"PioerLivingLookEffects"]) {
//        return;
//    }
    UIImageView *parabolaView = [[UIImageView alloc] init];
    parabolaView.frame = CGRectMake(20, 0, 40, 40);
    [parabolaView sd_setImageWithURL:[NSURL URLWithString: url] placeholderImage:[UIImage imageNamed:@"pioer_feed_placehold"]];

    [parabolaSuperview addSubview: parabolaView];
    [parabolaSuperview bringSubviewToFront: parabolaView];
    // 抛物线关键帧动画
    CAKeyframeAnimation *keyframeAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, nowX, nowY);//移动到起始点 babyView.layer.position.x, babyView.layer.position.y
//    CGPathMoveToPoint(path, NULL, parabolaView.layer.position.x, parabolaView.layer.position.y);//移动到起始点

    //当前view x = -187.500000 当前view y = 300.000000
    
    //(参数3,参数4)最高点;(参数5,参数6)中间点 (参数7,参数8)掉落最低点
    if (index == 0) {
        CGPathAddCurveToPoint(path, NULL, nowX, nowY, 280, nowY - 280, PioerOCWidth, PioerOCHeight);
    } else if (index == 1) {
        CGPathAddCurveToPoint(path, NULL, nowX, nowY, 380, nowY - 320, PioerOCWidth, PioerOCHeight);
    } else if (index == 2) {
        CGPathAddCurveToPoint(path, NULL, nowX, nowY, 330, nowY - 230, PioerOCWidth, PioerOCHeight);
    } else if (index == 3) {
        CGPathAddCurveToPoint(path, NULL, nowX, nowY, 400, nowY - 360, PioerOCWidth, PioerOCHeight);
    } else if (index == 4) {
        CGPathAddCurveToPoint(path, NULL, nowX, nowY, 230, nowY - 200, PioerOCWidth, PioerOCHeight);
    } else if (index == 5) {
        CGPathAddCurveToPoint(path, NULL, nowX, nowY, 430, nowY - 290, PioerOCWidth, PioerOCHeight);
    } else if (index == 6) {
        CGPathAddCurveToPoint(path, NULL, nowX, nowY, 310, nowY - 230, PioerOCWidth, PioerOCHeight);
    } else if (index == 7) {
        CGPathAddCurveToPoint(path, NULL, nowX, nowY, 200, nowY - 290, PioerOCWidth, PioerOCHeight);
    } else if (index == 8) {
        CGPathAddCurveToPoint(path, NULL, nowX, nowY, 380, nowY - 330, PioerOCWidth, PioerOCHeight);
    } else if (index == 9) {
        CGPathAddCurveToPoint(path, NULL, nowX, nowY, 190, nowY - 300, PioerOCWidth, PioerOCHeight);
    } else if (index == 10) {
        CGPathAddCurveToPoint(path, NULL, nowX, nowY, 270, nowY - 370, PioerOCWidth, PioerOCHeight);
    } else if (index == 11) {
        CGPathAddCurveToPoint(path, NULL, nowX, nowY, 450, nowY - 230, PioerOCWidth, PioerOCHeight);
    } else if (index == 12) {
        CGPathAddCurveToPoint(path, NULL, nowX, nowY, 350, nowY - 200, PioerOCWidth, PioerOCHeight);
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
