//
//  CATaskForm.h
//  CustomerApp
//
//  Created by Onur Şahindur on 09/11/16.
//  Copyright © 2016 onursahindur. All rights reserved.
//

@interface CATaskForm : NSObject

@property (nonatomic, assign) NSInteger taskFormId;
@property (nonatomic, strong) NSString  *title;

- (id)initWithDictionary:(NSDictionary *)dict;

@end
