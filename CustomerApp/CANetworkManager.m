//
//  CANetworkManager.m
//  CustomerApp
//
//  Created by Onur Şahindur on 09/11/16.
//  Copyright © 2016 onursahindur. All rights reserved.
//

#import "CANetworkManager.h"
#import "Reachability.h"

static NSString *kUserEmail                             = @"john@doe";
static NSString *kUserPassword                          = @"123456";

static NSString *kCABaseURL                             = @"http://api-sb.twentify.com/customer_api/v1";
static NSString *kTokenURL                              = @"tokens";
static NSString *kProjectsURL                           = @"projects";
static NSString *kProjectTaskformsURL                   = @"projects/%@/task_forms"; // %@ represents project id
static NSString *kProjectTaskformSubmissionsURL         = @"projects/%@/task_forms/%@/submissions"; // first %@ is project id, second is taskform id.

@implementation CANetworkManager

+ (instancetype)sharedInstance
{
    static dispatch_once_t once;
    static id sharedInstance;
    dispatch_once(&once, ^{
        NSURL *baseUrl = [NSURL URLWithString:kCABaseURL];
        sharedInstance = [[CANetworkManager alloc] initWithBaseURL:baseUrl];
        ((CANetworkManager *)sharedInstance).responseSerializer.acceptableContentTypes = [NSSet setWithArray:@[@"text/xml", @"text/html", @"application/json", @"text/json", @"text/javascript", @"text/plain"]];
        ((CANetworkManager *)sharedInstance).requestSerializer = [AFJSONRequestSerializer serializer];
        [((CANetworkManager *)sharedInstance).requestSerializer setTimeoutInterval:30];
        [((CANetworkManager *)sharedInstance) makeInitializationConfigurations];
        [((CANetworkManager *)sharedInstance).reachabilityManager startMonitoring];
        [[NSNotificationCenter defaultCenter] addObserver:sharedInstance selector:@selector(reachabilityDidChange:) name:AFNetworkingReachabilityDidChangeNotification object:nil];
        [((CANetworkManager *)sharedInstance) performSelector:@selector(checkReachability) withObject:nil afterDelay:0.1];
        
    });
    return sharedInstance;
}

- (void)makeInitializationConfigurations
{
    // Empty..
}

- (void)cancelRunningServices
{
    [[self operationQueue] cancelAllOperations];
}

#pragma mark - Reachability
- (void)checkReachability
{
    if (self.reachabilityManager.networkReachabilityStatus == AFNetworkReachabilityStatusNotReachable)
    {
        [self reachabilityDidChange:[[NSNotification alloc] initWithName:AFNetworkingReachabilityDidChangeNotification
                                                                  object:nil
                                                                userInfo:@{AFNetworkingReachabilityNotificationStatusItem : @(self.reachabilityManager.networkReachabilityStatus)}]];
    }
}

- (void)reachabilityDidChange:(NSNotification *)notification
{
    AFNetworkReachabilityStatus status = [notification.userInfo[AFNetworkingReachabilityNotificationStatusItem] integerValue];
    if (status == AFNetworkReachabilityStatusNotReachable)
    {
        __weak typeof (self) weakSelf = self;
        [CAAlertManager showAlertWithTitle:nil
                                   message:@"Bağlantınızda bir sorun var. Lütfen bağlantı ayarlarınızı kontrol edip tekrar deneyin."
                         cancelButtonTitle:NSLocalizedString(@"Close", nil)
                         otherButtonTitles:@[@"Tekrar dene"]
                            viewController:[[[UIApplication sharedApplication] delegate] window].rootViewController
                         completionHandler:^(NSInteger buttonClicked)
                         {
                              if (buttonClicked == 1)
                              {
                                  __strong typeof (weakSelf) strongSelf = weakSelf;
                                  [strongSelf checkReachability];
                              }
                          }
         ];
    }
}

#pragma mark - AFNetworking Requests
- (AFHTTPRequestOperation *)GET:(NSString *)URLString
                     parameters:(id)parameters
                        success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                        failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [self.requestSerializer setValue:[NSString stringWithFormat:@"%@", [CAManager sharedInstance].accessToken] forHTTPHeaderField:@"Authorization"];
    return [super GET:URLString
           parameters:parameters
              success:^(AFHTTPRequestOperation *operation, id responseObject) {
                  
                  [self handleGetWithOperation:operation
                                responseObject:responseObject
                                         error:nil
                                 withURLString:URLString
                                withParameters:parameters
                                  successBlock:success
                                  failureBlock:failure];
                  
              }
              failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                  
                  [self handleGetWithOperation:operation
                                responseObject:nil
                                         error:error
                                 withURLString:URLString
                                withParameters:parameters
                                  successBlock:success
                                  failureBlock:failure];
              }];
    
}

