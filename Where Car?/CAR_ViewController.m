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
#import "CAR_MapSettings.h"

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
	}
}

- (CAR_MapAnnotation *)carAnnotation {
	_carAnnotation = nil;
	_carAnnotation = [[CAR_MapAnnotation alloc] init];
	if (CLLocationCoordinate2DIsValid(_locationController.beaconLocation.location.coordinate)) {
		[_carAnnotation setCoordinate:_locationController.beaconLocation.location.coordinate];
		[_carAnnotation setTitle:@"Your Car, Dude!"];
		[_carAnnotation setSubTitle:@"There it is!"];
	}
	return _carAnnotation;
}

- (void)updateLastSeen {
	if (self.locationController.beaconStatus != kBeaconUnknown) {
		NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
		[dateFormatter setDateStyle:NSDateFormatterShortStyle];
		[dateFormatter setTimeStyle:NSDateFormatterMediumStyle];
		NSString *logMessage = NSLocalizedString(@"Beacon not found", @"Shown to user when there are no tracked objects displayed on map");
		if (self.locationController.beaconLocation.lastSeen) {
			if (self.locationController.beaconStatus == kBeaconImmediate
				|| self.locationController.beaconStatus == kBeaconNear) {
				logMessage = NSLocalizedString(@"Beacon nearby", @"Message to user that their tracked object is within about 3 meters");
			} else {
				logMessage = NSLocalizedString(@"Last seen: ", @"Shown to user to indicate the last time an object was tracked. ex: `Last seen: 5/18/2014 8:30AM`");
				logMessage = [logMessage stringByAppendingString:[dateFormatter stringFromDate:self.locationController.beaconLocation.lastSeen]];
			}
		}
		[self.statusLabel setText:logMessage];
	}
	[self updateMap:NO];
}

- (void)updateMap:(BOOL)initial {
	if (initial) {
		CAR_MapSettings *mapSettings = [[CAR_MapSettings alloc] init];
		[self.bigMap setRegion:[mapSettings getRegionForLocation:self.locationController.locationManager.location]
					  animated:YES];
	} else if ([self.locationController shouldDrawPin]) {
		if (self.bigMap.annotations.count > 1) {
			return;
		} else {
			[self.bigMap addAnnotation:self.carAnnotation];
		}
	} else {
		[self clearAllMarkers];
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
