//
//  NSURLSession+PioerDownloadTask.h
//  Pioer
//
//  Created by Pioer on 22/03/24.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
//NSURLSession+SGDownloadTask
@interface NSURLSession (PioerDownloadTask)

/**
 构造一个从特定位置开始下载的任务

 @param urlString 资源路径的URLstring
 @param startSize 开始的位置
 @return 下载任务
 */
- (NSURLSessionDataTask *)sg_downloadDataTaskWithURLString:(NSString *)urlString
                                                  startSize:(int64_t)startSize;

@end

NS_ASSUME_NONNULL_END
