//
//  CATaskFormQuestion.m
//  CustomerApp
//
//  Created by Onur Şahindur on 10/11/16.
//  Copyright © 2016 onursahindur. All rights reserved.
//

#import "CATaskFormQuestion.h"
#import "CAAnswer.h"

@implementation CATaskFormQuestion

- (id)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    if (self)
    {
        _questionId = [[dict safeObjectForKey:@"id"] integerValue];
        _labelText = [dict safeObjectForKey:@"label"];
        _questionType = [dict safeObjectForKey:@"question_type"];
    }
    return self;
}

@end
