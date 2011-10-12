//
//  geobbsAppDelegate.h
//  geobbs
//
//  Created by sebcorbin on 29/09/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface geobbsAppDelegate : NSObject <UIApplicationDelegate> {
    
    UIWindow *window;
    UINavigationController *navigationController;
}

@property (retain) IBOutlet UIWindow *window;
@property (retain) IBOutlet UINavigationController *navigationController;

@end

