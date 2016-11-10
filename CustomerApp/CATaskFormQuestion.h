//
//  CATaskFormQuestion.h
//  CustomerApp
//
//  Created by Onur Şahindur on 10/11/16.
//  Copyright © 2016 onursahindur. All rights reserved.
//

typedef enum
{
    CAQuestionTypeImage,
    CAQuestionTypeLocation,
    CAQuestionTypeOthers
}CATaskFormQuestionType;

@interface CATaskFormQuestion : NSObject

@property (nonatomic, assign) NSInteger                 questionId;
@property (nonatomic, strong) NSString                  *labelText;
@property (nonatomic, assign) CATaskFormQuestionType    questionType;

- (id)initWithDictionary:(NSDictionary *)dict;

@end
