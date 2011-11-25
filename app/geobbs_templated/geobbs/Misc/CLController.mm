//
//  CLController.m
//  geobbs


#import "CLController.h"
#import "geobbsAppDelegate.h"

@implementation CLController

@synthesize locationManager;
@synthesize delegate;

- (id)init {
    self = [super init];
    if (self != nil) {
        self.locationManager = [[[CLLocationManager alloc] init] autorelease];
        self.locationManager.delegate = self; // send loc updates to myself
    }
    return self;
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    // Notify the new location
    [self.delegate newLocation:newLocation];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"Error: %@", [error description]);
}

- (void)dealloc {
    [self.locationManager release];
    [super dealloc];
}

@end
