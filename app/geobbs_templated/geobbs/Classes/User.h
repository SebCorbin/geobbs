//
//  User.h
//  geobbs
//
//  Created by sebcorbin on 29/09/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//


@interface User : NSObject {
	NSString *login;
	NSString *password;
	NSArray *checks;
}

@property (retain) NSString *login;
@property (retain) NSString *password;
@property (retain) NSArray *checks;

+(User*) getCurrentUser;

@end

@interface NSString (Extensions)
- (NSString *) md5;
@end
@interface NSData (Extensions)
- (NSString*)md5;
@end