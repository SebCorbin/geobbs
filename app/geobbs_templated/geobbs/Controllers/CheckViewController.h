//
//  CheckViewController.h
//  geobbs


#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "CLController.h"

@interface CheckViewController : UIViewController <UITextFieldDelegate, CLControllerDelegate> {
    IBOutlet MKMapView *mapView;
    IBOutlet UITextField *messageField;
}

@property(nonatomic, retain) IBOutlet MKMapView *mapView;
@property(nonatomic, retain) IBOutlet UITextField *messageField;
@property(retain) CLController *locationController;

- (void)postCheck;

@end
