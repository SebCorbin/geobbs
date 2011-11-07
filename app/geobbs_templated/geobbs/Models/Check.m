//
//  Check.m
//  geobbs
//
//  Created by sebcorbin on 29/09/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Check.h"


@implementation Check

@synthesize location;
@synthesize userId;
@synthesize date;
@synthesize description;

- (id)initWithLocation: (CLLocation*)_location userId:(NSString*)_userId description:(NSString*)_description{
	
    if (self = [super init])
    {
        [self setLocation:_location];
        [self setUserId:_userId];
        [self setDescription:_description];
    }
    return self;
}


- (void)dealloc {
    [super dealloc];
}
@end
