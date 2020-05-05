//
//  JCNetwork.h
//  AFNetworking
//
//  Created by iverson1234tw on 2020/5/4.
//

#import <AFNetworking/AFNetworking.h>
#import "Reachability.h"

typedef void (^requestSuccessBlock)(id responseObject);
typedef void (^requestFailureBlock)(NSError *error);
typedef enum {
    GET,
    POST,
    PUT,
    DELETE,
    FORM_DATA,
    HEAD
} HTTPMethod;

@interface JCNetwork : AFHTTPSessionManager

+ (instancetype)sharedManager;

- (instancetype)initWithBaseURL:(NSURL *)url;

- (void)requestWithMethod:(HTTPMethod)method
                 WithPath:(NSString *)path
               WithParams:(NSDictionary *)params
                 WithFile:(NSArray *)array
         WithSuccessBlock:(requestSuccessBlock)success
          WithFailurBlock:(requestFailureBlock)failure;

@end

