//
//  CAR_BeaconController.m
//  Where Car?
//
//  Created by Michael Critz on 3/22/14.
//  Copyright (c) 2014 Map of the Unexplored. All rights reserved.
//

#import "CAR_BeaconController.h"

@implementation CAR_BeaconController

@synthesize beaconRegion = _beaconRegion;
@synthesize beaconLocation = _beaconLocation;
@synthesize locationManager = _locationManager;

- (CAR_BeaconController *)init {
    self = [super init];
    if (self) {
        [self.locationManager setDelegate:self];
        [self.locationManager startMonitoringForRegion:self.beaconRegion];
    }
    return self;
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    self.deviceLocation = [locations lastObject];
}

// CL
- (CLLocationManager *)locationManager {
    if (!_locationManager) {
        _locationManager = [[CLLocationManager alloc] init];
    }
    return _locationManager;
}

- (CLBeaconRegion *)beaconRegion {
    if (!_beaconRegion) {
        NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:@"8AEFB031-6C32-486F-825B-E26FA193487D"];
        _beaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:uuid identifier:@"com.MapOfTheUnexplored.WhereCar"];
    }
    return _beaconRegion;
}

- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region {
    [self updateBeaconLocation:self.locationManager.location];
    [self.locationManager startRangingBeaconsInRegion:self.beaconRegion];
}

-(void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region {
    [self.locationManager stopRangingBeaconsInRegion:self.beaconRegion];
    [self updateBeaconLocation:self.locationManager.location];
    [self logLocation:self.locationManager.location andString:@"locationManager:didExitRegion"];
}

-(void)locationManager:(CLLocationManager *)manager
       didRangeBeacons:(NSArray *)beacons
              inRegion:(CLBeaconRegion *)region {
    self.beacon = [beacons lastObject];
    if (self.beacon.proximity == CLProximityUnknown) {
        NSLog(@"Dude, where's my car?");
    } else if (self.beacon.proximity == CLProximityImmediate) {
        NSLog(@"Dude, THERE'S your car!");
    } else if (self.beacon.proximity == CLProximityNear) {
        NSLog(@"Dude, it's right there!");
    } else if (self.beacon.proximity == CLProximityFar) {
        NSLog(@"Dude, your car is far.");
    }
    [self updateBeaconLocation:self.locationManager.location];
}

// return a location for the last seen beacon
- (void)updateBeaconLocation:(CLLocation *)newBeaconLocation {
    self.beaconLocation = newBeaconLocation;
    [self logLocation:newBeaconLocation
            andString:@"updateBeaconLocation"];
}

- (CLLocation *)deviceLocation {
    CLLocation *currentLocation = self.locationManager.location;
    [self logLocation:currentLocation andString:@"deviceLocation"];
    return currentLocation;
}

- (void)logLocation:(CLLocation *)loc andString:(NSString *)string {
    NSLog(@"%@ is: %f lat %f long", string, loc.coordinate.latitude, loc.coordinate.longitude);
}

@end
