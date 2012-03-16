//
//  AKOViewController.m
//  FakePhoneGap
//
//  Created by Adrian Kosmaczewski on 2/17/12.
//  Copyright (c) 2012 akosma software. All rights reserved.
//

#import "AKOFakePhoneGapController.h"
#import "NSData+Base64.h"

@interface AKOFakePhoneGapController ()

@property (nonatomic, strong) CLLocationManager *locationManager;

@end


@implementation AKOFakePhoneGapController

@synthesize webView = _webView;
@synthesize locationManager = _locationManager;

- (void)dealloc 
{
    [_webView release];
    _locationManager.delegate = nil;
    [_locationManager stopUpdatingLocation];
    [_locationManager release];
    [super dealloc];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"index" ofType:@"html"];
    NSURL *url = [NSURL fileURLWithPath:path];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
}


- (void)viewDidUnload
{
    self.webView = nil;
    self.locationManager = nil;
    [super viewDidUnload];
}

#pragma mark - UIWebViewDelegate methods

-            (BOOL)webView:(UIWebView *)webView 
shouldStartLoadWithRequest:(NSURLRequest *)request
            navigationType:(UIWebViewNavigationType)navigationType
{
    NSURL *url = [request URL];
    NSString *urlString = [url absoluteString];
    if ([urlString hasPrefix:@"photolibrary://"])
    {
        UIImagePickerController *controller = [[[UIImagePickerController alloc] init] autorelease];
        controller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        controller.delegate = self;
        [self presentModalViewController:controller animated:YES];
        NSLog(@"Opening the photo library");
        return NO;
    }
    else if ([urlString hasPrefix:@"geolocation://"])
    {
        if (self.locationManager == nil)
        {
            self.locationManager = [[[CLLocationManager alloc] init] autorelease];
            self.locationManager.delegate = self;
        }
        [self.locationManager startUpdatingLocation];
        
        // Automatically stop the location manager after 5 seconds
        [self.locationManager performSelector:@selector(stopUpdatingLocation)
                                   withObject:nil
                                   afterDelay:5];
        
        NSString *statusChange = @"PhoneGap.setStatusMessage('Location manager started');";
        [self.webView stringByEvaluatingJavaScriptFromString:statusChange];
        return NO;
    }
    return YES;
}

#pragma mark - CLLocationManagerDelegate methods

- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
    NSString *template = @"PhoneGap.setLocation(%1.2f, %1.2f);";
    CLLocationDegrees lat = newLocation.coordinate.latitude;
    CLLocationDegrees lng = newLocation.coordinate.longitude;

    NSString *statusChange = [NSString stringWithFormat:template, lat, lng];
    NSString *result = [self.webView stringByEvaluatingJavaScriptFromString:statusChange];
    NSLog(@"Location changed in JavaScript to (%@)", result);
}

#pragma mark - UIImagePickerControllerDelegate methods

- (void)imagePickerController:(UIImagePickerController *)picker
        didFinishPickingImage:(UIImage *)image
                  editingInfo:(NSDictionary *)editingInfo
{
    NSData *imageData = UIImageJPEGRepresentation(image, 0.8);
    NSString *base64Data = [imageData base64EncodedString];
    NSArray *array = [base64Data componentsSeparatedByString:@"\n"];
    NSString *template = @"PhoneGap.appendImageData(\"%@\");";
    for (NSString *string in array)
    {
        NSString *appendImageData = [NSString stringWithFormat:template, [string stringByReplacingOccurrencesOfString:@"\r" withString:@""]];
        [self.webView stringByEvaluatingJavaScriptFromString:appendImageData];
    }
    NSString *displayImage = @"PhoneGap.displayImage()";
    NSString *result = [self.webView stringByEvaluatingJavaScriptFromString:displayImage];
    NSLog(@"Image displayed: %@", result);

    [picker dismissModalViewControllerAnimated:YES];
}

@end
