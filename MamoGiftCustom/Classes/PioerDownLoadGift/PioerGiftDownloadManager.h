//
//  PioerGiftDownloadManager.h
//  Pioer
//
//  Created by Pioer on 22/03/24.
//

#import <Foundation/Foundation.h>
#import "PioerdReceiveGiftData.h"

/**
 block 回调
 */
typedef void(^SGDownloadBeginBlock)(NSString * _Nullable filePath);
typedef void(^SGDownloadProgressBlock)(NSInteger completeSize,NSInteger expectSize);
typedef void(^SGDownloadCompleteBlock)(NSDictionary * _Nullable respose,NSError * _Nullable error);



NS_ASSUME_NONNULL_BEGIN
/**
 下载管理  SGDownloadManager
 */
@interface PioerGiftDownloadManager : NSObject
/** 实例化对象（单例） */
+ (instancetype)shareManager;

#pragma mark - 添加下载任务同时开启任务下载
/** 开启下载任务 监听完成下载 */
- (void)downloadWithURL:(NSURL *)url
complete:(SGDownloadCompleteBlock)complete;

/** 开启下载任务 监听下载进度、完成下载 */
- (void)downloadWithURL:(PioerdReceiveGiftData *)model
progress:(SGDownloadProgressBlock)progress
complete:(SGDownloadCompleteBlock)complete;

/** 开启下载任务 监听开始下载信息、下载进度、完成下载 */
- (void)downloadWithURL:(NSURL *)url
begin:(SGDownloadBeginBlock)begin
progress:(SGDownloadProgressBlock)progress
complete:(SGDownloadCompleteBlock)complete;



#pragma mark - 队列中的任务进行操作
/** 开始任务（不会自动添加任务，列队中没有就直接返回） */
- (void)startDownLoadWithUrl:(NSString *)url;

/** 暂停任务（暂停下载url内容的任务） */
- (void)supendDownloadWithUrl:(NSString *)url;

/** 取消任务（取消下载url内容的任务） */
- (void)cancelDownloadWithUrl:(NSString *)url;


/** 暂停当前所有的下载任务 下载任务不会从列队中删除 */
- (void)suspendAllDownloadTask;

/** 开启当前列队中所有被暂停的下载任务 */
- (void)startAllDownloadTask;

/** 停止当前所有的下载任务 调用此方法会清空所有列队下载任务 */
- (void)stopAllDownloads;

@end





NS_ASSUME_NONNULL_END
