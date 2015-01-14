//
//  EGYWebViewController.m
//
//  Created by Mokhles Hussien on 29.08.2013.
//  Copyright 2013 iMokhles. All rights reserved.
//
//  https://github.com/iMokhles/EGYWebViewController

#import "EGYWebViewController.h"
#import "TUSafariActivity.h"
#import "ARChromeActivity.h"
#import "MLCruxActivity.h"

@interface EGYWebViewController () <UIWebViewDelegate, UIActionSheetDelegate, MFMailComposeViewControllerDelegate>

@property (nonatomic, strong, readonly) UIBarButtonItem *backBarButtonItem;
@property (nonatomic, strong, readonly) UIBarButtonItem *forwardBarButtonItem;
@property (nonatomic, strong, readonly) UIBarButtonItem *refreshBarButtonItem;
@property (nonatomic, strong, readonly) UIBarButtonItem *stopBarButtonItem;
@property (nonatomic, strong, readonly) UIBarButtonItem *actionBarButtonItem;

@property (nonatomic, strong) UIWebView *mainWebView;

#ifdef __IPHONE_8_0
@property (nonatomic, strong) WKWebView *mainWebKitView;
@property (nonatomic, assign, readwrite) BOOL usingWebkit;
#else
    // Leaving this and lettingit be null will prevent
    // needing macros for every peice of code that can
    // optionally use webkit.
@property (nonatomic, strong) id mainWebKitView;
#endif

@property (nonatomic, strong) NSURL *URL;

- (id)initWithAddress:(NSString*)urlString;
- (id)initWithURL:(NSURL*)URL;
- (void)loadURL:(NSURL*)URL;

- (void)updateToolbarItems;

- (void)goBackClicked:(UIBarButtonItem *)sender;
- (void)goForwardClicked:(UIBarButtonItem *)sender;
- (void)reloadClicked:(UIBarButtonItem *)sender;
- (void)stopClicked:(UIBarButtonItem *)sender;
- (void)actionButtonClicked:(UIBarButtonItem *)sender;

@end


@implementation EGYWebViewController


@synthesize URL, mainWebView;
@synthesize backBarButtonItem, forwardBarButtonItem, refreshBarButtonItem, stopBarButtonItem, actionBarButtonItem;

#pragma mark - setters and getters

- (UIBarButtonItem *)backBarButtonItem {
    
    if (!backBarButtonItem) {
        backBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"EGYWebViewController.bundle/iPhone/back"] style:UIBarButtonItemStylePlain target:self action:@selector(goBackClicked:)];
        backBarButtonItem.imageInsets = UIEdgeInsetsMake(2.0f, 0.0f, -2.0f, 0.0f);
		backBarButtonItem.width = 18.0f;
    }
    return backBarButtonItem;
}

- (UIBarButtonItem *)forwardBarButtonItem {
    
    if (!forwardBarButtonItem) {
        forwardBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"EGYWebViewController.bundle/iPhone/forward"] style:UIBarButtonItemStylePlain target:self action:@selector(goForwardClicked:)];
        forwardBarButtonItem.imageInsets = UIEdgeInsetsMake(2.0f, 0.0f, -2.0f, 0.0f);
		forwardBarButtonItem.width = 18.0f;
    }
    return forwardBarButtonItem;
}

- (UIBarButtonItem *)refreshBarButtonItem {
    
    if (!refreshBarButtonItem) {
        refreshBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(reloadClicked:)];
    }
    
    return refreshBarButtonItem;
}

- (UIBarButtonItem *)stopBarButtonItem {
    
    if (!stopBarButtonItem) {
        stopBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(stopClicked:)];
    }
    return stopBarButtonItem;
}

- (UIBarButtonItem *)actionBarButtonItem {
    
    if (!actionBarButtonItem) {
        actionBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(actionButtonClicked:)];
    }
    return actionBarButtonItem;
}


#pragma mark - Initialization

- (instancetype)initWithAddress:(NSString *)urlString {
    return [self initWithURL:[NSURL URLWithString:urlString] usingWebkit:USE_WEBKIT_DEFAULT];
}

- (instancetype)initWithAddress:(NSString *)urlString usingWebkit:(BOOL)usingWebkit {
    return [self initWithURL:[NSURL URLWithString:urlString]];
}

- (instancetype)initWithURL:(NSURL*)pageURL {
    return [self initWithURL:pageURL usingWebkit:USE_WEBKIT_DEFAULT];
}

