//
//  JCNetwork.m
//  AFNetworking
//
//  Created by iverson1234tw on 2020/5/4.
//

#import "JCNetwork.h"

@implementation JCNetwork

- (BOOL)checkInternetConnection {
    
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus netStatus = [reachability currentReachabilityStatus];
    
    if (netStatus == NotReachable)
        return NO;
    else
        return YES;    
}

+ (instancetype)sharedManager {
    
    static JCNetwork *manager = nil;
    static dispatch_once_t pred;
    dispatch_once(&pred, ^{
        manager = [[self alloc] initWithBaseURL:[NSURL URLWithString:@"http://127.0.0.1:5000/"]];
    });
    
    return manager;
}

- (instancetype)initWithBaseURL:(NSURL *)url {
    
    self = [super initWithBaseURL:url];
    
    if (self) {
        
        self.requestSerializer = [AFJSONRequestSerializer serializer];
        self.responseSerializer = [AFJSONResponseSerializer serializer];
        self.requestSerializer.timeoutInterval = 60;
        self.requestSerializer.cachePolicy = NSURLRequestReloadIgnoringCacheData;
        self.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/plain", @"text/javascript", @"text/json", @"text/html", @"text/xml", @"multipart/form-data", nil];
        self.securityPolicy.allowInvalidCertificates = NO;
        self.securityPolicy.validatesDomainName = NO;
        [self.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [self.requestSerializer setValue:url.absoluteString forHTTPHeaderField:@"Referer"];
        
    }
    
    return self;
}

- (void)requestWithMethod:(HTTPMethod)method
                 WithPath:(NSString *)path
               WithParams:(NSDictionary *)params
                 WithFile:(NSArray *)array
         WithSuccessBlock:(requestSuccessBlock)success
          WithFailurBlock:(requestFailureBlock)failure {
    
    if (![self checkInternetConnection]) {
        
        NSError *error;
        NSMutableDictionary* details = [NSMutableDictionary dictionary];
        [details setValue:[NSString stringWithFormat:@"請確認網路連線"] forKey:NSLocalizedDescriptionKey];
        error = [NSError errorWithDomain:@"網路連線失敗" code:999 userInfo:details];
        failure(error);
        
    } else {
        
        switch (method) {
                
            case GET:{
                
                [self GET:path parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                    success(responseObject);
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    failure(error);
                }];
                
                break;
            }
                
            case POST:{
                
                [self.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
                
                [self POST:path parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                    success(responseObject);
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    failure(error);
                }];
                
                break;
            }
                
            case FORM_DATA:{
                
                NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST"
                                                                                                          URLString:path
                                                                                                         parameters:params
                                                                                          constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
                                                                                              
                                                                                              for (int i = 0; i < [array count]; i ++) {
                                                                                                  
                                                                                                  [formData appendPartWithFileData:array[i] name:@"photo" fileName:@"test.png" mimeType:@"image/png"];
                                                                                                  
                                                                                              }
                                                                                              
                                                                                          } error:nil];
                
                NSURLSessionUploadTask *uploadTask;
                
                uploadTask = [self uploadTaskWithStreamedRequest:request
                                                           progress:nil
                                                  completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
                                                      
                                                      if (!error) {
                                                          
                                                          success(responseObject);
                                                          
                                                      } else {
                                                          
                                                          failure(error);
                                                          
                                                      }
                                                      
                                                  }];
                
                [uploadTask resume];
                
                break;
            }
                
            default:
                break;
        }
        
    }
    
}

@end
