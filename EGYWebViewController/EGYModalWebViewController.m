//
//  EGYModalWebViewController.m
//
//  Created by Mokhles Hussien on 29.08.2013.
//  Copyright 2013 iMokhles. All rights reserved.
//
//  https://github.com/iMokhles/EGYWebViewController

#import "EGYModalWebViewController.h"
#import "EGYWebViewController.h"

@interface EGYModalWebViewController ()

@property (nonatomic, strong) EGYWebViewController *webViewController;

@end


@implementation EGYModalWebViewController

@synthesize barsTintColor, webViewController;

#pragma mark - Initialization


- (id)initWithAddress:(NSString*)urlString {
    return [self initWithURL:[NSURL URLWithString:urlString]];
}

- (id)initWithURL:(NSURL *)URL {
    self.webViewController = [[EGYWebViewController alloc] initWithURL:URL];
    if (self = [super initWithRootViewController:self.webViewController]) {
        self.webViewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:webViewController action:@selector(doneButtonClicked:)];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:NO];
    
    self.webViewController.title = self.title;
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1) {
#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_7_0
    	self.navigationBar.tintColor = self.barsTintColor;
    	self.toolbar.tintColor = self.barsTintColor;
    	self.navigationItem.backBarButtonItem.tintColor = self.barItemsTintColor;
    	[self.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObject:self.barItemsTintColor forKey:UITextAttributeTextColor]];
#endif
    } else {
    	self.navigationBar.barTintColor = self.barsTintColor;
    	self.toolbar.barTintColor = self.barsTintColor;
    	self.toolbar.tintColor = self.barItemsTintColor;
        self.toolbar.translucent = NO;
    	self.navigationItem.backBarButtonItem.tintColor = self.barItemsTintColor;
        self.navigationBar.tintColor = self.barItemsTintColor;
        [self.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObject:self.barItemsTintColor forKey:NSForegroundColorAttributeName]];
    }
}


@end
