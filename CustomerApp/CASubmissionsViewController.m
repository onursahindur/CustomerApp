//
//  CASubmissionsViewController.m
//  CustomerApp
//
//  Created by Onur Şahindur on 09/11/16.
//  Copyright © 2016 onursahindur. All rights reserved.
//

#import "CASubmissionsViewController.h"
#import "CASubmissionsLogic.h"

@interface CASubmissionsViewController () <CASubmissionsLogicDelegate>

@property (nonatomic, strong) CASubmissionsLogic *logic;

@end

@implementation CASubmissionsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.logic = [CASubmissionsLogic new];
    self.logic.delegate = self;
    [self styleNavigationBar];
    [self fetchProjects];
}

- (void)styleNavigationBar
{
    [CANavigationBarStyler addLeftAlignedTitle:@"Submissions" withViewController:self];
    [CANavigationBarStyler styleNavigationBarColorsWithTintColor:[UIColor whiteColor]
                                                withBarTintColor:RGB(0, 0, 128)
                                                    withBarStyle:UIStatusBarStyleLightContent
                                          withBarButtonItemColor:[UIColor whiteColor]
                                              withViewController:self];
}

- (void)fetchProjects
{
    [self.view showLoadingView];
    [self.logic loadProjects];
}

- (void)dataLoadedWithDataType:(CASubmissionDataType)dataType
{
    [self.view dismissLoadingView];
    id responseData = nil;
    switch (dataType)
    {
        case CASubmissionDataProjects:
        {
            responseData = self.logic.projects;
        }
            break;
        case CASubmissionDataProjectTaskForms:
        {
            
        }
            break;
        case CASubmissionDataProjectTaskFormQuestions:
        {
            
        }
            break;
        case CASubmissionDataProjectTaskFormSubmissions:
        {
            
        }
            break;
    }
    
    
    
    
    
    
    
    
}


@end
