//
//  AKOAppDelegate.h
//  FakePhoneGap
//
//  Created by Adrian Kosmaczewski on 2/17/12.
//  Copyright (c) 2012 akosma software. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AKOFakePhoneGapController;

@interface AKOAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) AKOFakePhoneGapController *viewController;

@end
