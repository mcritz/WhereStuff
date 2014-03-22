//
//  CAR_ViewController.h
//  Where Car?
//
//  Created by Michael Critz on 3/21/14.
//  Copyright (c) 2014 Map of the Unexplored. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@interface CAR_ViewController : UIViewController <CLLocationManagerDelegate, MKMapViewDelegate>

// CL
@property (strong, nonatomic) CLBeaconRegion *beaconRegion;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (weak, nonatomic) IBOutlet MKMapView *bigMap;

@end
