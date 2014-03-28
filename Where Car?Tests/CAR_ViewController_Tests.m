//
//  CAR_ViewController_Tests.m
//  Where Car?
//
//  Created by Michael Critz on 3/24/14.
//  Copyright (c) 2014 Map of the Unexplored. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "CAR_ViewController.h"
#import "CAR_BeaconAnnotation.h"

@interface CAR_ViewController_Tests : XCTestCase

@property (nonatomic)CAR_ViewController *carVc;

@end

@implementation CAR_ViewController_Tests

- (void)setUp
{
    [super setUp];
    self.carVc = [[CAR_ViewController alloc] init];
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
    self.carVc = nil;
}

- (void)testExists {
    XCTAssert([self.carVc isKindOfClass:[CAR_ViewController class]], @"carVC is a CAR_ViewController");
}

- (void)testLocationManager {
    CAR_BeaconController *testBeacon = [[CAR_BeaconController alloc] init];
    self.carVc.beaconController = testBeacon;
    CLLocationManager *testLocationManager = [[CLLocationManager alloc] init];
    testBeacon.locationManager = testLocationManager;
    XCTAssert([self.carVc.beaconController.locationManager isEqual:testLocationManager], @"Location managers match");
}

@end
