//
//  User.h
//  geobbs
//


@interface User : NSObject {
    NSString *login;
    NSString *password;
    NSArray *checks;
}

@property(retain) NSString *login;
@property(retain) NSString *password;
@property(retain) NSArray *checks;

+ (User *)getCurrentUser;

@end

@interface NSString (Extensions)
- (NSString *)md5;
@end

@interface NSData (Extensions)
- (NSString *)md5;
@end