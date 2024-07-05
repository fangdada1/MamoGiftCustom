//
//  PioerQueueOperation.m
//  Pioer
//
//  Created by Pioer on 01/03/24.
//

#import "PioerQueueOperation.h"
#define  KWidth [[UIScreen mainScreen] bounds].size.width
#define  kHeight [[UIScreen mainScreen] bounds].size.height
//参考的屏幕宽度和高度 - 适配尺寸
#define referenceBoundsHeight 568
#define referenceBoundsWight 320
#define ratioHeight kHeight/referenceBoundsHeight
#define ratioWidth KWidth/referenceBoundsWight

@interface PioerQueueOperation ()
@property (nonatomic, getter = isFinished)  BOOL finished;
@property (nonatomic, getter = isExecuting) BOOL executing;
@property (nonatomic,copy) void(^finishedBlock)(BOOL result,NSInteger finishCount);

@end

@implementation PioerQueueOperation
@synthesize finished = _finished;
@synthesize executing = _executing;

+ (instancetype)animOperationWithUserID:(NSString *)userID model:(PioerQueueGiftData *)model finishedBlock:(void(^)(BOOL result,NSInteger finishCount))finishedBlock; {
    PioerQueueOperation *op = [[PioerQueueOperation alloc] init];
    op.presentView = [[PioerQueueView alloc] init];
    op.model = model;
    op.finishedBlock = finishedBlock;
    return op;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _executing = NO;
        _finished  = NO;
        
        
    }
    return self;
}

- (void)start {
    NSLog(@"start");
    // 添加到队列时调用
//    if (如果半天没訊息或者取消了操作) {
//        return
//    }
//    self.executing = YES;
//    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
//        执行动画；
//        } completion:^(BOOL finished) {
//            self.finished = YES;
//            self.executing = NO;
//        }];
//    }];
    
    if ([self isCancelled]) {
        self.finished = YES;
        return;
    }
    self.executing = YES;
    
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
    
        self.presentView.model = self.model;
        self.presentView.parabolaView = self.listView;
//        if (![[NSUserDefaults standardUserDefaults] boolForKey:@"PioerLivingLookEffects"]) {
//            [self.presentView hidePresendView];
//            return;
//            }
//        if ([self.model.type intValue] >4 ) {
//            // i ％ 4 控制最多允许出现几行
//            if (self.index % 4) {
//                self.presentView.frame = CGRectMake(-20, 320 * ratioHeight, self.listView.frame.size.width / 2, 40); //120
//            }else if (self.index % 3) {
//                self.presentView.frame = CGRectMake(-20, 300 * ratioHeight, self.listView.frame.size.width / 2, 40); //120
//            }else if (self.index % 2) {
//                self.presentView.frame = CGRectMake(-20, 280 * ratioHeight, self.listView.frame.size.width / 2, 40); //120
//            }else {
//                self.presentView.frame = CGRectMake(-20, 260 * ratioHeight, self.listView.frame.size.width / 2, 40); //100
//            }
//            NSLog(@"9打印 = %f", self.presentView.frame.origin.y);
//        }else{
            // i ％ 4 控制最多允许出现几行
//        NSLog(@"当前index = %ld", (long)self.index);
        if (self.index % 4 == 0) {
            self.presentView.frame = CGRectMake(-20, (kHeight - 40) / 2 - 30 , self.listView.frame.size.width / 2, 40);
        } else if (self.index % 4 == 1) {
            self.presentView.frame = CGRectMake(-20, (kHeight - 40) / 2 - 30 - 60 , self.listView.frame.size.width / 2, 40);
        } else if (self.index % 4 == 2) {
            self.presentView.frame = CGRectMake(-20, (kHeight - 40) / 2 - 30 + 60 , self.listView.frame.size.width / 2, 40);
        } else if (self.index % 4 == 3) {
            self.presentView.frame = CGRectMake(-20, (kHeight - 40) / 2 - 30 - 120 , self.listView.frame.size.width / 2, 40);
        }
//            if (self.index % 4) {
//                self.presentView.frame = CGRectMake(-20, 520 , self.listView.frame.size.width / 2, 40); //350 * ratioHeight
//            }else if (self.index % 3) {
//                self.presentView.frame = CGRectMake(-20, 470 , self.listView.frame.size.width / 2, 40); //350 * ratioHeight
//            }else if (self.index % 2) {
//                self.presentView.frame = CGRectMake(-20, 400 , self.listView.frame.size.width / 2, 40); //350 * ratioHeight
//            }else {
//                self.presentView.frame = CGRectMake(-20, 330, self.listView.frame.size.width / 2, 40); //280
//            }
//            NSLog(@"10打印 = %f", self.presentView.frame.origin.y);
//        }

        
       self.presentView.originFrame = self.presentView.frame;
       [self.listView addSubview:self.presentView];
        
        [self.presentView animateWithCompleteBlock:^(BOOL finished,NSInteger finishCount) {
            self.finished = finished;
            self.finishedBlock(finished,finishCount);
        }];

    }];
    
}

#pragma mark -  手动触发 KVO
- (void)setExecuting:(BOOL)executing
{
    [self willChangeValueForKey:@"isExecuting"];
    _executing = executing;
    [self didChangeValueForKey:@"isExecuting"];
}

- (void)setFinished:(BOOL)finished
{
    [self willChangeValueForKey:@"isFinished"];
    _finished = finished;
    [self didChangeValueForKey:@"isFinished"];
}

@end

