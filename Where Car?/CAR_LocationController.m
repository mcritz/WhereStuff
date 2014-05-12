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
	[self initLocationManager];
	return self;
}

- (void)initLocationManager {
	if (!_locationManager) {
		_locationManager = [[CLLocationManager alloc] init];
		[_locationManager setDelegate:self];
		// TODO: probably not this
		[_locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
		[_locationManager setPausesLocationUpdatesAutomatically:YES];
		
		// 'CLActivityTypeFitness' is defined as 'pedestrian activity'.
		// We assume the user is walking away from a desired object.
		[_locationManager setActivityType:CLActivityTypeFitness];
	}
	[self checkCLAuthorization];
	[self initBeacon];
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
																major:1
														   identifier:@"com.mapoftheunexplored.car"];
	[self.locationManager startMonitoringForRegion:self.beaconRegion];
}

- (CAR_LocationModel *)beaconLocation {
	if (!_beaconLocation) {
		_beaconLocation = [[CAR_LocationModel alloc] init];
	}
	return _beaconLocation;
}

- (void)checkCLAuthorization {
	if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorized) {
		NSLog(@"Hola! CL is authorized");
		[self.locationManager startUpdatingLocation];
	} else {
		// TODO: Better UX
		NSLog(@"Oh, fucksocks. CL is not authorized");
	}
}

- (CLLocation *)deviceLocation {
	if (!_deviceLocation) {
		_deviceLocation = self.locationManager.location;
	}
	return _deviceLocation;
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
	[self updateLocationForBeacon:beaconToRange];
	[self attemptToConserveBattery:shouldConservePower];
}

- (void)locationManager:(CLLocationManager *)manager
	  didDetermineState:(CLRegionState)state
			  forRegion:(CLRegion *)region {
	if ([region isKindOfClass:[CLBeaconRegion class]]) {
		[self.locationManager startRangingBeaconsInRegion:(CLBeaconRegion *)region];
	}
}

- (void)updateLocationForBeacon:(CLBeacon *)beacon {
	self.beaconLocation.lastSeen = [NSDate date];
	
	if (self.beaconStatus == kBeaconImmediate
		|| self.beaconStatus == kBeaconNear) {
		[self.beaconLocation setLocation:self.locationManager.location];
	} else if (self.beaconStatus == kBeaconFar) {
//		NSLog(@"kBeaconFar");
	}
}

- (void)locationManager:(CLLocationManager *)manager monitoringDidFailForRegion:(CLRegion *)region withError:(NSError *)error {
	// TODO: Graceful error handling
	NSLog(@"monitoring failed!");
}

#pragma mark - Utility methods

// Decide whether to draw a map pin
- (BOOL)shouldDrawPin {
	if (self.beaconStatus == kBeaconImmediate
		|| self.beaconStatus == kBeaconNear) {
		return NO;
	} else if (!self.beaconLocation.lastSeen) {
		return NO;
	} else if ([self.beaconLocation.lastSeen isEqual:[NSDate date]]) {
		return NO;
	} else {
		return YES;
	}
}

// Attempt to conserve energy
- (void)attemptToConserveBattery:(BOOL)conserve {
	CLLocationAccuracy accuracy = conserve ? kCLLocationAccuracyKilometer : kCLLocationAccuracyBest;
	[self.locationManager setDesiredAccuracy:accuracy];
}

@end
