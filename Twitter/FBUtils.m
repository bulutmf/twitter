//
//  FBUtils.m
//  Twitter
//
//  Created by mfb on 5/21/14.
//  Copyright (c) 2014 bulutmf. All rights reserved.
//

#import "FBUtils.h"
#import <Accounts/Accounts.h>
#import <Social/Social.h>
#import "SVProgressHUD.h"

@implementation FBUtils

+ (void) executeAsyncBlock:(void (^)(void (^completionBlock)(void))) blockToExecute {
    
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    void (^completionBlock)(void) = ^ {
        dispatch_semaphore_signal(semaphore);
    };
    blockToExecute(completionBlock);
    while (dispatch_semaphore_wait(semaphore, DISPATCH_TIME_NOW)) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode
                                 beforeDate:[NSDate dateWithTimeIntervalSinceNow:30]];
    }
}

+ (void) showPopupMessageInView:(UIViewController *) viewController title:(NSString *) title message:(NSString *) msg {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:msg
                                                   delegate:viewController
                                          cancelButtonTitle:nil
                                          otherButtonTitles:@"OK", nil];
    [alert show];
}


#pragma mark - check Twitter authorization

+ (BOOL) checkAuthorization:(UIViewController *) viewController {
    
    // Check availability
    if (![FBUtils isTwitterAvailable]) {
        [FBUtils showPopupMessageInView:viewController title:@"" message:@"Please add a Twitter account from Settings"];
        return NO;
    }
    
    // Check authorization
    __block bool statusW = NO;
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    [FBUtils checkAuthorizationWithViewController:(UIViewController *) viewController block:^void(bool status) {
        statusW = status;
        dispatch_semaphore_signal(semaphore);
    }];
    
    while (dispatch_semaphore_wait(semaphore, DISPATCH_TIME_NOW)) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode
                                 beforeDate:[NSDate dateWithTimeIntervalSinceNow:30]];
    }
    
    return statusW;
}

+ (BOOL) isTwitterAvailable {
    return [SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter];
}

+ (void) checkAuthorizationWithViewController:(UIViewController *) viewController block:(void (^)(bool)) completionBlock {
    
    ACAccountStore *accountStore = [[ACAccountStore alloc] init];
    ACAccountType *accountType = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    [accountStore requestAccessToAccountsWithType:accountType options:nil completion:^(BOOL granted, NSError *error) {
        
        if (error == nil) {
            if (granted) {
                NSLog(@"Granted");
                // Authorized
                completionBlock(YES);
                
            } else {
                NSLog(@"Please authenticate our app!");
                dispatch_async(dispatch_get_main_queue(), ^{
                    [SVProgressHUD dismiss];
                    [FBUtils showPopupMessageInView:viewController title:@"" message:@"Please authenticate the app from Settings!"];
                    completionBlock(NO);
                });
            }
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [SVProgressHUD dismiss];
                [FBUtils showPopupMessageInView:viewController title:@"" message:[error description]];
                completionBlock(NO);
            });
        }
        
    }];
}

@end
