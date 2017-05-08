//
//  LCNetworkManager.h
//  BSProject
//
//  Created by Liu-Mac on 5/5/17.
//  Copyright © 2017 Liu-Mac. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>



/**
 请求方式

 - LCHttpMethodGET: GET请求
 - LCHttpMethodPOST: POST请求
 */
typedef NS_ENUM(NSUInteger, LCHttpMethod) {
    LCHttpMethodGET,
    LCHttpMethodPOST
};

NS_ASSUME_NONNULL_BEGIN

@interface LCHTTPSessionManager : AFHTTPSessionManager


/**
 获取单例对象
 说明: 
 1. 可以使用原有的 manager 获取非单例对象
 2. 非单例对象存在循环引用问题
 3. 建议使用单例
 
 @return 单例对象
 */
+ (instancetype)sharedInstance;

/**
 GET / POST : 不监听进度
 
 @param method     网络请求方式
 @param URLString  URL 字符串
 @param parameters 请求参数
 @param completion 请求完成后的回调闭包
 isSuccess == YES : result 为 响应的具体数据
 isSuccess == NO  : result 为 错误信息对象(NSError)
 */
- (nullable NSURLSessionDataTask *)request:(LCHttpMethod)method
                                    urlStr:(NSString *)URLString
                                parameters:(nullable id)parameters
                                completion:(nullable void (^)(id result, BOOL isSuccess))completion;

/**
 GET / POST : 监听进度
 
 @param method     网络请求方式
 @param URLString  URL 字符串
 @param parameters 请求参数
 @param progress   请求进度回调: progress 为进度值
 @param completion 请求完成后的回调闭包
 isSuccess == YES : result 为 响应的具体数据
 isSuccess == NO  : result 为 错误信息对象(NSError)
 */
- (nullable NSURLSessionDataTask *)request:(LCHttpMethod)method
                                    urlStr:(NSString *)URLString
                                parameters:(nullable id)parameters
                                  progress:(nullable void (^)(float progress))progress
                                completion:(nullable void (^)(id result, BOOL isSuccess))completion;

/**
 上传文件方法 : 不监听进度

 @param URLString  URL 字符串
 @param parameters 请求参数
 @param name       接收上传数据的服务器字段(要咨询公司的服务器人员)
 @param fileName   保存在服务器的文件名(需要和服务器人员约定, 本方法内部实现使用这个参数决定上传的 MimeType)
 @param data       要上传的二进制数据
 @param completion 请求完成后的回调闭包
 isSuccess == YES : result 为 响应的具体数据
 isSuccess == NO  : result 为 错误信息对象(NSError)
 */
- (nullable NSURLSessionDataTask *)upload:(NSString *)URLString
                               parameters:(nullable id)parameters
                                     name:(NSString *)name
                                 fileName:(nullable NSString *)fileName
                                     data:(NSData *)data
                               completion:(nullable void (^)(id result, BOOL isSuccess))completion;

/**
 上传文件方法 : 监听进度
 
 @param URLString  URL 字符串
 @param parameters 请求参数
 @param name       接收上传数据的服务器字段(要咨询公司的服务器人员)
 @param fileName   保存在服务器的文件名(需要和服务器人员约定, 本方法内部实现使用这个参数决定上传的 MimeType)
 @param data       要上传的二进制数据
 @param progress   请求进度回调: progress 为进度值
 @param completion 请求完成后的回调闭包
 isSuccess == YES : result 为 响应的具体数据
 isSuccess == NO  : result 为 错误信息对象(NSError)
 */
- (nullable NSURLSessionDataTask *)upload:(NSString *)URLString
                               parameters:(nullable id)parameters
                                     name:(NSString *)name
                                 fileName:(nullable NSString *)fileName
                                     data:(NSData *)data
                                 progress:(nullable void (^)(float progress))progress
                               completion:(nullable void (^)(id result, BOOL isSuccess))completion;

NS_ASSUME_NONNULL_END

@end
