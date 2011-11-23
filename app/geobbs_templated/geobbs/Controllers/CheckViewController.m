//
//  CheckViewController.m
//  geobbs
//
//  Created by sebcorbin on 20/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <MapKit/MapKit.h>
#import "CheckViewController.h"


@implementation CheckViewController

@synthesize messageField;
@synthesize locationController;
@synthesize mapView;


- (void)viewDidLoad {
    // Initialize location manager
    locationController = [[CLController alloc] init];
    locationController.delegate = self;
    [locationController.locationManager startUpdatingLocation];

    messageField.delegate = self;
}

- (void)newLocation:(CLLocation *)location {
    // On fait déplacer la carte vers la nouvelle position courante de l'utilisateur
    MKCoordinateRegion region;
    region.center = location.coordinate;
    // Le span est le niveau de zoom
    MKCoordinateSpan span;
    span.latitudeDelta = .005;
    span.longitudeDelta = .005;
    region.span = span;
    // Application des nouvelles coordonnées
    [mapView setRegion:region animated:TRUE];
}

- (void)postCheck {
    NSLog(@"%@", [messageField text]);

    // Create a check and post it
    [Service postCheck:[[[Check alloc]
            initWithLocation:[[mapView userLocation] location]
                      userId:@"fg"
                 description:[messageField text]
    ] autorelease]];
}

// When a user click on the keyboard "Add" button
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];

    [self postCheck];

    // TODO switch to NotifViewController

    return YES;
}

- (void)dealloc {
    [mapView release];
    [messageField release];
    [locationController release];
    [super dealloc];
}
@end
