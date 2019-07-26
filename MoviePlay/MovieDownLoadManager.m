//
//  MovieDownLoadManager.m
//  MoviePlay
//
//  Created by 张奥 on 2019/7/26.
//  Copyright © 2019年 张奥. All rights reserved.
//

#import "MovieDownLoadManager.h"

@interface MovieDownLoadManager()<NSURLSessionDelegate,NSURLSessionDownloadDelegate>
@property (nonatomic, strong) NSURLSession *session;
@property (nonatomic, copy) void(^success)(NSURL *URL);
@property (nonatomic, copy) void(^fail)(NSString *message);
@end

@implementation MovieDownLoadManager
+ (instancetype)shareManager {
    static id manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init];
    });
    return manager;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        NSOperationQueue *queue = [[NSOperationQueue alloc] init];
        queue.maxConcurrentOperationCount = 1;
        self.session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:queue];
    }
    return self;
}

-(NSURLSessionDownloadTask *)downLoadMovieWithUrl:(NSURL*)url progressBlock:(void(^)(CGFloat progress))progressBlock
                                        success:(void(^)(NSURL *URL))success
                                           fail:(void(^)(NSString *message))fail {
    self.success = success;
    self.fail = fail;
    
    NSURLSessionDownloadTask *task = [self.session downloadTaskWithURL:url];
    [task resume];
    
    return task;
}

#pragma mark NSURLSessionDelegate
-(void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location{
//    NSString *name = [[NSFileManager defaultManager] displayNameAtPath:downloadTask.currentRequest.URL.path];
//    NSString *filePath = [[[self class] filePath] stringByAppendingPathComponent:name];
//    [[NSFileManager defaultManager] moveItemAtPath:location.path toPath:filePath error:nil];
}
-(void)URLSession:(NSURLSession *)session downloadTask:(nonnull NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite{
    dispatch_async(dispatch_get_main_queue(), ^{
        CGFloat progeress = totalBytesWritten * 1.0 / totalBytesExpectedToWrite;
        NSLog(@"%f>>>>>>>>>>",progeress);
    });
}
-(void)URLSession:(NSURLSession *)session task:(nonnull NSURLSessionTask *)task didCompleteWithError:(nullable NSError *)error{
    NSString *name = [[NSFileManager defaultManager] displayNameAtPath:task.currentRequest.URL.path];
    NSString *filePath = [[[self class] filePath] stringByAppendingPathComponent:name];
    BOOL isExists = [[NSFileManager defaultManager] fileExistsAtPath:filePath];
    dispatch_async(dispatch_get_main_queue(), ^{
        if (isExists) {
            if (self.success) self.success([NSURL fileURLWithPath:filePath]);
        } else {
            if (error.code != NSURLErrorCancelled && self.fail) self.fail(@"下载失败");
        }
//        [self clearAllBlock];
    });
}
#pragma mark 文件管理
+ (NSString *)filePath {
    NSString *path = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject;
    NSString *filePath = [path stringByAppendingPathComponent:@"wj_movie_file"];
    BOOL isExists = [[NSFileManager defaultManager] fileExistsAtPath:filePath];
    if (!isExists) {
        [[NSFileManager defaultManager] createDirectoryAtPath:filePath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return filePath;
}

+ (void)clearDisk {
    [[NSFileManager defaultManager] removeItemAtPath:[self filePath] error:nil];
}
@end