- (instancetype)initWithURL:(NSURL*)pageURL usingWebkit:(BOOL)usingWebkit {
    
    if(self = [super init]) {
        self.URL = pageURL;
#ifdef __IPHONE_8_0
        _usingWebkit = usingWebkit;
#endif
    }

    return self;
}

- (void)loadURL:(NSURL *)pageURL {
    if (_mainWebKitView) {
        [_mainWebKitView loadRequest:[NSURLRequest requestWithURL:pageURL]];
    } else {
        [mainWebView loadRequest:[NSURLRequest requestWithURL:pageURL]];
    }
}

#pragma mark - View lifecycle

- (void)loadView {
        // Use of macro here because class is use explicetely
        // elsewhere code just nil checks _mainWebKitView
#ifdef __IPHONE_8_0
    if ( self.usingWebkit && NSClassFromString(@"WKWebView") != nil ) {
        WKWebViewConfiguration *config = [WKWebViewConfiguration new];
        _mainWebKitView = [[WKWebView alloc] initWithFrame:[UIScreen mainScreen].bounds configuration:config];
        _mainWebKitView.navigationDelegate = self;
        _mainWebKitView.UIDelegate         = self;
        self.view                          = _mainWebKitView;
    } else {
#endif
        mainWebView = [[UIWebView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        mainWebView.delegate        = self;
        mainWebView.scalesPageToFit = YES;
        self.view                   = mainWebView;
#ifdef __IPHONE_8_0
    }
#endif
    [self loadURL:self.URL];
}

- (void)viewDidLoad {
	[super viewDidLoad];
    [self updateToolbarItems];
}

- (void)viewDidUnload {
    [super viewDidUnload];
    mainWebView = nil;
    _mainWebKitView = nil;
    backBarButtonItem = nil;
    forwardBarButtonItem = nil;
    refreshBarButtonItem = nil;
    stopBarButtonItem = nil;
    actionBarButtonItem = nil;
}

//- (void)viewDidAppear:(BOOL)animated {
//    [super viewDidAppear:YES];
//    
//    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1) {
//#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_7_0
//        if (self.barsTintColor != nil) {
//            // Checked if not nil
//            self.navigationController.navigationBar.tintColor = self.barsTintColor;
//            self.navigationController.toolbar.tintColor = self.barsTintColor;
//        } else if (self.barItemsTintColor != nil) {
//            self.navigationItem.backBarButtonItem.tintColor = self.barItemsTintColor;
//            [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObject:self.barItemsTintColor forKey:UITextAttributeTextColor]];
//        }
//#endif
//    } else {
//        if (self.barsTintColor != nil) {
//            self.navigationController.navigationBar.barTintColor = self.barsTintColor;
//            self.navigationController.toolbar.barTintColor = self.barsTintColor;
//            self.navigationController.toolbar.translucent = NO;
//        } else if (self.barItemsTintColor != nil) {
//            self.navigationController.toolbar.tintColor = self.barItemsTintColor;
//            self.navigationController.navigationItem.backBarButtonItem.tintColor = self.barItemsTintColor;
//            self.navigationController.navigationBar.tintColor = self.barItemsTintColor;
//            [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObject:self.barItemsTintColor forKey:NSForegroundColorAttributeName]];
//        }
//    }
//}

- (void)viewWillAppear:(BOOL)animated {
    NSAssert(self.navigationController, @"EGYWebViewController needs to be contained in a UINavigationController. If you are presenting EGYWebViewController modally, use EGYWebViewController instead.");
    
	[super viewWillAppear:animated];
	
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        [self.navigationController setToolbarHidden:NO animated:animated];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        [self.navigationController setToolbarHidden:YES animated:animated];
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        return YES;
    
    return toInterfaceOrientation != UIInterfaceOrientationPortraitUpsideDown;
}

- (void)dealloc
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    if (_mainWebKitView) {
        [_mainWebKitView stopLoading];
        _mainWebKitView.UIDelegate = nil;
        _mainWebKitView.navigationDelegate = nil;
    }
    if (mainWebView) {
        [mainWebView stopLoading];
        mainWebView.delegate = nil;
    }
}

#pragma mark - Toolbar

- (void)updateToolbarItems {
    UIBarButtonItem *refreshStopBarButtonItem;

        // TODO :: Should use KVO for webKit
    if (_mainWebKitView) {
        self.backBarButtonItem.enabled    = self.mainWebKitView.canGoBack;
        self.forwardBarButtonItem.enabled = self.mainWebKitView.canGoForward;
        self.actionBarButtonItem.enabled  = !self.mainWebKitView.isLoading;
        refreshStopBarButtonItem          = self.mainWebKitView.isLoading ?
                                            self.stopBarButtonItem : self.refreshBarButtonItem;
    } else {
        self.backBarButtonItem.enabled    = self.mainWebView.canGoBack;
        self.forwardBarButtonItem.enabled = self.mainWebView.canGoForward;
        self.actionBarButtonItem.enabled  = !self.mainWebView.isLoading;
        refreshStopBarButtonItem          = self.mainWebView.isLoading ?
                                            self.stopBarButtonItem : self.refreshBarButtonItem;
    }
    
    UIBarButtonItem *fixedSpace    = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                                                target:nil
                                                                                action:nil];
    fixedSpace.width               = 5.0f;
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                                   target:nil
                                                                                   action:nil];
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1) {
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            NSArray *items;
            CGFloat toolbarWidth = 250.0f;
            
            if(self.URL == 0) {
                toolbarWidth = 200.0f;
                items = [NSArray arrayWithObjects:
                         fixedSpace,
                         refreshStopBarButtonItem,
                         flexibleSpace,
                         self.backBarButtonItem,
                         flexibleSpace,
                         self.forwardBarButtonItem,
                         fixedSpace,
                         nil];
            } else {
                items = [NSArray arrayWithObjects:
                         fixedSpace,
                         refreshStopBarButtonItem,
                         flexibleSpace,
                         self.backBarButtonItem,
                         flexibleSpace,
                         self.forwardBarButtonItem,
                         flexibleSpace,
                         self.actionBarButtonItem,
                         fixedSpace,
                         nil];
            }
            
            UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0.0f, 0.0f, toolbarWidth, 44.0f)];
            toolbar.items = items;
            toolbar.barStyle = self.navigationController.navigationBar.barStyle;
            toolbar.tintColor = self.navigationController.navigationBar.tintColor;
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:toolbar];
        } else {
            NSArray *items;
            
            if(self.URL == 0) {
                items = [NSArray arrayWithObjects:
                         flexibleSpace,
                         self.backBarButtonItem,
                         flexibleSpace,
                         self.forwardBarButtonItem,
                         flexibleSpace,
                         refreshStopBarButtonItem,
                         flexibleSpace,
                         nil];
            } else {
                items = [NSArray arrayWithObjects:
                         fixedSpace,
                         self.backBarButtonItem,
                         flexibleSpace,
                         self.forwardBarButtonItem,
                         flexibleSpace,
                         refreshStopBarButtonItem,
                         flexibleSpace,
                         self.actionBarButtonItem,
                         fixedSpace,
                         nil];
            }
            
            self.navigationController.toolbar.barStyle = self.navigationController.navigationBar.barStyle;
            self.navigationController.toolbar.tintColor = self.navigationController.navigationBar.tintColor;
            self.toolbarItems = items;
        }
    } else {
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            NSArray *items;
            CGFloat toolbarWidth = 250.0f;
            
            if(self.URL == 0) {
                toolbarWidth = 200.0f;
                items = [NSArray arrayWithObjects:
                         fixedSpace,
                         refreshStopBarButtonItem,
                         flexibleSpace,
                         self.backBarButtonItem,
                         flexibleSpace,
                         self.forwardBarButtonItem,
                         fixedSpace,
                         nil];
            } else {
                items = [NSArray arrayWithObjects:
                         fixedSpace,
                         refreshStopBarButtonItem,
                         flexibleSpace,
                         self.backBarButtonItem,
                         flexibleSpace,
                         self.forwardBarButtonItem,
                         flexibleSpace,
                         self.actionBarButtonItem,
                         fixedSpace,
                         nil];
            }
            
            UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0.0f, 0.0f, toolbarWidth, 44.0f)];
            toolbar.items = items;
            toolbar.barStyle = self.navigationController.navigationBar.barStyle;
            toolbar.barTintColor = self.navigationController.navigationBar.barTintColor;
            toolbar.tintColor = self.navigationController.navigationBar.tintColor;
            toolbar.translucent = NO;
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:toolbar];
        } else {
            NSArray *items;
            
            if(self.URL == 0) {
                items = [NSArray arrayWithObjects:
                         flexibleSpace,
                         self.backBarButtonItem,
                         flexibleSpace,
                         self.forwardBarButtonItem,
                         flexibleSpace,
                         refreshStopBarButtonItem,
                         flexibleSpace,
                         nil];
            } else {
                items = [NSArray arrayWithObjects:
                         fixedSpace,
                         self.backBarButtonItem,
                         flexibleSpace,
                         self.forwardBarButtonItem,
                         flexibleSpace,
                         refreshStopBarButtonItem,
                         flexibleSpace,
                         self.actionBarButtonItem,
                         fixedSpace,
                         nil];
            }
            
            self.navigationController.toolbar.barStyle = self.navigationController.navigationBar.barStyle;
            self.navigationController.toolbar.barTintColor = self.navigationController.navigationBar.barTintColor;
            self.navigationController.toolbar.tintColor = self.navigationController.navigationBar.tintColor;
            self.navigationController.toolbar.translucent = NO;
            self.toolbarItems = items;
        }
    }
}

