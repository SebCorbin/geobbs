//
//  CheckViewController.m
//  geobbs
//  ViewController for adding check-in
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
    // TODO: userId should be the currentUserId
    [Service postCheck:[[[Check alloc]
            initWithLocation:[[mapView userLocation] location]
            userId:@"4e7f08f0bd99e46165000001"
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
