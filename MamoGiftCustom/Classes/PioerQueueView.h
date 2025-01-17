//
//  PioerQueueView.h
//  Pioer
//
//  Created by Pioer on 01/03/24.
//

#import <UIKit/UIKit.h>
#import "PioerQueueShake.h"
#import "PioerQueueGiftData.h"
#import "PioerCountingLabel.h"


NS_ASSUME_NONNULL_BEGIN

typedef void(^completeBlock)(BOOL finished,NSInteger finishCount,NSInteger nowQueue);

@interface PioerQueueView : UIView //giftPresentView

@property (nonatomic,strong) PioerQueueGiftData *model;
//@property (nonatomic,strong) PioerQueueShake *giftShakeLab; // 礼物个数抖动动画Lab
@property (nonatomic,strong) PioerCountingLabel *giftShakeLab; // 礼物个数抖动动画Lab
@property (nonatomic,strong) CAGradientLayer    *gradientLayer;
@property (nonatomic,assign) NSInteger animCount; // 后面礼物的累计个数
@property (nonatomic,assign) CGRect originFrame; // 记录原始坐标
@property (nonatomic,strong) UIView *parabolaView; //直播间装载的父视图
@property (nonatomic,assign) NSInteger nowQueue; // 当前第几队列

@property (nonatomic,assign,getter=isFinished) BOOL finished;
- (void)animateWithCompleteBlock:(completeBlock)completed;
- (void)shakeNumberLabel;
- (void)hidePresendView;
- (instancetype)initWithModel:(PioerQueueGiftData *)model;

- (void)applyTextStrokeToLabel:(UILabel *)label withStrokeColor:(UIColor *)strokeColor;
- (void)startAnimWithDuration:(NSTimeInterval)duration completion:(void (^)(void))completion;
@end

NS_ASSUME_NONNULL_END
