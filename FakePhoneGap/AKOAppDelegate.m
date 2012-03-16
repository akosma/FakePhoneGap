//
//  AKOAppDelegate.m
//  FakePhoneGap
//
//  Created by Adrian Kosmaczewski on 2/17/12.
//  Copyright (c) 2012 akosma software. All rights reserved.
//

#import "AKOAppDelegate.h"
#import "AKOFakePhoneGapController.h"

@implementation AKOAppDelegate

@synthesize window = _window;
@synthesize viewController = _viewController;

- (void)dealloc
{
    [_window release];
    [_viewController release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    CGRect rect = [UIScreen mainScreen].bounds;
    self.window = [[[UIWindow alloc] initWithFrame:rect] autorelease];
    self.viewController = [[[AKOFakePhoneGapController alloc] init] autorelease];
    self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];
    
    // This is required for iWebInspector http://www.iwebinspector.com/
    // to work in the context of this application; to avoid rejections by Apple,
    // remember to remove this call from your code before shipping!!
    [NSClassFromString(@"WebView") performSelector:@selector(_enableRemoteInspector)];
    
    return YES;
}

@end