#pragma mark -
#pragma mark UIWebViewDelegate

- (void)webViewDidStartLoad:(UIWebView *)webView {
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [self updateToolbarItems];
}


- (void)webViewDidFinishLoad:(UIWebView *)webView {
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    
    self.navigationItem.title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    [self updateToolbarItems];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    [self updateToolbarItems];
}

#ifdef __IPHONE_8_0
#pragma mark - WKNavigationDelegate
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [self updateToolbarItems];
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    [self updateToolbarItems];
}

- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation {
    [self updateToolbarItems];
}
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];

    self.navigationItem.title = webView.title;
    [self updateToolbarItems];
}
- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    [self updateToolbarItems];
}
#endif

#pragma mark - Target actions

- (void)goBackClicked:(UIBarButtonItem *)sender {
    if (_mainWebKitView) {
        [_mainWebKitView goBack];
    } else {
        [mainWebView goBack];
    }
}

- (void)goForwardClicked:(UIBarButtonItem *)sender {
    if (_mainWebKitView) {
        [_mainWebKitView goForward];
    } else {
        [mainWebView goForward];
    }
}

- (void)reloadClicked:(UIBarButtonItem *)sender {
    if (_mainWebKitView) {
        [_mainWebKitView reload];
    } else {
        [mainWebView reload];
    }
}

