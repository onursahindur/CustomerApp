//
//  CASubmissionsViewController.m
//  CustomerApp
//
//  Created by Onur Şahindur on 09/11/16.
//  Copyright © 2016 onursahindur. All rights reserved.
//

#import "CASubmissionsViewController.h"
#import "CASubmissionsLogic.h"
#import <MKDropdownMenu/MKDropdownMenu.h>
#import "Masonry.h"
#import "CATaskForm.h"
#import "CASubmission.h"
#import "CASubmissionCollectionViewCell.h"
#import "CATaskFormQuestion.h"

static NSInteger kStaticProjectId = 685;

@interface CASubmissionsViewController () <CASubmissionsLogicDelegate, MKDropdownMenuDataSource, MKDropdownMenuDelegate,
                                                        UICollectionViewDelegate, UICollectionViewDataSource, UIScrollViewDelegate>

@property (assign, nonatomic) NSInteger                 currentPage;
@property (strong, nonatomic) CASubmissionsLogic        *logic;
@property (strong, nonatomic) MKDropdownMenu            *taskFormListMenu;

@property (weak, nonatomic) IBOutlet UILabel            *projectTaskFormLabel;
@property (weak, nonatomic) IBOutlet UIView             *submissionsView;
@property (weak, nonatomic) IBOutlet UICollectionView   *collectionView;
@property (weak, nonatomic) IBOutlet UIButton           *backButton;
@property (weak, nonatomic) IBOutlet UIButton           *nextButton;
@property (weak, nonatomic) IBOutlet UIButton           *middleButton;

@end

@implementation CASubmissionsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.logic = [CASubmissionsLogic new];
    self.logic.delegate = self;
    [self initUI];
    [self styleNavigationBar];
    [self fetchTaskForms];
}

- (void)initUI
{
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([CASubmissionCollectionViewCell class]) bundle:nil]
          forCellWithReuseIdentifier:NSStringFromClass([CASubmissionCollectionViewCell class])];
    self.currentPage = 0;
    self.backButton.enabled = NO;
    self.middleButton.userInteractionEnabled = NO;
    self.submissionsView.hidden = YES;
}

- (void)styleNavigationBar
{
    [CANavigationBarStyler addLeftAlignedTitle:NSLocalizedString(@"Submissions", nil) withViewController:self];
    [CANavigationBarStyler styleNavigationBarColorsWithTintColor:[UIColor whiteColor]
                                                withBarTintColor:RGB(51, 84, 156)
                                                    withBarStyle:UIStatusBarStyleLightContent
                                          withBarButtonItemColor:[UIColor whiteColor]
                                              withViewController:self];
}

- (void)fetchTaskForms
{
    self.projectTaskFormLabel.hidden = YES;
    [self.view showLoadingView];
    [self.logic loadProjectTaskForms:kStaticProjectId];
}

- (void)initTaskFormListMenu
{
    self.taskFormListMenu = [[MKDropdownMenu alloc] init];
    self.taskFormListMenu.delegate = self;
    self.taskFormListMenu.dataSource = self,
    self.taskFormListMenu.backgroundColor = [UIColor whiteColor];
    self.taskFormListMenu.componentTextAlignment = NSTextAlignmentLeft;
    self.taskFormListMenu.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.taskFormListMenu.layer.borderWidth = 0.5f;
    self.taskFormListMenu.layer.cornerRadius = 10.0f;
    self.taskFormListMenu.disclosureIndicatorImage = [UIImage imageNamed:@"bottom"];
    self.taskFormListMenu.backgroundDimmingOpacity = 0.0f;
    [self.view addSubview:self.taskFormListMenu];
    
    [self.taskFormListMenu mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.projectTaskFormLabel.mas_bottom).offset(10);
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.height.mas_equalTo(44);
    }];
}

