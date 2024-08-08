//
//  PioerGiftDownloadQueue.m
//  Pioer
//
//  Created by Pioer on 22/03/24.
//

#import "PioerGiftDownloadQueue.h"
#import "PioerGiftDownloadOperation.h"


@interface PioerGiftDownloadQueue()
// 列队管理集合
@property (nonatomic,strong) NSMutableSet <PioerGiftDownloadOperation *> *operations;

@end

@implementation PioerGiftDownloadQueue

- (instancetype)init {
    
    if (self = [super init]) {
        // 监听完成通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didResiveDownloadFileCompete:) name:SGDownloadCompleteNoti object:nil];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didResiveDownloadFileCompete:(NSNotification *)noti {
    PioerGiftDownloadOperation *operation = noti.object;
    if (operation) {
        [self.operations removeObject:operation];
    }
}

#pragma mark - handle Out operations
- (void)addDownloadWithSession:(NSURLSession *)session URL:(PioerdReceiveGiftData *)model begin:(void(^)(NSString *))begin progress:(void(^)(NSInteger,NSInteger))progress complete:(void(^)(NSDictionary *,NSError *))complet {
    @synchronized(self) {
        // 获取operation对象
        PioerGiftDownloadOperation *operation = [self operationWithUrl:[NSURL URLWithString:model.animEffectUrl].absoluteString];
        if (operation == nil) {
            
            operation = [[PioerGiftDownloadOperation alloc] initWith:model session:session];
            
            if (operation == nil) {
                // 没有下载任务代表已下载完成
                NSDictionary *fileInfo = [PioerDownCacheManager queryFileInfoWithUrl:[NSURL URLWithString:model.animEffectUrl].absoluteString];
                if (fileInfo && complet) {
                    complet(fileInfo,nil);
                }else {
                    complet(nil,[NSError errorWithDomain:@"构建下载任务失败" code:-1 userInfo:nil]);
                }
                return;
            }
            [self.operations addObject:operation];
        }
        
        // 回调赋值operation
        [operation configCallBacksWithDidReceiveResponse:begin didReceivData:progress didComplete:complet];
        
        [operation.dataTask resume];
    }
}

- (void)operateDownloadWithUrl:(NSString *)url handle:(DownloadHandleType)handle{
    
    PioerGiftDownloadOperation *operation = [self operationWithUrl:url];
    
    if (!operation) {
        return;
    } else if (!operation.dataTask) {
        
        [self.operations removeObject:operation];
        return;
    }
    
    
    switch (handle) {
        case DownloadHandleTypeStart:
            [operation.dataTask resume]; // 开始
            break;
        case DownloadHandleTypeSuspend:
            [operation.dataTask suspend]; // 暂停
            break;
        case DownloadHandleTypeCancel:
            [operation.dataTask cancel];  // 取消
            [self.operations removeObject:operation]; // 删除任务
            break;
    }
}

- (void)cancelAllTasks {
    // 取消所有的任务
    [_operations enumerateObjectsUsingBlock:^(PioerGiftDownloadOperation * _Nonnull obj, BOOL * _Nonnull stop) {
        [obj.dataTask cancel];
    }];
    // 清理内存
    _operations = nil;
}
- (void)suspendAllTasks {
    // 取消所有的任务
    [_operations enumerateObjectsUsingBlock:^(PioerGiftDownloadOperation * _Nonnull obj, BOOL * _Nonnull stop) {
        [obj.dataTask suspend];
    }];
}
- (void)startAllTasks {
    // 取消所有的任务
    [_operations enumerateObjectsUsingBlock:^(PioerGiftDownloadOperation * _Nonnull obj, BOOL * _Nonnull stop) {
        [obj.dataTask resume];
    }];
}


#pragma mark - handle download
- (void)dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response {
    
    [[self oprationWithDataTask:dataTask] operateWithResponse:response];
}

- (void)dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data {
    [[self oprationWithDataTask:dataTask] operateWithReceivingData:data];
}


- (void)task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error {
    [[self oprationWithDataTask:task] operateWithComplete:error];
}


#pragma mark - query operation
- (PioerGiftDownloadOperation *)operationWithUrl:(NSString *)url{
    __block PioerGiftDownloadOperation *operation = nil;
    
    [self.operations enumerateObjectsUsingBlock:^(PioerGiftDownloadOperation * _Nonnull obj, BOOL * _Nonnull stop) {
        if ([obj.url isEqualToString:url]) {
            operation = obj;
            *stop = YES;
        }
    }];
    
    return operation;
}

// 寻找operation
- (PioerGiftDownloadOperation *)oprationWithDataTask:(NSURLSessionTask *)dataTask {
    
    __block PioerGiftDownloadOperation *operation = nil;
    
    [self.operations enumerateObjectsUsingBlock:^(PioerGiftDownloadOperation * _Nonnull obj, BOOL * _Nonnull stop) {
        if (obj.dataTask == dataTask) {
            operation = obj;
            *stop = YES;
        }
    }];
    
    return operation;
}
#pragma mark - lazy load
- (NSMutableSet<PioerGiftDownloadOperation *> *)operations {
    
    if (!_operations) {
        _operations = [NSMutableSet set];
    }
    return _operations;
}
@end
