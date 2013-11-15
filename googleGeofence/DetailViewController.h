//
//  DetailViewController.h
//  googleGeofence
//
//  Created by Olya Lutsyk on 11/14/13.
//  Copyright (c) 2013 Olya Lutsyk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@interface DetailViewController : UIViewController <CLLocationManagerDelegate>

@property (strong, nonatomic) id detailItem;

@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@property (weak, nonatomic) IBOutlet MKMapView *map;
@end
