//
//  Check.h
//  geobbs
//
//  Created by sebcorbin on 29/09/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>

@interface Check : NSObject {
    CLLocation *location;
    NSString *userId;
    NSDate *date;
    NSString *description;
}

@property(retain) CLLocation *location;
@property(retain) NSString *userId;
@property(retain) NSDate *date;
@property(retain) NSString *description;

@end
