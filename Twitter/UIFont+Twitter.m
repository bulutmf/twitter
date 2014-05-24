//
//  UIFont+Twitter.m
//  Twitter
//
//  Created by mfb on 5/24/14.
//  Copyright (c) 2014 bulutmf. All rights reserved.
//

#import "UIFont+Twitter.h"

@implementation UIFont (Twitter)

+ (UIFont *) t_regularPostFont {
    return [UIFont fontWithName:@"Helvetica" size:14];
    
}

+ (UIFont *) t_rsmallerPostFont {
    return [UIFont fontWithName:@"Helvetica" size:12];
}

+ (UIFont *) t_titleFont {
    return [UIFont fontWithName:@"Helvetica-Bold" size:12];
}

@end
