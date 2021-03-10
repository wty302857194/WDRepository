//
//  TYNetworkTool.m
//  XXOO
//
//  Created by wbb on 2019/4/10.
//  Copyright © 2019 wbb. All rights reserved.
//

#import "TYNetworkTool.h"

@interface AFNetworkClient : AFHTTPSessionManager
@property (nonatomic, copy) NSString * urlString;
+ (instancetype)sharedClient;
@end

static AFNetworkClient *_sharedClient;

@implementation AFNetworkClient

+ (instancetype)sharedClient
{
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        _sharedClient = [AFNetworkClient manager];
        // 设置请求接口回来的时候支持什么类型的数据
        _sharedClient.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"application/x-json",@"text/html",nil];
        // 使用证书验证模式
        _sharedClient.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
        
    });
    
    return _sharedClient;
}
@end

@implementation TYNetworkTool

/**
 *  post请求
 *
 *  @param url          链接
 *  @param parameters   参数
 *  @param successBlock 成功block
 *  @param failureBlock 失败block
 */
+(void)postRequest:(NSString*)url parameters:(NSDictionary *)parameters successBlock:(void (^)(id data,NSString* msg))successBlock failureBlock:(void (^)(NSString* description))failureBlock{
    NSString *URLStr = [NSString stringWithFormat:@"%@%@",URL_main,url];
    NSLog(@"入参：%@ ----------- %@",url,parameters);
    NSMutableDictionary *mutableParams = [NSMutableDictionary dictionaryWithDictionary:[NSDictionary nullDic:parameters?:@{}]];
    
    if(kWindow) {
        [MBProgressHUD showHUDAddedTo:kWindow animated:YES];
    }

    [[AFNetworkClient sharedClient] POST:URLStr parameters:mutableParams headers:@{} progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if(kWindow) {
            [MBProgressHUD hideHUD];
        }
        

        if (responseObject && [responseObject isKindOfClass:[NSDictionary class]]) {
            // 开始验签
            NSDictionary *dict = [NSDictionary nullDic:responseObject];
            NSLog(@"出参：%@ ----------- %@",url,dict);

            if(successBlock) successBlock(dict, dict[@"msg"]);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if(kWindow) {
            [MBProgressHUD hideHUD];
        }

        if(failureBlock) failureBlock(error.localizedDescription);
    }];
}

/**
 *  get请求
 *
 *  @param url          链接
 *  @param parameters   参数
 *  @param successBlock 成功block
 *  @param failureBlock 失败block
 */
+ (void)getRequest:(NSString*)url parameters:(NSDictionary *)parameters successBlock:(void (^)(NSDictionary *data,NSString* msg))successBlock failureBlock:(void (^)(NSString* description))failureBlock
{
    NSString *URLStr = [NSString stringWithFormat:@"%@%@",URL_main,url];
    if(kWindow) {
        [MBProgressHUD showHUDAddedTo:kWindow animated:YES];
    }
    NSLog(@"入参：%@ ----------- %@",URLStr,parameters);

    [[AFNetworkClient sharedClient] GET:URLStr parameters:parameters headers:@{} progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if(kWindow) {
            [MBProgressHUD hideHUD];
        }

        if (responseObject && [responseObject isKindOfClass:[NSDictionary class]]) {
            // 开始验签
            NSDictionary *dict = [NSDictionary nullDic:responseObject];
            NSLog(@"出参：%@ ----------- %@",url,dict);

            if(successBlock) successBlock(dict, dict[@"msg"]);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if(kWindow) {
            [MBProgressHUD hideHUD];
        }
        if(failureBlock) failureBlock(error.localizedDescription);
    }];
}

// 请求Body参数的json格式
+ (NSURLSessionTask *)postRequestWithUrl:(NSString *)URLString
                                    body:(NSDictionary *)jsonDictionary
                            successBlock:(void (^)(NSDictionary *data,NSString* msg))successBlock
                            failureBlock:(void (^)(NSString* description))failureBlock {
    
    NSString *URLStr = [NSString stringWithFormat:@"%@%@",URL_main,URLString];
    NSMutableURLRequest *request = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:URLStr parameters:nil error:nil];
    // 实体头 (发送的实体数据类型)
    [request setValue:@"application/json;charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    // 请求头 (希望接受的数据类型)
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonDictionary options:NSJSONWritingPrettyPrinted error:&error];
    [request setHTTPBody:jsonData];
    
    NSURLSessionDataTask *dataTask = [[AFNetworkClient sharedClient] dataTaskWithRequest:request uploadProgress:nil downloadProgress:nil completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (error) {
            if (failureBlock) failureBlock(error.localizedDescription);
        } else {
            if (responseObject && [responseObject isKindOfClass:[NSDictionary class]]) {
                // 开始验签
                NSDictionary *dict = [NSDictionary nullDic:responseObject];
                if (successBlock) successBlock(dict, dict[@"msg"]);

            }
        }
    }];
    [dataTask resume];
    return dataTask;
}

