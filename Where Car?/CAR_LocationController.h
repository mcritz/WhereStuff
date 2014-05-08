//
//  CAR_LocationController.h
//  Where Car?
//
//  Created by Michael Critz on 5/4/14.
//  Copyright (c) 2014 Map of the Unexplored. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "CAR_LocationModel.h"

@interface CAR_LocationController : NSObject <CLLocationManagerDelegate>

@property (strong, nonatomic)CLLocationManager *locationManager;
@property (strong, nonatomic)CLBeaconRegion *beaconRegion;
@property (nonatomic)CLLocation *deviceLocation;

// Beacon States
typedef NS_ENUM(NSUInteger, BeaconStatus) {
	kBeaconUnknown = 0,
	kBeaconImmediate,
	kBeaconNear,
	kBeaconFar
};
@property (readonly)BeaconStatus beaconStatus;

// Access model through the controller
@property (strong, nonatomic)CAR_LocationModel *beaconLocation;

@end