- (void)stopClicked:(UIBarButtonItem *)sender {
    if (_mainWebKitView) {
        [_mainWebKitView stopLoading];
    } else {
        [mainWebView stopLoading];
    }
    [self updateToolbarItems];
}

- (void)actionButtonClicked:(id)sender {
    
    // activityItems
    NSURL *url;
    if (self.mainWebView) {
        url = self.mainWebView.request.URL;
    } else {
        url = self.URL;
    }
    //NSString *text = [NSString stringWithFormat:@"This link shared from %@ Application", [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleName"]];
    NSArray *activityItems;
    if (url) {
        activityItems = @[url /*text*/];
    } else {
        NSLog(@"No url was found");
        return;
    }

    // activities
    TUSafariActivity     *safariActivity     = [[TUSafariActivity alloc] init];
    ARChromeActivity     *chromeActivity     = [[ARChromeActivity alloc] init];
    MLCruxActivity       *cruxActivity       = [[MLCruxActivity alloc] init];
    
    NSArray *activities = @[
                            safariActivity,
                            chromeActivity,
                            cruxActivity,];
    
    // UIActivityViewController
    UIActivityViewController *activityView = [[UIActivityViewController alloc] initWithActivityItems:activityItems
                                                                               applicationActivities:activities];
    
    /* Exclude default activity types for demo.
     activityView.excludedActivityTypes = @[
     //  UIActivityTypeAssignToContact,
     UIActivityTypeCopyToPasteboard,
     UIActivityTypePostToFacebook,
     UIActivityTypePostToTwitter,
     UIActivityTypePostToWeibo,
     //  UIActivityTypePrint,
     UIActivityTypeMail,
     UIActivityTypeMessage,
     //  UIActivityTypeSaveToCameraRoll,
     ];
     */
    // show
    [self presentViewController:activityView animated:YES completion:nil];
    
}

- (void)doneButtonClicked:(id)sender {
#if __IPHONE_OS_VERSION_MIN_REQUIRED < 60000
    [self dismissModalViewControllerAnimated:YES];
#else
    [self dismissViewControllerAnimated:YES completion:NULL];
#endif
}

@end