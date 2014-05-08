//
//  CAR_ViewController.m
//  Where Car?
//
//  Created by Michael Critz on 3/21/14.
//  Copyright (c) 2014 Map of the Unexplored. All rights reserved.
//

#import "CAR_ViewController.h"
#import "CAR_LocationController.h"
#import "CAR_MapAnnotation.h"

@interface CAR_ViewController ()
@property (nonatomic, strong)CAR_MapAnnotation *carAnnotation;
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
	if ([keyPath isEqualToString:@"beaconLocation"]) {
		[self updateLastSeen];
	} else if ([keyPath isEqualToString:@"beaconStatus"]) {
		[self updateLastSeen];
		NSString *logMessage = [[NSString alloc] initWithFormat:@"beaconStatus: %lu", self.locationController.beaconStatus];
//		NSLog(@"%@", logMessage);
		[self.statusLabel setText:logMessage];
//	} else if (@"deviceLocation") {
	}
}

- (CAR_MapAnnotation *)carAnnotation {
	if (!_carAnnotation) {
		_carAnnotation = [[CAR_MapAnnotation alloc] init];
	}
	if (CLLocationCoordinate2DIsValid(_locationController.deviceLocation.coordinate)) {
		[_carAnnotation setCoordinate:_locationController.deviceLocation.coordinate];
		[_carAnnotation setTitle:@"Your Car, Dude!"];
		[_carAnnotation setSubTitle:@"There it is!"];
	}
	return _carAnnotation;
}

- (void)updateLastSeen {
	[self.statusLabel setText:@"updateLastSeen"];
	[self updateMap:NO];
}

- (IBAction)logButtonPressed:(id)sender {
	NSString *logMessage = @"logPressed";
	[self updateLastSeen];
	[self.statusLabel setText:logMessage];
}

- (IBAction)clearButtonPressed:(id)sender {
	[self clearAllMarkers];
}

- (void)updateMap:(BOOL)initial {
	if (initial) {
		[self.bigMap setCenterCoordinate:self.locationController.deviceLocation.coordinate];
		[self.bigMap setRegion:MKCoordinateRegionMake(self.locationController.deviceLocation.coordinate, MKCoordinateSpanMake(.1, .1))
					  animated:YES];
	} else {
		if (![self.bigMap.annotations containsObject:self.carAnnotation]) {
			[self.bigMap addAnnotation:self.carAnnotation];
		}
		[self.carAnnotation setCoordinate:self.locationController.deviceLocation.coordinate];
	}
}

- (void)clearAllMarkers {
	[self.bigMap removeAnnotations:self.bigMap.annotations];
	for (int i = 0; i < self.bigMap.annotations.count; i++) {
		MKAnnotationView *annotation = [self.bigMap.annotations objectAtIndex:i];
		if (annotation) {
			annotation = nil;
		}
	}
}

@end
