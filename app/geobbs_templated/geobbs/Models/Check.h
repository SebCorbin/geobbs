//
//  Check.h
//  geobbs
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



- (id)initWithLocation: (CLLocation *)location userId:(NSString *)userId description:(NSString *)description;

@end