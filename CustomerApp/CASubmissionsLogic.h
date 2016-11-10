//
//  CASubmissionsLogic.h
//  CustomerApp
//
//  Created by Onur Şahindur on 09/11/16.
//  Copyright © 2016 onursahindur. All rights reserved.
//

typedef enum
{
    CASubmissionDataProjects,
    CASubmissionDataProjectTaskForms,
    CASubmissionDataProjectTaskFormSubmissions
}CASubmissionDataType;

@protocol CASubmissionsLogicDelegate <NSObject>

@optional
- (void)dataLoading;
- (void)dataLoadedWithDataType:(CASubmissionDataType)dataType;
- (void)dataLoadedWithError:(NSError *)error
               withDataType:(CASubmissionDataType)dataType;

@end

@interface CASubmissionsLogic : NSObject

- (void)loadProjects;
- (void)loadProjectTaskForms:(NSInteger)projectId;
- (void)loadProjectSubmissions:(NSInteger)projectId
                withTaskFormId:(NSInteger)taskFormId;

// Data to be collected.
@property (nonatomic, strong) NSMutableArray *projects;
@property (nonatomic, strong) NSMutableArray *projectTaskForms;
@property (nonatomic, strong) NSMutableArray *submissions;

@property (nonatomic, weak) id<CASubmissionsLogicDelegate>delegate;

@end
