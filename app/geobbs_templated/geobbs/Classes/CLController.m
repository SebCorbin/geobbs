//
//  CLController.m
//  geobbs
//
//  Created by sebcorbin on 12/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CLController.h"
#import "Service.h"
#import "User.h"

@implementation CLController

@synthesize locationManager;

- (id) init {
    self = [super init];
    if (self != nil) {
        self.locationManager = [[[CLLocationManager alloc] init] autorelease];
        self.locationManager.delegate = self; // send loc updates to myself
    }
    return self;
}

- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
	// Get the notifiaction list
	[[Service getService] getNotificationsList:[User getCurrentUser] withLocation:newLocation];
}

- (void)locationManager:(CLLocationManager *)manager
	   didFailWithError:(NSError *)error
{
	NSLog(@"Error: %@", [error description]);
}

- (void)dealloc {
    [self.locationManager release];
    [super dealloc];
}

@end
