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
						  forKeyPath:@"beaconStatus"
							 options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld)
							 context:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
	NSLog(@"event");
	if ([keyPath isEqualToString:@"beaconStatus"]) {
		[self.statusLabel setText:@"Beacon updated4"];
	}
}

- (MKPointAnnotation *)carAnnotation {
	_carAnnotation = [[MKPointAnnotation alloc] init];
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
	[_locationController updateBeaconLocation];
	for (MKPointAnnotation *annotation in self.bigMap.annotations) {
		[self.bigMap removeAnnotation:annotation];
	}
	[self.bigMap addAnnotation:self.carAnnotation];
}

- (IBAction)logButtonPressed:(id)sender {
	NSString *logMessage = @"updateLastSeen";
	[self updateLastSeen];
	[self.statusLabel setText:logMessage];
	NSLog(@"%@", _locationController.beaconLocation.location);
}

@end
