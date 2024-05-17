//
//  PioerGiftDownloadSession.h
//  Pioer
//
//  Created by Pioer on 22/03/24.
//

#import <Foundation/Foundation.h>
#import "PioerGiftDownloadManager.h"

NS_ASSUME_NONNULL_BEGIN
//SGDownloadSession
@interface PioerGiftDownloadSession : NSObject
// 接口回调
- (void)downloadWithURL:(PioerdReceiveGiftData *)model
                  begin:(void(^)(NSString *))begin
               progress:(void(^)(NSInteger,NSInteger))progress
               complete:(void(^)(NSDictionary *,NSError *))complet;


- (void)startDownLoadWithUrl:(NSString *)url;

- (void)supendDownloadWithUrl:(NSString *)url;

- (void)cancelDownloadWithUrl:(NSString *)url;

- (void)cancelAllDownloads;
- (void)startAllDownloads;
- (void)suspendAllDownloads;

@end

NS_ASSUME_NONNULL_END
