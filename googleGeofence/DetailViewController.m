//
//  DetailViewController.m
//  googleGeofence
//
//  Created by Olya Lutsyk on 11/14/13.
//  Copyright (c) 2013 Olya Lutsyk. All rights reserved.
//

#import "DetailViewController.h"
#import "AppDelegate.h"
#include <MailCore/MailCore.h>
#import <MapKit/MapKit.h>

@interface DetailViewController ()
{
    CLLocationManager *locationManager;
    BOOL _didStartMonitoringRegion;
}

- (void)configureView;

@property (strong, nonatomic) CLRegion *geofence;

@end

@implementation DetailViewController

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem
{
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        
        // Update the view.
        [self configureView];
    }
}

- (void)configureView
{
    // Update the user interface for the detail item.

    if (self.detailItem) {
        self.detailDescriptionLabel.text = [self.detailItem description];
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    locationManager = [[CLLocationManager alloc] init];
    [locationManager setDelegate:self];
    [locationManager setDesiredAccuracy:kCLLocationAccuracyHundredMeters];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self configureView];
  //  [self sendEmail];
}

- (void)viewWillAppear:(BOOL)animated{
    self.navigationItem.leftBarButtonItem = nil;
    self.navigationItem.hidesBackButton = YES;
    [self addCurrentLocation];
}

- (MKOverlayView *)mapView:(MKMapView *)map viewForOverlay:(id <MKOverlay>)overlay
{
    MKCircleView *circleView = [[MKCircleView alloc] initWithOverlay:overlay];
    circleView.strokeColor = [UIColor redColor];
    circleView.fillColor = [[UIColor redColor] colorWithAlphaComponent:0.4];
    return circleView;
}


- (void)addCurrentLocation {
    // Update Helper
    _didStartMonitoringRegion = NO;
    // Start Updating Location
    [locationManager startUpdatingLocation];
}



- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    // If it's a relatively recent event, turn off updates to save power.
  
    NSLog(@"didUpdateLocation");
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    if (locations && [locations count] && !_didStartMonitoringRegion) {
        // Update Helper
        _didStartMonitoringRegion = YES;
        // Fetch Current Location
        CLLocation *location = [locations objectAtIndex:0];
        // Initialize Region to Monitor
        CLLocationDistance fenceRadius = 250.0;
        
        CLCircularRegion *region = [[CLCircularRegion alloc] initWithCenter:[location coordinate]
                                                                     radius:fenceRadius
                                                                 identifier:[[NSUUID UUID] UUIDString]];
        // Start Monitoring Region
        [locationManager startMonitoringForRegion:region];
        [locationManager stopUpdatingLocation];
        // Update Table View
        
        MKCoordinateRegion adjustedRegion = [self.map regionThatFits:MKCoordinateRegionMakeWithDistance(location.coordinate, fenceRadius, fenceRadius)];
        adjustedRegion.span.longitudeDelta  = 0.01;
        adjustedRegion.span.latitudeDelta  = 0.01;
        
        [self.map setRegion:adjustedRegion animated:YES];
        
        MKCircle *circle = [MKCircle circleWithCenterCoordinate:location.coordinate radius:fenceRadius];
        [self.map addOverlay:circle];
        
        self.geofence = region;
    }
}

-(void)sendEmail {
    AppDelegate *app = [[UIApplication sharedApplication] delegate];
    GTMOAuth2Authentication *auth = [app auth];
    
    MCOSMTPSession * smtpSession = [[MCOSMTPSession alloc] init];
    [smtpSession setHostname:@"smtp.gmail.com"];
    [smtpSession setPort:25];
    [smtpSession setAuthType:MCOAuthTypeXOAuth2];
    [smtpSession setOAuth2Token:[auth accessToken]];
    [smtpSession setUsername:[auth userEmail]];
    [smtpSession setConnectionType:MCOConnectionTypeStartTLS];
  
    
    
    MCOMessageBuilder * builder = [[MCOMessageBuilder alloc] init];
    [[builder header] setFrom:[MCOAddress addressWithDisplayName:@"Test Geofence" mailbox:[auth userEmail]]];
    
    MCOAddress *addr = [MCOAddress addressWithMailbox:[auth userEmail]]; // Sends email back to user
    [[builder header] setTo:[NSArray arrayWithObject:addr]];
    
    [[builder header] setSubject:@"Hello from geofence test!"];
    [builder setTextBody:@"User left initial geofence"];
    
    NSData * rfc822Data = [builder data];
    MCOSMTPSendOperation *sendOperation = [smtpSession sendOperationWithData:rfc822Data];
    
    //[smtpSession setConnectionLogger:[[MCOConnectionLogger ;
    
    [sendOperation start:^(NSError *error) {
        if(error) {
            NSLog(@"Error sending email: %@", error);
        } else {
            NSLog(@"Successfully sent email!");
        }
    }];
}



- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"%@", error);
}

- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region {
    NSLog(@"Entered region");
}

- (void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region {
    NSLog(@"Exit region");
    [self sendEmail];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
