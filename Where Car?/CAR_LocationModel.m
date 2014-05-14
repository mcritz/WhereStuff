//
//  CAR_LocationModel.m
//  Where Car?
//
//  Created by Michael Critz on 5/4/14.
//  Copyright (c) 2014 Map of the Unexplored. All rights reserved.
//

#import "CAR_LocationModel.h"

@implementation CAR_LocationModel
@synthesize location = _location;
@synthesize lastSeen = _lastSeen;
@synthesize description = _description;

- (CLLocation *)location {
	if (!_location) {
		NSUserDefaults *standardDefaults = [NSUserDefaults standardUserDefaults];
		if (![standardDefaults valueForKey:@"latitude"]) {
			return [[CLLocation alloc] init];
		} else {
			double lat = [standardDefaults doubleForKey:@"latitude"];
			double lon = [standardDefaults doubleForKey:@"longitude"];
			CLLocation *storedLocation = [[CLLocation alloc] initWithLatitude:lat longitude:lon];
			if (CLLocationCoordinate2DIsValid(storedLocation.coordinate)) {
				_location = storedLocation;
			}
		}
	}
	return _location;
}

- (void)setLocation:(CLLocation *)location {
	if (CLLocationCoordinate2DIsValid(location.coordinate)) {
		_location = location;
	}
}

- (void)save {
	NSUserDefaults *stardardDefaults = [NSUserDefaults standardUserDefaults];
	[stardardDefaults setDouble:self.location.coordinate.latitude
						 forKey:@"latitude"];
	[stardardDefaults setDouble:self.location.coordinate.longitude
						 forKey:@"longitude"];
	[stardardDefaults setObject:self.description
						 forKey:@"description"];
	[stardardDefaults setObject:self.additionalInformation
						 forKey:@"additionalInformation"];

}

- (NSDate *)lastSeen {
	if (!_lastSeen) {
		NSUserDefaults *standardDefaults = [NSUserDefaults standardUserDefaults];
		if (![standardDefaults valueForKey:@"lastSeen"]) {
			return [[NSDate alloc] init];
		} else {
			id storedLastSeen = [standardDefaults objectForKey:@"lastSeen"];
			NSLog(@"%@", storedLastSeen);
			if ([storedLastSeen isKindOfClass:[NSDate class]]) {
				_lastSeen = storedLastSeen;
			}
		}
	}
	return _lastSeen;
}

- (void)setLastSeen:(NSDate *)lastSeen {
	if ([lastSeen isKindOfClass:[NSDate class]]) {
		_lastSeen = lastSeen;
		[[NSUserDefaults standardUserDefaults] setObject:lastSeen forKey:@"lastSeen"];
	}
}

- (NSString *)description {
	if (!_description) {
		NSString *storedDesc = [[NSUserDefaults standardUserDefaults] stringForKey:@"description"];
		if (storedDesc) {
			_description = storedDesc;
		} else {
			_description = NSLocalizedString(@"No description", @"Shown to users if their object has no description");
		}
	}
	return _description;
}

- (NSString *)additionalInformation {
	if (_additionalInformation) {
		_additionalInformation = NSLocalizedString(@"There it is!", @"Additional information for a location. Shown to users on a 'map pin' where their tracked object is");
	}
	return _additionalInformation;
}

@end
