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
static NSString *const kBreathAnimationKey  = @"BreathAnimationKey";
static NSString *const kBreathAnimationName = @"BreathAnimationName";
@interface PioerQueueView ()

@property (nonatomic,strong) UIImageView *bgImageView;
@property (nonatomic,strong) UIImageView *senderHead;
@property (nonatomic,strong) UILabel *sendLab;//显示 send
@property (nonatomic,strong) UILabel *giftNameLab; // 送礼人物
@property (nonatomic,strong) UILabel *giftContentLab; // 礼物名称
@property (nonatomic,strong) UIImageView *giftImageView; // 礼物icon
@property (nonatomic,assign) NSInteger giftCount; // 礼物个数
@property (nonatomic,strong) NSTimer *timer;
//礼物中奖视图
@property (nonatomic,strong) UIView *giftHaveView;
@property (nonatomic,strong) UIImageView *giftHaveImage;
@property (nonatomic,strong) UIImageView *giftRotateImage;
@property (nonatomic,strong) UILabel *giftHaveMultipleLabel;

//送礼个数视图
@property (nonatomic,strong) UIView *sendGiftCountView;

@property (nonatomic,strong) AVAudioPlayer *audioPlayer;
@property (nonatomic,strong) AVAudioPlayer *boxAudioPlayer; // 盲盒音效播放

@property (nonatomic,copy) void(^completeBlock)(BOOL finished, NSInteger finishCount, NSInteger nowQueue); // 新增了回调参数 finishCount， 用来记录动画结束时累加数量，将来在3秒内，还能继续累加

@end

@implementation PioerQueueView
// 根据礼物个数播放动画
- (void)animateWithCompleteBlock:(completeBlock)completed{
    
    [UIView animateWithDuration:0.3 animations:^{
        self.frame = CGRectMake(0, self.frame.origin.y, self.frame.size.width, self.frame.size.height);
    } completion:^(BOOL finished) {
        [self shakeNumberLabel];
    }];
    self.completeBlock = completed;
}

//MARK:-- 设置数量lab动画
- (void)shakeNumberLabel {
    if (self.model.giftCount>1) {
        long beforeCount = (long)self.animCount;
        if (self.model.last_combo > 0) { //是否连击
            self.animCount = self.model.last_combo;
        } else {
            self.animCount += self.model.giftCount;
        }
        
        long afterCount = (long)self.animCount;
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hidePresendView) object:nil];//可以取消成功。
        [self performSelector:@selector(hidePresendView) withObject:nil afterDelay:4.7];
        [self startAnimWithDuration:0.3 completion:^{
            self.giftShakeLab.model = self.model;
            [self.giftShakeLab countFrom:beforeCount
                                     to:afterCount
                           withDuration:0.3 alpha: false];
        }];
    }else{
        long beforeCount = ((long)self.animCount) < 1 ? 1 : ((long)self.animCount);
        self.animCount ++;
        long afterCount = (long)self.animCount;
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hidePresendView) object:nil];//可以取消成功。
        [self performSelector:@selector(hidePresendView) withObject:nil afterDelay:4.7];
        [self startAnimWithDuration:0.3 completion:^{
            self.giftShakeLab.model = self.model;
            [self.giftShakeLab countFrom:beforeCount
                                     to:afterCount
                            withDuration:0.3 alpha: false];
        }];
    }
}

- (void)startAnimWithDuration:(NSTimeInterval)duration completion:(void (^)(void))completion {
    [UIView animateKeyframesWithDuration:duration delay:0 options:0 animations:^{
        [UIView addKeyframeWithRelativeStartTime:0 relativeDuration:0 animations:^{
            self.sendGiftCountView.transform = CGAffineTransformMakeScale(3, 3);
        }];
        [UIView addKeyframeWithRelativeStartTime:0.1 relativeDuration:0.8 animations:^{
            self.sendGiftCountView.transform = CGAffineTransformMakeScale(0.7, 0.7);
        }];
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.06 delay:0 usingSpringWithDamping:0.1 initialSpringVelocity:120 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.sendGiftCountView.transform = CGAffineTransformIdentity;
        } completion:^(BOOL restoreFinished) {
            //完成回调
            if (completion) {
                completion();
            }
        }];
    }];
}

