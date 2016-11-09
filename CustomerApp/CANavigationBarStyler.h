//
//  CANavigationBarStyler.h
//  CustomerApp
//
//  Created by Onur Şahindur on 09/11/16.
//  Copyright © 2016 onursahindur. All rights reserved.
//

@interface CANavigationBarStyler : NSObject

+ (void)addLeftAlignedTitle:(NSString *)title
         withViewController:(UIViewController *)viewController;

+ (void)styleNavigationBarColorsWithTintColor:(UIColor *)tintColor
                             withBarTintColor:(UIColor *)barTintColor
                                 withBarStyle:(UIStatusBarStyle)barStyle
                       withBarButtonItemColor:(UIColor *)barButtonItemColor
                           withViewController:(UIViewController *)viewController;

@end
