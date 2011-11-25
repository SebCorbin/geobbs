//
//  ARViewController.m
//  geobbs
//
//  Created by Francois-Guillaume Ribreau on 25/11/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "ARViewController.h"

@implementation ARViewController

@synthesize view;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}
*/

- (void)viewWillAppear:(BOOL)animated{
    NSLog(@"Vue active !");
}

- (void)viewWillDisappear:(BOOL)animated{
     NSLog(@"Vue willdisappear !");
}

- (void)viewDidLoad{
    NSLog(@"Vue didload !");
    
    // create ARController and Markers
 	[self createAR];
	[self createMarkers];
    
    // check if AR is available and if so show the controller in first view of TabBarController
    if ([self checkForAR:YES]) [self showAR];
    
}
- (void)viewDidUnload
{
     NSLog(@"Vue didunload !");
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

// standard dealloc of the delegate
- (void)dealloc {
	if (m_ARController != nil) [m_ARController release];
	[super dealloc];
}

// check if AR is available, show error if it's not and set bar item
- (BOOL) checkForAR:(BOOL)showErrors {
    BOOL supportsAR = [ARController deviceSupportsAR];
    BOOL supportsLocations = [ARController locationServicesAvailable];
    BOOL result = supportsLocations && supportsAR;
    
    if (!result) {
        //[tabBarController setSelectedIndex:1];
        // Changer de tab
    }
    
    if (showErrors) {
        if (!supportsAR) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"AR not supported"
                                                            message:@"This device does not support AR functionality"
                                                           delegate:self 
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil, nil];
            [alert show];
            [alert release];
        }
        
        if (!supportsLocations) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:@"GPS not available"
                                                           delegate:self 
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil, nil];
            [alert show];
            [alert release];
        }
    }
    
    return result;
}

// create the ARController
- (void) createAR {
	//setup ARController properties
    [ARController setAPIKey:@"none"];
	[ARController setEnableCameraView:YES];
	[ARController setEnableRadar:YES];
	[ARController setEnableInteraction:YES];
	[ARController setEnableLoadingView:YES]; // enable loading view, call has no effect on iOS 5 (not supported yet)
	[ARController setEnableAccelerometer:YES];
	[ARController setEnableAutoswitchToRadar:YES];
	[ARController setEnableViewOrientationUpdate:YES];
	[ARController setFadeInAnim:UIViewAnimationTransitionCurlDown];
	[ARController setFadeOutAnim:UIViewAnimationTransitionCurlUp];
	[ARController setCameraTint:0 g:0 b:0 a:0];
	[ARController setCameraTransform:1.25 y:1.25];
    [ARController setRange:5 Maximum:-1];
    [ARController setRadarPosition:0 y:-24];
    
	
	//create ARController
	m_ARController = [[ARController alloc] initWithNibName:@"ARController" bundle:nil delegate:self];
	
	//[[tabBarController.viewControllers objectAtIndex:0] setView:nil];
	
#if (TARGET_IPHONE_SIMULATOR)
	// returns nil if AR not available on device
	if (m_ARController) {
		// simulator testing coordinates
		m_ARController.lastLocation = [[CLLocation alloc] initWithLatitude:49.009860 longitude:12.108049];
	}
#endif
}

// create a few test markers
- (void) createMarkers {
    // first: setup a new marker with title and content
    ARMarker* newMarker = [[ARMarker alloc] initWithTitle:@"Rome" contentOrNil:@"Italy"];
    
    // second: add the marker to the ARController using the addMarkerAtLocation method
    // pass the geolocation (latitude, longitude) that specifies where the marker should be located
    // WARNING: use double-precision coordinates whenever possible (the following coordinates are from Google Maps which only provides 8-9 digit coordinates
	[m_ARController addMarkerAtLocation: newMarker atLocation:[[[CLLocation alloc] initWithLatitude:41.890156 longitude:12.492304] autorelease]];
    
    
    // add a second marker
    newMarker = [[ARMarker alloc] initWithTitle:@"Berlin" contentOrNil:@"Germany"];
    [m_ARController addMarkerAtLocation:newMarker atLocation:[[[CLLocation alloc] initWithLatitude:52.523402 longitude:13.41141] autorelease]];
    
    // add a third marker, this time allocation of a new marker and adding to the ARController are wrapped up in one line
	[m_ARController addMarkerAtLocation:[[ARMarker alloc] initWithTitle:@"London" contentOrNil:@"United Kingdom"] atLocation:[[[CLLocation alloc] initWithLatitude:51.500141 longitude:-0.126257] autorelease]];
    

}


// display the ARView in the tab bar (non-modal)
- (void) showAR {
    // on DEVICE: show error if device does not support AR functionality
    // AR is not supported if either camera or compass is not available
    
    
#if !(TARGET_IPHONE_SIMULATOR)
    if (![ARController deviceSupportsAR]) {
        UIAlertView *alert = [[UIAlertView alloc] 
                              initWithTitle:NSLocalizedString(@"No AR Error Title", @"No AR Support")
                              message:NSLocalizedString(@"No AR Error Message", @"This device does not support AR functionality!") 
                              delegate:nil 
                              cancelButtonTitle:NSLocalizedString(@"OK Button", @"OK") 
                              otherButtonTitles:nil];
        [alert show];
        return;
    }
#endif
    
    // check if ARController instance is valid
    if (m_ARController == nil) {
        NSLog(@"No ARController available!");
        return;
    }
    
    // show AR Controller in tab bar by assigning the ARView to the first view controller of the tab bar
    //[[tabBarController.viewControllers objectAtIndex:0] setView:m_ARController.view];
    // now tell the ARController to become visbiel in a non-modal way while keeping the status bar visible
    // NOTE: the camera feed will mess with the status bar's visibility while being loaded, so far there is no way to avoid that (iOS SDK weakness)
    [m_ARController showController:NO showStatusBar:YES];
    // when showing the ARView non-modal the viewport has to be set each time it becomes visible in order to avoid positioning and resizing problems
    [m_ARController setViewport:CGRectMake(0, 0, 320, 411)];
    
    NSLog(@"ARView selected in TabBar");
}


@end
