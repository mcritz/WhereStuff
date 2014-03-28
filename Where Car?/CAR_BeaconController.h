//
//  CAR_BeaconController.h
//  Where Car?
//
//  Created by Michael Critz on 3/22/14.
//  Copyright (c) 2014 Map of the Unexplored. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface CAR_BeaconController : NSObject <CLLocationManagerDelegate>

// CL Beacon setup
@property (nonatomic, strong)CLBeacon *beacon;
@property (strong, nonatomic)CLBeaconRegion *beaconRegion;
@property (strong, nonatomic)CLLocationManager *locationManager;
- (CAR_BeaconController *)init;

// CL Locations
@property (nonatomic)CLLocation *deviceLocation;
@property (nonatomic)CLLocation *beaconLocation;

@end
