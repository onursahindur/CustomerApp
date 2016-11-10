//
//  CASubmissionCollectionViewCell.h
//  CustomerApp
//
//  Created by Onur Şahindur on 10/11/16.
//  Copyright © 2016 onursahindur. All rights reserved.
//

@interface CASubmissionCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) NSMutableArray *questionsArray;
@property (nonatomic, strong) NSMutableArray *answersArray;

- (void)reloadTableViewData;

@end
