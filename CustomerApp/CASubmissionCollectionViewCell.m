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
#import <MWPhotoBrowser/MWPhotoBrowser.h>

static NSString *const kTableViewCellIdentifier = @"CAAnswerTableViewCell";

@interface CASubmissionCollectionViewCell () <UITableViewDelegate, UITableViewDataSource, MWPhotoBrowserDelegate>

@property (weak, nonatomic) IBOutlet UITableView    *tableView;
@property (strong, nonatomic) MWPhoto               *bigPhotoToDisplay;

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
    
    if (question.questionType == CAQuestionTypeImage)
    {
        cell.imageUploadedView.hidden = NO;
        [cell.imageUploadedView sd_setImageWithURL:[NSURL URLWithString:belongingAnswer.value]
                                  placeholderImage:[UIImage imageNamed:@"photoPlaceholder"]];
        cell.imageViewHeightConstraint.constant = 25.0f;
        cell.imageViewWidthConstraint.constant = 25.0f;
        cell.answerLabelLeftConstraint.constant = kLeftPadding * 5;
        cell.answerLabel.text = NSLocalizedString(@"TapToSeeBig", nil);
        cell.answerLabel.font = [UIFont italicSystemFontOfSize:15.0f];
    }
    else
    {
        cell.imageUploadedView.hidden = YES;
        cell.answerLabelLeftConstraint.constant = kLeftPadding;
        cell.answerLabel.font = [UIFont systemFontOfSize:15.0f];
    }
    
    CGFloat estimatedHeight = [self sizeOfMultiLineLabel:cell.answerLabel].height;
    cell.answerLabelHeightConstraint.constant = estimatedHeight;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CATaskFormQuestion *question = self.questionsArray[indexPath.row];
    if (question.questionType == CAQuestionTypeImage)
    {
        CAAnswer *belongingAnswer = [self findAnswer:question];
        MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
        self.bigPhotoToDisplay = [MWPhoto photoWithURL:[NSURL URLWithString:belongingAnswer.value]];
        self.bigPhotoToDisplay.caption = question.labelText;
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:browser];
        [self.parentViewController presentViewController:navController animated:YES completion:nil];
    }
}

- (void)reloadTableViewData
{
    [self.tableView reloadData];
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]
                          atScrollPosition:UITableViewScrollPositionNone animated:NO];
}

#pragma mark - Helpers
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

#pragma mark - MWPhoto Delegate
- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser
{
    return 1;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index
{
    return self.bigPhotoToDisplay;
}


@end
