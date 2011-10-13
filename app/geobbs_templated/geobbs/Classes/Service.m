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

static Service *serviceManager = nil;

-(id)init {
	if (self = [super init]) {
		[self setServerUrl:@"http://localhost:3000"];
	}
	return self;
}

-(void)dealloc {
	[ super dealloc ];
}

/////////////////////
// Singleton methods
+ (Service*)getService {
    if (serviceManager == nil) {
        serviceManager = [[super allocWithZone:NULL] init];
    }
    return serviceManager;
}
+ (id)allocWithZone:(NSZone *)zone {
    return [[self getService] retain];
}

- (id)copyWithZone:(NSZone *)zone {
    return self;
}

- (id)retain {
    return self;
}

- (NSUInteger)retainCount {
    return NSUIntegerMax;  //denotes an object that cannot be released
}

- (void)release {
    //do nothing
}

- (id)autorelease {
    return self;
}

-(NSArray*)getNotificationsList:(User*)user withLocation:(CLLocation*)location {
	NSString *stringUrl = [NSString stringWithFormat:@"%@/check/?lat=%+.6f&lon=%+.6f", [[Service getService] serverUrl], location.coordinate.latitude, location.coordinate.longitude];
	
	NSURLRequest *query = [NSURLRequest requestWithURL:[NSURL URLWithString:stringUrl]
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
			NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
			NSDictionary *json = [jsonString JSONValue];
			NSArray *notifs = [json objectForKey:@"msg"];
			return notifs;
		}
	}
	return nil;
}

@end
