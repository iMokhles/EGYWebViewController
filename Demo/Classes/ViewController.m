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

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *pushButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [pushButton setFrame:CGRectMake(50, 200, 200, 50)];
    [pushButton setTitle:@"PushEGYWebViewController" forState:UIControlStateNormal];
    [pushButton addTarget:self action:@selector(pushWebViewController) forControlEvents:UIControlEventTouchUpInside];
    UIButton *presentButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [presentButton setFrame:CGRectMake(50, 150, 200, 50)];
    [presentButton setTitle:@"PresentEGYWebViewController" forState:UIControlStateNormal];
    [presentButton sizeToFit];
    [presentButton addTarget:self action:@selector(presentWebViewController) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:presentButton];
    [self.view addSubview:pushButton];
}
- (void)pushWebViewController {
    NSURL *URL = [NSURL URLWithString:@"http://yahoo.com"];
	EGYWebViewController *webViewController = [[EGYWebViewController alloc] initWithURL:URL];
    // [webViewController setBarItemsTintColor:[UIColor whiteColor]];
    // [webViewController setBarsTintColor:[UIColor blackColor]];
	[self.navigationController pushViewController:webViewController animated:YES];
}


- (void)presentWebViewController {
	NSURL *URL = [NSURL URLWithString:@"http://twitter.com/iMokhles"];
	EGYModalWebViewController *webViewController = [[EGYModalWebViewController alloc] initWithURL:URL];
    webViewController.barItemsTintColor = [UIColor redColor];
    webViewController.barsTintColor = [UIColor blackColor];
	webViewController.modalPresentationStyle = UIModalPresentationPageSheet;
	[self presentModalViewController:webViewController animated:YES];	
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return YES;
}


@end

