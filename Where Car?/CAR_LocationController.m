//
//  CAR_LocationController.m
//  Where Car?
//
//  Created by Michael Critz on 5/4/14.
//  Copyright (c) 2014 Map of the Unexplored. All rights reserved.
//

#import "CAR_LocationController.h"

@interface CAR_LocationController()

@property (readwrite)BeaconStatus beaconStatus;

@end

@implementation CAR_LocationController

#pragma mark - Object LifeCycle

- (CAR_LocationController *)init {
	self = [super init];
	[self checkCLAuthorization];
	return self;
}

- (CLLocationManager *)locationManager {
	if (!_locationManager) {
		_locationManager = [[CLLocationManager alloc] init];
		// TODO: probably not this
		[_locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
		[_locationManager setPausesLocationUpdatesAutomatically:YES];
		
		// 'CLActivityTypeFitness' is defined as 'pedestrian activity'.
		// We assume the user is walking away from a desired object.
		[_locationManager setActivityType:CLActivityTypeFitness];
	}
	return _locationManager;
}

- (void)checkCLAuthorization {
	if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorized) {
		NSLog(@"Hola! CL is authorized");
		[self.locationManager setDelegate:self];
		[self.locationManager startUpdatingLocation];
		[self initBeacon];
	} else {
		// TODO: Better UX
		NSLog(@"Oh, fucksocks. CL is not authorized");
	}
}

- (void)initBeacon {
	for (CLBeaconRegion *br in self.locationManager.monitoredRegions) {
		[self.locationManager stopMonitoringForRegion:br];
	}
	
	// TODO: not hardcoded beacon
	// KST		8AEFB031-6C32-486F-825B-E26FA193487D
	// Qualcom	E30F2707-DB66-46DF-A504-215C396990CA
	NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:@"E30F2707-DB66-46DF-A504-215C396990CA"];
	self.beaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:uuid
														   identifier:@"com.mapoftheunexplored.car"];
	[self.locationManager startMonitoringForRegion:self.beaconRegion];
}

- (CAR_LocationModel *)beaconLocation {
	if (!_beaconLocation) {
		_beaconLocation = [[CAR_LocationModel alloc] init];
		_beaconLocation.location = self.locationManager.location;
	}
	return _beaconLocation;
}

#pragma mark - CL Protocol Methods
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
	self.deviceLocation = [locations lastObject];
}

- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region {
    [self.locationManager startRangingBeaconsInRegion:self.beaconRegion];
}

-(void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region {
    [self.locationManager stopRangingBeaconsInRegion:self.beaconRegion];
}

-(void)locationManager:(CLLocationManager *)manager
       didRangeBeacons:(NSArray *)beacons
              inRegion:(CLBeaconRegion *)region {
    CLBeacon *beaconToRange = [beacons lastObject];
	BOOL shouldConservePower = NO;
    if (beaconToRange.proximity == CLProximityUnknown) {
		self.beaconStatus = kBeaconUnknown;
    } else if (beaconToRange.proximity == CLProximityImmediate) {
		self.beaconStatus = kBeaconImmediate;
    } else if (beaconToRange.proximity == CLProximityNear) {
		self.beaconStatus = kBeaconNear;
    } else if (beaconToRange.proximity == CLProximityFar) {
		self.beaconStatus = kBeaconFar;
		shouldConservePower = YES;
    }
	[self attemptToConserveBattery:shouldConservePower];
}

#pragma mark - Utility methods

- (void)updateBeaconLocation {
	[self.beaconLocation setLocation:self.locationManager.location];
}

// Attempt to conserve energy
- (void)attemptToConserveBattery:(BOOL)conserve {
	CLLocationAccuracy accuracy = conserve ? kCLLocationAccuracyKilometer : kCLLocationAccuracyBest;
	[self.locationManager setDesiredAccuracy:accuracy];
}

@end