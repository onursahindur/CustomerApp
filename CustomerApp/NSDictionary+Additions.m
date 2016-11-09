//
//  NSDictionary+Additions.m
//  CustomerApp
//
//  Created by Onur Şahindur on 09/11/16.
//  Copyright © 2016 onursahindur. All rights reserved.
//

#import "NSDictionary+Additions.h"

@implementation NSDictionary (Additions)

- (id)safeObjectForKey:(id)aKey
{
    if (![self objectForKey:aKey] || [[self objectForKey:aKey] isKindOfClass:[NSNull class]])
    {
        return nil;
    }
    return [self objectForKey:aKey];
}

@end
