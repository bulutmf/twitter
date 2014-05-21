//
//  FBUtils.h
//  Twitter
//
//  Created by mfb on 5/21/14.
//  Copyright (c) 2014 bulutmf. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FBUtils : NSObject

+ (void) executeAsyncBlock:(void (^)(void (^completionBlock)(void))) blockToExecute;
+ (void) showPopupMessageInView:(UIViewController *) viewController title:(NSString *) title message:(NSString *) msg;

@end
