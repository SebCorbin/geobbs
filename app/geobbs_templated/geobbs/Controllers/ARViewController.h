//
//  ARViewController.h
//  geobbs
//


#import <UIKit/UIKit.h>
#import <PanicARLib/PanicARLib.h>
#import "Service.h"
#import "CLController.h"
#import "Check.h"

@class ARController;


@interface ARViewController : UIViewController <ARControllerDelegate, CLControllerDelegate>{
    ARController* m_ARController; // the AR controller instance of the app 
    NSArray *notifications;
}

@property(retain) CLController *locationController;
@property(nonatomic, retain) NSArray *notifications;

- (void)newLocation:(CLLocation *)location;
- (NSArray*)getDifferenceBetween:(NSArray*) old andNew:(NSArray*)newData;

// AR functionality
- (void) createAR;
- (void) createMarkers;
- (void) showAR;
- (BOOL) checkForAR:(BOOL)showErrors;

@end