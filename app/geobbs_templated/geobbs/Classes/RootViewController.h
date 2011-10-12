//
//  RootViewController.h
//  geobbs
//
//  Created by sebcorbin on 29/09/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "SBJson/SBJson.h"
#import "User.h"

@interface RootViewController : UITableViewController {
	NSArray *notifications;
}

@property (nonatomic, retain) NSArray *notifications;

-(void) getNotifications:(User*) user;

@end
