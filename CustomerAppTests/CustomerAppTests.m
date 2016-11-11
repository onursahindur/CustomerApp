//
//  CustomerAppTests.m
//  CustomerAppTests
//
//  Created by Onur Şahindur on 09/11/16.
//  Copyright © 2016 onursahindur. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "CASubmissionsViewController.h"
#import "CANetworkManager.h"
#import "CAManager.h"

@interface CustomerAppTests : XCTestCase

@property (nonatomic, strong) CASubmissionsViewController *subVC;

@end

@implementation CustomerAppTests

- (void)setUp
{
    [super setUp];
    self.subVC = [CASubmissionsViewController new];
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testAccessTokenExists
{
    [[CANetworkManager sharedInstance] getProjectListWithSuccessBlock:^(NSArray *projectList)
    {
        XCTAssertNotNil([CAManager sharedInstance].accessToken);
    } failureBlock:nil];
}




@end
