//
//  Service.m
//  geobbs
//
//  Created by sebcorbin on 04/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import "Service.h"

@implementation Service

@synthesize apis;
@synthesize userId;

static Service *serviceManager = nil;

- (id)init {
    if (self = [super init]) {
        //[self setServerUrl:@"http://localhost:3000"];
        self.userId = @"4e7f08f0bd99e46165000001";

        self.apis = [NSDictionary dictionaryWithObjectsAndKeys:
                @"http://localhost:3000/check/create/", @"checkCreate",
                @"http://localhost:3000/check/list/", @"checkList",
                nil];
    }
    return self;
}

- (void)dealloc {
    [super dealloc];
}

/////////////////////
// Singleton methods
+ (Service *)getService {
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

+ (void)postCheck:(Check *)check {
    NSString *stringUrl = [NSString stringWithFormat:@"%@?userId=%@&lat=%+.6f&lon=%+.6f&description=%@",
                                                     [[[Service getService] apis] objectForKey:@"checkCreate"],
                                                     check.userId,
                                                     check.location.coordinate.latitude,
                                                     check.location.coordinate.longitude,
                                                     [check.description stringByAddingPercentEscapesUsingEncoding:
                                                             NSASCIIStringEncoding]];
    NSLog(@"%@", stringUrl);
}

// getNotificationsList should return an array
- (NSArray *)getNotificationsList:(User *)user withLocation:(CLLocation *)location {

    NSString *stringUrl = [NSString stringWithFormat:@"%@?userId=%@&lat=%+.6f&lon=%+.6f",
                                                     [[[Service getService] apis] objectForKey:@"checkList"],
                                                     [[Service getService] userId],
                                                     location.coordinate.latitude,
                                                     location.coordinate.longitude];

    NSLog(@"Loading %@", stringUrl);

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
        int statusCode = [(NSHTTPURLResponse *) response statusCode];
        if (statusCode == 404) {
            NSLog(@"404 Not Found: %@", query);
        }
        else if (statusCode == 200) {
            // Passage de NSData en NSString
            NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            // Récupération du JSON
            NSDictionary *json = [jsonString JSONValue];
            NSArray *notifs = [[NSArray alloc] initWithArray:[json objectForKey:@"msg"]];
            return notifs;
        }
    }

    return [[NSArray alloc] init];
}

@end