#pragma mark -- Private Methods
//MARK:--自动隐藏
- (void)hidePresendView
{
    if (self.superview != nil) {
        //加个通知 移除
        [UIView animateWithDuration:0.30 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            self.frame = CGRectMake(0, self.frame.origin.y - 20, self.frame.size.width, self.frame.size.height);
            self.alpha = 0;
        } completion:^(BOOL finished) {
            if (self.completeBlock) {
                self.completeBlock(true, self.animCount, self.nowQueue);
            }
            [self reset];
            self.finished = finished;
            [self removeFromSuperview];
        }];
    } else {
    }
}

// 重置
- (void)reset {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    self.frame = _originFrame;
    self.alpha = 1;
    self.animCount = 0;
//    [self.giftShakeLab changeToNumber:@0 animated: false];
    [self.giftShakeLab countFromZeroTo: 0 alpha:false];
}

//MARK:--初始化方法
//- (instancetype)init {
//    if (self = [super init]) {
//        _originFrame = self.frame;
//        [[NSNotificationCenter defaultCenter] addObserver:self
//                                                 selector:@selector(removeGiftViewQueue:)
//                                                     name:@"removeGiftViewQueue"
//                                                   object:nil];
//        [self setUI];
//    }
//    return self;
//}
- (instancetype)initWithModel:(PioerQueueGiftData *)model {
    if (self = [super init]) {
        _originFrame = self.frame;
        _model = model; // 保存传入的 model
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(removeGiftViewQueue:)
                                                     name:@"removeGiftViewQueue"
                                                   object:nil];
        [self setUIWithModel:model]; // 根据 model 设置 UI
    }
    return self;
}

// 旧的 init 方法可以废弃或不允许直接调用
//- (instancetype)init {
//    return [self initWithModel:nil]; // 或直接禁用此方法
//}


// 处理通知
- (void)removeGiftViewQueue:(NSNotification *)notification {
    //加个通知 移除
    self.frame = CGRectMake(0, self.frame.origin.y - 20, self.frame.size.width, self.frame.size.height);
    self.alpha = 0;
    if (self.completeBlock) {
        
        self.completeBlock(true, self.animCount, self.nowQueue);
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
    _giftHaveView.frame = CGRectMake(60, -20, 78, 78);
    _giftHaveView.backgroundColor = [UIColor clearColor];
    
    _giftHaveImage.frame = CGRectMake(0, 0, 78, 78);
    
    _giftRotateImage.frame = CGRectMake(0, 0, 78, 78);
    _giftRotateImage.hidden = YES;
    [self removeTransFormAnimation:_giftRotateImage];
    _giftHaveMultipleLabel.frame = CGRectMake(0, 48, 78, 20);
    _giftHaveMultipleLabel.textAlignment = NSTextAlignmentCenter;
    
    _senderHead.frame = CGRectMake(12, 2, 36, 36);
    _senderHead.layer.cornerRadius = 18;
    _senderHead.layer.masksToBounds = YES;
    _senderHead.userInteractionEnabled = YES;
    _senderHead.contentMode = UIViewContentModeScaleAspectFill;
    
    _giftNameLab.frame = CGRectMake(50, 0, 80, 17);
    [_giftNameLab sizeThatFits: CGSizeMake(60, 17)];
    _giftNameLab.top = 5;
    
    _giftContentLab.frame = CGRectMake(50, 20, 72, 17);
    [_giftContentLab sizeThatFits: CGSizeMake(52, 17)];
    _giftContentLab.top = 20;
    
    _giftImageView.frame = CGRectMake(136, -5, 50, 50);
    _giftImageView.userInteractionEnabled = YES;
    [self startPulsingAnimation];
}

#pragma mark 初始化 UI
/**
 左bgimg：背景图,  右 lab：x10
 背景图上：赠送者头像+giftNameLab +giftimge
 */
- (void)setUIWithModel:(PioerQueueGiftData *)model {
    //背景图
    _bgImageView = [[UIImageView alloc] init];
    _bgImageView.backgroundColor = [UIColor clearColor];
    _bgImageView.image = [UIImage imageNamed:@"liveing_giftsQueue_one"];
    
    //中奖视图
    _giftHaveView = [[UIView alloc] init];
    _giftHaveImage = [[UIImageView alloc] init];
    _giftHaveImage.image = [UIImage imageNamed:@"live_gift_gain_100"];
    
    _giftRotateImage = [[UIImageView alloc] init];
    _giftRotateImage.image = [UIImage imageNamed:@"live_gift_rotate"];
    
    _giftHaveMultipleLabel = [[UILabel alloc] init];
    _giftHaveMultipleLabel.text = @"x100";
    _giftHaveMultipleLabel.font = [UIFont fontWithName:@"DIN-BlackItalic" size:14];
    _giftHaveMultipleLabel.textColor = [UIColor colorWithHexString:@"#FAFF00"];
    
    
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
    
    UITapGestureRecognizer *headGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(senderHeadTapped:)];
    [_senderHead addGestureRecognizer:headGesture];
    
    UITapGestureRecognizer *giftImageGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(giftImageTapped:)];
    [_giftImageView addGestureRecognizer:giftImageGesture];
    
    [self addSubview:_sendLab];
    [self addSubview:_giftNameLab];
    [self addSubview:_giftContentLab];
    
    _sendGiftCountView = [[UIView alloc] init];
    _sendGiftCountView.frame = CGRectMake(120, 0, 200, 40);
    _sendGiftCountView.backgroundColor = [UIColor clearColor];
    
    [self addSubview:_sendGiftCountView];
    
    // 初始化动画label
    //    _giftShakeLab =  [[PioerCountingLabel alloc] initWithNumber:@(1) fontSize:32 show_style:model.show_style signSetting: SignSettingSigned];
    //    _giftShakeLab.frame = CGRectMake(20, 0, _giftShakeLab.frame.size.width, _giftShakeLab.frame.size.height);
    //    _giftShakeLab.minRowNumber = 1;
