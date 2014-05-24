//
//  FBMenuVC.m
//  Twitter
//
//  Created by mfb on 5/21/14.
//  Copyright (c) 2014 bulutmf. All rights reserved.
//

#import "FBMenuVC.h"
#import "SWRevealViewController.h"
#import "FBHomeVC.h"
#import <Accounts/Accounts.h>
#import <Social/Social.h>
#import "SVProgressHUD.h"
#import "FBUtils.h"
#import "FBAppDelegate.h"
#import "FBProfileCell.h"
#import "UIFont+Twitter.h"

@interface FBMenuVC ()

@property (strong, nonatomic) NSDictionary *accountOwner;

@end

@implementation FBMenuVC

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
    // Do any additional setup after loading the view from its nib.
    
    self.tableView.backgroundColor = [UIColor lightGrayColor];
    [self performSelector:@selector(checkTwitterAuthorization) withObject:nil afterDelay:0.2];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableView Data Source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	
    UITableViewCell *cell;
    
	
    
    if (indexPath.row == 0) {
        static NSString *cellIdentifier = @"ProfileCell";
        cell = (FBProfileCell *) [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (nil == cell) {
            cell = [[FBProfileCell alloc] init];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSURL *url = [NSURL URLWithString:[self.accountOwner objectForKey:@"profile_image_url"]];
            NSData *data = [NSData dataWithContentsOfURL:url];
            dispatch_async(dispatch_get_main_queue(), ^{
                [((FBProfileCell *)cell).actIndicator stopAnimating];
                ((FBProfileCell *)cell).profileImageView.image = [UIImage imageWithData:data];
            });
        });
        
        ((FBProfileCell *)cell).nameLabel.text = [self.accountOwner objectForKey:@"name"];
        ((FBProfileCell *)cell).bioLabel.text = [self.accountOwner objectForKey:@"description"];
        
    } else {
        static NSString *cellIdentifier = @"Cell2";
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        if (nil == cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
            cell.backgroundColor = [UIColor lightGrayColor];
        }
        
        if (indexPath.row == 1) {
            cell.textLabel.text = @"Home";
        } else if (indexPath.row == 2) {
            cell.textLabel.text = @"@Mentions";
        } else if (indexPath.row == 3) {
            cell.textLabel.text = @"My Profile";
        } else {
            cell.textLabel.text = @"Others";
        }
        
    }
	
	
	return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
        return 80;
    else
        return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SWRevealViewController *revealController = self.revealViewController;
    UINavigationController *frontNavigationController = (id)revealController.frontViewController;
    
    if (indexPath.row == 1) {
        if (![[frontNavigationController topViewController] isKindOfClass:[FBHomeVC class]]) {
            FBHomeVC *homeVC = [[FBHomeVC alloc] init];
            UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:homeVC];
            [revealController pushFrontViewController:navController animated:YES];
        } else {
            [revealController revealToggle:self];
        }
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Getting profile information from Twitter

- (void) checkTwitterAuthorization {
    if ([FBUtils checkAuthorization:self]) {
        NSLog(@"Twitter is available and authorized to use");
        
        // Now get timeline of the user
        [self getProfileInfo];
        
    }
}

- (void) getProfileInfo {
    
    ACAccountStore *accountStore = [[ACAccountStore alloc] init];
    ACAccountType *accountType = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    [self performRequestToGetProfileWithAccountStore:accountStore accountType:accountType];
}

- (void) performRequestToGetProfileWithAccountStore:(ACAccountStore *) accountStore accountType:(ACAccountType *) accountType {
    
    NSArray *twitterAccounts = [accountStore accountsWithAccountType:accountType];
    ACAccount *account = [twitterAccounts objectAtIndex:0];
    NSURL *url = [NSURL URLWithString:@"https://api.twitter.com/1.1/users/show.json"];
    NSDictionary *params = @{@"screen_name" : account.username,
                             @"user_id" : account.identifier};
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
                NSDictionary *userData = [NSJSONSerialization JSONObjectWithData:responseData
                                                                             options:NSJSONReadingAllowFragments
                                                                               error:&jsonError];
                if (userData) {
                    //NSLog(@"UserInfo Response: %@\n", userData);
                    
                    ((FBAppDelegate *)[[UIApplication sharedApplication] delegate]).accountOwner = userData;
                    self.accountOwner = userData;
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.tableView reloadData];
                    });
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


@end
