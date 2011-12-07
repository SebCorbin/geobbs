//
//  ARViewController.m
//  geobbs
//
//  Created by Francois-Guillaume Ribreau on 25/11/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "ARViewController.h"

@implementation ARViewController

@synthesize locationController;
@synthesize notifications;

- (void) arDidTapMarker:(ARMarker*)marker {
    
}


/** AR System Error Callback 
 sent to the delegate when an error occured
 this will most likely be caused by an error in the locationManager
 
 error types:
 kCLErrorLocationUnknown
 kCLErrorDenied
 kCLErrorNetwork
 */
- (void) arDidReceiveErrorCode:(int)code {
    
}


/** Info Update Callback
 sent to delegate when location or heading changes
 use this to change the output in the infoLabel or to perform other output functions
 */
- (void) arDidUpdateLocation {
    if (m_ARController.lastLocation == nil) {
        m_ARController.infoLabel.text = @"could not retrieve location";
        m_ARController.infoLabel.textColor = [UIColor redColor];
    }
    else {
        m_ARController.infoLabel.text = [NSString stringWithFormat:@"GPS signal quality: %f Meters", m_ARController.lastLocationQuality];
        m_ARController.infoLabel.textColor = [UIColor whiteColor];
    }
}

/** Device Orientation Changed Callback
 sent to delegate when arOrientation changed, use it to adjust AR views (like radar)
 */
- (void) arDidChangeOrientation:(UIDeviceOrientation)orientation radarOrientation:(UIDeviceOrientation)radarOrientation {
    if (!m_ARController.isVisible || (m_ARController.isVisible && !m_ARController.isModalView)) {
        if (radarOrientation == UIDeviceOrientationPortrait) [ARController setRadarPosition:0 y:-11];
        else if (radarOrientation == UIDeviceOrientationPortraitUpsideDown) [ARController setRadarPosition:0 y:11];
        else if (radarOrientation == UIDeviceOrientationFaceUp) [ARController setRadarPosition:0 y:-11];
        else if (radarOrientation == UIDeviceOrientationLandscapeLeft) [ARController setRadarPosition:-11 y:0];
        else if (radarOrientation == UIDeviceOrientationLandscapeRight) [ARController setRadarPosition:11 y:0];
    }
}

- (void)newLocation:(CLLocation *)location {
    NSArray *newNotifications = [[[Service getService] getNotificationsList:[User getCurrentUser] withLocation:location] autorelease];
    
    // Don't reload if newNotifications == notification
    if(![newNotifications isEqualToArray:notifications]){
        
        NSArray* diff = [self getDifferenceBetween:notifications andNew:newNotifications];
        
        
        // Update the UITableView
        [notifications release];
        notifications = [[NSArray alloc] initWithArray:newNotifications];
        [self createMarkers];
    }
}

// Get the difference between old & new data array
- (NSArray*)getDifferenceBetween:(NSArray*) oldData andNew:(NSArray*) newData{
    
    NSMutableSet *old = [NSMutableSet setWithArray:oldData];
    NSMutableSet *newSet = [NSMutableSet setWithArray:newData];
    
    [newSet minusSet:old];
    
    return [newSet allObjects];
}


/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
*/
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
        
    // Initialize location manager
    locationController = [[CLController alloc] init];
    locationController.delegate = self;
    [locationController.locationManager startUpdatingLocation];

    // create ARController and Markers
 	[self createAR];
    
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
    [ARController setAPIKey:@"6f81e2673e662416a72813ce"];
    NSLog(@"API Key is 6f81e2673e662416a72813ce");
	[ARController setEnableCameraView:YES];
	[ARController setEnableRadar:YES];
	[ARController setEnableInteraction:YES];
	[ARController setEnableLoadingView:NO]; // enable loading view, call has no effect on iOS 5 (not supported yet)
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
    // TODO : Flush all the old markers
    for (NSDictionary *item in notifications) {
        CLLocation* location = [[[CLLocation alloc] 
           initWithLatitude:[[(NSArray*)[item valueForKeyPath:@"loc"] objectAtIndex:0] floatValue] 
                                 longitude:[[(NSArray*)[item valueForKeyPath:@"loc"] objectAtIndex:1] floatValue]] autorelease];
        [m_ARController addMarkerAtLocation:[[ARMarker alloc] 
                                             initWithTitle:[item valueForKeyPath:@"User.login"] 
                                             contentOrNil:[item valueForKeyPath:@"description"]] 
                                 atLocation: location];
    }
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
    [self setView:m_ARController.view];
    // now tell the ARController to become visbiel in a non-modal way while keeping the status bar visible
    // NOTE: the camera feed will mess with the status bar's visibility while being loaded, so far there is no way to avoid that (iOS SDK weakness)
    [m_ARController showController:NO showStatusBar:YES];
    // when showing the ARView non-modal the viewport has to be set each time it becomes visible in order to avoid positioning and resizing problems
    [m_ARController setViewport:CGRectMake(0, 0, 320, 411)];
    
    NSLog(@"ARView selected in TabBar");
}


@end
