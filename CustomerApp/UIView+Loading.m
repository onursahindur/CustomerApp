//
//  UIView+Loading.m
//  CustomerApp
//
//  Created by Onur Şahindur on 09/11/16.
//  Copyright © 2016 onursahindur. All rights reserved.
//

#import "UIView+Loading.h"
#import "MBProgressHUD.h"

static const NSInteger kHudTag = 1234567890;

@implementation UIView (Loading)

- (void)showLoadingView
{
    if (![self viewWithTag:kHudTag])
    {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
        [hud setTag:kHudTag];
        hud.color = [UIColor orangeColor];
        hud.activityIndicatorColor = [UIColor whiteColor];
    }
}

- (void)dismissLoadingView
{
    [MBProgressHUD hideHUDForView:self animated:NO];
}

@end
