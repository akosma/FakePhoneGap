//
//  AKOViewController.h
//  FakePhoneGap
//
//  Created by Adrian Kosmaczewski on 2/17/12.
//  Copyright (c) 2012 akosma software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface AKOViewController : UIViewController <UINavigationControllerDelegate,
                                                 UIImagePickerControllerDelegate,
                                                 UIWebViewDelegate, 
                                                 CLLocationManagerDelegate>

@property (retain, nonatomic) IBOutlet UIWebView *webView;

@end
