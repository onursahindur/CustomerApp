//
//  CAAnswer.m
//  CustomerApp
//
//  Created by Onur Şahindur on 10/11/16.
//  Copyright © 2016 onursahindur. All rights reserved.
//

#import "CAAnswer.h"
#import "CATaskFormQuestion.h"

@implementation CAAnswer

- (id)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    if (self)
    {
        _answerId = [[dict safeObjectForKey:@"id"] integerValue];
        _type = [dict safeObjectForKey:@"type"];
        _questionId = [[dict safeObjectForKey:@"question_id"] integerValue];
        _value = [dict safeObjectForKey:@"value"];
    }
    return self;
}

@end
