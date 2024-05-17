//
//  PioerDownGiftConfig.h
//  Pioer
//
//  Created by Pioer on 22/03/24.
//

#import <Foundation/Foundation.h>
#import "PioerGiftDownloadManager.h"
#import "PioerDownCacheManager.h"
#import "PioerdReceiveGiftData.h"

NS_ASSUME_NONNULL_BEGIN
//GiftConfig
@interface PioerDownGiftConfig : NSObject
/**
 下载礼物特效
 
 */
+ (void)downLoadUrl:(PioerdReceiveGiftData *)model;

/**
 本地是否存在这个礼物
 */
+ (BOOL)isdownloadedGiftFile:(PioerdReceiveGiftData *)model;


/**
 get本地已下载的礼物信息
 */
+ (NSDictionary *)getThisGiftInfo:(PioerdReceiveGiftData *)model;

/**
下载缓存所有礼物特效
 
 */
+ (void)downLoadAllGift:(NSMutableArray *)gifts;
@end

NS_ASSUME_NONNULL_END
