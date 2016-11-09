//
//  CAAlertManager.m
//  CustomerApp
//
//  Created by Onur Şahindur on 09/11/16.
//  Copyright © 2016 onursahindur. All rights reserved.
//

#import "CAAlertManager.h"

@interface CAAlertManager ()

@property (nonatomic, copy)     void (^completionHandler)(NSInteger buttonClicked);
@property (nonatomic, strong)   UIAlertController *alertController;

@end

@implementation CAAlertManager

+ (instancetype)sharedInstance
{
    static CAAlertManager *manager = nil;
    static dispatch_once_t token;
    
    dispatch_once(&token, ^{
        manager = [CAAlertManager new];
    });
    
    return manager;
}

+ (void) showAlertWithTitle:(NSString *)title
                    message:(NSString *)message
          cancelButtonTitle:(NSString *)cancelButtonTitle
          otherButtonTitles:(NSArray *)otherButtonTitles
             viewController:(UIViewController *)viewController
          completionHandler:(void (^)(NSInteger buttonClicked))completionHandler
{
    [CAAlertManager sharedInstance].alertController = [UIAlertController alertControllerWithTitle:title.copy
                                                                                           message:message.copy
                                                                                    preferredStyle:UIAlertControllerStyleAlert];
    if(cancelButtonTitle)
    {
        UIAlertAction *action = [UIAlertAction actionWithTitle:cancelButtonTitle
                                                         style:UIAlertActionStyleCancel
                                                       handler:^(UIAlertAction *action) {
                                                           if(completionHandler)
                                                           {
                                                               completionHandler(0);
                                                           }
                                                       }];
        
        [[CAAlertManager sharedInstance].alertController addAction:action];
    }
    
    for(NSInteger i = 0; i < otherButtonTitles.count; i++)
    {
        UIAlertAction *action = [UIAlertAction actionWithTitle:otherButtonTitles[i]
                                                         style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction *action) {
                                                           if(completionHandler)
                                                           {
                                                               completionHandler(i+1);
                                                           }
                                                       }];
        
        [[CAAlertManager sharedInstance].alertController addAction:action];
    }
    
    [viewController presentViewController:[CAAlertManager sharedInstance].alertController animated:YES completion:nil];
}

@end
