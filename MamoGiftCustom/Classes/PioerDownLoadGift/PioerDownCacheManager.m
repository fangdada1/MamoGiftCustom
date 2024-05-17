//
//  PioerDownCacheManager.m
//  Pioer
//
//  Created by Pioer on 22/03/24.
//

#import "PioerDownCacheManager.h"
#import "NSString+DownloadGiftStringHash.h"
#import "PioerGiftDownloadData.h"

static NSMutableDictionary *_downloadList;

static dispatch_semaphore_t _semaphore;


NSString const * filePath   =  @"filePath";
NSString const * fileSize   =  @"fileSize";
NSString const * fileName   =  @"fileName";
NSString const * fileUrl    =  @"fileUrl";
NSString const * isFinished =  @"isFinished";
NSString const * totalSize  =  @"totalSize";
NSString const * icon       =  @"icon";
NSString const * name       =  @"name";
NSString const * updatedAt  =  @"updatedAt";

NSString const * type  =  @"type";
NSString const * gid  =  @"gid";



#define SGDownloadInfoPath [KFullDirector stringByAppendingString:@"downloadInfo.plist"]

#define SGDownloadList [self getDownloadList]

@interface PioerDownCacheManager ()
+ (NSMutableDictionary *)getDownloadList;

@end

@implementation PioerDownCacheManager
+ (void)initialize {
    _semaphore = dispatch_semaphore_create(1);
    
}


+ (NSMutableDictionary *)getDownloadList {
    
    if (!_downloadList) { // 内存没有
        _downloadList = [[NSDictionary dictionaryWithContentsOfFile:SGDownloadInfoPath] mutableCopy]; // 本地加载
        if (!_downloadList) { // 本地没有，分配内存
            _downloadList = [NSMutableDictionary dictionary];
        }
    }
    return _downloadList;
}

#pragma mark - query
+ (NSDictionary *)queryFileInfoWithUrl:(NSString *)url {
    // 本地查找
    NSString *key = [url sg_md5HashString];
    
    NSMutableDictionary *dictM  = [[SGDownloadList objectForKey:key] mutableCopy];
    if (dictM) {
        NSString *path = [KFullDirector stringByAppendingString:dictM[fileName]];
        [dictM setObject:path forKey:filePath];
    }
    
    return dictM;
    
}

+ (NSInteger)totalSizeWith:(NSString *)url {
    
    return [[self queryFileInfoWithUrl:url][totalSize] integerValue];
}

+ (NSString *)updatedAtTimeWith:(NSString *)url {
    
    return [self queryFileInfoWithUrl:url][updatedAt];
}

/** 记录要下载的文件大小 */
+ (BOOL)saveTotalSizeWithSize:(NSInteger)size forURL:(NSString *)url {
    
    return YES;
}

/**  增加配置信息 */
+ (BOOL)saveFileInfoWithDict:(NSDictionary *)dict {
    
    // 线程等待 (信号量 + 1)
    dispatch_semaphore_wait(_semaphore, DISPATCH_TIME_FOREVER);
    
    NSString *key = [dict[fileUrl] sg_md5HashString];
    NSMutableDictionary *dictM =  SGDownloadList;
    [dictM setObject:dict forKey:key];
    NSLog(@"本地保存的plistDict数据??%@ == %@",SGDownloadInfoPath,dictM);
    BOOL flag = [dictM writeToFile:SGDownloadInfoPath atomically:YES];
    // 线程结束 （信号量 - 1）
    dispatch_semaphore_signal(_semaphore);
    
    return flag;
    
}

/**  删除配置信息 */
+ (BOOL)deleteFileWithUrl:(NSString *)url {
    // 线程等待 分配信号量 (信号量 + 1)
    dispatch_semaphore_wait(_semaphore, DISPATCH_TIME_FOREVER);
    
    NSString *key = [url sg_md5HashString];
    NSDictionary *dict = SGDownloadList[key];
    BOOL flag = [[NSFileManager defaultManager] removeItemAtPath:dict[filePath] error:nil];
    [SGDownloadList removeObjectForKey:key];
    BOOL writeFlag = [SGDownloadList writeToFile:SGDownloadInfoPath atomically:YES];
    
    // 线程结束 释放信号量（信号量 - 1）
    dispatch_semaphore_signal(_semaphore);
    return (flag && writeFlag);
}



#pragma mark -

+ (BOOL)clearDisks {
    // 1.删除所有的文件下载信息关联表
    // 2.删除cache 下的download文件夹
    return  [[NSFileManager defaultManager] removeItemAtPath:KFullDirector error:nil];
    
}

/**  取消所有当前下载的文件 清理内存缓存的数据 */
+ (BOOL)clearMemory {
    // 删除信息关联
    _downloadList = nil;
    
    return YES;
}

/**  取消所有当前下载的文件 删除磁盘所有的下载 清理内存缓存的数据 */
+ (BOOL)clearMemoryAndDisk {
    return ([self clearMemory] && [self clearDisks]);
}




@end

