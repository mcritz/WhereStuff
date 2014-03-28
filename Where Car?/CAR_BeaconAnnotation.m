//
//  CAR_BeaconAnnotation.m
//  Where Car?
//
//  Created by Michael Critz on 3/23/14.
//  Copyright (c) 2014 Map of the Unexplored. All rights reserved.
//

#import "CAR_BeaconAnnotation.h"

@implementation CAR_BeaconAnnotation

@synthesize location = _location;
@synthesize coordinate = _coordinate;
@synthesize title = _title;

- (CLLocation *)location {
    if (!_location) {
        _location = [[CLLocation alloc] init];
    }
    return _location;
}

- (CLLocationCoordinate2D)coordinate {
    return self.location.coordinate;
}

- (NSString *)title {
    if (!_title) {
        _title = @"My Car!";
    }
    return _title;
}

@end
