//
//  PioerQueueView.m
//  Pioer
//
//  Created by Pioer on 01/03/24.
//

#import "PioerQueueView.h"
#import "UIView+Coordinate.h"
#import <SDWebImage.h>
#import "UIColor+CustomColor.h"

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
@property (nonatomic,copy) void(^completeBlock)(BOOL finished,NSInteger finishCount); // 新增了回调参数 finishCount， 用来记录动画结束时累加数量，将来在3秒内，还能继续累加

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
    self.completeBlock = completed;
}

//MARK:-- 设置数量lab动画
- (void)shakeNumberLabel {
    if (self.model.giftCount>1) {
        NSLog(@"model.giftCount= %ld",self.model.giftCount);
        self.animCount += self.model.giftCount;
        
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hidePresendView) object:nil];//可以取消成功。
        [self performSelector:@selector(hidePresendView) withObject:nil afterDelay:3];
        self.giftShakeLab.text = [NSString stringWithFormat:@"X%ld",self.animCount];
        [self.giftShakeLab startAnimWithDuration:0.3];
        
    }else{
        NSLog(@"加之前animCount = %ld",(long)self.animCount);
           self.animCount ++;
        NSLog(@"加之后animCount = %ld",(long)self.animCount);
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
    [UIView animateWithDuration:0.30 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.frame = CGRectMake(0, self.frame.origin.y - 20, self.frame.size.width, self.frame.size.height);
        self.alpha = 0;
    } completion:^(BOOL finished) {
        if (self.completeBlock) {
            self.completeBlock(finished,self.animCount);
        }
        [self reset];
        self.finished = finished;
        [self removeFromSuperview];
    }];
}

// 重置
- (void)reset {
    
    self.frame = _originFrame;
    self.alpha = 1;
    self.animCount = 0;
    self.giftShakeLab.text = @"";
}

//MARK:--初始化方法
- (instancetype)init {
    if (self = [super init]) {
        _originFrame = self.frame;
        [self setUI];
    }
    return self;
}

#pragma mark 布局 UI
- (void)layoutSubviews {
    [super layoutSubviews];
    _bgImageView.frame = CGRectMake(10, 0, 137, 40);
    _bgImageView.left = 10;
    _bgImageView.layer.cornerRadius = 20;
    _bgImageView.layer.masksToBounds = YES;
    
    _senderHead.frame = CGRectMake(12, 2, 36, 36);
    _senderHead.layer.cornerRadius = 18;
    _senderHead.layer.masksToBounds = YES;
//    _senderHead.top = (self.height - _senderHead.height) / 2.0;
    
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
    
    _giftImageView.frame = CGRectMake(130, 0, 40, 40);
    
//    self.svgaPlayer.frame = CGRectMake(self.width - 60,0, 50, 50);

}

#pragma mark 初始化 UI
/**
 左bgimg：背景图,  右 lab：x10
 背景图上：赠送者头像+giftNameLab +giftimge
 */
- (void)setUI {
    //背景图
    _bgImageView = [[UIImageView alloc] init];
    _bgImageView.backgroundColor = [UIColor blackColor];
    _bgImageView.alpha = 0.3;
    _bgImageView.image = [UIImage imageNamed:@"icon_ChatS_GiftAnimationBgImg"];
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
    
    //礼物价格
//    _giftPriceLab = [[UILabel alloc] init];
//    _giftPriceLab.textColor  = [UIColor whiteColor];
//    _giftPriceLab.font = [UIFont systemFontOfSize:13];
//    _giftPriceLab.textAlignment = NSTextAlignmentCenter;
   
//    // 初始化动画label
//    _giftShakeLab =  [[PioerQueueShake alloc] init];
//    _giftShakeLab.font = [UIFont systemFontOfSize:28];
//    _giftShakeLab.borderColor = [UIColor colorWithHexString:@"#D64A2C"];
//    _giftShakeLab.textColor = [UIColor colorWithHexString:@"#FFDD2B"];
//    _giftShakeLab.textAlignment = NSTextAlignmentLeft;
    _animCount = 0;
    
    
    
    [self addSubview:_bgImageView];
    [self addSubview:_senderHead];
    [self addSubview:_giftImageView];
    
    [self addSubview:_sendLab];
    [self addSubview:_giftNameLab];
    [self addSubview:_giftContentLab];
//    [self addSubview:_giftPriceLab];
    [self addSubview:_giftShakeLab];

//    self.svgaPlayer = [[SVGAPlayer alloc] init];
//    self.svgaPlayer.delegate = self;
//    self.svgaPlayer.loops = 1;
//    self.svgaPlayer.clearsAfterStop = YES;
//    [self addSubview:self.svgaPlayer];
//    self.svgaparser = [[SVGAParser alloc] init];

    
}

- (void)setModel:(PioerQueueGiftData *)model {
    _model = model;

    [_senderHead sd_setImageWithURL:[NSURL URLWithString:_model.senderHead] placeholderImage:[UIImage imageNamed:@"pioer_feed_placehold"]];
    
    _giftNameLab.text = [NSString stringWithFormat:@"%@",model.senderName];//
    _giftContentLab.text = [NSString stringWithFormat:@"%@",model.giftName];

//    _giftPriceLab.text = [NSString stringWithFormat:@"%d",_model.diamonds];

    //下载礼物动画文件
//    ReceivedGiftInfo *downloadeModel = [[ReceivedGiftInfo alloc] init];
//       downloadeModel.name = model.giftName;
//       downloadeModel.icon = model.giftImage;
//       downloadeModel.uid = model.giftUid;
//       downloadeModel.animEffectUrl = model.animEffectUrl;
//       downloadeModel.updatedAt = model.updatedAt;
//       downloadeModel.type = model.type;
//    
       [_giftImageView sd_setImageWithURL:[NSURL URLWithString:_model.giftImage] placeholderImage:[UIImage imageNamed:@"pioer_feed_placehold"]];

                   
   
    
}

//playLottie





//playSVGA
//-(void)playSVGA:(ReceivedGiftInfo *)model{
//
//    if ([GiftConfig isdownloadedGiftFile:model]) {
//       NSDictionary *fileInfo  = [GiftConfig getThisGiftInfo:model];
//        SGDownloadModel *downloadMode =  [SGDownloadModel modelWithJSON:fileInfo];
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
