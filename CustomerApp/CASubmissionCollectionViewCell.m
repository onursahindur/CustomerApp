//
//  CASubmissionCollectionViewCell.m
//  CustomerApp
//
//  Created by Onur Şahindur on 10/11/16.
//  Copyright © 2016 onursahindur. All rights reserved.
//

#import "CASubmissionCollectionViewCell.h"

@interface CASubmissionCollectionViewCell ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;


@end

@implementation CASubmissionCollectionViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.tableView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.tableView.layer.borderWidth = 0.5f;
    self.tableView.layer.cornerRadius = 10.0f;
}

@end
