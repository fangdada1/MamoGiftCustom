//
//  NSString+DownloadGiftStringHash.h
//  Pioer
//
//  Created by Pioer on 22/03/24.
//

#import <Foundation/Foundation.h>

#define KFullPath [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject]

#define KFullDirector [NSString stringWithFormat:@"%@/downloads/",KFullPath]

NS_ASSUME_NONNULL_BEGIN
//NSString+SGHashString
@interface NSString (DownloadGiftStringHash)

/** 获取MD5加密哈希散列值字符串 */
- (NSString *)sg_md5HashString;

@end

NS_ASSUME_NONNULL_END
