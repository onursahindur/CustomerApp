//
//  CASubmission.h
//  CustomerApp
//
//  Created by Onur Şahindur on 10/11/16.
//  Copyright © 2016 onursahindur. All rights reserved.
//

@interface CASubmission : NSObject

@property (nonatomic, assign) NSInteger         submissionId;
@property (nonatomic, strong) NSString          *taskTitle;
@property (nonatomic, strong) NSMutableArray    *answerArray;
@property (nonatomic, strong) NSMutableArray    *questionsArray;

- (id)initWithDictionary:(NSDictionary *)dict
      withQuestionsArray:(NSMutableArray *)questions;

@end
