//
//  FBHomeVC.m
//  Twitter
//
//  Created by mfb on 5/21/14.
//  Copyright (c) 2014 bulutmf. All rights reserved.
//

#import "FBHomeVC.h"
#import "SWRevealViewController.h"
#import "FBLoginVC.h"
#import <Accounts/Accounts.h>
#import <Social/Social.h>
#import "FBUtils.h"
#import "SVProgressHUD.h"

@interface FBHomeVC ()

@end

@implementation FBHomeVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    SWRevealViewController *revealController = [self revealViewController];
    [revealController panGestureRecognizer];
    [revealController tapGestureRecognizer];
    
    UIBarButtonItem *menuitem = [[UIBarButtonItem alloc]
                                 initWithImage:[UIImage imageNamed:@"reveal-icon.png"]
                                 style:UIBarButtonItemStylePlain
                                 target:revealController
                                 action:@selector(revealToggle:)];
    self.navigationItem.leftBarButtonItem = menuitem;
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if ([self isTwitterAvailable]) {
        NSLog(@"Twitter is available and there exists at least one user account");
        
        // Now get timeline of the user
        [self getTimeLine];
        
    } else {
        NSLog(@"No account added yet! Please add first");
        [FBUtils showPopupMessageInView:self title:@"" message:@"Please add Twitter account from Settings!"];
    }
}

- (BOOL) isTwitterAvailable {
    return [SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter];
}

- (void) getTimeLine {
    
    [SVProgressHUD showWithStatus:@"Getting timeline..."];
    ACAccountStore *accountStore = [[ACAccountStore alloc] init];
    ACAccountType *accountType = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    [accountStore requestAccessToAccountsWithType:accountType options:nil completion:^(BOOL granted, NSError *error) {
        
        if (error == nil) {
            if (granted) {
                NSLog(@"Granted");
                // Go get the status updates
                [self performRequestToGetTimelineWithAccountStore:accountStore accountType:accountType];
                
            } else {
                NSLog(@"Please authenticate our app!");
                dispatch_async(dispatch_get_main_queue(), ^{
                    [SVProgressHUD dismiss];
                    [FBUtils showPopupMessageInView:self title:@"" message:@"Please authenticate the app from Settings!"];
                });
            }
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [SVProgressHUD dismiss];
                [FBUtils showPopupMessageInView:self title:@"" message:[error description]];
            });
        }
        
    }];
}

- (void) performRequestToGetTimelineWithAccountStore:(ACAccountStore *) accountStore accountType:(ACAccountType *) accountType {
    
    NSArray *twitterAccounts = [accountStore accountsWithAccountType:accountType];
    ACAccount *account = [twitterAccounts objectAtIndex:0];
    NSURL *url = [NSURL URLWithString:@"https://api.twitter.com/1.1/statuses/home_timeline.json"];
    NSDictionary *params = @{@"screen_name" : account.username,
                             @"count" : @"1"};
    SLRequest *request = [SLRequest requestForServiceType:SLServiceTypeTwitter
                                            requestMethod:SLRequestMethodGET
                                                      URL:url
                                               parameters:params];
    //  Attach an account to the request
    [request setAccount:account];
    [request performRequestWithHandler: ^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
         if (responseData) {
             if (urlResponse.statusCode >= 200 && urlResponse.statusCode < 300) {
                 NSError *jsonError;
                 NSDictionary *timelineData = [NSJSONSerialization JSONObjectWithData:responseData
                                                                              options:NSJSONReadingAllowFragments
                                                                                error:&jsonError];
                 if (timelineData) {
                     NSLog(@"Timeline Response: %@\n", timelineData);
                 } else {
                     // Our JSON deserialization went awry
                     NSLog(@"JSON Error: %@", [jsonError localizedDescription]);
                 }
                 dispatch_async(dispatch_get_main_queue(), ^{
                     [SVProgressHUD dismiss];
                 });
             } else {
                 // The server did not respond ... were we rate-limited?
                 NSLog(@"The response status code is %ld", (long) urlResponse.statusCode);
                 dispatch_async(dispatch_get_main_queue(), ^{
                     [SVProgressHUD dismiss];
                 });
             }
         }
     }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
