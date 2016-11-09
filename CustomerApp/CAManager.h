//
//  CAManager.h
//  CustomerApp
//
//  Created by Onur Şahindur on 09/11/16.
//  Copyright © 2016 onursahindur. All rights reserved.
//

@interface CAManager : NSObject

+ (instancetype)sharedInstance;

@property (nonatomic, strong) NSString *accessToken;

@end
