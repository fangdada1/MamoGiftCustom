//
//  PioerQueueClass.m
//  Pioer
//
//  Created by Pioer on 16/08/24.
//

#import "PioerQueueClass.h"

@implementation PioerQueueClass

// 静态变量来保存单例的 BOOL 值
static BOOL _firstQueueInUse = NO;
static BOOL _secondQueueInUse = NO;
static BOOL _thirdQueueInUse = NO;
static BOOL _fourQueueInUse = NO;

+ (BOOL)firstQueueInUse {
    return _firstQueueInUse;
}

+ (void)setFirstQueueInUse:(BOOL)value {
    _firstQueueInUse = value;
}

+ (BOOL)secondQueueInUse {
    return _secondQueueInUse;
}

+ (void)setSecondQueueInUse:(BOOL)value {
    _secondQueueInUse = value;
}


+ (BOOL)thirdQueueInUse {
    return _thirdQueueInUse;
}

+ (void)setThirdQueueInUse:(BOOL)value {
    _thirdQueueInUse = value;
}


+ (BOOL)fourQueueInUse {
    return _fourQueueInUse;
}

+ (void)setFourQueueInUse:(BOOL)value {
    _fourQueueInUse = value;
}


@end
