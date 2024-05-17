//
//  PioerGiftDownloadManager.m
//  Pioer
//
//  Created by Pioer on 22/03/24.
//

#import "PioerGiftDownloadManager.h"
#import "PioerGiftDownloadSession.h"
#import "PioerDownCacheManager.h"
#import "PioerdReceiveGiftData.h"

@interface PioerGiftDownloadManager ()

@property(nonatomic,strong) PioerGiftDownloadSession *downloadSession;

@end

@implementation PioerGiftDownloadManager

+ (instancetype)shareManager {
    static PioerGiftDownloadManager *_instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}


#pragma mark - 外界交互
- (void)downloadWithURL:(NSURL *)url complete:(void(^)(NSDictionary *,NSError *))complete{
    [self downloadWithURL:url begin:nil progress:nil complete:complete];
}

- (void)downloadWithURL:(NSURL *)url progress:(void(^)(NSInteger,NSInteger ))progress complete:(void(^)(NSDictionary *,NSError *))complete {
    [self downloadWithURL:url begin:nil progress:progress complete:complete];
}

- (void)downloadWithURL:(PioerdReceiveGiftData *)model begin:(void(^)(NSString *))begin progress:(void(^)(NSInteger,NSInteger))progress complete:(void(^)(NSDictionary *,NSError *))complete {
    // 开启异步 操作
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        // 本地查找
        NSDictionary *fileInfo = [PioerDownCacheManager queryFileInfoWithUrl:[NSURL URLWithString:model.animEffectUrl].absoluteString];
        NSLog(@"之前的时间=%@，当前时间=%@",[PioerDownCacheManager updatedAtTimeWith:[NSURL URLWithString:model.animEffectUrl].absoluteString], model.updatedAt);
        // 本地存在直接返回
        if ([fileInfo[isFinished] integerValue] && [[PioerDownCacheManager updatedAtTimeWith:[NSURL URLWithString:model.animEffectUrl].absoluteString] isEqualToString:model.updatedAt]) {
            NSLog(@"本地存在");
            dispatch_async(dispatch_get_main_queue(), ^{
                !complete ? : complete(fileInfo,nil);
            });
            return;
        }
        
        // 交给downloader下载
        [self.downloadSession downloadWithURL:model begin:begin progress:progress complete:complete];
    });
    
}

#pragma mark -
- (void)startDownLoadWithUrl:(NSString *)url {
    // 本地查找
    NSDictionary *fileInfo = [PioerDownCacheManager queryFileInfoWithUrl:url];
    
    if (fileInfo) {
        return;
    }
    //
    [self.downloadSession startDownLoadWithUrl:url];
}

- (void)supendDownloadWithUrl:(NSString *)url {
    // 暂停下载
    [_downloadSession supendDownloadWithUrl:url];
}

- (void)cancelDownloadWithUrl:(NSString *)url {
    // 取消下载
    [_downloadSession cancelDownloadWithUrl:url];
}


/** 暂停当前所有的下载任务 下载任务不会从列队中删除 */
- (void)suspendAllDownloadTask {
    [_downloadSession suspendAllDownloads];
}

/** 开启当前列队中所有被暂停的下载任务 */
- (void)startAllDownloadTask {
    [_downloadSession startAllDownloads];
}

/** 停止当前所有的下载任务 调用此方法会清空所有列队下载任务 */
- (void)stopAllDownloads {
    [_downloadSession cancelAllDownloads];
    _downloadSession = nil;
}

#pragma mark - lazy load
- (PioerGiftDownloadSession *)downloadSession {
    if (!_downloadSession) {
        _downloadSession = [[PioerGiftDownloadSession alloc] init];
    }
    return _downloadSession;
}

@end

