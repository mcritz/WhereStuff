//
//  CAR_MapAnnotation.m
//  Where Car?
//
//  Created by Michael Critz on 5/8/14.
//  Copyright (c) 2014 Map of the Unexplored. All rights reserved.
//

#import "CAR_MapAnnotation.h"

@interface CAR_MapAnnotation()

@property (nonatomic)MKAnnotationView *annotationView;

@end

@implementation CAR_MapAnnotation

@synthesize subtitle, title, coordinate;

- (MKAnnotationView *)annotationView {
	if (!_annotationView) {
		CGRect newFrame = CGRectMake(0., 0., 10., 10.);
		_annotationView = [[MKAnnotationView alloc] initWithFrame:newFrame];
		[_annotationView setBackgroundColor:[UIColor colorWithRed:230. green:115. blue:255 alpha:.7]];
	}
	return _annotationView;
}

@end
