//
//  PioerQueueManager.h
//  Pioer
//
//  Created by Pioer on 01/03/24.
//

#import <UIKit/UIKit.h>
#import "PioerQueueGiftData.h"

NS_ASSUME_NONNULL_BEGIN

@interface PioerQueueManager : NSObject //giftOperationManager

+ (instancetype)shared;
+ (void)attemptDealloc;

@property (nonatomic,strong) UIView *parentView;
@property (nonatomic,strong) PioerQueueGiftData *model;
@property (nonatomic,retain) NSMutableArray *giftArray;

/// 队列1
@property (nonatomic,strong) NSOperationQueue *queue1;
/// 队列2
@property (nonatomic,strong) NSOperationQueue *queue2;

/// 操作缓存池
@property (nonatomic,strong) NSCache *operationCache;

/// 维护用户礼物信息
@property (nonatomic,strong) NSCache *userGigtInfos;

//礼物的id
@property (nonatomic,strong) NSCache *gifInfos;

@property (nonatomic,copy) NSString *oldUser;

//用户 count
@property (nonatomic,assign) int moreUserCount;


/// 动画操作 : 需要UserID和回调
- (void)animWithUserID:(NSString *)userID model:(PioerQueueGiftData *)model finishedBlock:(void(^)(BOOL result))finishedBlock;

/// 取消上一次的动画操作
- (void)cancelOperationWithLastUserID:(NSString *)userID;

@end

NS_ASSUME_NONNULL_END
