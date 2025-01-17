//
//  PioerQueueOperation.m
//  Pioer
//
//  Created by Pioer on 01/03/24.
//

#import "PioerQueueOperation.h"
#import "PioerQueueClass.h"
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
    op.presentView = [[PioerQueueView alloc] initWithModel: model];
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
    
    if ([self isCancelled]) {
        self.finished = YES;
        return;
    }
    self.executing = YES;
    
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        NSLog(@"查看当前送礼下标 = %d", self.giftBottom);
        if (![PioerQueueClass firstQueueInUse]) {
            [PioerQueueClass setFirstQueueInUse: YES];
            self.presentView.nowQueue = 0;
            self.presentView.frame = CGRectMake(-20, (kHeight - self.giftBottom) - 40, self.listView.frame.size.width / 2 + 80, 40);
        }
        else if ( ![PioerQueueClass secondQueueInUse]) {
            [PioerQueueClass setSecondQueueInUse: YES];
            self.presentView.nowQueue = 1;
            self.presentView.frame = CGRectMake(-20, (kHeight - self.giftBottom) - 100 , self.listView.frame.size.width / 2 + 80, 40);
        }
        else if ( ![PioerQueueClass thirdQueueInUse]) {
            [PioerQueueClass setThirdQueueInUse: YES];
            self.presentView.nowQueue = 2;
            self.presentView.frame = CGRectMake(-20, (kHeight - self.giftBottom) - 160 , self.listView.frame.size.width / 2 + 80, 40);
        }
        else if ( ![PioerQueueClass fourQueueInUse]) {
            [PioerQueueClass setFourQueueInUse: YES];
            self.presentView.nowQueue = 3;
            self.presentView.frame = CGRectMake(-20, (kHeight - self.giftBottom) - 220, self.listView.frame.size.width / 2 + 80, 40);
        }
        
        self.presentView.originFrame = self.presentView.frame;
       [self.listView addSubview:self.presentView];
        self.presentView.parabolaView = self.listView;
        self.presentView.model = self.model;
        
        [self.presentView animateWithCompleteBlock:^(BOOL finished,NSInteger finishCount,NSInteger nowQueue) {
            NSLog(@"动画结束视图已移除 = %ld", nowQueue);
            if (nowQueue == 0) {
                [PioerQueueClass setFirstQueueInUse: NO];
            } else if (nowQueue == 1) {
                [PioerQueueClass setSecondQueueInUse: NO];
            } else if (nowQueue == 2) {
                [PioerQueueClass setThirdQueueInUse: NO];
            } else if (nowQueue == 3) {
                [PioerQueueClass setFourQueueInUse: NO];
            }
            
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