//    _giftShakeLab.alpha_style = 1;
    _giftShakeLab = [[PioerCountingLabel alloc] initWithFrame:CGRectMake(75, 0, 200, 40)];
    _giftShakeLab.textAlignment = NSTextAlignmentLeft;
    _giftShakeLab.format = @"%d";
    _giftShakeLab.animationDuration = 0.3;
    _giftShakeLab.model = self.model;
    _giftShakeLab.method = UILabelCountingMethodEaseOutBounce;
    [_giftShakeLab countFromCurrentValueTo: 1 alpha: true];
    _giftShakeLab.backgroundColor = UIColor.clearColor;
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.numberStyle = kCFNumberFormatterDecimalStyle;
    _giftShakeLab.formatBlock = ^NSString* (CGFloat value)
    {
        NSString* formatted = [formatter stringFromNumber:@((int)value)];
        return [NSString stringWithFormat:@"x%@",formatted];
    };
    _giftShakeLab.font = [UIFont fontWithName:@"BakbakOne-Regular" size:35];//BakbakOne BakbakOne-Regular
    _giftShakeLab.textColor = UIColor.clearColor;
    [self applyTextStrokeToLabel:_giftShakeLab withStrokeColor:[UIColor colorWithHexString:@"#FFFFFF"]];
    
    [_sendGiftCountView addSubview: _giftShakeLab];
    
    //中奖视图
    [self addSubview:_giftHaveView];
    [_giftHaveView addSubview:_giftRotateImage];
    [_giftHaveView addSubview:_giftHaveImage];
    [_giftHaveView addSubview:_giftHaveMultipleLabel];
    [self bringSubviewToFront:_sendGiftCountView];
}


//描边
- (void)applyTextStrokeToLabel:(UILabel *)label withStrokeColor:(UIColor *)strokeColor {
    if (label.text == nil) return;

    NSAttributedString *attributedText = [[NSAttributedString alloc] initWithString:label.text attributes:@{
        NSFontAttributeName: label.font,
        NSForegroundColorAttributeName: label.textColor,
        NSStrokeColorAttributeName: strokeColor,
        NSStrokeWidthAttributeName: @(-2.0)
    }];

    label.attributedText = attributedText;
}

