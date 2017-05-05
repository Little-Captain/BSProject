//
//  LCNetworkManager.m
//  BSProject
//
//  Created by Liu-Mac on 5/5/17.
//  Copyright © 2017 Liu-Mac. All rights reserved.
//

#import "LCHTTPSessionManager.h"

typedef void(^SuccessCallbackBlock)(NSURLSessionDataTask * task, id responseObject);
typedef void(^FailureCallbackBlock)(NSURLSessionDataTask * task, NSError * error);

@implementation LCHTTPSessionManager

static LCHTTPSessionManager *_instance;
+ (instancetype)sharedInstance {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        _instance = [self manager];
    });
    return _instance;
}

/** 重写原有方法, 增加解析响应数据支持的类型 */
+ (instancetype)manager {
    
    LCHTTPSessionManager *mgr = [super manager];
    // 设置解析响应数据支持的类型
    mgr.responseSerializer.acceptableContentTypes =  [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", nil];
    
    return mgr;
}

- (void)request:(LCHttpMethod)method urlStr:(NSString *)urlStr parameters:(NSDictionary *)parameters completion:(void (^)(id responseObject, BOOL isSuccess))completion {
    
    SuccessCallbackBlock successBlock = ^(NSURLSessionDataTask * task, id responseObject) {
        completion(responseObject, YES);
    };
    FailureCallbackBlock failureBlock = ^(NSURLSessionDataTask * task, NSError * error) {
        completion(error, NO);
    };
    
    if (method == LCHttpMethodGET) {
        [self GET:urlStr parameters:parameters progress:nil success:successBlock failure:failureBlock];
    }
    
    if (method == LCHttpMethodPOST) {
        [self POST:urlStr parameters:parameters progress:nil success:successBlock failure:failureBlock];
    }
}

- (void)upload:(NSString *)urlStr parameters:(NSDictionary *)parameters name:(NSString *)name fileName:(NSString *)fileName data:(NSData *)data completion:(void (^)(id, BOOL))completion {
    
    fileName = fileName ? fileName : @"文件名客户端未指定";
    
    SuccessCallbackBlock successBlock = ^(NSURLSessionDataTask * task, id responseObject) {
        completion(responseObject, YES);
    };
    FailureCallbackBlock failureBlock = ^(NSURLSessionDataTask * task, NSError * error) {
        completion(error, NO);
    };
    
    [self POST:urlStr parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        // 创建 formData
        /*
         1. data: 要上传的二进制数据
         2. name: 服务器接收数据的字段名
         3. fileName: 保存在服务器的文件名, 大多数服务器都可以乱写
         很多服务器, 上传图片完成后, 会生成缩略图, 大图, 小图
         4. mimeType: 告诉服务器上传文件的类型, 如果不想告诉, 可以使用 application/octet-stream
         */
        [formData appendPartWithFileData:data
                                    name:name
                                fileName:fileName
                                mimeType:mimeTypeForPathExtension([fileName pathExtension])];
    } progress:nil success:successBlock failure:failureBlock];
}

#pragma mark -
#pragma mark 私有方法

static inline NSString * mimeTypeForPathExtension(NSString *extension) {
    NSString *UTI = (__bridge_transfer NSString *)UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, (__bridge CFStringRef)extension, NULL);
    NSString *contentType = (__bridge_transfer NSString *)UTTypeCopyPreferredTagWithClass((__bridge CFStringRef)UTI, kUTTagClassMIMEType);
    if (!contentType) {
        return @"application/octet-stream";
    } else {
        return contentType;
    }
}

@end
