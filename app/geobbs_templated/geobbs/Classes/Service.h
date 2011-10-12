//
//  Service.h
//  geobbs
//
//  Created by sebcorbin on 04/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "User.h"


@interface Service : NSObject {
	NSString* serverUrl;
	NSString* serverPort;
}

static Service* serviceManager;
@property (nonatomic, retain) NSString* serverUrl;
@property (nonatomic, retain) NSString* serverPort;

+ (Service*)getService;
+ (NSString*)getServerUrl;
+ (NSArray*)getNotificationsList: (User*) user;

@end
