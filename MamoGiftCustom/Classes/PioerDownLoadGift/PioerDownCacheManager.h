//
//  PioerDownCacheManager.h
//  Pioer
//
//  Created by Pioer on 22/03/24.
//

#define SG_EXTERN extern
#import <Foundation/Foundation.h>

SG_EXTERN NSString const * filePath;
SG_EXTERN NSString const * fileSize;
SG_EXTERN NSString const * totalSize;
SG_EXTERN NSString const * fileName;
SG_EXTERN NSString const * fileUrl;
SG_EXTERN NSString const * isFinished;
SG_EXTERN NSString const * icon;
SG_EXTERN NSString const * name;
SG_EXTERN NSString const * updatedAt;

//新增
///礼物类型
SG_EXTERN NSString const * type;
///礼物编号 id
SG_EXTERN NSString const * gid;

NS_ASSUME_NONNULL_BEGIN
//SGCacheManager
@interface PioerDownCacheManager : NSObject
/** 查询文件信息 */
+ (NSDictionary *)queryFileInfoWithUrl:(NSString *)url;

/** 查询要下载的文件大小 */
+ (NSInteger)totalSizeWith:(NSString *)url;

/** 查询下载的文件时间 */
+ (NSString *)updatedAtTimeWith:(NSString *)url;

/** 记录要下载的文件大小 */
+ (BOOL)saveTotalSizeWithSize:(NSInteger)size forURL:(NSString *)url;

/**  增加配置信息 */
+ (BOOL)saveFileInfoWithDict:(NSDictionary *)dict;


/**  删除某个文件 */
+ (BOOL)deleteFileWithUrl:(NSString *)url;

/**  清理所有下载文件及下载信息 */
+ (BOOL)clearDisks;

/**  取消所有当前下载的文件 清理内存缓存的数据 */
+ (BOOL)clearMemory;

/**  取消所有当前下载的文件 删除磁盘所有的下载 清理内存缓存的数据 */
+ (BOOL)clearMemoryAndDisk;
@end

NS_ASSUME_NONNULL_END
