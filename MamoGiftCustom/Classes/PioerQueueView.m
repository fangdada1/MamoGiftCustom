//
//  PioerQueueView.m
//  Pioer
//
//  Created by Pioer on 01/03/24.
//

#import "PioerQueueView.h"
#import "UIView+Coordinate.h"
#import "SDWebImage.h"
#import "UIColor+CustomColor.h"
#import <AVFoundation/AVFoundation.h>
#import "PioerParabolaAnimations.h"
//#import <SVGA.h>
//#import "PioerdReceiveGiftData.h"
//#import "PioerGiftDownloadData.h"
//#import "PioerDownGiftConfig.h"
static NSString *const kBreathAnimationKey  = @"BreathAnimationKey";
static NSString *const kBreathAnimationName = @"BreathAnimationName";
@interface PioerQueueView ()

@property (nonatomic,strong) UIImageView *bgImageView;
@property (nonatomic,strong) UIImageView *senderHead;
@property (nonatomic,strong) UILabel *sendLab;//显示 send
@property (nonatomic,strong) UILabel *giftNameLab; // 送礼人物
@property (nonatomic,strong) UILabel *giftContentLab; // 礼物名称
//@property (nonatomic,strong) UILabel *giftPriceLab; // 礼物价格
@property (nonatomic,strong) UIImageView *giftImageView; // 礼物icon
@property (nonatomic,assign) NSInteger giftCount; // 礼物个数
@property (nonatomic,strong) NSTimer *timer;

//礼物中奖视图
@property (nonatomic,strong) UIView *giftHaveView;
@property (nonatomic,strong) UIImageView *giftHaveImage;
@property (nonatomic,strong) UIImageView *giftRotateImage;
@property (nonatomic,strong) UILabel *giftHaveMultipleLabel;

@property (nonatomic,strong) AVAudioPlayer *audioPlayer;

@property (nonatomic,copy) void(^completeBlock)(BOOL finished, NSInteger finishCount); // 新增了回调参数 finishCount， 用来记录动画结束时累加数量，将来在3秒内，还能继续累加

//@property (nonatomic,strong) SVGAParser *svgaparser;
//@property (nonatomic,strong) SVGAPlayer *svgaPlayer;
@end
//@interface PioerQueueView ()<SVGAPlayerDelegate>

//@end

@implementation PioerQueueView
// 根据礼物个数播放动画
- (void)animateWithCompleteBlock:(completeBlock)completed{
    
    [UIView animateWithDuration:0.3 animations:^{
        self.frame = CGRectMake(0, self.frame.origin.y, self.frame.size.width, self.frame.size.height);
    } completion:^(BOOL finished) {
        [self shakeNumberLabel];
    }];
    //    NSLog(@"！2 ！finished移除队列 = %@！！", completed);
    self.completeBlock = completed;
}

//MARK:-- 设置数量lab动画
- (void)shakeNumberLabel {
    if (self.model.giftCount>1) {
        //        NSLog(@"model.giftCount= %ld",self.model.giftCount);
        self.animCount += self.model.giftCount;
        
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hidePresendView) object:nil];//可以取消成功。
        [self performSelector:@selector(hidePresendView) withObject:nil afterDelay:3];
        self.giftShakeLab.text = [NSString stringWithFormat:@"X%ld",self.animCount];
        [self.giftShakeLab startAnimWithDuration:0.3];
        
    }else{
        //        NSLog(@"加之前animCount = %ld",(long)self.animCount);
        self.animCount ++;
        //        NSLog(@"加之后animCount = %ld",(long)self.animCount);
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hidePresendView) object:nil];//可以取消成功。
        [self performSelector:@selector(hidePresendView) withObject:nil afterDelay:3];
        self.giftShakeLab.text = [NSString stringWithFormat:@"X%ld",self.animCount];
        [self.giftShakeLab startAnimWithDuration:0.3];
    }
    
}


#pragma mark -- Private Methods
//MARK:--自动隐藏
- (void)hidePresendView
{
    if (self.superview != nil) {
        //        NSLog(@"！！通知暂未移除 准备移除队列！！");
        //加个通知 移除
        [UIView animateWithDuration:0.30 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            self.frame = CGRectMake(0, self.frame.origin.y - 20, self.frame.size.width, self.frame.size.height);
            self.alpha = 0;
        } completion:^(BOOL finished) {
            if (self.completeBlock) {
                //                NSLog(@"！1 ！finished移除队列 = %d！！", finished);
                self.completeBlock(true, self.animCount);
            }
            [self reset];
            self.finished = finished;
            [self removeFromSuperview];
        }];
    } else {
        //        NSLog(@"！！已通知移除 ！！");
    }
}

