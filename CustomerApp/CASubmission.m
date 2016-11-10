//
//  CASubmission.m
//  CustomerApp
//
//  Created by Onur Şahindur on 10/11/16.
//  Copyright © 2016 onursahindur. All rights reserved.
//

#import "CASubmission.h"
#import "CAAnswer.h"
#import "CATaskFormQuestion.h"

@implementation CASubmission

- (id)initWithDictionary:(NSDictionary *)dict
      withQuestionsArray:(NSMutableArray *)questions
{
    self = [super init];
    if (self)
    {
        _questionsArray = [NSMutableArray arrayWithArray:questions]; // crash safe.
        _submissionId = [[dict safeObjectForKey:@"id"] integerValue];
        _taskTitle = [[dict safeObjectForKey:@"task"] safeObjectForKey:@"title"];
        _answerArray = [NSMutableArray new];
        for (NSDictionary *ansDict in [dict safeObjectForKey:@"answers"])
        {
            CAAnswer *answer = [[CAAnswer alloc] initWithDictionary:ansDict];
//            NSInteger indexOfQuestion = [self findQuestionIndex:answer.questionId];
//            CATaskFormQuestion *question = [self.questionsArray objectAtIndex:indexOfQuestion];
//            question.answer = answer;
//            [self.questionsArray removeObjectAtIndex:indexOfQuestion];
//            [self.questionsArray insertObject:question atIndex:indexOfQuestion];
            [_answerArray addObject:answer];
        }
    }
    return self;
}

- (NSInteger)findQuestionIndex:(NSInteger)questionId
{
    for (CATaskFormQuestion *question in self.questionsArray)
    {
        if (question.questionId == questionId)
        {
            return [self.questionsArray indexOfObject:question];
        }
    }
    return -1;
//    // Internal server error. Return mock Question to prevent any strange crash.
//    CATaskFormQuestion *mockQuestion = [CATaskFormQuestion new];
//    mockQuestion.labelText = @"";
//    DebugLog(@"Question not found. Mock Question using. Actual Q ID: %ld", questionId);
//    return mockQuestion;
}

@end
