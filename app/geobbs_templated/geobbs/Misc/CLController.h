//
//  CLController.h
//  geobbs
//


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "Service.h"
#import "User.h"

@protocol CLControllerDelegate
@required
- (void)newLocation:(CLLocation *)location;
@end

@interface CLController : NSObject <CLLocationManagerDelegate> {
    CLLocationManager *locationManager;
    id delegate;
}

@property(nonatomic, retain) CLLocationManager *locationManager;
@property(nonatomic, assign) id delegate;

- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation;

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error;

@end

