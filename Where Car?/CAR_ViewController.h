//
//  CAR_ViewController.h
//  Where Car?
//
//  Created by Michael Critz on 3/21/14.
//  Copyright (c) 2014 Map of the Unexplored. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface CAR_ViewController : UIViewController <MKMapViewDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *bigMap;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
- (IBAction)logButtonPressed:(id)sender;
- (IBAction)clearButtonPressed:(id)sender;

@end
