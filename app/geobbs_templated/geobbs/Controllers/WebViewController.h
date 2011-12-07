//
//  WebViewController.h
//  geobbs
//
//  Created by Francois-Guillaume Ribreau on 07/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Service.h"

@interface WebViewController : UIViewController {
    IBOutlet UIWebView *webView;
}

@property (nonatomic, retain) UIWebView *webView;

@end
