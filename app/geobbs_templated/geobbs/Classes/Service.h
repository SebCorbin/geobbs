//
//  Service.h
//  geobbs
//
//  Created by sebcorbin on 04/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "User.h"
#import <CoreLocation/CoreLocation.h>

@interface Service : NSObject {
	NSString* serverUrl;
}

@property (nonatomic, retain) NSString* serverUrl;

+ (Service*)getService;
- (NSArray*)getNotificationsList:(User*)user withLocation:(CLLocation*)location;

@end
