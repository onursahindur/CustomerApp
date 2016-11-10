//
//  CANetworkManager.h
//  CustomerApp
//
//  Created by Onur Şahindur on 09/11/16.
//  Copyright © 2016 onursahindur. All rights reserved.
//

#import "AFNetworking.h"

@interface CANetworkManager : AFHTTPRequestOperationManager

typedef void (^FailureBlock)(NSError *error);

+ (instancetype)sharedInstance;

- (void)cancelRunningServices;

- (void)getProjectListWithSuccessBlock:(void (^)(NSArray *))successBlock
                          failureBlock:(FailureBlock)failureBlock;

- (void)getProjectTaskFormsWithProjectId:(NSString *)projectId
                        withSuccessBlock:(void (^)(NSArray *))successBlock
                            failureBlock:(FailureBlock)failureBlock;

@end