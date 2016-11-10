//
//  CAAnswer.h
//  CustomerApp
//
//  Created by Onur Şahindur on 10/11/16.
//  Copyright © 2016 onursahindur. All rights reserved.
//

@interface CAAnswer : NSObject

@property (nonatomic, assign) NSInteger         answerId;
@property (nonatomic, strong) NSString          *type;
@property (nonatomic, assign) NSInteger         questionId;
@property (nonatomic, strong) NSString          *value;

- (id)initWithDictionary:(NSDictionary *)dict;

@end
