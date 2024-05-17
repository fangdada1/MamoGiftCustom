//
//  NSString+DownloadGiftStringHash.m
//  Pioer
//
//  Created by Pioer on 22/03/24.
//

#import "NSString+DownloadGiftStringHash.h"
#import <CommonCrypto/CommonCrypto.h>

@implementation NSString (DownloadGiftStringHash)

#pragma mark - MD5加密
- (NSString *)sg_md5HashString {
    const char *str = self.UTF8String;
    
    uint8_t buffer[CC_MD5_DIGEST_LENGTH];
    
    CC_MD5(str, (CC_LONG)strlen(str), buffer);
    
    return [self sg_stringFromBytes:buffer length:CC_MD5_DIGEST_LENGTH];
    
}

/**
 *  返回二进制 Bytes 流的字符串表示形式
 *
 *  bytes  二进制 Bytes 数组
 *  length 数组长度
 *
 *  字符串表示形式
 */
- (NSString *)sg_stringFromBytes:(uint8_t *)bytes length:(int)length {
    NSMutableString *strM = [NSMutableString string];
    
    for (int i = 0; i < length; i++) {
        [strM appendFormat:@"%02x", bytes[i]];
    }
    
    return [strM copy];
}
@end
