//
//  geobbsAppDelegate.h
//  geobbs
//
//  Created by sebcorbin on 29/09/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class geobbsViewController;

@interface geobbsAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    geobbsViewController *viewController;
	UITableView *listController;
}

-(void)initializeList;

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet geobbsViewController *viewController;
@property (nonatomic, retain) IBOutlet UITableView *listController;

@end

