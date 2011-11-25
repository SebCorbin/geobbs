//
//  Service.h
//  geobbs
//
//  Created by sebcorbin on 04/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "User.h"
#import "Check.h"
#import <CoreLocation/CoreLocation.h>
#import "../SBJson/SBJson.h"

@interface Service : NSObject {
    NSString *userId;
    NSString *ip;
    NSString *port;
    NSDictionary *apis;
}

@property(nonatomic, retain) NSDictionary *apis;
@property(nonatomic, retain) NSString *userId;
@property(nonatomic, retain) NSString *ip;
@property(nonatomic, retain) NSString *port;

+ (Service *)getService;

- (NSString *)endpoint;

- (NSString *)getApiUrlForCheckList:(CLLocation *)location withUser:(User *)User;

- (NSString *)doHttpRequest:(NSString *)url;

- (NSArray *)getNotificationsList:(User *)user withLocation:(CLLocation *)location;

+ (void)postCheck:(Check *)check;

@end