// 重置
- (void)reset {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    self.frame = _originFrame;
    self.alpha = 1;
    self.animCount = 0;
    self.giftShakeLab.text = @"";
}

//MARK:--初始化方法
- (instancetype)init {
    if (self = [super init]) {
        _originFrame = self.frame;
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(removeGiftViewQueue:)
                                                     name:@"removeGiftViewQueue"
                                                   object:nil];
        [self setUI];
    }
    return self;
}

// 处理通知
- (void)removeGiftViewQueue:(NSNotification *)notification {
    //    NSLog(@"！！removeGiftViewQueue通知移除队列！！");
    //加个通知 移除
    self.frame = CGRectMake(0, self.frame.origin.y - 20, self.frame.size.width, self.frame.size.height);
    self.alpha = 0;
    if (self.completeBlock) {
        
        self.completeBlock(true, self.animCount);
    }
    [self reset];
    self.finished = true;
    [self removeFromSuperview];
}


#pragma mark 布局 UI
- (void)layoutSubviews {
    [super layoutSubviews];
    _bgImageView.frame = CGRectMake(10, 0, 157, 40);
    _bgImageView.left = 10;
    _bgImageView.layer.cornerRadius = 20;
    _bgImageView.layer.masksToBounds = YES;
    //中奖视图
    _giftHaveView.frame = CGRectMake(50, -20, 78, 78);
    _giftHaveView.backgroundColor = [UIColor clearColor];
    
    _giftHaveImage.frame = CGRectMake(0, 0, 78, 78);
    
    _giftRotateImage.frame = CGRectMake(0, 0, 78, 78);
    _giftRotateImage.hidden = YES;
    [self removeTransFormAnimation:_giftRotateImage];
    _giftHaveMultipleLabel.frame = CGRectMake(0, 52, 78, 10);
    _giftHaveMultipleLabel.textAlignment = NSTextAlignmentCenter;
    
    _senderHead.frame = CGRectMake(12, 2, 36, 36);
    _senderHead.layer.cornerRadius = 18;
    _senderHead.layer.masksToBounds = YES;
    _senderHead.contentMode = UIViewContentModeScaleAspectFill;
    
    _giftNameLab.frame = CGRectMake(50, 0, 80, 17);
    //    _giftNameLab.width = self.width - 80;
    [_giftNameLab sizeThatFits: CGSizeMake(60, 17)];
    _giftNameLab.top = 5;
    
    _giftContentLab.frame = CGRectMake(50, 20, 80, 17);
    [_giftContentLab sizeThatFits: CGSizeMake(60, 17)];
    _giftContentLab.top = 20;
    
    // 初始化动画label
    _giftShakeLab =  [[PioerQueueShake alloc] init];
    _giftShakeLab.frame = CGRectMake(142, -30, 120, 100);
    _giftShakeLab.font = [UIFont systemFontOfSize:28];
    _giftShakeLab.borderColor = [UIColor colorWithHexString:@"#D64A2C"];
    _giftShakeLab.textColor = [UIColor colorWithHexString:@"#FFDD2B"];
    _giftShakeLab.textAlignment = NSTextAlignmentCenter;
    
    NSArray *colors = @[(id)[UIColor colorWithHexString:@"#FF099C"].CGColor, (id)[UIColor colorWithHexString:@"#FFDD2B"].CGColor];
    // 创建渐变层
    CAGradientLayer* gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = _giftShakeLab.frame;
    gradientLayer.colors = colors;
    gradientLayer.startPoint = CGPointMake(1, 0);
    gradientLayer.endPoint = CGPointMake(1, 1);
    [self.layer addSublayer:gradientLayer];
    
    gradientLayer.mask = _giftShakeLab.layer;
    _giftShakeLab.frame = gradientLayer.bounds;
    
    _giftImageView.frame = CGRectMake(116, 0, 40, 40);
    
}

#pragma mark 初始化 UI
/**
 左bgimg：背景图,  右 lab：x10
 背景图上：赠送者头像+giftNameLab +giftimge
 */
