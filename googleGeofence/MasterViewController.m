//
//  MasterViewController.m
//  googleGeofence
//
//  Created by Olya Lutsyk on 11/14/13.
//  Copyright (c) 2013 Olya Lutsyk. All rights reserved.
//

#import "MasterViewController.h"

#import "DetailViewController.h"
#import "AppDelegate.h"

static NSString * const kClientId = @"559691642764.apps.googleusercontent.com";

@implementation MasterViewController

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    GPPSignIn *signIn = [GPPSignIn sharedInstance];
    
    
    signIn.shouldFetchGooglePlusUser = YES;
    signIn.shouldFetchGoogleUserEmail = YES;  // Uncomment to get the user's email
    
    // You previously set kClientId in the "Initialize the Google+ client" step
    signIn.clientID = kClientId;
    [signIn setScopes:[NSArray arrayWithObjects:@"https://mail.google.com/", kGTLAuthScopePlusLogin, kGTLAuthScopePlusMe, nil]];
    
    // Optional: declare signIn.actions, see "app activities"
    signIn.delegate = self;
    [signIn trySilentAuthentication];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)refreshInterfaceBasedOnSignIn
{
    if ([[GPPSignIn sharedInstance] authentication]) {
        // The user is signed in.
        self.signInButton.hidden = YES;
        // Perform other actions here, such as showing a sign-out button
    } else {
        self.signInButton.hidden = NO;
        // Perform other actions here
    }
}

- (void)finishedWithAuth: (GTMOAuth2Authentication *)auth
                   error: (NSError *) error
{
    if (error) {
         NSLog(@"Received error %@", error);
    } else {
        AppDelegate *app = [[UIApplication sharedApplication] delegate];
        [app setAuth:auth];
        
        NSLog(@"Received auth object %@", auth.accessToken);
        [self refreshInterfaceBasedOnSignIn];
        [super performSegueWithIdentifier:@"mapSegue" sender:self];;
    }
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        
       // [[segue destinationViewController] setDetailItem:object];
    }
}

@end
