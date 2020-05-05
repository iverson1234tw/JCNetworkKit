//
//  NSDictionary+BVJSONString.h
//  JCNetworkKit_Example
//
//  Created by iverson1234tw on 2020/5/5.
//  Copyright © 2020 Chen Hung-Wei. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDictionary (BVJSONString)

-(NSString*) bv_jsonStringWithPrettyPrint:(BOOL) prettyPrint;

@end

NS_ASSUME_NONNULL_END
