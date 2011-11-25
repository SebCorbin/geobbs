//
//  RootViewController.h
//  geobbs
//

#import <UIKit/UIKit.h>
#import "User.h"
#import "CLController.h"
#import "Service.h"

@interface NotifViewController : UITableViewController <CLControllerDelegate> {
    NSArray *notifications;
}

@property(nonatomic, retain) NSArray *notifications;
@property(retain) CLController *locationController;

- (void)newLocation:(CLLocation *)location;
- (NSArray*)getDifferenceBetween:(NSArray*) old andNew:(NSArray*) new;

@end
