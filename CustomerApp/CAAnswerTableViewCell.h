//
//  CAAnswerTableViewCell.h
//  CustomerApp
//
//  Created by Onur Şahindur on 10/11/16.
//  Copyright © 2016 onursahindur. All rights reserved.
//

@interface CAAnswerTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel                    *questionLabel;
@property (weak, nonatomic) IBOutlet UILabel                    *answerLabel;
@property (weak, nonatomic) IBOutlet UIImageView                *imageUploadedView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint         *answerLabelHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint         *imageViewWidthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint         *imageViewHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint         *answerLabelLeftConstraint;

@end
