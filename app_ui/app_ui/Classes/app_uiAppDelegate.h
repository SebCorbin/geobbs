//
//  app_uiAppDelegate.h
//  app_ui
//
//  Created by Francois-Guillaume Ribreau on 22/09/11.
//  Copyright __MyCompanyName__ 2011. All rights reserved.
//

#import <UIKit/UIKit.h>

@class app_uiViewController;

@interface app_uiAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    app_uiViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet app_uiViewController *viewController;

@end

