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
#import "UIImageView+WebCache.h"

static NSString *const kTableViewCellIdentifier = @"CAAnswerTableViewCell";

@interface CASubmissionCollectionViewCell () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation CASubmissionCollectionViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self.tableView registerNib:[UINib nibWithNibName:kTableViewCellIdentifier bundle:nil]
         forCellReuseIdentifier:kTableViewCellIdentifier];
    self.tableView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.tableView.layer.borderWidth = 0.5f;
    self.tableView.layer.cornerRadius = 10.0f;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 140;
}

#pragma mark - TableView DataSource & Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.questionsArray.count;
}

static CGFloat const kLeftPadding = 10.0f;
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CAAnswerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kTableViewCellIdentifier];
    CATaskFormQuestion *question = self.questionsArray[indexPath.row];
    CAAnswer *belongingAnswer = [self findAnswer:question];
    cell.questionLabel.text = question.labelText;
    cell.answerLabel.text = belongingAnswer ? belongingAnswer.value : NSLocalizedString(@"NoAnswer", nil);
    CGFloat estimatedHeight = [self sizeOfMultiLineLabel:cell.answerLabel].height;
    cell.answerLabelHeightConstraint.constant = estimatedHeight;
    if ([cell.answerLabel.text containsString:@"photos"])
    {
        cell.imageUploadedView.hidden = NO;
        [cell.imageUploadedView sd_setImageWithURL:[NSURL URLWithString:cell.answerLabel.text]
                                  placeholderImage:[UIImage imageNamed:@"photoPlaceholder"]];
        cell.imageViewHeightConstraint.constant = 70.0f;
        cell.imageViewWidthConstraint.constant = 70.0f;
        cell.answerLabelLeftConstraint.constant = kLeftPadding * kLeftPadding;
    }
    else
    {
        cell.imageUploadedView.hidden = YES;
        cell.answerLabelLeftConstraint.constant = kLeftPadding;
    }
    
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

- (CGSize)sizeOfMultiLineLabel:(UILabel *)label
{
    NSString *aLabelTextString = [label text];
    UIFont *aLabelFont = [label font];
    CGFloat aLabelSizeWidth = label.frame.size.width;
    return [aLabelTextString boundingRectWithSize:CGSizeMake(aLabelSizeWidth, MAXFLOAT)
                                          options:NSStringDrawingUsesLineFragmentOrigin
                                       attributes:@{
                                                    NSFontAttributeName : aLabelFont
                                                    }
                                          context:nil].size;
    
}


@end
