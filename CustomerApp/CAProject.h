//
//  CAProject.h
//  CustomerApp
//
//  Created by Onur Şahindur on 09/11/16.
//  Copyright © 2016 onursahindur. All rights reserved.
//

typedef enum
{
    CAProjectAvailable,
    CAProjectNotAvailable
}CAProjectAvailability;

typedef enum
{
    CAProjectTypeLocationless,
    CAProjectTypeLocationly
}CAProjectType;

@interface CAProject : NSObject

@property (nonatomic, assign) NSInteger                 projectId;
@property (nonatomic, strong) NSString                  *name;
@property (nonatomic, strong) NSString                  *logoURLString;
@property (nonatomic, strong) NSDate                    *startedDate;
@property (nonatomic, strong) NSDate                    *finishedDate;
@property (nonatomic, assign) NSInteger                 tasksCount;
@property (nonatomic, assign) NSInteger                 submissionsCount;
@property (nonatomic, assign) NSInteger                 acceptedSubmissionsCount;
@property (nonatomic, assign) NSInteger                 submissionLimit;
@property (nonatomic, strong) NSString                  *totalSpent;
@property (nonatomic, strong) NSString                  *completionRate;
@property (nonatomic, assign) CAProjectType             projectType;
@property (nonatomic, assign) CAProjectAvailability     status;

- (id)initWithDictionary:(NSDictionary *)dict;

@end
