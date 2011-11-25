//
//  ARViewController.h
//  geobbs
//


#import <UIKit/UIKit.h>
#import <PanicARLib/PanicARLib.h>

@class ARController;


@interface ARViewController : UIViewController <ARControllerDelegate>{
    ARController* m_ARController; // the AR controller instance of the app 
    UIView* view;
}

@property (nonatomic, retain) IBOutlet UIView* view;


// AR functionality
- (void) createAR;
- (void) createMarkers;
- (void) showAR;
- (BOOL) checkForAR:(BOOL)showErrors;

@end