//
//  geobbsAppDelegate.h
//  geobbs
//

#import <UIKit/UIKit.h>
#import <PanicARLib/PanicARLib.h>
#import "NotifViewController.h"
#import "ARViewController.h"


@interface geobbsAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    UITabBarController *tabBarController;
    NotifViewController *notifController;
    ARViewController *arViewController;
}

@property(retain) IBOutlet UIWindow *window;
@property(retain) IBOutlet UITabBarController *tabBarController;
@property(retain) IBOutlet NotifViewController *notifController;
@property(retain) IBOutlet ARViewController *arViewController;

@end

