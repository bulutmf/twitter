//
//  FBAppDelegate.h
//  Twitter
//
//  Created by mfb on 5/20/14.
//  Copyright (c) 2014 bulutmf. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SWRevealViewController;

@interface FBAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) SWRevealViewController *viewController;
@property (strong, nonatomic) NSDictionary *accountOwner;// Info about the user

@end
