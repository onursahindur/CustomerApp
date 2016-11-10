//
//  CASubmissionsLogic.m
//  CustomerApp
//
//  Created by Onur Şahindur on 09/11/16.
//  Copyright © 2016 onursahindur. All rights reserved.
//

#import "CASubmissionsLogic.h"
#import "CAProject.h"
#import "CATaskForm.h"

@implementation CASubmissionsLogic

- (void)loadProjects
{
    if ([self.delegate respondsToSelector:@selector(dataLoading)])
    {
        [self.delegate dataLoading];
    }
    
    __weak typeof (self) weakSelf = self;
    [[CANetworkManager sharedInstance] getProjectListWithSuccessBlock:^(NSArray *projects)
    {
        __strong typeof (weakSelf) strongSelf = weakSelf;
        strongSelf.projects = [NSMutableArray new];
        for (NSDictionary *dict in projects)
        {
            [strongSelf.projects addObject:[[CAProject alloc] initWithDictionary:dict]];
        }
        if ([strongSelf.delegate respondsToSelector:@selector(dataLoadedWithDataType:)])
        {
            [strongSelf.delegate dataLoadedWithDataType:CASubmissionDataProjects];
        }
        
    } failureBlock:^(NSError *error) {
        if ([weakSelf.delegate respondsToSelector:@selector(dataLoadedWithError:withDataType:)])
        {
            [weakSelf.delegate dataLoadedWithError:error withDataType:CASubmissionDataProjects];
        }
    }];
    
}

- (void)loadProjectTaskForms:(NSString *)projectId
{
    if ([self.delegate respondsToSelector:@selector(dataLoading)])
    {
        [self.delegate dataLoading];
    }
    
    __weak typeof (self) weakSelf = self;
    [[CANetworkManager sharedInstance] getProjectTaskFormsWithProjectId:projectId withSuccessBlock:^(NSArray *taskFormArray)
    {
        __strong typeof (weakSelf) strongSelf = weakSelf;
        strongSelf.projectTaskForms = [NSMutableArray new];
        for (NSDictionary *dict in taskFormArray)
        {
            [strongSelf.projectTaskForms addObject:[[CATaskForm alloc] initWithDictionary:dict]];
        }
        if ([strongSelf.delegate respondsToSelector:@selector(dataLoadedWithDataType:)])
        {
            [strongSelf.delegate dataLoadedWithDataType:CASubmissionDataProjectTaskForms];
        }
        
    } failureBlock:^(NSError *error) {
        if ([weakSelf.delegate respondsToSelector:@selector(dataLoadedWithError:withDataType:)])
        {
            [weakSelf.delegate dataLoadedWithError:error withDataType:CASubmissionDataProjectTaskForms];
        }
    }];
    
    
    
}

@end
