//
//  PioerQueueClass.h
//  Pioer
//
//  Created by Pioer on 16/08/24.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PioerQueueClass : NSObject

+ (BOOL)firstQueueInUse;
+ (void)setFirstQueueInUse:(BOOL)value;

+ (BOOL)secondQueueInUse;
+ (void)setSecondQueueInUse:(BOOL)value;

+ (BOOL)thirdQueueInUse;
+ (void)setThirdQueueInUse:(BOOL)value;

+ (BOOL)fourQueueInUse;
+ (void)setFourQueueInUse:(BOOL)value;

@end

NS_ASSUME_NONNULL_END
