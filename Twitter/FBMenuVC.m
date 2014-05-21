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

@interface FBMenuVC ()

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableView Data Source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *cellIdentifier = @"Cell";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	NSInteger row = indexPath.row;
    
	if (nil == cell)
	{
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
	}
	
    
    if (row == 0) {
        cell.textLabel.text = @"Home";
    } else if (row == 1) {
        cell.textLabel.text = @"Notifications";
    } else {
        cell.textLabel.text = @"Others";
    }
	
	
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SWRevealViewController *revealController = self.revealViewController;
    UINavigationController *frontNavigationController = (id)revealController.frontViewController;
    
    if (indexPath.row == 0) {
        if (![[frontNavigationController topViewController] isKindOfClass:[FBHomeVC class]]) {
            FBHomeVC *homeVC = [[FBHomeVC alloc] init];
            UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:homeVC];
            [revealController pushFrontViewController:navController animated:YES];
        } else {
            [revealController revealToggle:self];
        }
    }
    
    
	
}

@end
