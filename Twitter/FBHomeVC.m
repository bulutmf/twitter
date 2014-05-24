//
//  FBHomeVC.m
//  Twitter
//
//  Created by mfb on 5/21/14.
//  Copyright (c) 2014 bulutmf. All rights reserved.
//

#import "FBHomeVC.h"
#import "SWRevealViewController.h"
#import <Accounts/Accounts.h>
#import <Social/Social.h>
#import "FBUtils.h"
#import "SVProgressHUD.h"
#import "FBStatusUpdateCell.h"
#import "UIFont+Twitter.h"

@interface FBHomeVC ()

@property (strong, nonatomic) NSCache *cache;
@property (strong, nonatomic) NSOperationQueue *opQueue;
@property (strong, nonatomic) NSArray *updates;

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
    
    self.title = @"Home";
    SWRevealViewController *revealController = [self revealViewController];
    [revealController panGestureRecognizer];
    [revealController tapGestureRecognizer];
    
    UIBarButtonItem *menuitem = [[UIBarButtonItem alloc]
                                 initWithImage:[UIImage imageNamed:@"reveal-icon.png"]
                                 style:UIBarButtonItemStylePlain
                                 target:revealController
                                 action:@selector(revealToggle:)];
    self.navigationItem.leftBarButtonItem = menuitem;
    
    self.cache = [[NSCache alloc] init];
    self.opQueue = [[NSOperationQueue alloc] init];
    self.opQueue.maxConcurrentOperationCount = 3;
    
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    
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
	return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.updates count];
}

- (CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0)
        return 6;
    return 1.0;
}

- (CGFloat)tableView:(UITableView*)tableView heightForFooterInSection:(NSInteger)section
{
    return 5.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"StatusUpdateCell";
    FBStatusUpdateCell *cell = (FBStatusUpdateCell *) [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (nil == cell) {
        cell = [[FBStatusUpdateCell alloc] init];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    NSDictionary *update = [self.updates objectAtIndex:indexPath.section];
    NSDictionary *user = [update objectForKey:@"user"];
	
    
    cell.nameLabel.text = [user objectForKey:@"name"];
    cell.statusUpdate.text = [update objectForKey:@"text"];
    
    cell.replyButton.tag = indexPath.section;
    [cell.replyButton addTarget:self action:@selector(reply:) forControlEvents:UIControlEventTouchUpInside];
    cell.retweetButton.tag = indexPath.section;
    [cell.retweetButton addTarget:self action:@selector(retweet:) forControlEvents:UIControlEventTouchUpInside];
    
    NSString *urlForImage = [user objectForKey:@"profile_image_url"];
    UIImage *cachedImage = [self.cache objectForKey:urlForImage];
    if (cachedImage) {
        cell.profileImageView.image = cachedImage;
    } else {
        [self.opQueue addOperationWithBlock:^{
            NSURL *url = [NSURL URLWithString:urlForImage];
            NSData *data = [NSData dataWithContentsOfURL:url];
            UIImage *image = [UIImage imageWithData:data];
            
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                
                // Here check if the cell is still visible
                FBStatusUpdateCell *opCell = (FBStatusUpdateCell *) [tableView cellForRowAtIndexPath:indexPath];
                if (opCell) {
                    if (image != nil) {
                        opCell.profileImageView.image = image;
                    }
                    [opCell.actIndicator stopAnimating];
                }
            }];
        }];
    }
    
    /*dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURL *url = [NSURL URLWithString:[user objectForKey:@"profile_image_url"]];
        NSData *data = [NSData dataWithContentsOfURL:url];
        dispatch_async(dispatch_get_main_queue(), ^{
            [cell.actIndicator stopAnimating];
            cell.profileImageView.image = [UIImage imageWithData:data];
        });
    });*/
    
    
	return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *update = [self.updates objectAtIndex:indexPath.section];
    float height = [FBHomeVC heightOfText:[update objectForKey:@"text"]];
    if ((height + 10 + 15 + 10 + 15) < 60)
        return 60;
    else
        return 10 + height + 15 + 10 + 15;
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

#pragma mark - Twitter requests

- (void) checkTwitterAuthorization {
    if ([FBUtils checkAuthorization:self]) {
        NSLog(@"Twitter is available and authorized to use");
        
        // Now get timeline of the user
        [self getTimeLine];
        
    }
}

- (BOOL) isTwitterAvailable {
    return [SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter];
}

- (void) getTimeLine {
    
    [SVProgressHUD showWithStatus:@"Getting timeline..."];
    ACAccountStore *accountStore = [[ACAccountStore alloc] init];
    ACAccountType *accountType = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    [self performRequestToGetTimelineWithAccountStore:accountStore accountType:accountType];
}

- (void) performRequestToGetTimelineWithAccountStore:(ACAccountStore *) accountStore accountType:(ACAccountType *) accountType {
    
    NSArray *twitterAccounts = [accountStore accountsWithAccountType:accountType];
    ACAccount *account = [twitterAccounts objectAtIndex:0];
    NSURL *url = [NSURL URLWithString:@"https://api.twitter.com/1.1/statuses/home_timeline.json"];
    NSDictionary *params = @{@"screen_name" : account.username,
                             @"exclude_replies" : @"true",
                             @"count" : @"20"};
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
                NSArray *timelineData = [NSJSONSerialization JSONObjectWithData:responseData
                                                                             options:NSJSONReadingAllowFragments
                                                                               error:&jsonError];
                if (timelineData) {
                    NSLog(@"Timeline Response: %@\n", timelineData);
                    self.updates = timelineData;
                    
                } else {
                    // Our JSON deserialization went awry
                    NSLog(@"JSON Error: %@", [jsonError localizedDescription]);
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.tableView reloadData];
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

#pragma mark - Auxilary methods

+ (float) heightOfText:(NSString *) text {
    CGSize constraintSize = CGSizeMake(320 - 40 - 10 - 5 - 5, 400);
    CGRect requriedSize = [text boundingRectWithSize:constraintSize
                                             options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin
                                          attributes:@{NSFontAttributeName: [UIFont t_regularPostFont]}
                                             context:nil];
    return requriedSize.size.height;
}

+ (float) heightForOneLine {
    CGSize constraint = CGSizeMake(1000, 1000);
    CGRect requriedSize;
    requriedSize = [@" " boundingRectWithSize:constraint
                                      options:
                    NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin
                                   attributes:@{NSFontAttributeName: [UIFont t_regularPostFont]}
                                      context:nil];
    
    return requriedSize.size.height;
}

#pragma mark - Reply and Retweet logic 

- (void) reply:(UIButton *) button {
    NSLog(@"%ld", button.tag);
}

- (void) retweet:(UIButton *) button {
    NSLog(@"%ld", button.tag);
}

@end
