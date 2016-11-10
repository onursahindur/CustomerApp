//
//  CATaskForm.m
//  CustomerApp
//
//  Created by Onur Şahindur on 09/11/16.
//  Copyright © 2016 onursahindur. All rights reserved.
//

#import "CATaskForm.h"

@implementation CATaskForm

- (id)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    if (self)
    {
        _taskFormId = [[dict safeObjectForKey:@"id"] integerValue];
        _title = [dict safeObjectForKey:@"title"];
    }
    return self;
}

@end