- (void)senderHeadTapped:(UITapGestureRecognizer *)gesture {
    NSLog(@"senderHeadTapped tapped!");
    
    NSDictionary *message = @{
        @"user_id": self.model.senderUserId,
        @"portrait": self.model.senderHead,
        @"nickName": self.model.senderName,
        @"senderPrivilege_type":@(self.model.senderPrivilege_type),
        @"nowType": @(2)
    };

    [[NSNotificationCenter defaultCenter] postNotificationName:@"roomWebEvocation" object:nil userInfo:message];
}

- (void)giftImageTapped:(UITapGestureRecognizer *)gesture {
    NSLog(@"giftImageTapped tapped!");
    NSDictionary *message = @{
        @"nowType": @(self.model.nowType),
        @"gift_id": self.model.giftUid
    };

    [[NSNotificationCenter defaultCenter] postNotificationName:@"roomGiftQueueEvocation" object:nil userInfo:message];
}

- (void)setModel:(PioerQueueGiftData *)model {
    
    //    if (self.superview != nil) {
    _model = model;
    
    [_senderHead sd_setImageWithURL:[NSURL URLWithString:_model.senderHead] placeholderImage:[UIImage imageNamed:@"pioer_avatar_placehold"]];
    _giftNameLab.text = [NSString stringWithFormat:@"%@",model.senderName];
    // 是否只送给一位 1：是 (显示送礼对象人称) 0：不是 (显示送礼礼物名称)
    if (model.isSendOneUser != 1) {
        _giftContentLab.text = [NSString stringWithFormat:@"%@",model.giftName];
    } else {
        _giftContentLab.text = [NSString stringWithFormat:@"%@",model.receiverName];
    }
    
    [_giftImageView sd_setImageWithURL:[NSURL URLWithString:_model.giftImage] placeholderImage:[UIImage imageNamed:@"pioer_feed_placehold"]];
    _giftHaveView.hidden = NO;
    if (_model.nowType != 1) { //礼物类型 1幸运礼物 0礼物其他
        _giftHaveMultipleLabel.hidden = YES;
        _giftRotateImage.hidden = YES;
        [self removeTransFormAnimation:_giftRotateImage];
        _giftHaveImage.hidden = YES;
    }
    if (_model.show_style == 1) {
        _bgImageView.image = [UIImage imageNamed:@"liveing_giftsQueue_one"];
    } else if (_model.show_style == 2) {
        _bgImageView.image = [UIImage imageNamed:@"liveing_giftsQueue_two"];
    } else if (_model.show_style == 3) {
        _bgImageView.image = [UIImage imageNamed:@"liveing_giftsQueue_three"];
    } else if (_model.show_style == 4) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"liveing_giftsQueue_four" ofType:@"webp"];
        if (path) {
            NSURL *url = [NSURL fileURLWithPath:path];
            [_bgImageView sd_setImageWithURL:url];
        }
    } else if (_model.show_style == 5) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"liveing_giftsQueue_five" ofType:@"webp"];
        if (path) {
            NSURL *url = [NSURL fileURLWithPath:path];
            [_bgImageView sd_setImageWithURL:url];
        }
    }
    // 非盲盒礼物
    if (model.winning_multiple > 0 && _model.nowType != 4) { //需要显示放大缩小
        _giftHaveMultipleLabel.hidden = NO;
        _giftRotateImage.hidden = NO;
        _giftHaveImage.hidden = NO;
        CGRect currentFrame = _giftHaveMultipleLabel.frame;
        
        CGFloat newX = currentFrame.origin.x;
        CGFloat newY = 48;
        //        NSLog(@"当前送礼的show_type=%d model.winning_multiple=%d",model.show_type, model.winning_multiple);
        if (model.show_type == 2) { //show_type; //2 - 250 3 - 500  其他100  动画效果
            _giftHaveMultipleLabel.text = [NSString stringWithFormat:@"x%d", model.winning_multiple]; //@"x250";
            newY = 48;
            _giftHaveImage.image = [UIImage imageNamed:@"live_gift_gain_250"];
            _giftRotateImage.hidden = NO;
            [self startTransFormAnimation:_giftRotateImage];
        } else if (model.show_type == 3) {
            _giftHaveMultipleLabel.text = [NSString stringWithFormat:@"x%d", model.winning_multiple];//@"x500";
            newY = 48;
            _giftHaveImage.image = [UIImage imageNamed:@"live_gift_gain_500"];
            _giftRotateImage.hidden = NO;
            [self startTransFormAnimation:_giftRotateImage];
        } else {
            _giftRotateImage.hidden = YES;
            [self removeTransFormAnimation:_giftRotateImage];
            _giftHaveMultipleLabel.text = [NSString stringWithFormat:@"x%d", model.winning_multiple];
            newY = 48;
            _giftHaveImage.image = [UIImage imageNamed:@"live_gift_gain_100"];
        }
        
        currentFrame.origin = CGPointMake(newX, newY);
        _giftHaveMultipleLabel.frame = currentFrame;
        [self layoutIfNeeded];
        if ([model.senderUserId isEqualToString:[[NSUserDefaults standardUserDefaults] stringForKey:@"PioerUserIdKey"]]) {
            if (model.isAnchorSend != 1) {
                BOOL nowRewards = [[NSUserDefaults standardUserDefaults] boolForKey:@"PioerLivingStopRewards"];
                if (!nowRewards) {
                    [self.player play];
                    [PioerParabolaAnimations parabolaAnimationsWithX: self.x withY: self.y parabolaView: self.parabolaView];
                    BOOL nowShake = [[NSUserDefaults standardUserDefaults] boolForKey:@"PioerLivingStopShake"];
                    if (nowShake) {
                        // 震动
                        SystemSoundID sound = kSystemSoundID_Vibrate;
                        AudioServicesPlayAlertSound(sound);
                    }
                }
            }
        }
    } else {
        _giftHaveMultipleLabel.hidden = YES;
        _giftRotateImage.hidden = YES;
        [self removeTransFormAnimation:_giftRotateImage];
        _giftHaveImage.hidden = YES;
    }
    
    if ([model.senderUserId isEqualToString:[[NSUserDefaults standardUserDefaults] stringForKey:@"PioerUserIdKey"]] && model.blindBoxWinArr.count > 0 && model.nowType == 4) {
        if (model.isAnchorSend != 1) {
            BOOL nowRewards = [[NSUserDefaults standardUserDefaults] boolForKey:@"PioerLivingStopRewards"];
            if (!nowRewards) {
                self.boxPlayer.currentTime = 0;
                [self.boxPlayer play];
                [PioerParabolaAnimations boxAnimationsWithX: 170 withY: self.y parabolaView: self.parabolaView withUrls: model.blindBoxWinArr];
            }
            BOOL nowShake = [[NSUserDefaults standardUserDefaults] boolForKey:@"PioerLivingStopShake"];
            if (nowShake) {
                // 震动
                SystemSoundID sound = kSystemSoundID_Vibrate;
                AudioServicesPlayAlertSound(sound);
            }

        }
    }
    
}

- (void)startPulsingAnimation {
    // 创建放大动画
     CABasicAnimation *scaleUp = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
     scaleUp.fromValue = @(1.0);
     scaleUp.toValue = @(1.2);
     scaleUp.duration = 0.5;
     scaleUp.autoreverses = YES; // 动画完成后反向播放
     
     // 创建重复动画
     CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
     animationGroup.animations = @[scaleUp];
     animationGroup.duration = 1.0; // 动画总时长（放大 + 缩小）
     animationGroup.repeatCount = HUGE_VALF; // 无限重复
     
     // 将动画添加到图层
     [self.giftImageView.layer addAnimation:animationGroup forKey:@"pulsing"];
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

- (AVAudioPlayer *)boxPlayer {
    if (!_boxAudioPlayer) {
        NSURL *path = [[NSBundle mainBundle] URLForResource:@"living_box_open.mp3" withExtension:nil];
        AVAudioPlayer *player = [[AVAudioPlayer alloc] initWithContentsOfURL:path error:nil];
        player.numberOfLoops = 0;
        [player prepareToPlay];
        _boxAudioPlayer = player;
    }
    return _boxAudioPlayer;
}
@end
