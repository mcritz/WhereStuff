//
//  CAR_MapSettings.m
//  Where Car?
//
//  Created by Michael Critz on 5/9/14.
//  Copyright (c) 2014 Map of the Unexplored. All rights reserved.
//

#import "CAR_MapSettings.h"

@implementation CAR_MapSettings

- (MKCoordinateRegion)getRegionForLocation:(CLLocation *)location {
	return MKCoordinateRegionMake(location.coordinate, MKCoordinateSpanMake(.1, .1));
}

@end