- (void)setUI {
    //背景图
    _bgImageView = [[UIImageView alloc] init];
    _bgImageView.backgroundColor = [UIColor clearColor];
    //    _bgImageView.alpha = 0.3;
    _bgImageView.image = [UIImage imageNamed:@"icon_ChatS_GiftAnimationBgImg"];
    
    //中奖视图
    _giftHaveView = [[UIView alloc] init];
    //    _giftHaveView.hidden = YES;
    
    _giftHaveImage = [[UIImageView alloc] init];
    _giftHaveImage.image = [UIImage imageNamed:@"live_gift_gain_100"];
    
    _giftRotateImage = [[UIImageView alloc] init];
    _giftRotateImage.image = [UIImage imageNamed:@"live_gift_rotate"];
    
    _giftHaveMultipleLabel = [[UILabel alloc] init];
    _giftHaveMultipleLabel.text = @"x100";
    _giftHaveMultipleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:8];
    _giftHaveMultipleLabel.textColor = [UIColor yellowColor];
    
    //赠送者头像
    _senderHead = [[UIImageView alloc] init];
    
    //send
    _sendLab = [[UILabel alloc] init];
    _sendLab.text = @"send";
    _sendLab.textColor = [UIColor whiteColor];
    //礼物icon
    _giftImageView = [[UIImageView alloc] init];
    
    
    //礼物name
    _giftNameLab = [[UILabel alloc] init];
    _giftNameLab.textColor  = [UIColor whiteColor];
    _giftNameLab.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];//[UIFont systemFontOfSize:13];
    _giftNameLab.textAlignment = NSTextAlignmentLeft;
    
    _giftContentLab = [[UILabel alloc] init];
    _giftContentLab.textColor  = [UIColor whiteColor];
    _giftContentLab.font = [UIFont fontWithName:@"PingFangSC-Regular" size:10];
    _giftContentLab.textAlignment = NSTextAlignmentLeft;
    
    _animCount = 0;
    
    
    [self addSubview:_bgImageView];
    [self addSubview:_senderHead];
    [self addSubview:_giftImageView];
    
    [self addSubview:_sendLab];
    [self addSubview:_giftNameLab];
    [self addSubview:_giftContentLab];
    [self addSubview:_giftShakeLab];
    
    //中奖视图
    [self addSubview:_giftHaveView];
    [_giftHaveView addSubview:_giftRotateImage];
    [_giftHaveView addSubview:_giftHaveImage];
    [_giftHaveView addSubview:_giftHaveMultipleLabel];
}

