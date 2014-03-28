//
//  CAR_ViewController.h
//  Where Car?
//
//  Created by Michael Critz on 3/21/14.
//  Copyright (c) 2014 Map of the Unexplored. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "CAR_BeaconController.h"
#import "CAR_BeaconAnnotation.h"

@protocol CAR_ViewController <NSObject>

- (void)addAnnotation:(CAR_BeaconAnnotation *)beaconAnnotation;

@end

@interface CAR_ViewController : UIViewController <MKMapViewDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *bigMap;
@property (nonatomic)CAR_BeaconController *beaconController;

@end
