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
    [pushButton setFrame:CGRectMake(20, 200, 250, 50)];
    [pushButton setTitle:@"PushEGYWebViewController" forState:UIControlStateNormal];
    [pushButton addTarget:self action:@selector(pushWebViewController) forControlEvents:UIControlEventTouchUpInside];
    UIButton *presentButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [presentButton setFrame:CGRectMake(20, 150, 250, 50)];
    [presentButton setTitle:@"PresentEGYWebViewController" forState:UIControlStateNormal];
    [presentButton sizeToFit];
    [presentButton addTarget:self action:@selector(presentWebViewController) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:presentButton];
    [self.view addSubview:pushButton];

#ifdef __IPHONE_8_0
    UIButton *pushButtonWK = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [pushButtonWK setFrame:CGRectMake(20, 325, 250, 50)];
    [pushButtonWK setTitle:@"PushEGYWebViewController Webkit" forState:UIControlStateNormal];
    [pushButtonWK addTarget:self action:@selector(pushWebKitViewController) forControlEvents:UIControlEventTouchUpInside];
    UIButton *presentButtonWK = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [presentButtonWK setFrame:CGRectMake(20, 275, 250, 50)];
    [presentButtonWK setTitle:@"PresentEGYWebViewController Webkit" forState:UIControlStateNormal];
    [presentButtonWK sizeToFit];
    [presentButtonWK addTarget:self action:@selector(presentWebKitViewController) forControlEvents:UIControlEventTouchUpInside];

    [self.view addSubview:pushButtonWK];
    [self.view addSubview:presentButtonWK];
#endif
}
-(void)pushWebViewController{
    [self _pushWebViewController:NO];
}

- (void)presentWebViewController {
    [self _presentWebViewController:NO];
}

#ifdef __IPHONE_8_0
-(void)pushWebKitViewController{
    [self _pushWebViewController:YES];
}

- (void)presentWebKitViewController {
    [self _presentWebViewController:YES];
}
#endif


- (void)_pushWebViewController:(BOOL)useWebkit {
    NSURL *URL = [NSURL URLWithString:@"http://yahoo.com"];
	EGYWebViewController *webViewController = [[EGYWebViewController alloc] initWithURL:URL];
    // [webViewController setBarItemsTintColor:[UIColor whiteColor]];
    // [webViewController setBarsTintColor:[UIColor blackColor]];
#ifdef __IPHONE_8_0
    webViewController.useWebkit = useWebkit;
#endif
	[self.navigationController pushViewController:webViewController animated:YES];
}


- (void)_presentWebViewController:(BOOL)useWebkit {
    NSURL *URL                                   = [NSURL URLWithString:@"http://twitter.com/iMokhles"];

    EGYModalWebViewController *webViewController = [[EGYModalWebViewController alloc] initWithURL:URL];
    webViewController.barItemsTintColor          = [UIColor redColor];
    webViewController.barsTintColor              = [UIColor blackColor];
    webViewController.modalPresentationStyle     = UIModalPresentationPageSheet;
#ifdef __IPHONE_8_0
    webViewController.useWebkit = useWebkit;
#endif
	[self presentModalViewController:webViewController animated:YES];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return YES;
}


@end

