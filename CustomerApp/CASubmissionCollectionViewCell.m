//
//  CASubmissionCollectionViewCell.m
//  CustomerApp
//
//  Created by Onur Şahindur on 10/11/16.
//  Copyright © 2016 onursahindur. All rights reserved.
//

#import "CASubmissionCollectionViewCell.h"
#import "CAAnswerTableViewCell.h"
#import "CATaskFormQuestion.h"
#import "CAAnswer.h"

@interface CASubmissionCollectionViewCell () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation CASubmissionCollectionViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self.tableView registerNib:[UINib nibWithNibName:@"CAAnswerTableViewCell" bundle:nil]
         forCellReuseIdentifier:@"CAAnswerTableViewCell"];
    self.tableView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.tableView.layer.borderWidth = 0.5f;
    self.tableView.layer.cornerRadius = 10.0f;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}

#pragma mark - TableView DataSource & Delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.questionsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CAAnswerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CAAnswerTableViewCell"];
    CATaskFormQuestion *question = self.questionsArray[indexPath.row];
    CAAnswer *belongingAnswer = [self findAnswer:question];
    cell.questionLabel.text = question.labelText;
    cell.answerLabel.text = belongingAnswer.value;
    return cell;
}

- (void)reloadTableViewData
{
    [self.tableView reloadData];
}

- (CAAnswer *)findAnswer:(CATaskFormQuestion *)question
{
    for (CAAnswer *answer in self.answersArray)
    {
        if (answer.questionId == question.questionId)
        {
            return answer;
        }
    }
    return nil;
}


@end