- (void)setModel:(PioerQueueGiftData *)model {
    
    //    if (self.superview != nil) {
    _model = model;
    
    [_senderHead sd_setImageWithURL:[NSURL URLWithString:_model.senderHead] placeholderImage:[UIImage imageNamed:@"pioer_feed_placehold"]];
    _giftNameLab.text = [NSString stringWithFormat:@"%@",model.senderName];
    _giftContentLab.text = [NSString stringWithFormat:@"%@",model.giftName];
    [_giftImageView sd_setImageWithURL:[NSURL URLWithString:_model.giftImage] placeholderImage:[UIImage imageNamed:@"pioer_feed_placehold"]];
    _giftHaveView.hidden = NO;
    if (_model.nowType != 1) { //礼物类型 1幸运礼物 0礼物其他
        _giftHaveMultipleLabel.hidden = YES;
        _giftRotateImage.hidden = YES;
        [self removeTransFormAnimation:_giftRotateImage];
        _giftHaveImage.hidden = YES;
    }
    //    NSLog(@"1打印坐标 x=%f  y=%f ",_originFrame.origin.x, _originFrame.origin.y);
    //    NSLog(@"2打印坐标 x=%f  y=%f ",self.x, self.y);
    
    
    //    [self makeparabolaAnimation];
    //    NSLog(@"当前中奖用户id = \(%@)", model.senderUserId);
    //    NSLog(@"当前自己用户id = \(%@)", [[NSUserDefaults standardUserDefaults] stringForKey:@"PioerUserIdKey"]);
    if (model.winning_multiple > 0) { //需要显示放大缩小
        //        _giftHaveView.hidden = NO;
        //        if (![[NSUserDefaults standardUserDefaults] boolForKey:@"PioerLivingLookEffects"]) {
        //            NSLog(@"！！隐藏送礼物视图！！");
        //            _giftHaveView.hidden = YES;
        //        }
        _giftHaveMultipleLabel.hidden = NO;
        _giftRotateImage.hidden = NO;
        _giftHaveImage.hidden = NO;
        CGRect currentFrame = _giftHaveMultipleLabel.frame;
        
        CGFloat newX = currentFrame.origin.x;
        CGFloat newY = 52;
        //        NSLog(@"当前送礼的show_type=%d model.winning_multiple=%d",model.show_type, model.winning_multiple);
        if (model.show_type == 2) { //show_type; //2 - 250 3 - 500  其他100  动画效果
            _giftHaveMultipleLabel.text = [NSString stringWithFormat:@"x%d", model.winning_multiple]; //@"x250";
            newY = 52;
            _giftHaveImage.image = [UIImage imageNamed:@"live_gift_gain_250"];
            _giftRotateImage.hidden = NO;
            [self startTransFormAnimation:_giftRotateImage];
        } else if (model.show_type == 3) {
            _giftHaveMultipleLabel.text = [NSString stringWithFormat:@"x%d", model.winning_multiple];//@"x500";
            newY = 52;
            _giftHaveImage.image = [UIImage imageNamed:@"live_gift_gain_500"];
            _giftRotateImage.hidden = NO;
            [self startTransFormAnimation:_giftRotateImage];
        } else {
            _giftRotateImage.hidden = YES;
            [self removeTransFormAnimation:_giftRotateImage];
            _giftHaveMultipleLabel.text = [NSString stringWithFormat:@"x%d", model.winning_multiple];
            newY = 52;
            _giftHaveImage.image = [UIImage imageNamed:@"live_gift_gain_100"];
        }
        currentFrame.origin = CGPointMake(newX, newY);
        //        NSLog(@"打印新坐标x =  %f", newX);
        //        NSLog(@"打印新坐标y =  %f", newY);
        _giftHaveMultipleLabel.frame = currentFrame;
        [self layoutIfNeeded];
        if ([model.senderUserId isEqualToString:[[NSUserDefaults standardUserDefaults] stringForKey:@"PioerUserIdKey"]]) {
            if (model.isAnchorSend != 1) {
                BOOL nowRewards = [[NSUserDefaults standardUserDefaults] boolForKey:@"PioerLivingStopRewards"];
                if (!nowRewards) {
                    [self.player play];
                    [PioerParabolaAnimations parabolaAnimationsWithX: self.x withY: self.y parabolaView: self.parabolaView];
                }
            }
        }
    } else {
        _giftHaveMultipleLabel.hidden = YES;
        _giftRotateImage.hidden = YES;
        [self removeTransFormAnimation:_giftRotateImage];
        _giftHaveImage.hidden = YES;
    }
    //    }
    
    //    [self layoutIfNeeded];
    //    else {
    //        _giftHaveView.hidden = YES;
    //    }
}

- (void)addBreathAnimation
{
    CALayer *layer = [CALayer layer];
    layer.position = CGPointMake(_giftHaveView.width/2.0f, _giftHaveView.width/2.0f);
    layer.bounds = CGRectMake(0, 0, _giftHaveView.width/2.0f, _giftHaveView.width/2.0f);
    layer.backgroundColor = [UIColor clearColor].CGColor;
    layer.contents = _giftHaveView;
    layer.contentsGravity = kCAGravityResizeAspect;
    [self.layer addSublayer:layer];
    
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    animation.values = @[@1.f, @1.4f, @1.f];
    animation.keyTimes = @[@0.f, @0.5f, @1.f];
    animation.duration = 1; //1000ms
    animation.repeatCount = FLT_MAX;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [animation setValue:kBreathAnimationKey forKey:kBreathAnimationName];
    [layer addAnimation:animation forKey:kBreathAnimationKey];
    
}
/// 开始动画
- (void)startTransFormAnimation:(UIImageView *)view {
    [self removeTransFormAnimation:view];
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];//rotation.z
    //默认是顺时针效果，若将fromValue和toValue的值互换，则为逆时针效果
    animation.toValue =   [NSNumber numberWithFloat: M_PI *2];
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    animation.duration = 2;
    animation.autoreverses = NO;
    animation.cumulative = NO;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    animation.repeatCount = FLT_MAX; //如果这里想设置成一直自旋转，可以设置为FLT_MAX，
    [view.layer addAnimation:animation forKey:@"animation"];
    [view startAnimating];
}
/// 移除动画
- (void)removeTransFormAnimation:(UIImageView *)view {
    [view.layer removeAllAnimations];
}

