//
//  geobbsAppDelegate.h
//  geobbs
//
//  Created by sebcorbin on 29/09/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NotifViewController.h"

@interface geobbsAppDelegate : NSObject <UIApplicationDelegate> {
    
    UIWindow *window;
    UITabBarController *tabBarController;
	NotifViewController *notifController;
}

@property (retain) IBOutlet UIWindow *window;
@property (retain) IBOutlet UITabBarController *tabBarController;
@property (retain) IBOutlet NotifViewController *notifController;

@end

