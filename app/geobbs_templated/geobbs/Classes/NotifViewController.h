//
//  RootViewController.h
//  geobbs
//
//  Created by sebcorbin on 29/09/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"
#import "CLController.h"
#import "Service.h"

@interface NotifViewController : UITableViewController <CLControllerDelegate> {
	NSArray *notifications;
	CLController *locationController;
}

@property (nonatomic, retain) NSArray *notifications;
@property (retain) CLController *locationController;

-(void) setNotifications:(NSArray*) array;

@end
