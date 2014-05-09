//
//  CAR_MapAnnotation.h
//  Where Car?
//
//  Created by Michael Critz on 5/8/14.
//  Copyright (c) 2014 Map of the Unexplored. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface CAR_MapAnnotation : NSObject <MKAnnotation>

@property (nonatomic, copy)NSString *title;
@property (nonatomic, copy)NSString *subTitle;
@property (nonatomic)CLLocationCoordinate2D coordinate;

@end
