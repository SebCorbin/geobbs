//
//  RootViewController.h
//  geobbs
//
//  Created by sebcorbin on 29/09/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SBJson/SBJson.h"
#import "User.h"
#import "CLController.h"

@interface RootViewController : UITableViewController {
	NSArray *notifications;
	CLController *locationController;
}

@property (nonatomic, retain) NSArray *notifications;
@property (retain) CLController *locationController;

-(void) getNotifications:(User*) user;

@end
