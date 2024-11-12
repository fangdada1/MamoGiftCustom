//
//  PioerQueueOperation.h
//  Pioer
//
//  Created by Pioer on 01/03/24.
//

#import <UIKit/UIKit.h>
#import "PioerQueueView.h"
#import "PioerQueueGiftData.h"

NS_ASSUME_NONNULL_BEGIN

@interface PioerQueueOperation : NSOperation //giftOperation

@property (nonatomic,strong) PioerQueueView *presentView;
@property (nonatomic,strong) UIView *listView;
@property (nonatomic,strong) PioerQueueGiftData *model;
@property (nonatomic,assign) NSInteger index;
@property (nonatomic,copy) NSString *userID; // 新增用户唯一标示，记录礼物信息
@property (nonatomic,assign) int giftBottom; //礼物下标

// 回调参数增加了结束时礼物累计数
+ (instancetype)animOperationWithUserID:(NSString *)userID model:(PioerQueueGiftData *)model finishedBlock:(void(^)(BOOL result,NSInteger finishCount))finishedBlock;

@end

NS_ASSUME_NONNULL_END
