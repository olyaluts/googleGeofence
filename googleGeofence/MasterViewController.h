//
//  MasterViewController.h
//  googleGeofence
//
//  Created by Olya Lutsyk on 11/14/13.
//  Copyright (c) 2013 Olya Lutsyk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GooglePlus/GooglePlus.h>
#import <GoogleOpenSource/GoogleOpenSource.h>

@class GPPSignInButton;


@interface MasterViewController : UIViewController <GPPSignInDelegate>

    @property (retain, nonatomic) IBOutlet GPPSignInButton *signInButton;

@end
