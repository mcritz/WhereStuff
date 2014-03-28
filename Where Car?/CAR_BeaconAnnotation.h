//
//  CAR_BeaconAnnotation.h
//  Where Car?
//
//  Created by Michael Critz on 3/23/14.
//  Copyright (c) 2014 Map of the Unexplored. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface CAR_BeaconAnnotation : NSObject <MKAnnotation>

@property (nonatomic, strong)CLLocation *location;

@end
