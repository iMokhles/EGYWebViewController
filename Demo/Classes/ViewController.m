//
//
//  EGYWebViewController
//
//  Created by Mokhles Hussien on 29.08.2013.
//  Copyright 2013 iMokhles. All rights reserved.
//
//  https://github.com/iMokhles/EGYWebViewController


#import "ViewController.h"
#import "EGYWebViewController.h"

@implementation ViewController

// How to push EGYWebViewController

/*- (void)pushWebViewController {
    NSURL *URL = [NSURL URLWithString:@"http://twitter.com/iMokhles"];
	EGYWebViewController *webViewController = [[EGYWebViewController alloc] initWithURL:URL];
	[self.navigationController pushViewController:webViewController animated:YES];
}
*/

- (void)presentWebViewController {
	NSURL *URL = [NSURL URLWithString:@"http://twitter.com/iMokhles"];
	EGYModalWebViewController *webViewController = [[EGYModalWebViewController alloc] initWithURL:URL];
	webViewController.modalPresentationStyle = UIModalPresentationPageSheet;
	[self presentModalViewController:webViewController animated:YES];	
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return YES;
}


@end

