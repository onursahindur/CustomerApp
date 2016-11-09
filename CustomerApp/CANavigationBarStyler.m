//
//  CANavigationBarStyler.m
//  CustomerApp
//
//  Created by Onur Şahindur on 09/11/16.
//  Copyright © 2016 onursahindur. All rights reserved.
//

#import "CANavigationBarStyler.h"

@implementation CANavigationBarStyler

+ (void)addLeftAlignedTitle:(NSString *)title
         withViewController:(UIViewController *)viewController
{
    UILabel *navTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 40, 320, 40)];
    navTitle.textAlignment = NSTextAlignmentLeft;
    navTitle.text = title;
    navTitle.textColor = [UIColor whiteColor];
    viewController.navigationItem.titleView = navTitle;
}

+ (void)styleNavigationBarColorsWithTintColor:(UIColor *)tintColor
                             withBarTintColor:(UIColor *)barTintColor
                                 withBarStyle:(UIStatusBarStyle)barStyle
                       withBarButtonItemColor:(UIColor *)barButtonItemColor
                           withViewController:(UIViewController *)viewController
{
    [viewController.navigationController.navigationBar setTranslucent:NO];
    [viewController.navigationController.navigationBar setBarTintColor:barTintColor];
    [viewController.navigationController.navigationBar setTintColor:tintColor];
    [[UIApplication sharedApplication] setStatusBarStyle:barStyle];
    [[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil] setTintColor:barButtonItemColor];
}

@end
