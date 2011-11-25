//
//  geobbsAppDelegate.h
//  geobbs
//

#import <UIKit/UIKit.h>
#import "NotifViewController.h"

@interface geobbsAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    UITabBarController *tabBarController;
    NotifViewController *notifController;
}

@property(retain) IBOutlet UIWindow *window;
@property(retain) IBOutlet UITabBarController *tabBarController;
@property(retain) IBOutlet NotifViewController *notifController;

@end

