//
//  PioerQueueManager.m
//  Pioer
//
//  Created by Pioer on 01/03/24.
//

#import "PioerQueueManager.h"
#import "PioerQueueOperation.h"

@implementation PioerQueueManager

static PioerQueueManager *manager;
static dispatch_once_t onceToken;
+ (instancetype)shared
{
    
    dispatch_once(&onceToken, ^{
        manager = [[PioerQueueManager alloc] init];
        
    });
    return manager;
}

+ (void)attemptDealloc
{
    onceToken = 0;
    manager = nil;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
//        self.giftArray = [NSMutableArray array];
        self.oldUser = [NSMutableArray array];
    }
    return self;
}

- (BOOL)checkIsBoolWithUserId:(NSString *)userID withData:(NSMutableArray *)data {
    if (data.count == 0) {
        return YES;
    }
    if ([self.oldUser containsObject: userID]) {
        return YES;
    }
    return NO;
}

/// 动画操作 : 需要UserID和回调
/// isMultipleRoom: 是否多人房 队列3  默认4
- (void)animWithUserID:(NSString *)userID isMultipleRoom:(BOOL)isMultipleRoom model:(PioerQueueGiftData *)model finishedBlock:(void(^)(BOOL result))finishedBlock {
    
    //跟之前的礼物id比较
    if ([self checkIsBoolWithUserId:userID withData:self.oldUser]) {
        //ALog(@"11111");
        //在有用户礼物信息时
        if ([self.userGigtInfos objectForKey:userID]){
              //ALog(@"11111-有用户礼物信");
            // 如果有操作缓存，则直接累加，不需要重新创建op
            if ([self.operationCache objectForKey:userID]!=nil) {
                PioerQueueOperation *op = [self.operationCache objectForKey:userID];
                op.presentView.model = model;
                [op.presentView shakeNumberLabel];
//                NSLog(@"动画视图已添加 = 0被过滤");
                return;
            }
//            NSLog(@"动画视图已添加 = 0");
            // 没有操作缓存，创建op
            PioerQueueOperation *op = [PioerQueueOperation animOperationWithUserID:userID model:model finishedBlock:^(BOOL result,NSInteger finishCount) {
                // 回调
                if (finishedBlock) {
                    finishedBlock(result);
                }
                // 将礼物信息数量存起来
                [self.userGigtInfos setObject:@(finishCount) forKey:userID];
                // 动画完成之后,要移除动画对应的操作
                [self.operationCache removeObjectForKey:userID];
                // 延时删除用户礼物信息
                [self.userGigtInfos removeObjectForKey:userID];
                
            }];
            
            // 注意：下面两句代码是和无用户礼物信息时不同的，其余的逻辑一样
            op.presentView.animCount = [[self.userGigtInfos objectForKey:userID] integerValue];
//            op.model.giftCount = op.presentView.animCount + 1;
            if (op.model.giftCount>1) {
                
            }else{
                op.model.giftCount = op.presentView.animCount + 1;
            }
            op.listView = self.parentView;
            if (isMultipleRoom) {
                op.index = self.moreUserCount % 3;
            } else {
                op.index = self.moreUserCount % 4;
            }
            
            // 将操作添加到缓存池
            [self.operationCache setObject:op forKey:userID];
//            NSLog(@"4当前moreUserCount = %d", self.moreUserCount);
            // 根据用户ID 控制显示的位置
            if (isMultipleRoom) { //多人房
                if (self.moreUserCount % 3 == 0) {
                    op.presentView.frame  = CGRectMake(-self.parentView.frame.size.width / 2, (self.parentView.frame.size.height - 50) / 2, self.parentView.frame.size.width / 2, 50);//240
                    op.presentView.originFrame = op.presentView.frame;
    //                NSLog(@"7打印 = %f", op.presentView.frame.origin.y);
                    [self.queue2 addOperation:op];
                } else if (self.moreUserCount % 3 == 1) {
                    
                    if (op.model.giftCount != 0) {
                        op.presentView.frame  = CGRectMake(-self.parentView.frame.size.width / 2, (self.parentView.frame.size.height - 50) / 2 - 70, self.parentView.frame.size.width / 2, 50);//300
                        op.presentView.originFrame = op.presentView.frame;
    //                    NSLog(@"3打印 = %f", op.presentView.frame.origin.y);
                        [self.queue1 addOperation:op];
                    }
                } else if (self.moreUserCount % 3 == 2) {
                    
                    if (op.model.giftCount != 0) {
                        op.presentView.frame  = CGRectMake(-self.parentView.frame.size.width / 2, (self.parentView.frame.size.height - 50) / 2 + 70, self.parentView.frame.size.width / 2, 50);//300
                        op.presentView.originFrame = op.presentView.frame;
    //                    NSLog(@"3打印 = %f", op.presentView.frame.origin.y);
                        [self.queue3 addOperation:op];
                    }
                }
            } else {
                if (self.moreUserCount % 4 == 0) {
                    op.presentView.frame  = CGRectMake(-self.parentView.frame.size.width / 2, (self.parentView.frame.size.height - 50) / 2, self.parentView.frame.size.width / 2, 50);//240
                    op.presentView.originFrame = op.presentView.frame;
    //                NSLog(@"7打印 = %f", op.presentView.frame.origin.y);
                    [self.queue2 addOperation:op];
                } else if (self.moreUserCount % 4 == 1) {
                    
                    if (op.model.giftCount != 0) {
                        op.presentView.frame  = CGRectMake(-self.parentView.frame.size.width / 2, (self.parentView.frame.size.height - 50) / 2 - 70, self.parentView.frame.size.width / 2, 50);//300
                        op.presentView.originFrame = op.presentView.frame;
    //                    NSLog(@"3打印 = %f", op.presentView.frame.origin.y);
                        [self.queue1 addOperation:op];
                    }
                } else if (self.moreUserCount % 4 == 2) {
                    
                    if (op.model.giftCount != 0) {
                        op.presentView.frame  = CGRectMake(-self.parentView.frame.size.width / 2, (self.parentView.frame.size.height - 50) / 2 + 70, self.parentView.frame.size.width / 2, 50);//300
                        op.presentView.originFrame = op.presentView.frame;
    //                    NSLog(@"3打印 = %f", op.presentView.frame.origin.y);
                        [self.queue3 addOperation:op];
                    }
                } else if (self.moreUserCount % 4 == 3) {
                    
                    if (op.model.giftCount != 0) {
                        op.presentView.frame  = CGRectMake(-self.parentView.frame.size.width / 2, (self.parentView.frame.size.height - 50) / 2 - 140, self.parentView.frame.size.width / 2, 50);//300
                        op.presentView.originFrame = op.presentView.frame;
    //                    NSLog(@"3打印 = %f", op.presentView.frame.origin.y);
                        [self.queue4 addOperation:op];
                    }
                }
            }
        }
        // 在没有用户礼物信息时
        else
        {
              //ALog(@"11111-没有用户礼物信");
            // 如果有操作缓存，则直接累加，不需要重新创建op
            if ([self.operationCache objectForKey:userID] !=nil) {
                PioerQueueOperation *op = [self.operationCache objectForKey:userID];
                op.presentView.model = model;
                [op.presentView shakeNumberLabel];
//                NSLog(@"动画视图已添加 = 1被过滤");
                return;
            }
//            NSLog(@"动画视图已添加 = 1");
            PioerQueueOperation *op = [PioerQueueOperation animOperationWithUserID:userID model:model finishedBlock:^(BOOL result,NSInteger finishCount) {
                //ALog(@"finishCount = %ld",(long)finishCount);
                // 回调
                if (finishedBlock) {
                    finishedBlock(result);
                }
                // 将礼物信息数量存起来
                [self.userGigtInfos setObject:@(finishCount) forKey:userID];
                // 动画完成之后,要移除动画对应的操作
                [self.operationCache removeObjectForKey:userID];
                // 延时删除用户礼物信息
                [self.userGigtInfos removeObjectForKey:userID];
                [self.oldUser removeObject:userID];
            }];
            op.listView = self.parentView;
            // 将操作添加到缓存池
            [self.operationCache setObject:op forKey:userID];
//            op.index = self.moreUserCount % 4;
            if (isMultipleRoom) {
                op.index = self.moreUserCount % 3;
            } else {
                op.index = self.moreUserCount % 4;
            }
//            NSLog(@"3当前moreUserCount = %d", self.moreUserCount);
//            NSLog(@"3当前op.model.giftCount = %ld", (long)op.model.giftCount);
            /*
             2024-05-17 13:43:17.893553+0800 Pioer[1476:53259] 3当前moreUserCount = 0
             2024-05-17 13:43:17.893840+0800 Pioer[1476:53259] 3当前op.model.giftCount = 50
             */
            // 根据用户ID 控制显示的位置
            if (isMultipleRoom) { //多人房
                if (self.moreUserCount % 3 == 0) {
                    op.presentView.frame  = CGRectMake(-self.parentView.frame.size.width / 2, (self.parentView.frame.size.height - 50) / 2, self.parentView.frame.size.width / 2, 50);//240
                    op.presentView.originFrame = op.presentView.frame;
    //                NSLog(@"7打印 = %f", op.presentView.frame.origin.y);
                    [self.queue2 addOperation:op];
                } else if (self.moreUserCount % 3 == 1) {
                    
                    if (op.model.giftCount != 0) {
                        op.presentView.frame  = CGRectMake(-self.parentView.frame.size.width / 2, (self.parentView.frame.size.height - 50) / 2 - 70, self.parentView.frame.size.width / 2, 50);//300
                        op.presentView.originFrame = op.presentView.frame;
    //                    NSLog(@"3打印 = %f", op.presentView.frame.origin.y);
                        [self.queue1 addOperation:op];
                    }
                } else if (self.moreUserCount % 3 == 2) {
                    
                    if (op.model.giftCount != 0) {
                        op.presentView.frame  = CGRectMake(-self.parentView.frame.size.width / 2, (self.parentView.frame.size.height - 50) / 2 + 70, self.parentView.frame.size.width / 2, 50);//300
                        op.presentView.originFrame = op.presentView.frame;
    //                    NSLog(@"3打印 = %f", op.presentView.frame.origin.y);
                        [self.queue3 addOperation:op];
                    }
                }
            } else {
                if (self.moreUserCount % 4 == 0) {
                    op.presentView.frame  = CGRectMake(-self.parentView.frame.size.width / 2, (self.parentView.frame.size.height - 50) / 2, self.parentView.frame.size.width / 2, 50);//240
                    op.presentView.originFrame = op.presentView.frame;
    //                NSLog(@"7打印 = %f", op.presentView.frame.origin.y);
                    [self.queue2 addOperation:op];
                } else if (self.moreUserCount % 4 == 1) {
                    
                    if (op.model.giftCount != 0) {
                        op.presentView.frame  = CGRectMake(-self.parentView.frame.size.width / 2, (self.parentView.frame.size.height - 50) / 2 - 70, self.parentView.frame.size.width / 2, 50);//300
                        op.presentView.originFrame = op.presentView.frame;
    //                    NSLog(@"3打印 = %f", op.presentView.frame.origin.y);
                        [self.queue1 addOperation:op];
                    }
                } else if (self.moreUserCount % 4 == 2) {
                    
                    if (op.model.giftCount != 0) {
                        op.presentView.frame  = CGRectMake(-self.parentView.frame.size.width / 2, (self.parentView.frame.size.height - 50) / 2 + 70, self.parentView.frame.size.width / 2, 50);//300
                        op.presentView.originFrame = op.presentView.frame;
    //                    NSLog(@"3打印 = %f", op.presentView.frame.origin.y);
                        [self.queue3 addOperation:op];
                    }
                } else if (self.moreUserCount % 4 == 3) {
                    
                    if (op.model.giftCount != 0) {
                        op.presentView.frame  = CGRectMake(-self.parentView.frame.size.width / 2, (self.parentView.frame.size.height - 50) / 2 - 140, self.parentView.frame.size.width / 2, 50);//300
                        op.presentView.originFrame = op.presentView.frame;
    //                    NSLog(@"3打印 = %f", op.presentView.frame.origin.y);
                        [self.queue4 addOperation:op];
                    }
                }
            }
            
            
        }
        
        
        
    }else{
        //ALog(@"0000");
        //之前没送过这个礼物
        self.moreUserCount ++;
//        NSLog(@"动画视图已添加 = 2被过滤");
        //在有用户礼物信息时
        if ([self.userGigtInfos objectForKey:userID]) {
            //ALog(@"0000-有礼物信息");
//            NSLog(@"动画视图已添加 = 2");
            PioerQueueOperation *op = [PioerQueueOperation animOperationWithUserID:userID model:model finishedBlock:^(BOOL result,NSInteger finishCount) {
                // 回调
                if (finishedBlock) {
                    finishedBlock(result);
                }
                // 将礼物信息数量存起来
                [self.userGigtInfos setObject:@(finishCount) forKey:userID];
                // 动画完成之后,要移除动画对应的操作
                [self.operationCache removeObjectForKey:userID];
                // 延时删除用户礼物信息
                [self.userGigtInfos removeObjectForKey:userID];
                
            }];
            
            // 注意：下面两句代码是和无用户礼物信息时不同的，其余的逻辑一样
            op.presentView.animCount = [[self.userGigtInfos objectForKey:userID] integerValue];
//            op.model.giftCount = op.presentView.animCount + 1;
            if (op.model.giftCount>1) {
                
            }else{
                op.model.giftCount = op.presentView.animCount + 1;
            }
           
            op.listView = self.parentView;
            op.index = self.moreUserCount;
            // 将操作添加到缓存池
            [self.operationCache setObject:op forKey:userID];
//            NSLog(@"2当前moreUserCount = %d", self.moreUserCount);
            // 根据用户ID 控制显示的位置
            if (isMultipleRoom) { //多人房
                if (self.moreUserCount % 3 == 0) {
                    op.presentView.frame  = CGRectMake(-self.parentView.frame.size.width / 2, (self.parentView.frame.size.height - 50) / 2, self.parentView.frame.size.width / 2, 50);//240
                    op.presentView.originFrame = op.presentView.frame;
    //                NSLog(@"7打印 = %f", op.presentView.frame.origin.y);
                    [self.queue2 addOperation:op];
                } else if (self.moreUserCount % 3 == 1) {
                    
                    if (op.model.giftCount != 0) {
                        op.presentView.frame  = CGRectMake(-self.parentView.frame.size.width / 2, (self.parentView.frame.size.height - 50) / 2 - 70, self.parentView.frame.size.width / 2, 50);//300
                        op.presentView.originFrame = op.presentView.frame;
    //                    NSLog(@"3打印 = %f", op.presentView.frame.origin.y);
                        [self.queue1 addOperation:op];
                    }
                } else if (self.moreUserCount % 3 == 2) {
                    
                    if (op.model.giftCount != 0) {
                        op.presentView.frame  = CGRectMake(-self.parentView.frame.size.width / 2, (self.parentView.frame.size.height - 50) / 2 + 70, self.parentView.frame.size.width / 2, 50);//300
                        op.presentView.originFrame = op.presentView.frame;
    //                    NSLog(@"3打印 = %f", op.presentView.frame.origin.y);
                        [self.queue3 addOperation:op];
                    }
                }
            } else {
                if (self.moreUserCount % 4 == 0) {
                    op.presentView.frame  = CGRectMake(-self.parentView.frame.size.width / 2, (self.parentView.frame.size.height - 50) / 2, self.parentView.frame.size.width / 2, 50);//240
                    op.presentView.originFrame = op.presentView.frame;
    //                NSLog(@"7打印 = %f", op.presentView.frame.origin.y);
                    [self.queue2 addOperation:op];
                } else if (self.moreUserCount % 4 == 1) {
                    
                    if (op.model.giftCount != 0) {
                        op.presentView.frame  = CGRectMake(-self.parentView.frame.size.width / 2, (self.parentView.frame.size.height - 50) / 2 - 70, self.parentView.frame.size.width / 2, 50);//300
                        op.presentView.originFrame = op.presentView.frame;
    //                    NSLog(@"3打印 = %f", op.presentView.frame.origin.y);
                        [self.queue1 addOperation:op];
                    }
                } else if (self.moreUserCount % 4 == 2) {
                    
                    if (op.model.giftCount != 0) {
                        op.presentView.frame  = CGRectMake(-self.parentView.frame.size.width / 2, (self.parentView.frame.size.height - 50) / 2 + 70, self.parentView.frame.size.width / 2, 50);//300
                        op.presentView.originFrame = op.presentView.frame;
    //                    NSLog(@"3打印 = %f", op.presentView.frame.origin.y);
                        [self.queue3 addOperation:op];
                    }
                } else if (self.moreUserCount % 4 == 3) {
                    
                    if (op.model.giftCount != 0) {
                        op.presentView.frame  = CGRectMake(-self.parentView.frame.size.width / 2, (self.parentView.frame.size.height - 50) / 2 - 140, self.parentView.frame.size.width / 2, 50);//300
                        op.presentView.originFrame = op.presentView.frame;
    //                    NSLog(@"3打印 = %f", op.presentView.frame.origin.y);
                        [self.queue4 addOperation:op];
                    }
                }
            }
        }
        // 在没有用户礼物信息时
        else
        {   // 如果有操作缓存，则直接累加，不需要重新创建op
             //ALog(@"0000-没有礼物信息");
//            NSLog(@"动画视图已添加 = 3");
            PioerQueueOperation *op = [PioerQueueOperation animOperationWithUserID:userID model:model finishedBlock:^(BOOL result,NSInteger finishCount) {
                // 回调
                if (finishedBlock) {
                    finishedBlock(result);
                }
                // 将礼物信息数量存起来
                [self.userGigtInfos setObject:@(finishCount) forKey:userID];
                // 动画完成之后,要移除动画对应的操作
                [self.operationCache removeObjectForKey:userID];
                // 延时删除用户礼物信息
                [self.userGigtInfos removeObjectForKey:userID];
                [self.oldUser removeObject:userID];
        
            }];
            op.listView = self.parentView;
            // 将操作添加到缓存池
            [self.operationCache setObject:op forKey:userID];
            op.index = self.moreUserCount;
//            NSLog(@"1当前moreUserCount = %d", self.moreUserCount);
            // 根据用户ID 控制显示的位置
            if (isMultipleRoom) { //多人房
                if (self.moreUserCount % 3 == 0) {
                    op.presentView.frame  = CGRectMake(-self.parentView.frame.size.width / 2, (self.parentView.frame.size.height - 50) / 2, self.parentView.frame.size.width / 2, 50);//240
                    op.presentView.originFrame = op.presentView.frame;
    //                NSLog(@"7打印 = %f", op.presentView.frame.origin.y);
                    [self.queue2 addOperation:op];
                } else if (self.moreUserCount % 3 == 1) {
                    
                    if (op.model.giftCount != 0) {
                        op.presentView.frame  = CGRectMake(-self.parentView.frame.size.width / 2, (self.parentView.frame.size.height - 50) / 2 - 70, self.parentView.frame.size.width / 2, 50);//300
                        op.presentView.originFrame = op.presentView.frame;
    //                    NSLog(@"3打印 = %f", op.presentView.frame.origin.y);
                        [self.queue1 addOperation:op];
                    }
                } else if (self.moreUserCount % 3 == 2) {
                    
                    if (op.model.giftCount != 0) {
                        op.presentView.frame  = CGRectMake(-self.parentView.frame.size.width / 2, (self.parentView.frame.size.height - 50) / 2 + 70, self.parentView.frame.size.width / 2, 50);//300
                        op.presentView.originFrame = op.presentView.frame;
    //                    NSLog(@"3打印 = %f", op.presentView.frame.origin.y);
                        [self.queue3 addOperation:op];
                    }
                }
            } else {
                if (self.moreUserCount % 4 == 0) {
                    op.presentView.frame  = CGRectMake(-self.parentView.frame.size.width / 2, (self.parentView.frame.size.height - 50) / 2, self.parentView.frame.size.width / 2, 50);//240
                    op.presentView.originFrame = op.presentView.frame;
    //                NSLog(@"7打印 = %f", op.presentView.frame.origin.y);
                    [self.queue2 addOperation:op];
                } else if (self.moreUserCount % 4 == 1) {
                    
                    if (op.model.giftCount != 0) {
                        op.presentView.frame  = CGRectMake(-self.parentView.frame.size.width / 2, (self.parentView.frame.size.height - 50) / 2 - 70, self.parentView.frame.size.width / 2, 50);//300
                        op.presentView.originFrame = op.presentView.frame;
    //                    NSLog(@"3打印 = %f", op.presentView.frame.origin.y);
                        [self.queue1 addOperation:op];
                    }
                } else if (self.moreUserCount % 4 == 2) {
                    
                    if (op.model.giftCount != 0) {
                        op.presentView.frame  = CGRectMake(-self.parentView.frame.size.width / 2, (self.parentView.frame.size.height - 50) / 2 + 70, self.parentView.frame.size.width / 2, 50);//300
                        op.presentView.originFrame = op.presentView.frame;
    //                    NSLog(@"3打印 = %f", op.presentView.frame.origin.y);
                        [self.queue3 addOperation:op];
                    }
                } else if (self.moreUserCount % 4 == 3) {
                    
                    if (op.model.giftCount != 0) {
                        op.presentView.frame  = CGRectMake(-self.parentView.frame.size.width / 2, (self.parentView.frame.size.height - 50) / 2 - 140, self.parentView.frame.size.width / 2, 50);//300
                        op.presentView.originFrame = op.presentView.frame;
    //                    NSLog(@"3打印 = %f", op.presentView.frame.origin.y);
                        [self.queue4 addOperation:op];
                    }
                }
            }
            
        }
    }
    
    [self.oldUser addObject: userID];
    
}

