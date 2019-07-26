//
//  MovieDownLoadManager.h
//  MoviePlay
//
//  Created by 张奥 on 2019/7/26.
//  Copyright © 2019年 张奥. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface MovieDownLoadManager : NSObject
+ (instancetype)shareManager;
+ (NSString *)filePath;
-(NSURLSessionDownloadTask *)downLoadMovieWithUrl:(NSURL*)url progressBlock:(void(^)(CGFloat progress))progressBlock
                                          success:(void(^)(NSURL *URL))success
                                             fail:(void(^)(NSString *message))fail;
@end
