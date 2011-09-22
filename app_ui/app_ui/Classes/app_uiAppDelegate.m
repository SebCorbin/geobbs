//
//  app_uiAppDelegate.m
//  app_ui
//
//  Created by Francois-Guillaume Ribreau on 22/09/11.
//  Copyright __MyCompanyName__ 2011. All rights reserved.
//

#import "app_uiAppDelegate.h"
#import "app_uiViewController.h"

@implementation app_uiAppDelegate

@synthesize window;
@synthesize viewController;


- (void)applicationDidFinishLaunching:(UIApplication *)application {    
    
    // Override point for customization after app launch    
    [window addSubview:viewController.view];
    [window makeKeyAndVisible];
}


- (void)dealloc {
    [viewController release];
    [window release];
    [super dealloc];
}


@end
