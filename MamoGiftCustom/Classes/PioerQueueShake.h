//
//  PioerQueueShake.h
//  Pioer
//
//  Created by Pioer on 01/03/24.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PioerQueueShake : UILabel //giftShakeLab

// 动画时间
@property (nonatomic,assign) NSTimeInterval duration;
// 描边颜色
@property (nonatomic,strong) UIColor *borderColor;

- (void)startAnimWithDuration:(NSTimeInterval)duration;

@end

NS_ASSUME_NONNULL_END
