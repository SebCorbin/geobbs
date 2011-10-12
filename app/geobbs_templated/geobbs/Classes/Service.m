//
//  Service.m
//  geobbs
//
//  Created by sebcorbin on 04/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Service.h"

@implementation Service

@synthesize serverUrl;
@synthesize serverPort;

+ (Service*)getService {
    if (serviceManager == nil) {
        serviceManager = [[super allocWithZone:NULL] init];
    }
    return serviceManager;
}
+ (NSString*)getServerUrl {
    return [NSString stringWithFormat:@"%@", [Service getService]];
}

+(NSArray*)getNotificationsList:(User*) user {
	NSURLRequest *query = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%a", 
																			 [[Service getService] serverUrl], @""]]
										   cachePolicy:NSURLRequestUseProtocolCachePolicy
									   timeoutInterval:60.0];
	NSURLResponse *response = nil;
	NSData *data = [NSURLConnection sendSynchronousRequest:query returningResponse:&response error:NULL];
	// Connection failed
	if (!response) {
		NSLog(@"La connection a échouée");
	}
	// Connection ok
	else {
		// HTTP Status code must be 200
		int statusCode = [(NSHTTPURLResponse*)response statusCode];
		if(statusCode == 404) {
			NSLog(@"404 Not Found: %@", query);
		}
		else if(statusCode == 200) {
			
		}
	}
	return nil;
}

@end
