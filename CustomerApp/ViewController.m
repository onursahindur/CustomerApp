//
//  ViewController.m
//  CustomerApp
//
//  Created by Onur Şahindur on 09/11/16.
//  Copyright © 2016 onursahindur. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[CANetworkManager sharedInstance] getProjectListWithSuccessBlock:^(NSArray *projectList)
    {
        
    } failureBlock:^(NSError *error) {
        
    }];
    
}

@end
