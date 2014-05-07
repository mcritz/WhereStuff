//
//  CAR_LocationModel.m
//  Where Car?
//
//  Created by Michael Critz on 5/4/14.
//  Copyright (c) 2014 Map of the Unexplored. All rights reserved.
//

#import "CAR_LocationModel.h"

@implementation CAR_LocationModel

- (NSString *)description {
	if (!_description) {
		_description = NSLocalizedString(@"Your car, dude!", @"A reference to the goofy Ashton Kutcher movie 'Dude, Where's my Car' feel free to substitute it an expression an idiot would say when looking for something.");
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
