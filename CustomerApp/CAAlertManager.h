//
//  CAAlertManager.h
//  CustomerApp
//
//  Created by Onur Şahindur on 09/11/16.
//  Copyright © 2016 onursahindur. All rights reserved.
//

@interface CAAlertManager : NSObject

+ (void) showAlertWithTitle:(NSString *)title
                    message:(NSString *)message
          cancelButtonTitle:(NSString *)cancelButtonTitle
          otherButtonTitles:(NSArray *)otherButtonTitles
             viewController:(UIViewController *)viewController
          completionHandler:(void (^)(NSInteger buttonClicked))completionHandler;

@end
