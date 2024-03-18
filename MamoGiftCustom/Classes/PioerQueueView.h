//
//  PioerQueueView.h
//  Pioer
//
//  Created by Pioer on 01/03/24.
//

#import <UIKit/UIKit.h>
#import "PioerQueueShake.h"
#import "PioerQueueGiftData.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^completeBlock)(BOOL finished,NSInteger finishCount);

@interface PioerQueueView : UIView //giftPresentView

@property (nonatomic,strong) PioerQueueGiftData *model;
@property (nonatomic,strong) PioerQueueShake *giftShakeLab; // 礼物个数抖动动画Lab
@property (nonatomic,assign) NSInteger animCount; // 动画执行到了第几次
@property (nonatomic,assign) CGRect originFrame; // 记录原始坐标

@property (nonatomic,assign,getter=isFinished) BOOL finished;
- (void)animateWithCompleteBlock:(completeBlock)completed;
- (void)shakeNumberLabel;
- (void)hidePresendView;

@end

NS_ASSUME_NONNULL_END
