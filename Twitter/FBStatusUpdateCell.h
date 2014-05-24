//
//  FBStatusUpdateCell.h
//  Twitter
//
//  Created by mfb on 5/24/14.
//  Copyright (c) 2014 bulutmf. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FBStatusUpdateCell : UITableViewCell

@property (strong, nonatomic) UIImageView *profileImageView;
@property (strong, nonatomic) UILabel *nameLabel;
@property (strong, nonatomic) UILabel *statusUpdate;
@property (strong, nonatomic) UIButton *replyButton;
@property (strong, nonatomic) UIButton *retweetButton;
@property (strong, nonatomic) UIActivityIndicatorView *actIndicator;


@end
