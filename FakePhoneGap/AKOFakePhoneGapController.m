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
@property (retain, nonatomic) UIWebView *webView;

- (void)log:(NSString *)message;
- (NSString *)executeJavaScript:(NSString *)code;

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

- (void)loadView
{
    [super loadView];
    self.webView = [[[UIWebView alloc] initWithFrame:self.view.bounds] autorelease];
    self.webView.delegate = self;
    [self.view addSubview:self.webView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"www" ofType:@""];
    path = [path stringByAppendingPathComponent:@"index.html"];
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
    if ([urlString hasPrefix:@"fakephonegap"])
    {
        NSString *path = [url host];
        [self log:path];
        if ([path isEqualToString:@"openphotolibrary"])
        {
            UIImagePickerController *controller = [[[UIImagePickerController alloc] init] autorelease];
            controller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            controller.delegate = self;
            [self presentModalViewController:controller animated:YES];
            [self log:@"Opening the photo library"];
            return NO;
        }
        else if ([path isEqualToString:@"startgeolocation"])
        {
            if (self.locationManager == nil)
            {
                self.locationManager = [[[CLLocationManager alloc] init] autorelease];
                self.locationManager.delegate = self;
            }
            [self.locationManager startUpdatingLocation];
            [self log:@"Location manager started"];
            return NO;
        }
        else if ([path isEqualToString:@"stopgeolocation"])
        {
            [self.locationManager stopUpdatingLocation];
            [self log:@"Location manager stopped"];
        }
        return NO;
    }
    return YES;
}

#pragma mark - CLLocationManagerDelegate methods

- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
    NSString *template = @"FakePhoneGap.locationUpdated(%1.2f, %1.2f);";
    CLLocationDegrees lat = newLocation.coordinate.latitude;
    CLLocationDegrees lng = newLocation.coordinate.longitude;

    NSString *statusChange = [NSString stringWithFormat:template, lat, lng];
    NSString *result = [self executeJavaScript:statusChange];
    NSString *message = [NSString stringWithFormat:@"Location changed in JavaScript to (%@)", result];
    [self log:message];
}

#pragma mark - UIImagePickerControllerDelegate methods

- (void)imagePickerController:(UIImagePickerController *)picker
        didFinishPickingImage:(UIImage *)image
                  editingInfo:(NSDictionary *)editingInfo
{
    NSData *imageData = UIImageJPEGRepresentation(image, 0.8);
    NSString *base64Data = [imageData base64EncodedString];
    NSArray *array = [base64Data componentsSeparatedByString:@"\n"];
    NSString *template = @"FakePhoneGap.appendImageData(\"%@\");";
    for (NSString *string in array)
    {
        NSString *clean = [string stringByReplacingOccurrencesOfString:@"\r" withString:@""];
        NSString *appendImageData = [NSString stringWithFormat:template, clean];
        [self executeJavaScript:appendImageData];
    }
    NSString *imageDataReady = @"FakePhoneGap.imageDataReady()";
    NSString *result = [self executeJavaScript:imageDataReady];
    NSString *message = [NSString stringWithFormat:@"Image displayed: %@", result];
    [self log:message];

    [picker dismissModalViewControllerAnimated:YES];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self log:@"Image picker dismissed"];
    [picker dismissModalViewControllerAnimated:YES];
}

#pragma mark - Private methods

- (void)log:(NSString *)message
{
    NSLog(message, nil);
    NSString *statusChange = [NSString stringWithFormat:@"FakePhoneGap.log('%@');", message];
    [self executeJavaScript:statusChange];
}

- (NSString *)executeJavaScript:(NSString *)code
{
    return [self.webView stringByEvaluatingJavaScriptFromString:code];
}

@end