- (AFHTTPRequestOperation *)POST:(NSString *)URLString
                      parameters:(id)parameters
                         success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                         failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [self.requestSerializer setValue:[NSString stringWithFormat:@"%@", [CAManager sharedInstance].accessToken] forHTTPHeaderField:@"Authorization"];
    return [super POST:URLString
            parameters:parameters
               success:^(AFHTTPRequestOperation *operation, id responseObject) {
                   
                   [self handlePostWithOperation:operation
                                  responseObject:responseObject
                                           error:nil
                                   withURLString:URLString
                                  withParameters:parameters
                                    successBlock:success
                                    failureBlock:failure];
                   
               }
               failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                   
                   [self handlePostWithOperation:operation
                                  responseObject:nil
                                           error:error
                                   withURLString:URLString
                                  withParameters:parameters
                                    successBlock:success
                                    failureBlock:failure];
               }];
    
}

- (void)handleGetWithOperation:(AFHTTPRequestOperation *)operation
                responseObject:(id)responseObject
                         error:(NSError *)error
                 withURLString:URLString
                withParameters:parameters
                  successBlock:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                  failureBlock:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    if (error)
    {
        //unauthorized
        if (operation.response.statusCode == 401)
        {
            [self getAccessTokenWithSuccessBlock:^(NSString *token)
            {
                if ([token isEqualToString:@"error"])
                {
                    failure(operation, error);
                }
                else
                {
                    [CAManager sharedInstance].accessToken = token;
                    [self GET:URLString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject)
                    {
                        DebugLog(@"operation success: %@ \n with response: %@", operation, responseObject);
                        success(operation, responseObject);
                    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                        DebugLog(@"Network Error with url : %@ error : %@", [operation.request.URL absoluteString], [error localizedDescription]);
                        failure(operation, error);
                    }];
                }
            } failureBlock:^(NSError *error) {
                failure(nil, error);
            }];
        }
        else
        {
            DebugLog(@"Network Error with url : %@ error : %@", [operation.request.URL absoluteString], [error localizedDescription]);
            failure(operation, error);
        }
    }
    else
    {
        DebugLog(@"operation success:%@", operation);
        DebugLog(@"%@", responseObject);
        success(operation, responseObject);
    }
}

- (void)handlePostWithOperation:(AFHTTPRequestOperation *)operation
                 responseObject:(id)responseObject
                          error:(NSError *)error
                  withURLString:URLString
                 withParameters:parameters
                   successBlock:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                   failureBlock:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    if (error)
    {
        DebugLog(@"Network Error with url : %@ error : %@", [operation.request.URL absoluteString], [error localizedDescription]);
        failure(operation, error);
    }
    else
    {
        DebugLog(@"operation success:%@", operation);
        DebugLog(@"%@", responseObject);
        success(operation, responseObject);
    }
}

#pragma mark - CustomerApp API Requests
- (void)getAccessTokenWithSuccessBlock:(void (^)(NSString *))successBlock
                          failureBlock:(FailureBlock)failureBlock
{
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setValue:kUserEmail forKey:@"email"];
    [params setValue:kUserPassword forKey:@"password"];
    NSMutableDictionary *agentDict = [NSMutableDictionary new];
    [agentDict setObject:params forKey:@"agent"];
    
    [self POST:kTokenURL parameters:agentDict success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject)
    {
        if (![[responseObject objectForKey:@"data"] isKindOfClass:[NSNull class]]
            && ![[[responseObject objectForKey:@"data"] objectForKey:@"token"] isKindOfClass:[NSNull class]])
        {
            successBlock([[responseObject objectForKey:@"data"] objectForKey:@"token"]);
        }
        else
        {
            NSError *error = [[NSError alloc] initWithDomain:@"Internal Server Error" code:500 userInfo:nil];
            failureBlock(error);
        }
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        failureBlock(error);
    }];
}

- (void)getProjectListWithSuccessBlock:(void (^)(NSArray *))successBlock
                          failureBlock:(FailureBlock)failureBlock
{
    [self GET:kProjectsURL parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject)
    {
        if ([responseObject[@"data"] isKindOfClass:[NSArray class]])
        {
            successBlock((NSArray *)responseObject[@"data"]);
        }
        else
        {
            successBlock(nil);
        }
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        failureBlock(error);
    }];
}

- (void)getProjectTaskFormsWithProjectId:(NSString *)projectId
                        withSuccessBlock:(void (^)(NSArray *))successBlock
                            failureBlock:(FailureBlock)failureBlock
{
    NSString *urlString = [NSString stringWithFormat:kProjectTaskformsURL, projectId];
    [self GET:urlString parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject)
    {
        if ([responseObject[@"data"] isKindOfClass:[NSArray class]])
        {
            successBlock((NSArray *)responseObject[@"data"]);
        }
        else
        {
            successBlock(nil);
        }
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        failureBlock(error);
    }];
}












@end
