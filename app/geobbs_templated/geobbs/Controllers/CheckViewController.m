//
//  CheckViewController.m
//  geobbs
//
//  Created by sebcorbin on 20/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <MapKit/MapKit.h>
#import <UIKit/UIKit.h>
#import "CheckViewController.h"
#import "Check.h"
#import "Service.h"


@implementation CheckViewController

@synthesize mapView;
@synthesize messageField;


- (void)viewDidLoad {
    //[mapView setCenterCoordinate:[[mapView userLocation] coordinate] animated:TRUE];
    
    // Add the CheckViewController controller as a delegate for the textfield
    messageField.delegate = self;
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
    [super dealloc];
}
@end
