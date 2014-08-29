//
//  EGYWebViewController.h
//
//  Created by Mokhles Hussien on 29.08.2013.
//  Copyright 2013 iMokhles. All rights reserved.
//
//  https://github.com/iMokhles/EGYWebViewController

#import <MessageUI/MessageUI.h>
#import <objc/runtime.h>
#import <Foundation/Foundation.h>
#import "EGYModalWebViewController.h"

// #define deprecated __attribute__((deprecated))
#define noreturn __attribute__((noreturn)) void
#define unused __attribute__((unused))

@interface EGYWebViewController : UIViewController

- (id)initWithAddress:(NSString*)urlString;
- (id)initWithURL:(NSURL*)URL;

// Delete This error after you see the deprecate message ;)
// #error EGYWebViewController don't use the deprecated items (barsTintColor & barItemsTintColor) when you pushing it through UINavigationController.

@property (nonatomic, strong) UIColor *barsTintColor    __attribute__((deprecated("not finished yet barsTintColor")));
@property (nonatomic, strong) UIColor *barItemsTintColor __attribute__((deprecated("not finished yet barItemsTintColor")));

// Fixing @selector warning.
- (void)doneButtonClicked:(id)sender;
@end
