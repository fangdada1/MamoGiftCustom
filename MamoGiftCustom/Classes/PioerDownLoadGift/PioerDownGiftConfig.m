//
//  PioerDownGiftConfig.m
//  Pioer
//
//  Created by Pioer on 22/03/24.
//

#import "PioerDownGiftConfig.h"

@implementation PioerDownGiftConfig
/**
 下载礼物特效
 */
+ (void)downLoadUrl:(PioerdReceiveGiftData *)model {
    
    PioerGiftDownloadManager *manager = [PioerGiftDownloadManager shareManager];
    [manager downloadWithURL: model
                    progress:^(NSInteger completeSize, NSInteger expectSize) { //下载进度
        NSLog(@"礼物名字 = %@ 任务：-- %.2f%%", model.name, 100.0 * completeSize / expectSize);
    }
                    complete:^(NSDictionary *respose, NSError *error) { // 下载完成回调
        if(error) { // 失败回调
            NSLog(@"任务：礼物名字 = %@ 下载错误%@", model.name, error);
            return;
        }
        NSLog(@"任务：礼物名字 = %@ 下载完成 respose = %@", model.name, respose);
        
        //礼物下载完成发送通知
        //                [[NSNotificationCenter defaultCenter] postNotificationName:Notifi_GiftAnimtion_msg object:respose];
    }];
}
/**
 本地是否存在这个礼物
 */
+ (BOOL)isdownloadedGiftFile:(PioerdReceiveGiftData *)model{
    BOOL isExt = NO;
    // 本地查找
    NSDictionary *fileInfo = [PioerDownCacheManager queryFileInfoWithUrl:[NSURL URLWithString:model.animEffectUrl].absoluteString];
    //     本地存在直接返回
    if ([fileInfo[isFinished] integerValue] && [[PioerDownCacheManager updatedAtTimeWith:[NSURL URLWithString:model.animEffectUrl].absoluteString] isEqualToString:model.updatedAt]) {
        NSLog(@"本地已经存在");
        isExt = YES;
        
    }else{
        isExt = NO;
    }
    return isExt;
}

/**
 get这个礼物信息
 */
+ (NSDictionary *)getThisGiftInfo:(PioerdReceiveGiftData *)model{
    NSDictionary *fileInfo = [PioerDownCacheManager queryFileInfoWithUrl:[NSURL URLWithString:model.animEffectUrl].absoluteString];
    return fileInfo;
}

/**
 APP启动后下载缓存所有礼物特效
 
 */
+ (void)downLoadAllGift:(NSMutableArray *)gifts{
    
    if (gifts.count==0) {
        return;
    }
    for (int i = 0; i<gifts.count; i++) {
        PioerdReceiveGiftData *model = gifts[i];
        PioerGiftDownloadManager *manager = [PioerGiftDownloadManager shareManager];
        [manager downloadWithURL:model
                        progress:^(NSInteger completeSize, NSInteger expectSize) { //下载进度
            //                    NSLog(@"任务：-- %.2f%%",100.0 * completeSize / expectSize);
        }
                        complete:^(NSDictionary *respose, NSError *error) { // 下载完成回调
            if(error) { // 失败回调
                NSLog(@"任务：下载错误%@",error);
                return;
            }
            NSLog(@"任务：下载完成 respose = %@ i = %d",respose,i);
            
        }];
    }
}

@end