+ (void)uploadFileWithOption:(NSDictionary *)paramDic
              withRequestURL:(NSString*)requestURL
                   dataArray:(NSMutableArray *)dataArray
                    dataName:(NSMutableArray *)dataName
                     dataKey:(NSMutableArray *)dataKey
             downloadSuccess:(void (^)(id responseObject))success
             downloadFailure:(void (^)(NSError *error))failure
                    progress:(void (^)(float progress))progress

{
    
    //1。创建管理者对象
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSMutableDictionary *mulParameters = [NSMutableDictionary dictionaryWithDictionary:paramDic];
    NSString *URLStr = [NSString stringWithFormat:@"%@",requestURL];
    [manager POST:URLStr parameters:mulParameters headers:@{} constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        //上传文件参数
        
        if (dataArray.count > 0) {
            
            [dataArray enumerateObjectsUsingBlock:^(NSData *imageData, NSUInteger idx, BOOL * _Nonnull stop) {
                
                NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
                formatter.dateFormat=@"yyyyMMddHHmmss";
                NSString *str=[formatter stringFromDate:[NSDate date]];
                NSString *fileName=[NSString stringWithFormat:@"%@.jpg",str];
                
                [formData appendPartWithFileData:imageData name:dataKey[idx] fileName:fileName mimeType:@"image/png"];
            }];
        }
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        progress(1.0*uploadProgress.completedUnitCount/uploadProgress.totalUnitCount);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *weatherDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        
        if ([[weatherDic objectForKey:@"code"] integerValue] == 0) {
            
            //请求成功
            success(weatherDic);
            
        }else{
            
            NSError *error = nil;
            
            failure(error);
            //            [ZJPublicClass textBouncedWithMessage:[weatherDic objectForKey:@"msg"]];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //请求失败
        failure(error);
    }];
}

+ (void)downloadFileWithOption:(NSDictionary *)paramDic
                 withInferface:(NSString*)requestURL
                     savedPath:(NSString*)savedPath
               downloadSuccess:(void (^)(id responseObject))success
               downloadFailure:(void (^)(NSError *error))failure
                      progress:(void (^)(float progress))progress

{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    requestURL = [requestURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];;
    
    //savedPath = [NSString stringWithFormat:@"file://%@",[NSHomeDirectory() stringByAppendingString:@"/Documents/test.xlsx"]];
    
    //2.确定请求的URL地址
    NSURL *url = [NSURL URLWithString:requestURL];
    
    //3.创建请求对象
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    //下载任务
    NSURLSessionDownloadTask *task = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        
        //加载进度
        
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        //下载存放地址，要返回存放地址(存放地址前面加file://)
        
        return [NSURL URLWithString:savedPath];
        
        
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        
        success(response);
        // 下载完成之后，解压缩文件
        
    }];
    [task resume];
    
}

+ (void)monitorNetWorking:(void (^)(WDNetWorkStatus status))statusBlock {
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
//        switch (status) {
//            case -1:
//                NSLog(@"未知网络");
//                break;
//            case 0:
//                NSLog(@"网络不可达");
//                break;
//            case 1:
//                NSLog(@"GPRS网络");
//                break;
//            case 2:
//                NSLog(@"Wi-Fi网络");
//                break;
//            default:
//                break;
//        }
        
        if(status == AFNetworkReachabilityStatusReachableViaWWAN) {
            NSLog(@"GPRS网络");
            statusBlock(ReachableViaWWAN);
        } else if(status == AFNetworkReachabilityStatusReachableViaWiFi) {
            NSLog(@"Wi-Fi网络");
            statusBlock(ReachableViaWiFi);
        } else {
            NSLog(@"没网");
            statusBlock(ReachableViaNone);
        }
    }];
}
@end
