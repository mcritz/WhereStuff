//
//  CAR_ViewController.m
//  Where Car?
//
//  Created by Michael Critz on 3/21/14.
//  Copyright (c) 2014 Map of the Unexplored. All rights reserved.
//

#import "CAR_ViewController.h"
#import "CAR_BeaconController.h"
#import "CAR_BeaconAnnotation.h"

@interface CAR_ViewController ()

@end

@implementation CAR_ViewController

@synthesize beaconController = _beaconController;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self listenForBeacons];
    [self.bigMap setDelegate:self];
}

- (CAR_BeaconController *)beaconController {
    if (!_beaconController) {
        _beaconController = [[CAR_BeaconController alloc] init];
    }
    return _beaconController;
}

- (void)listenForBeacons {
    [self.beaconController addObserver:self
                            forKeyPath:@"deviceLocation"
                               options:NSKeyValueObservingOptionNew
                               context:NULL];
//    [self.beaconController addObserver:self
//                            forKeyPath:@"deviceLocation"
//                               options:NSKeyValueObservingOptionNew
//                               context:NULL];
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    if ([keyPath isEqualToString:@"beaconLocation"]) {
        NSLog(@"what what!??");
    }
    return;
}

- (void)handleAnnotationNotice {
    CAR_BeaconAnnotation *newBeaconAnnotation = [[CAR_BeaconAnnotation alloc] init];
    [newBeaconAnnotation setLocation:self.beaconController.deviceLocation];
    [self addAnnotation:newBeaconAnnotation];
}

- (void)addAnnotation:(CAR_BeaconAnnotation *)beaconAnnotation {
    [self.bigMap addAnnotation:beaconAnnotation];
}

@end
