//
//  CAR_LocationModel.h
//  Where Car?
//
//  Created by Michael Critz on 5/4/14.
//  Copyright (c) 2014 Map of the Unexplored. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@class CAR_LocationModel;

@interface CAR_LocationModel : NSObject

@property (nonatomic)NSString *description;
@property (nonatomic)NSString *additionalInformation;
@property (nonatomic)CLLocation *location;
@property (nonatomic)NSDate *lastSeen;

- (void)save;

@end
