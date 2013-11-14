//
//  DetailViewController.m
//  googleGeofence
//
//  Created by Olya Lutsyk on 11/14/13.
//  Copyright (c) 2013 Olya Lutsyk. All rights reserved.
//

#import "DetailViewController.h"

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
    locationManager = [[CLLocationManager alloc] init];
    [locationManager setDelegate:self];
    [locationManager setDesiredAccuracy:kCLLocationAccuracyHundredMeters];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self configureView];
}

- (void)viewWillAppear:(BOOL)animated{
    self.navigationItem.leftBarButtonItem = nil;
    self.navigationItem.hidesBackButton = YES;
    [self addCurrentLocation];
}


- (void)addCurrentLocation {
    // Update Helper
    _didStartMonitoringRegion = NO;
    // Start Updating Location
    [locationManager startUpdatingLocation];
}

- (void) checkLocation {
    if (CLLocationManager.locationServicesEnabled)
    {
        [locationManager startUpdatingLocation];
    }
    else
        NSLog(@"Please enable the location Services for this app in Settings");
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
        CLRegion *region = [[CLRegion alloc] initCircularRegionWithCenter:[location coordinate] radius:150.0 identifier:[[NSUUID UUID] UUIDString]];
        // Start Monitoring Region
        [locationManager startMonitoringForRegion:region];
        [locationManager stopUpdatingLocation];
        // Update Table View
        self.geofence = region;
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"%@", error);
}

- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region {
    NSLog(@"Entered region");
}
- (void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region {
   NSLog(@"Exited region");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
