//
//  WebViewController.m
//  geobbs
//
//  Created by Francois-Guillaume Ribreau on 07/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "WebViewController.h"

@implementation WebViewController

@synthesize webView;

- (void)viewDidLoad {
    Service* s = [Service getService];
    NSString* url = [NSString stringWithFormat:@"%@%@?userId=%@&lat=%+.6f&lon=%+.6f"
            , s.endpoint
            , [s.apis objectForKey:@"userProfile"]
            , s.userId];
    NSLog(@"%@", url);
    
    // URL Requst Object
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    
    // Load the request in the UIWebView.
    [webView loadRequest:requestObj];
}

@end
