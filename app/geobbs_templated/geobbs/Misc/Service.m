//
//  Service.m
//  geobbs
//

#import <CoreLocation/CoreLocation.h>
#import "Service.h"

@implementation Service

@synthesize apis;
@synthesize port;
@synthesize ip;
@synthesize userId;

static Service *serviceManager = nil;


- (id)init {
    if (self = [super init]) {
        
        // Setup
        self.ip = @"192.168.0.11";
        self.port = @"3000";
        
        
        self.userId = @"4e7f08f0bd99e46165000001";
        
        
        // API
        self.apis = [NSDictionary dictionaryWithObjectsAndKeys:
                @"/check/create/", @"checkCreate",
                @"/check/list/", @"checkList",
                nil];
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

  // Return the API endpoint
- (NSString*)endpoint {
    return [NSString stringWithFormat:@"http://%@:%@", self.ip, self.port];
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

/*- (void)release {
    //do nothing
}*/

- (id)autorelease {
    return self;
}


+ (void)postCheck:(Check *)check {

  Service* s = [Service getService];

  NSString *stringUrl = [NSString stringWithFormat:@"%@%@?userId=%@&lat=%+.6f&lon=%+.6f&description=%@"
                        , s.endpoint
                        , [s.apis objectForKey:@"checkCreate"]
                        , check.userId
                        , check.location.coordinate.latitude
                        , check.location.coordinate.longitude
                        , [check.description stringByAddingPercentEscapesUsingEncoding:
                               NSASCIIStringEncoding]];

  NSLog(@"%@", stringUrl);
}

- (NSString *)getApiUrlForCheckList:(CLLocation *)location withUser:(User *)User {
  Service* s = [Service getService];
  
  return [NSString stringWithFormat:@"%@%@?userId=%@&lat=%+.6f&lon=%+.6f"
          , s.endpoint
          , [s.apis objectForKey:@"checkList"]
          , s.userId
          , location.coordinate.latitude
          , location.coordinate.longitude];
}

// Get the page within a string content
- (NSString *)doHttpRequest:(NSString *)url {

    NSURLRequest *query = [NSURLRequest requestWithURL:[NSURL URLWithString:url]
                                    	cachePolicy:NSURLRequestUseProtocolCachePolicy
                                        timeoutInterval:60.0];

    NSLog(@"Req: %@", url);

    NSURLResponse *response = nil;
    NSData *data = [NSURLConnection sendSynchronousRequest:query returningResponse:&response error:NULL];

    // Connection failed
    if (!response) {
        NSLog(@"Req: Failed");
        return [[NSString alloc] initWithString:@""];
    }

    int statusCode = [(NSHTTPURLResponse *) response statusCode];

    // If other than 200 HTPP Status code
    if (statusCode != 200) {
        NSLog(@"Req: Error %d %@", statusCode, query);
        return [[NSString alloc] initWithString:@""];
    }

    // Convert NSData to NSString
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];

}

// getNotificationsList should return an array
- (NSArray *)getNotificationsList:(User *)user withLocation:(CLLocation *)location {

    // Make request url
    NSString *requestUrl = [self getApiUrlForCheckList:location withUser:user];

    // Do http request
    NSString *pageContent = [self doHttpRequest:requestUrl];


    // Make a JSON object out of the string and create an array from it
    return [[NSArray alloc] initWithArray:[[pageContent JSONValue] objectForKey:@"msg"]];
}

@end
