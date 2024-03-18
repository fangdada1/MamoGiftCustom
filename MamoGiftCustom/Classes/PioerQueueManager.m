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
        self.giftArray = [NSMutableArray array];
    }
    return self;
}

/// 动画操作 : 需要UserID和回调
- (void)animWithUserID:(NSString *)userID model:(PioerQueueGiftData *)model finishedBlock:(void(^)(BOOL result))finishedBlock {
    
    //跟之前的礼物id比较
    if ([self.oldUser isEqualToString:userID]) {
        //ALog(@"11111");
        //在有用户礼物信息时
        if ([self.userGigtInfos objectForKey:userID]){
              //ALog(@"11111-有用户礼物信");
            // 如果有操作缓存，则直接累加，不需要重新创建op
            if ([self.operationCache objectForKey:userID]!=nil) {
                PioerQueueOperation *op = [self.operationCache objectForKey:userID];
                op.presentView.model = model;
                [op.presentView shakeNumberLabel];
                return;
            }
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
            op.index = self.moreUserCount % 2;
            
            // 将操作添加到缓存池
            [self.operationCache setObject:op forKey:userID];
            
            // 根据用户ID 控制显示的位置
            if (self.moreUserCount % 2) {
                
                if (op.model.giftCount != 0) {
                    op.presentView.frame  = CGRectMake(-self.parentView.frame.size.width / 2, 300, self.parentView.frame.size.width / 2, 50);
                    op.presentView.originFrame = op.presentView.frame;
                    [self.queue1 addOperation:op];
                }
            }else {
                
                if (op.model.giftCount != 0) {
                    op.presentView.frame  = CGRectMake(-self.parentView.frame.size.width / 2, 240, self.parentView.frame.size.width / 2, 50);
                    op.presentView.originFrame = op.presentView.frame;
                    [self.queue2 addOperation:op];
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
                return;
            }
            
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
                [self.giftArray removeObject:userID];
            }];
            op.listView = self.parentView;
            // 将操作添加到缓存池
            [self.operationCache setObject:op forKey:userID];
            op.index = self.moreUserCount % 2;
            
            if (self.moreUserCount % 2) {
                if (op.model.giftCount != 0) {
                    op.presentView.frame  = CGRectMake(-self.parentView.frame.size.width / 2, 300, self.parentView.frame.size.width / 2, 50);
                    op.presentView.originFrame = op.presentView.frame;
                    [self.queue1 addOperation:op];
                }
            }else{
                
                if (op.model.giftCount != 0) {
                    op.presentView.frame  = CGRectMake(-self.parentView.frame.size.width / 2, 240, self.parentView.frame.size.width / 2, 50);
                    op.presentView.originFrame = op.presentView.frame;
                    [self.queue2 addOperation:op];
                }
            }
            
        }
        
        
        
    }else{
        //ALog(@"0000");
        //之前没送过这个礼物
        self.moreUserCount ++;
        //在有用户礼物信息时
        if ([self.userGigtInfos objectForKey:userID]) {
            //ALog(@"0000-有礼物信息");
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
            
            // 根据用户ID 控制显示的位置
            if (self.moreUserCount  % 2) {
                
                if (op.model.giftCount != 0) {
                    op.presentView.frame  = CGRectMake(-self.parentView.frame.size.width / 2, 380, self.parentView.frame.size.width / 2, 50);//300,
                    op.presentView.originFrame = op.presentView.frame;
                    [self.queue1 addOperation:op];
                }
            }else {
                
                if (op.model.giftCount != 0) {
                    op.presentView.frame  = CGRectMake(-self.parentView.frame.size.width / 2, 300, self.parentView.frame.size.width / 2, 50);//240
                    op.presentView.originFrame = op.presentView.frame;
                    [self.queue2 addOperation:op];
                }
            }
        }
        // 在没有用户礼物信息时
        else
        {   // 如果有操作缓存，则直接累加，不需要重新创建op
             //ALog(@"0000-没有礼物信息");
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
                [self.giftArray removeObject:userID];
        
            }];
            op.listView = self.parentView;
            // 将操作添加到缓存池
            [self.operationCache setObject:op forKey:userID];
            op.index = self.moreUserCount;
            
            if (self.moreUserCount  % 2) {
                if (op.model.giftCount != 0) {
                    op.presentView.frame  = CGRectMake(-self.parentView.frame.size.width / 2, 300, self.parentView.frame.size.width / 2, 50);
                    op.presentView.originFrame = op.presentView.frame;
                    [self.queue1 addOperation:op];
                }
            }else{
                
                if (op.model.giftCount != 0) {
                    op.presentView.frame  = CGRectMake(-self.parentView.frame.size.width / 2, 240, self.parentView.frame.size.width / 2, 50);
                    op.presentView.originFrame = op.presentView.frame;
                    [self.queue2 addOperation:op];
                }
            }
        }
    }
    
    self.oldUser = userID;
    
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

