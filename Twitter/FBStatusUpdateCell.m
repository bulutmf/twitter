//
//  FBStatusUpdateCell.m
//  Twitter
//
//  Created by mfb on 5/24/14.
//  Copyright (c) 2014 bulutmf. All rights reserved.
//

#import "FBStatusUpdateCell.h"
#import <QuartzCore/QuartzCore.h>
#import "UIFont+Twitter.h"

@implementation FBStatusUpdateCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.profileImageView = [[UIImageView alloc] init];
        self.profileImageView.layer.masksToBounds = YES;
        self.profileImageView.layer.cornerRadius = 7;
        
        self.actIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        [self.actIndicator startAnimating];
        [self.contentView addSubview:self.actIndicator];
        
        self.nameLabel = [[UILabel alloc] init];
        self.nameLabel.font = [UIFont t_titleFont];
        
        self.statusUpdate = [[UILabel alloc] init];
        self.statusUpdate.font = [UIFont t_regularPostFont];
        self.statusUpdate.lineBreakMode = NSLineBreakByWordWrapping;
        self.statusUpdate.numberOfLines = 0;
        
        self.replyButton = [[UIButton alloc] init];
        [self.replyButton setTitle:@"Reply" forState:UIControlStateNormal];
        [self.replyButton.titleLabel setFont:[UIFont t_rsmallerPostFont]];
        [self.replyButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        
        self.retweetButton = [[UIButton alloc] init];
        [self.retweetButton setTitle:@"Retweet" forState:UIControlStateNormal];
        [self.retweetButton.titleLabel setFont:[UIFont t_rsmallerPostFont]];
        [self.retweetButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        
        self.profileImageView.translatesAutoresizingMaskIntoConstraints = NO;
        self.nameLabel.translatesAutoresizingMaskIntoConstraints = NO;
        self.statusUpdate.translatesAutoresizingMaskIntoConstraints = NO;
        self.replyButton.translatesAutoresizingMaskIntoConstraints = NO;
        self.retweetButton.translatesAutoresizingMaskIntoConstraints = NO;
        self.actIndicator.translatesAutoresizingMaskIntoConstraints = NO;
        
        [self.contentView addSubview:self.profileImageView];
        [self.contentView addSubview:self.nameLabel];
        [self.contentView addSubview:self.statusUpdate];
        [self.contentView addSubview:self.replyButton];
        [self.contentView addSubview:self.retweetButton];
        [self.contentView addSubview:self.actIndicator];
        
        
        NSLayoutConstraint *profileImageConstraintWidth = [NSLayoutConstraint constraintWithItem:self.profileImageView
                                                                                      attribute:NSLayoutAttributeWidth
                                                                                      relatedBy:NSLayoutRelationEqual
                                                                                         toItem:nil
                                                                                      attribute:NSLayoutAttributeNotAnAttribute
                                                                                     multiplier:1
                                                                                       constant:40];
        NSLayoutConstraint *profileImageConstraintHeight = [NSLayoutConstraint constraintWithItem:self.profileImageView
                                                                                       attribute:NSLayoutAttributeHeight
                                                                                       relatedBy:NSLayoutRelationEqual
                                                                                          toItem:nil
                                                                                       attribute:NSLayoutAttributeNotAnAttribute
                                                                                      multiplier:1
                                                                                        constant:40];
        NSLayoutConstraint *profileImageConstraintLeft = [NSLayoutConstraint constraintWithItem:self.profileImageView
                                                                                      attribute:NSLayoutAttributeLeft
                                                                                      relatedBy:NSLayoutRelationEqual
                                                                                         toItem:self.contentView
                                                                                      attribute:NSLayoutAttributeLeft
                                                                                     multiplier:1
                                                                                       constant:10];
        NSLayoutConstraint *profileImageConstraintTop = [NSLayoutConstraint constraintWithItem:self.profileImageView
                                                                                      attribute:NSLayoutAttributeTop
                                                                                      relatedBy:NSLayoutRelationEqual
                                                                                         toItem:self.contentView
                                                                                      attribute:NSLayoutAttributeTop
                                                                                     multiplier:1
                                                                                       constant:10];
        [self.contentView addConstraints:@[profileImageConstraintWidth,
                                           profileImageConstraintHeight,
                                           profileImageConstraintLeft,
                                           profileImageConstraintTop]];
        
        
        
        // Activity indicator
        NSLayoutConstraint *actIndX = [NSLayoutConstraint constraintWithItem:self.actIndicator
                                                                   attribute:NSLayoutAttributeCenterX
                                                                   relatedBy:NSLayoutRelationEqual
                                                                      toItem:self.profileImageView
                                                                   attribute:NSLayoutAttributeCenterX
                                                                  multiplier:1
                                                                    constant:0];
        NSLayoutConstraint *actIndY = [NSLayoutConstraint constraintWithItem:self.actIndicator
                                                                   attribute:NSLayoutAttributeCenterY
                                                                   relatedBy:NSLayoutRelationEqual
                                                                      toItem:self.profileImageView
                                                                   attribute:NSLayoutAttributeCenterY
                                                                  multiplier:1
                                                                    constant:0];
        
        [self.contentView addConstraints:@[actIndX, actIndY]];
        
        // Name label
        NSLayoutConstraint *nameLabelWidth = [NSLayoutConstraint constraintWithItem:self.nameLabel
                                                                                  attribute:NSLayoutAttributeWidth
                                                                                  relatedBy:NSLayoutRelationEqual
                                                                                     toItem:nil
                                                                                  attribute:NSLayoutAttributeNotAnAttribute
                                                                                 multiplier:1
                                                                                   constant:self.contentView.frame.size.width - 10 - 40 - 5 - 5];
        NSLayoutConstraint *nameLabelHeight = [NSLayoutConstraint constraintWithItem:self.nameLabel
                                                                          attribute:NSLayoutAttributeHeight
                                                                          relatedBy:NSLayoutRelationEqual
                                                                             toItem:nil
                                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                                         multiplier:1
                                                                           constant:15];
        
        NSLayoutConstraint *nameLabelConstraintLeft = [NSLayoutConstraint constraintWithItem:self.nameLabel
                                                                                     attribute:NSLayoutAttributeLeft
                                                                                     relatedBy:NSLayoutRelationEqual
                                                                                        toItem:self.profileImageView
                                                                                     attribute:NSLayoutAttributeRight
                                                                                    multiplier:1
                                                                                      constant:5];
        NSLayoutConstraint *nameLabelConstraintTop = [NSLayoutConstraint constraintWithItem:self.nameLabel
                                                                                    attribute:NSLayoutAttributeTop
                                                                                    relatedBy:NSLayoutRelationEqual
                                                                                       toItem:self.contentView
                                                                                    attribute:NSLayoutAttributeTop
                                                                                   multiplier:1
                                                                                     constant:10];
        [self.contentView addConstraints:@[nameLabelHeight,
                                           nameLabelWidth,
                                           nameLabelConstraintLeft,
                                           nameLabelConstraintTop]];
        
        // Status update label
        NSLayoutConstraint *statusUpdateLabelWidth = [NSLayoutConstraint constraintWithItem:self.statusUpdate
                                                                                       attribute:NSLayoutAttributeWidth
                                                                                       relatedBy:NSLayoutRelationEqual
                                                                                          toItem:nil
                                                                                       attribute:NSLayoutAttributeNotAnAttribute
                                                                                      multiplier:1
                                                                                        constant:self.contentView.frame.size.width - 10 - 40 - 5 - 5];
        
        NSLayoutConstraint *statusLabelConstraintLeft = [NSLayoutConstraint constraintWithItem:self.statusUpdate
                                                                                      attribute:NSLayoutAttributeLeft
                                                                                      relatedBy:NSLayoutRelationEqual
                                                                                         toItem:self.profileImageView
                                                                                      attribute:NSLayoutAttributeRight
                                                                                     multiplier:1
                                                                                       constant:5];
        NSLayoutConstraint *statusLabelConstraintTop = [NSLayoutConstraint constraintWithItem:self.statusUpdate
                                                                                     attribute:NSLayoutAttributeTop
                                                                                     relatedBy:NSLayoutRelationEqual
                                                                                        toItem:self.nameLabel
                                                                                     attribute:NSLayoutAttributeBottom
                                                                                    multiplier:1
                                                                                      constant:0];
        [self.contentView addConstraints:@[statusUpdateLabelWidth,
                                           statusLabelConstraintLeft,
                                           statusLabelConstraintTop]];
        
        
        // Reply Button
        NSLayoutConstraint *replyButtonConstraintLeft = [NSLayoutConstraint constraintWithItem:self.replyButton
                                                                                     attribute:NSLayoutAttributeLeft
                                                                                     relatedBy:NSLayoutRelationEqual
                                                                                        toItem:self.profileImageView
                                                                                     attribute:NSLayoutAttributeRight
                                                                                    multiplier:1
                                                                                      constant:5];
        NSLayoutConstraint *replyButtonConstraintTop = [NSLayoutConstraint constraintWithItem:self.replyButton
                                                                                    attribute:NSLayoutAttributeTop
                                                                                    relatedBy:NSLayoutRelationEqual
                                                                                       toItem:self.statusUpdate
                                                                                    attribute:NSLayoutAttributeBottom
                                                                                   multiplier:1
                                                                                     constant:0];
        [self.contentView addConstraints:@[replyButtonConstraintLeft, replyButtonConstraintTop]];
        
        
        // Retweet button
        NSLayoutConstraint *retweetButtonConstraintLeft = [NSLayoutConstraint constraintWithItem:self.retweetButton
                                                                                     attribute:NSLayoutAttributeLeft
                                                                                     relatedBy:NSLayoutRelationEqual
                                                                                        toItem:self.replyButton
                                                                                     attribute:NSLayoutAttributeRight
                                                                                    multiplier:1
                                                                                      constant:10];
        NSLayoutConstraint *retweetButtonConstraintTop = [NSLayoutConstraint constraintWithItem:self.retweetButton
                                                                                    attribute:NSLayoutAttributeTop
                                                                                    relatedBy:NSLayoutRelationEqual
                                                                                       toItem:self.statusUpdate
                                                                                    attribute:NSLayoutAttributeBottom
                                                                                   multiplier:1
                                                                                     constant:0];
        
        [self.contentView addConstraints:@[retweetButtonConstraintLeft, retweetButtonConstraintTop]];
        
        
        
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
