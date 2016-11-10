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
@property (strong, nonatomic) NSMutableArray        *photoArray;

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
    NSArray *belongingAnswers = [self findAnswers:question];
    cell.questionLabel.text = question.labelText;
    
    if (question.questionType == CAQuestionTypeImage
        || question.questionType == CAQuestionTypeLocation)
    {
        cell.imageUploadedView.hidden = NO;
        cell.imageUploadedView.image = [UIImage imageNamed:question.questionType == CAQuestionTypeImage ? @"photo" : @"location"];
        cell.answerLabelLeftConstraint.constant = kLeftPadding * 5;
        cell.answerLabel.text = (question.questionType == CAQuestionTypeImage) ? [NSString stringWithFormat:NSLocalizedString(@"TapToSeeBig",nil), belongingAnswers.count] : NSLocalizedString(@"TapToSeeLocation",nil);
        cell.answerLabel.font = [UIFont italicSystemFontOfSize:15.0f];
    }
    else
    {
        cell.imageUploadedView.hidden = YES;
        cell.answerLabelLeftConstraint.constant = kLeftPadding;
        cell.answerLabel.font = [UIFont systemFontOfSize:15.0f];
        cell.answerLabel.text = (belongingAnswers.count > 0) ? ((CAAnswer *)[belongingAnswers firstObject]).value : NSLocalizedString(@"NoAnswer", nil);
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
        NSArray *belongingAnswers = [self findAnswers:question];
        MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
        self.photoArray = [NSMutableArray new];
        for (CAAnswer *answer in belongingAnswers)
        {
            MWPhoto *photo = [[MWPhoto alloc] initWithURL:[NSURL URLWithString:answer.value]];
            photo.caption = question.labelText;
            [self.photoArray addObject:photo];
        }
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:browser];
        [self.parentViewController presentViewController:navController animated:YES completion:nil];
    }
    else if (question.questionType == CAQuestionTypeLocation)
    {
        CAAnswer *belongingAnswer = [[self findAnswers:question] firstObject];
        NSRange startIndex = [belongingAnswer.value rangeOfString:@"("];
        NSRange endIndex = [belongingAnswer.value rangeOfString:@")"];
        
        if (startIndex.location == NSNotFound || endIndex.location == NSNotFound)
        {
            DebugLog(@"Internal Server Error");
            return;
        }
        
        NSString *pointString = [belongingAnswer.value substringWithRange:NSMakeRange(startIndex.location + 1, endIndex.location - startIndex.location - 1)];
        CGFloat latitude = [[[pointString componentsSeparatedByString:@" "] lastObject] floatValue];
        CGFloat longitude = [[[pointString componentsSeparatedByString:@" "] firstObject] floatValue];
        NSString *appleMapsLink = [NSString stringWithFormat:@"http://maps.apple.com/maps?ll=%f,%f", latitude, longitude];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString: appleMapsLink]];
    }
}

- (void)reloadTableViewData
{
    [self.tableView reloadData];
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]
                          atScrollPosition:UITableViewScrollPositionNone animated:NO];
}

#pragma mark - Helpers
- (NSArray *)findAnswers:(CATaskFormQuestion *)question
{
    NSMutableArray *answers = [NSMutableArray new];
    for (CAAnswer *answer in self.answersArray)
    {
        if (answer.questionId == question.questionId)
        {
            [answers addObject:answer];
        }
    }
    return answers;
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
    return self.photoArray.count;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index
{
    return [self.photoArray objectAtIndex:index];
}


@end
