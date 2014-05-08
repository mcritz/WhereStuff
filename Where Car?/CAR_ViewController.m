//
//  CAR_ViewController.m
//  Where Car?
//
//  Created by Michael Critz on 3/21/14.
//  Copyright (c) 2014 Map of the Unexplored. All rights reserved.
//

#import "CAR_ViewController.h"
#import "CAR_LocationController.h"

@interface CAR_ViewController ()
@property (nonatomic, strong)MKPointAnnotation *carAnnotation;
@property (nonatomic)CAR_LocationController *locationController;
@end

@implementation CAR_ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	self.locationController = [[CAR_LocationController alloc] init];
	[_locationController addObserver:self
						  forKeyPath:@"deviceLocation"
							 options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld)
							 context:nil];

	[_locationController addObserver:self
						  forKeyPath:@"beaconLocation"
							 options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld)
							 context:nil];
	[_locationController addObserver:self
						  forKeyPath:@"beaconStatus"
							 options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld)
							 context:nil];
	[self updateMap:YES];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
	NSLog(@"event");
	if ([keyPath isEqualToString:@"beaconLocation"]) {
		[self updateLastSeen];
	} else if ([keyPath isEqualToString:@"beaconStatus"]) {
		[self updateLastSeen];
		NSString *logMessage = [[NSString alloc] initWithFormat:@"beaconStatus: %lu", self.locationController.beaconStatus];
		NSLog(@"%@", logMessage);
		[self.statusLabel setText:logMessage];
	} else if (@"deviceLocation") {
		NSLog(@"beaconState: %lu\n", self.locationController.beaconStatus);
	}
}

- (MKPointAnnotation *)carAnnotation {
	if (!_carAnnotation) {
		_carAnnotation = [[MKPointAnnotation alloc] init];
	}
	if (CLLocationCoordinate2DIsValid(_locationController.beaconLocation.location.coordinate)) {
		[_carAnnotation setCoordinate:_locationController.beaconLocation.location.coordinate];
		[_carAnnotation setTitle:@"Your Car, Dude!"];
		[_carAnnotation setSubtitle:@"There it is!"];
	}
	return _carAnnotation;
}

- (void)updateLastSeen {
	NSLog(@"updateLastSeen");
	[self.statusLabel setText:@"updateLastSeen"];
	[self updateMap:NO];
}

- (IBAction)logButtonPressed:(id)sender {
	NSString *logMessage = @"logPressed";
	[self updateLastSeen];
	[self.statusLabel setText:logMessage];
	NSLog(@"%@", _locationController.beaconLocation.location);
}

- (IBAction)clearButtonPressed:(id)sender {
	[self clearAllMarkers];
}

- (void)updateMap:(BOOL)initial {
	if (initial) {
		[self.bigMap setRegion:MKCoordinateRegionMake(self.locationController.deviceLocation.coordinate, MKCoordinateSpanMake(.1, .1))
					  animated:YES];
	} else {
		[self.bigMap setCenterCoordinate:self.locationController.deviceLocation.coordinate];
		for (int i = 0; i < self.bigMap.annotations.count; i++) {
			MKPointAnnotation *annotation = [self.bigMap.annotations objectAtIndex:i];
			NSLog(@"annotation: %f", annotation.coordinate.latitude);
			[self.bigMap removeAnnotation:annotation];
			annotation = nil;
		}
		[self.bigMap addAnnotation:self.carAnnotation];
	}
}

- (void)clearAllMarkers {
	[self.bigMap removeAnnotations:self.bigMap.annotations];
	for (int i = 0; i < self.bigMap.annotations.count; i++) {
		MKPointAnnotation *annotation = [self.bigMap.annotations objectAtIndex:i];
		if (annotation) {
			annotation = nil;
		}
	}
}

@end
