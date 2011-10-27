//
//  CheckViewController.h
//  geobbs
//
//  Created by sebcorbin on 20/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface CheckViewController : UIViewController <UITextFieldDelegate> {
    IBOutlet MKMapView *mapView;
    IBOutlet UIBarButtonItem *doneButton;
    IBOutlet UITextField *messageField;
}

@property(nonatomic, retain) IBOutlet MKMapView *mapView;
@property(nonatomic, retain) IBOutlet UIBarButtonItem *doneButton;
@property(nonatomic, retain) IBOutlet UITextField *messageField;


- (void)doneButtonClicked:(id)sender;
@end
