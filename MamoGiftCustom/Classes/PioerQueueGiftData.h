//
//  PioerQueueGiftData.h
//  Pioer
//
//  Created by Pioer on 01/03/24.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PioerQueueGiftData : NSObject //GiftModel

@property (nonatomic,copy) NSString * _Nullable senderHead; // 送礼物者头像
@property (nonatomic,copy) NSString * _Nullable senderName; // 送礼物者Name
@property (nonatomic,copy) NSString * _Nullable senderUserId; // 送礼物者id

@property (nonatomic,assign) int isAnchorSend; // 是否是主播端送 1：是 0：不是
@property (nonatomic,copy) NSString * _Nullable giftImage; // 礼物icon地址
@property (nonatomic,copy) NSString * _Nullable animEffectUrl;//礼物动画地址
@property (nonatomic,copy) NSString * _Nullable giftName; // 礼物名称
@property (nonatomic,assign) NSInteger giftCount; // 礼物个数
@property (nonatomic,copy)NSString * _Nullable giftUid;//礼物id
@property (nonatomic,assign)int diamonds; //礼物价格

@property (nonatomic,assign)NSInteger show_type; //2 - 250 3 - 500  其他100  动画效果
@property (nonatomic,assign)int winning_multiple; //倍数 > 0显示 100 250 500

@property (nullable, nonatomic, copy) NSString  *updatedAt;
//礼物类型 1幸运礼物 0礼物其他
@property (nonatomic, assign) NSInteger  nowType;

@end

NS_ASSUME_NONNULL_END