/** 设置缩放动画 */
- (void)startScaleAnimation:(UIView *)view {
    [UIView animateKeyframesWithDuration:0.5 delay:0 options:0 animations: ^{
        view.transform = CGAffineTransformMakeScale(0.1, 0.1);
        [UIView addKeyframeWithRelativeStartTime:0 relativeDuration:0.5 animations: ^{
            view.transform = CGAffineTransformMakeScale(1.0, 1.0);
        }];
        
    } completion:nil];
}

- (AVAudioPlayer *)player {
    if (!_audioPlayer) {
        NSURL *path = [[NSBundle mainBundle] URLForResource:@"live_gold_voice.mp3" withExtension:nil];
        AVAudioPlayer *player = [[AVAudioPlayer alloc] initWithContentsOfURL:path error:nil];
        player.numberOfLoops = 0;
        [player prepareToPlay];
        _audioPlayer = player;
    }
    return _audioPlayer;
}


//-(void)makeparabolaAnimation {
//    UIImageView *babyView = [[UIImageView alloc] init];
//    babyView.frame = CGRectMake(20, 0, 20, 20);
//    babyView.image = [UIImage imageNamed: @"person_top_diamond"];
//    [self addSubview: babyView];
//    // 抛物线关键帧动画
//    CAKeyframeAnimation *keyframeAnimation=[CAKeyframeAnimation animationWithKeyPath:@"position"];
//    CGMutablePathRef path = CGPathCreateMutable();
//    CGPathMoveToPoint(path, NULL, babyView.layer.position.x, babyView.layer.position.y);//移动到起始点
//    NSLog(@"当前view x = %f 当前view y = %f", self.x, self.y);
//    //(参数3,参数4)最高点;(参数5,参数6)中间点 (参数7,参数8)掉落最低点
//    CGPathAddCurveToPoint(path, NULL, 50, _giftHaveView.bottom, 90, 120, [[UIScreen mainScreen] bounds].size.width - 30, [[UIScreen mainScreen] bounds].size.height - 30);
//    keyframeAnimation.path = path;
//    CGPathRelease(path);
//    keyframeAnimation.duration = 1.0f;
//    keyframeAnimation.removedOnCompletion = NO;//动画结束不返回原位置
//    keyframeAnimation.fillMode = kCAFillModeForwards;
//    [babyView.layer addAnimation:keyframeAnimation forKey:@"KCKeyframeAnimation_Position"];
//}


//playSVGA
//-(void)playSVGA:(PioerdReceiveGiftData *)model{
//
//    if ([PioerDownGiftConfig isdownloadedGiftFile:model]) {
//       NSDictionary *fileInfo  = [PioerDownGiftConfig getThisGiftInfo:model];
//        PioerGiftDownloadData *downloadMode =  [PioerGiftDownloadData modelWithJSON:fileInfo];
//        NSString * filePath = downloadMode.filePath;
//        NSDate *filePathData = [[NSData alloc] initWithContentsOfFile:filePath];
////       data
//        [self.svgaparser parseWithData:filePathData cacheKey:downloadMode.fileName completionBlock:^(SVGAVideoEntity * _Nonnull videoItem) {
//            self.svgaPlayer.videoItem = videoItem;
//            [self.svgaPlayer startAnimation];
//        } failureBlock:^(NSError * _Nonnull error) {
//
//        }];
//
//    }else{
////url
//        [self.svgaparser parseWithURL:[NSURL URLWithString: model.animEffectUrl] completionBlock:^(SVGAVideoEntity * _Nullable videoItem) {
//            self.svgaPlayer.videoItem = videoItem;
//            [self.svgaPlayer startAnimation];
//        } failureBlock:^(NSError * _Nullable error) {
//
//        }];
//    }
//
//
//
//}

//MARK:-- SVGAPlayerDelegate
//- (void)svgaPlayerDidFinishedAnimation:(SVGAPlayer *)player{
//    //AULog(@"动画完成");
//     [self hidePresendView];
////     [self.svgaPlayer removeFromSuperview];
//
//
//}
//- (void)svgaPlayerDidAnimatedToFrame:(NSInteger)frame{
//     //AULog(@"设置第几帧触发该方法");
//    if (frame == 1) {
//
//    }
//
//}
//- (void)svgaPlayerDidAnimatedToPercentage:(CGFloat)percentage{
//     //AULog(@"播放百分比percentage = %f",percentage);
//
//}
@end
