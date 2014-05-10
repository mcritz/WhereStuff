//
//  CAR_MapSettings.h
//  Where Car?
//
//  Created by Michael Critz on 5/9/14.
//  Copyright (c) 2014 Map of the Unexplored. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface CAR_MapSettings : NSObject

@property MKCoordinateRegion mapRegion;

- (MKCoordinateRegion)getRegionForLocation:(CLLocation *)location;

@end
   