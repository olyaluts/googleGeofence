//
//  DetailViewController.h
//  googleGeofence
//
//  Created by Olya Lutsyk on 11/14/13.
//  Copyright (c) 2013 Olya Lutsyk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;

@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@end
