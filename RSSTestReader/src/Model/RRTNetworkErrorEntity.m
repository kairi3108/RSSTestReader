//
//  RRTNetworkErrorEntity.m
//  RSSTestReader
//
//  Created by Yuto on 2018/07/28.
//  Copyright © 2018年 Yuto. All rights reserved.
//

#import "RRTNetworkErrorEntity.h"
#import "RRTNetworkRequestEntity.h"

NSString *kErrorDomainSuffix = @"error";
NSString *kErrorMessage = @"message";
NSString *kErrorObjects = @"objects";
NSInteger kErrorCodeAbnormal = -1;

@implementation RRTNetworkErrorEntity

- (NSString *)description {
    return [NSString stringWithFormat:@"%@, url : %@, response : %@, error : %@",
            [super description],
            [self.url description],
            [self.response description],
            [self.error description]];
}

+ (instancetype)errorCannotExecuteRequest:(NSURL *)url {
    RRTNetworkErrorEntity *error = [[RRTNetworkErrorEntity alloc] init];
    error.url = url;
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:@"Request Error" forKey:kErrorMessage];
    error.error = [NSError errorWithDomain:[[self class] errorDomain]
                                      code:kErrorCodeAbnormal
                                  userInfo:dict];
    return error;
}

+ (instancetype)errorRSSNotSupportVersion:(NSURL *)url xml:(NSDictionary *)xml {
    RRTNetworkErrorEntity *error = [[RRTNetworkErrorEntity alloc] init];
    error.url = url;
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:@"Version Error" forKey:kErrorMessage];
    if (xml) {
        [dict setObject:xml forKey:kErrorObjects];
    }
    error.error = [NSError errorWithDomain:[[self class] errorDomain]
                                      code:kErrorCodeAbnormal
                                  userInfo:dict];
    return error;
}

+ (instancetype)error:(RRTNetworkRequestEntity *)request response:(NSURLResponse *)response error:(NSError *)error {
    RRTNetworkErrorEntity *errorI = [[RRTNetworkErrorEntity alloc] init];
    errorI.url = request.url;
    errorI.response = response;
    errorI.error = error;
    return errorI;
}

+ (NSString *)errorDomain {
    return [NSString stringWithFormat:@"%@.%@", [[NSBundle mainBundle] bundleIdentifier], kErrorDomainSuffix];
}

@end