- (void)dataLoadedWithDataType:(CASubmissionDataType)dataType
{
    [self.view dismissLoadingView];
    if (dataType == CASubmissionDataProjectTaskForms)
    {
        if (!self.logic.projectTaskForms || self.logic.projectTaskForms.count == 0)
        {
            [CAAlertManager showAlertWithTitle:NSLocalizedString(@"Error", nil)
                                       message:NSLocalizedString(@"NoTaskForm", nil)
                             cancelButtonTitle:NSLocalizedString(@"OK", nil)
                             otherButtonTitles:nil
                                viewController:self
                             completionHandler:nil];
            return;
        }
        self.projectTaskFormLabel.hidden = NO;
        [self initTaskFormListMenu];
    }
    else if (dataType == CASubmissionDataProjectTaskFormSubmissions)
    {
        if (!self.logic.submissions || self.logic.submissions.count == 0)
        {
            [CAAlertManager showAlertWithTitle:NSLocalizedString(@"Error", nil)
                                       message:NSLocalizedString(@"NoSubmissions", nil)
                             cancelButtonTitle:NSLocalizedString(@"OK", nil)
                             otherButtonTitles:nil
                                viewController:self
                             completionHandler:nil];
            return;
        }
        self.submissionsView.hidden = NO;
        [self.collectionView reloadData];
    }
}

- (NSInteger)numberOfComponentsInDropdownMenu:(MKDropdownMenu *)dropdownMenu
{
    return 1;
}

- (NSString *)dropdownMenu:(MKDropdownMenu *)dropdownMenu titleForComponent:(NSInteger)component
{
    return NSLocalizedString(@"SelectTaskForm", nil);
}

- (NSInteger)dropdownMenu:(MKDropdownMenu *)dropdownMenu numberOfRowsInComponent:(NSInteger)component
{
    return self.logic.projectTaskForms.count;
}

- (NSString *)dropdownMenu:(MKDropdownMenu *)dropdownMenu titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    CATaskForm *task = [self.logic.projectTaskForms objectAtIndex:row];
    return task.title;
}

- (void)dropdownMenu:(MKDropdownMenu *)dropdownMenu didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    [dropdownMenu closeAllComponentsAnimated:YES];
    CATaskForm *task = [self.logic.projectTaskForms objectAtIndex:row];
    [self.view showLoadingView];
    [self.logic loadProjectSubmissions:kStaticProjectId withTaskFormId:task.taskFormId];
}

#pragma mark - CollectionView DataSource & Delegates
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.logic.submissions.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CASubmissionCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([CASubmissionCollectionViewCell class])
                                                                                     forIndexPath:indexPath];
    CASubmission *submission = self.logic.submissions[indexPath.row];
    cell.questionsArray = submission.questionsArray;
    cell.answersArray = submission.answerArray;
    cell.parentViewController = self;
    [cell reloadTableViewData];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(collectionView.frame.size.width, collectionView.frame.size.height);
}

#pragma mark - Actions
- (IBAction)navigationButtonTapped:(id)sender
{
    self.currentPage = (sender == self.nextButton) ? self.currentPage + 1 : self.currentPage - 1;
    self.nextButton.enabled = (self.currentPage <= self.logic.projectTaskForms.count) ? YES : NO;
    self.backButton.enabled = (self.currentPage > 0) ? YES : NO;
    [self.middleButton setTitle:[NSString stringWithFormat:@"%ld", (long)self.currentPage+1] forState:UIControlStateNormal];
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:self.currentPage inSection:0]
                                atScrollPosition:UICollectionViewScrollPositionNone
                                        animated:YES];
}

#pragma mark - ScrollView
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    // Since we supply paging, [self.collectionView visibleCells] method should return only one element.
    // In case of strange crashes, be sure it contains one element.
    if ([self.collectionView visibleCells].count == 1)
    {
        NSInteger newIndex = [self.collectionView indexPathForCell:[[self.collectionView visibleCells] firstObject]].row;
        if (newIndex < self.currentPage)
        {
            [self navigationButtonTapped:self.backButton];
        }
        else if (newIndex > self.currentPage)
        {
            [self navigationButtonTapped:self.nextButton];
        }
        else
        {
            // Same page do nothing..  Nothing to do here..
            // Don't want to live on this "else" planet anymore..
            // Ehe. Not funny?
        }
    }
}



@end
