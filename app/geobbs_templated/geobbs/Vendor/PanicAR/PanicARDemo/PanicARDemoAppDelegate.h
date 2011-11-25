//
//  PanicARDemoAppDelegate.h
//  PanicAR Demo
//
//  Created by Andreas Zeitler on 9/1/11.
//  Copyright doPanic 2011. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <PanicARLib/PanicARLib.h>

@class ARController;

// include the ARControllerDelegate Protocol to receive events from the ARController
@interface PanicARDemoAppDelegate : NSObject <UIApplicationDelegate, ARControllerDelegate, UITabBarControllerDelegate> {
    UIWindow *window;
    UITabBarController *tabBarController;
    UITabBarItem *arBarItem;
    BOOL arIsVisible;
    
	ARController* m_ARController; // the AR controller instance of the app
}

// a standard UI definitions
@property (nonatomic, retain) IBOutlet UIWindow* window;
@property (nonatomic, retain) IBOutlet UITabBarController* tabBarController;
@property (nonatomic, retain) IBOutlet UITabBarItem *arBarItem;

// AR functionality
- (void) createAR;
- (void) createMarkers;
- (void) showAR;
- (BOOL) checkForAR:(BOOL)showErrors;

// additional UI functionality (not AR-relevant)
- (IBAction)webButton_click;

@end