/// 取消上一次的动画操作 暂时没用到
- (void)cancelOperationWithLastUserID:(NSString *)userID {
    // 当上次为空时就不执行取消操作 (第一次进入执行时才会为空)
    if (userID!=nil) {
        [[self.operationCache objectForKey:userID] cancel];
    }
}

- (NSOperationQueue *)queue1
{
    if (_queue1==nil) {
        _queue1 = [[NSOperationQueue alloc] init];
        _queue1.maxConcurrentOperationCount = 1;
        
    }
    return _queue1;
}

- (NSOperationQueue *)queue2
{
    if (_queue2==nil) {
        _queue2 = [[NSOperationQueue alloc] init];
        _queue2.maxConcurrentOperationCount = 1;
    }
    return _queue2;
}

- (NSOperationQueue *)queue3
{
    if (_queue3==nil) {
        _queue3 = [[NSOperationQueue alloc] init];
        _queue3.maxConcurrentOperationCount = 1;
    }
    return _queue3;
}

- (NSOperationQueue *)queue4
{
    if (_queue4==nil) {
        _queue4 = [[NSOperationQueue alloc] init];
        _queue4.maxConcurrentOperationCount = 1;
    }
    return _queue4;
}

- (NSCache *)operationCache
{
    if (_operationCache==nil) {
        _operationCache = [[NSCache alloc] init];
    }
    return _operationCache;
}

- (NSCache *)userGigtInfos {
    if (_userGigtInfos == nil) {
        _userGigtInfos = [[NSCache alloc] init];
    }
    return _userGigtInfos;
}

- (NSCache *)gifInfos {
    if (_gifInfos == nil) {
        _gifInfos = [[NSCache alloc] init];
    }
    return _gifInfos;
}

@end

