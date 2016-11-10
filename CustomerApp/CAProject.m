//
//  CAProject.m
//  CustomerApp
//
//  Created by Onur Şahindur on 09/11/16.
//  Copyright © 2016 onursahindur. All rights reserved.
//

#import "CAProject.h"

@implementation CAProject

- (id)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    if (self)
    {
        _projectId = [[dict safeObjectForKey:@"id"] integerValue];
        _name = [dict safeObjectForKey:@"name"];
        _logoURLString = [dict safeObjectForKey:@"logo_url"];
        _status = [[dict safeObjectForKey:@"status"] isEqualToString:@"available"] ? CAProjectAvailable : CAProjectNotAvailable;
        
        NSDateFormatter *formatter = [NSDateFormatter new];
        [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZ"];
        _startedDate = [formatter dateFromString:[dict safeObjectForKey:@"started_at"]];
        _finishedDate = [formatter dateFromString:[dict safeObjectForKey:@"finished_at"]];
        
        _tasksCount = [[dict safeObjectForKey:@"tasks_count"] integerValue];
        _submissionsCount = [[dict safeObjectForKey:@"submissions_count"] integerValue];
        _acceptedSubmissionsCount = [[dict safeObjectForKey:@"accepted_submissions_count"] integerValue];
        _totalSpent = [dict safeObjectForKey:@"total_spent"];
        _submissionLimit = [[dict safeObjectForKey:@"submissions_limit"] integerValue];
        _completionRate = [dict safeObjectForKey:@"completion_rate"];
        _projectType = [[dict safeObjectForKey:@"project_type"] isEqualToString:@"locationly"] ? CAProjectTypeLocationly : CAProjectTypeLocationless;
    }
    return self;
}

@end
