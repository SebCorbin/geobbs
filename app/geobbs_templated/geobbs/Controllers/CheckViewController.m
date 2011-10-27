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
@synthesize doneButton;


- (void)viewDidLoad {
    //[mapView setCenterCoordinate:[[mapView userLocation] coordinate] animated:TRUE];
    messageField.delegate = self;
    [doneButton initWithBarButtonSystemItem:UIBarButtonItemStyleDone target:self action:@selector(doneButtonClicked:)];
}

- (void)doneButtonClicked:(id)sender {
    Check *check = [[[Check alloc] init] autorelease];

    [check setDate:[NSDate date]];
    [check setLocation:[[mapView userLocation] location]];
    [check setUserId:@"fg"];
    NSLog(@"%@", [messageField text]);
    [check setDescription:[messageField text]];

    [Service postCheck:check];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    [self doneButtonClicked:NULL];
    return YES;
}

- (void)dealloc {
    [mapView release];
    [doneButton release];
    [messageField release];
    [super dealloc];
}
@end
