//
//  Where_Car_Tests.m
//  Where Car?Tests
//
//  Created by Michael Critz on 3/21/14.
//  Copyright (c) 2014 Map of the Unexplored. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "CAR_LocationController.h"

@interface Where_Car_Tests : XCTestCase

@end

@implementation Where_Car_Tests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testLocationController
{
	CAR_LocationController *testLocationController = [[CAR_LocationController alloc] init];
	XCTAssert([testLocationController.locationManager isKindOfClass:[CLLocationManager class]], @"LocationController should be valid");
	XCTAssert(testLocationController.beaconStatus >= 0, @"beaconStatus should be valid");
}

@end
