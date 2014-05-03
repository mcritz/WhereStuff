//
//  CAR_ViewController.m
//  Where Car?
//
//  Created by Michael Critz on 3/21/14.
//  Copyright (c) 2014 Map of the Unexplored. All rights reserved.
//

#import "CAR_ViewController.h"

@interface CAR_ViewController ()

@property (nonatomic, strong)CLLocation *lastSeen;
@property (nonatomic, strong)MKPointAnnotation *carAnnotation;
@property (nonatomic, strong)CLBeaconRegion *beaconRegion;

@end

@implementation CAR_ViewController
@synthesize locationManager = _locationManager;
@synthesize beaconRegion;
@synthesize lastSeen = _lastSeen;
@synthesize carAnnotation = _carAnnotation;

- (void)viewDidLoad
{
    [super viewDidLoad];
	[self.statusLabel setText:@"viewDidLoad"];
	[self checkCLAuthorization];
}

- (void)checkCLAuthorization {
	if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorized) {
		NSLog(@"Hola! CL is authorized");
		[self.locationManager setDelegate:self];
		[self initBeacon];
		[self.locationManager startMonitoringForRegion:self.beaconRegion];
		[self.locationManager startUpdatingLocation];
	} else {
		NSLog(@"Oh, fucksocks. CL is not authorized");
	}
}

- (CLLocationManager *)locationManager {
	if (!_locationManager) {
		_locationManager = [[CLLocationManager alloc] init];
		// TODO: probably not this
		[_locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
	}
	return _locationManager;
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
}

- (MKPointAnnotation *)carAnnotation {
	_carAnnotation = [[MKPointAnnotation alloc] init];
	if (CLLocationCoordinate2DIsValid(self.locationManager.location.coordinate)) {
		[_carAnnotation setCoordinate:self.locationManager.location.coordinate];
		[_carAnnotation setTitle:@"Your Car, Dude!"];
		[_carAnnotation setSubtitle:@"There it is!"];
	}
	return _carAnnotation;
}


- (void)initBeacon {
	for (CLBeaconRegion *br in self.locationManager.monitoredRegions) {
		[self.locationManager stopMonitoringForRegion:br];
	}

	// TODO: not shitty hardcoded beacon
	// KST		8AEFB031-6C32-486F-825B-E26FA193487D
	// Qualcom	E30F2707-DB66-46DF-A504-215C396990CA
	NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:@"E30F2707-DB66-46DF-A504-215C396990CA"];
	self.beaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:uuid
															major:1
															minor:4
													   identifier:@"com.mapoftheunexplored.car"];
}

- (CLLocation *)lastSeen {
	if (!_lastSeen) {
		_lastSeen = self.locationManager.location;
	}
	return _lastSeen;
}

- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region {
    [self.statusLabel setText:@"Beacon Found"];
    [self.locationManager startRangingBeaconsInRegion:self.beaconRegion];
}

-(void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region {
    [self.locationManager stopRangingBeaconsInRegion:self.beaconRegion];
}

-(void)locationManager:(CLLocationManager *)manager
       didRangeBeacons:(NSArray *)beacons
              inRegion:(CLBeaconRegion *)region {
    CLBeacon *beaconToRange = [beacons lastObject];
    if (beaconToRange.proximity == CLProximityUnknown) {
        [self.statusLabel setText:@"Dude, where's my car?"];
    } else if (beaconToRange.proximity == CLProximityImmediate) {
        [self.statusLabel setText:@"Dude, THERE'S your car!"];
		[self updateLastSeen];
    } else if (beaconToRange.proximity == CLProximityNear) {
        [self.statusLabel setText:@"Dude, it's right there!"];
		[self updateLastSeen];
    } else if (beaconToRange.proximity == CLProximityFar) {
        [self.statusLabel setText:@"Dude, your car is far."];
    }
}

- (void)updateLastSeen {
	NSLog(@"updateLastSeen");
	[self.statusLabel setText:@"updateLastSeen"];
	self.lastSeen = self.locationManager.location;
	for (MKPointAnnotation *annotation in self.bigMap.annotations) {
		[self.bigMap removeAnnotation:annotation];
	}
	[self.bigMap addAnnotation:self.carAnnotation];
}


- (IBAction)logButtonPressed:(id)sender {
	NSString *logMessage = @"updateLastSeen";
	[self updateLastSeen];
	[self.statusLabel setText:logMessage];
	NSLog(@"%@", self.locationManager.location);
}

@end
