//
//  PioerdReceiveGiftData.h
//  Pioer
//
//  Created by Pioer on 22/03/24.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
//ReceivedGiftInfo
@interface PioerdReceiveGiftData : NSObject
@property (nullable, nonatomic, copy) NSString  *diamonds;//礼物价格
@property (nullable, nonatomic, copy) NSString  *icon;//礼物icon地址
@property (nullable, nonatomic, copy) NSString  *name;//礼物名字
@property (nullable, nonatomic, copy) NSString  *uid;//礼物id
@property (nullable, nonatomic, copy) NSString  *quantity;//数量
@property (nullable, nonatomic, copy) NSString  *message;//
@property (nullable, nonatomic, copy) NSString  *animEffectUrl;//特效动画文件地址
@property (nullable, nonatomic, copy) NSString  *updatedAt;//礼物更新时间

///礼物类型
//1 SVGAPlayer播放
@property (nullable, nonatomic, copy) NSString  *type;

@end

NS_ASSUME_NONNULL_END
