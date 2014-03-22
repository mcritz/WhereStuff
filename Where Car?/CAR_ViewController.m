//
//  CAR_ViewController.m
//  Where Car?
//
//  Created by Michael Critz on 3/21/14.
//  Copyright (c) 2014 Map of the Unexplored. All rights reserved.
//

#import "CAR_ViewController.h"

@interface CAR_ViewController ()

@property (nonatomic, strong)CLBeacon *beacon;

@end

@implementation CAR_ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// CL
- (CLLocationManager *)locationManager {
    if (!_locationManager) {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
    }
    return _locationManager;
}

- (CLBeaconRegion *)beaconRegion {
    if (!_beaconRegion) {
        // TODO: not shitty hardcoded beacon
        NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:@"8AEFB031-6C32-486F-825B-E26FA193487D"];
        _beaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:uuid identifier:@"com.MapOfTheUnexplored.WhereCar"];
    }
    return _beaconRegion;
}

- (void)initRegion {
    [self.locationManager startMonitoringForRegion:self.beaconRegion];
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
}


@end
