//
//  FBProfileCell.m
//  Twitter
//
//  Created by mfb on 5/23/14.
//  Copyright (c) 2014 bulutmf. All rights reserved.
//

#import "FBProfileCell.h"
#import <QuartzCore/QuartzCore.h>
#import "UIFont+Twitter.h"

@implementation FBProfileCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [UIColor lightGrayColor];
        //CGRect contentFrame = self.contentView.frame;
        float imageSize = 50;
        
        self.profileImageView = [[UIImageView alloc] init];
        self.profileImageView.layer.masksToBounds = YES;
        self.profileImageView.layer.cornerRadius = 7;
        [self.contentView addSubview:self.profileImageView];
        
        self.nameLabel = [[UILabel alloc] init];
        self.nameLabel.font = [UIFont t_regularPostFont];
        //self.nameLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:self.nameLabel];
        
        self.bioLabel = [[UILabel alloc] init];
        self.bioLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        self.bioLabel.numberOfLines = 0;
        self.bioLabel.font = [UIFont italicSystemFontOfSize:11];
        [self.contentView addSubview:self.bioLabel];
        
        self.actIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        [self.actIndicator startAnimating];
        [self.contentView addSubview:self.actIndicator];
        
        
        self.profileImageView.translatesAutoresizingMaskIntoConstraints = NO;
        self.nameLabel.translatesAutoresizingMaskIntoConstraints = NO;
        self.bioLabel.translatesAutoresizingMaskIntoConstraints = NO;
        self.actIndicator.translatesAutoresizingMaskIntoConstraints = NO;
        
        // Lets do it with auto layout
        NSLayoutConstraint *imageViewConstraint = [NSLayoutConstraint constraintWithItem:self.profileImageView
                                                                               attribute:NSLayoutAttributeLeft
                                                                               relatedBy:NSLayoutRelationEqual
                                                                                  toItem:self.contentView
                                                                               attribute:NSLayoutAttributeLeft
                                                                              multiplier:1
                                                                                constant:10];
        NSLayoutConstraint *imageViewConstraintTop = [NSLayoutConstraint constraintWithItem:self.profileImageView
                                                                                  attribute:NSLayoutAttributeTop
                                                                                  relatedBy:NSLayoutRelationEqual
                                                                                     toItem:self.contentView
                                                                                  attribute:NSLayoutAttributeTop
                                                                                 multiplier:1
                                                                                   constant:20];
        NSLayoutConstraint *imageViewWidthConstraint = [NSLayoutConstraint constraintWithItem:self.profileImageView
                                                                                   attribute:NSLayoutAttributeWidth
                                                                                   relatedBy:NSLayoutRelationEqual
                                                                                      toItem:nil
                                                                                   attribute:NSLayoutAttributeNotAnAttribute
                                                                                  multiplier:1
                                                                                    constant:imageSize];
        NSLayoutConstraint *imageViewHeightConstraint = [NSLayoutConstraint constraintWithItem:self.profileImageView
                                                                                    attribute:NSLayoutAttributeHeight
                                                                                    relatedBy:NSLayoutRelationEqual
                                                                                       toItem:nil
                                                                                    attribute:NSLayoutAttributeNotAnAttribute
                                                                                   multiplier:1
                                                                                     constant:imageSize];
        NSLayoutConstraint *nameLabelConstraint = [NSLayoutConstraint constraintWithItem:self.nameLabel
                                                                                attribute:NSLayoutAttributeLeft
                                                                                relatedBy:NSLayoutRelationEqual
                                                                                   toItem:self.profileImageView
                                                                                attribute:NSLayoutAttributeRight
                                                                               multiplier:1
                                                                                 constant:10];
        NSLayoutConstraint *nameLabelConstraintTop = [NSLayoutConstraint constraintWithItem:self.nameLabel
                                                                                  attribute:NSLayoutAttributeTop
                                                                                  relatedBy:NSLayoutRelationEqual
                                                                                     toItem:self.contentView
                                                                                  attribute:NSLayoutAttributeTop
                                                                                 multiplier:1
                                                                                   constant:20];
        NSLayoutConstraint *nameLabelWidthConstraint = [NSLayoutConstraint constraintWithItem:self.nameLabel
                                                                                   attribute:NSLayoutAttributeWidth
                                                                                   relatedBy:NSLayoutRelationEqual
                                                                                      toItem:nil
                                                                                   attribute:NSLayoutAttributeNotAnAttribute
                                                                                  multiplier:1
                                                                                    constant:self.contentView.frame.size.width-imageSize-10-80];
        NSLayoutConstraint *nameLabelHeightConstraint = [NSLayoutConstraint constraintWithItem:self.nameLabel
                                                                                    attribute:NSLayoutAttributeHeight
                                                                                    relatedBy:NSLayoutRelationEqual
                                                                                       toItem:nil
                                                                                    attribute:NSLayoutAttributeNotAnAttribute
                                                                                   multiplier:1
                                                                                     constant:20];
        NSLayoutConstraint *bioLabelConstraint = [NSLayoutConstraint constraintWithItem:self.bioLabel
                                                                             attribute:NSLayoutAttributeLeft
                                                                             relatedBy:NSLayoutRelationEqual
                                                                                toItem:self.profileImageView
                                                                             attribute:NSLayoutAttributeRight
                                                                            multiplier:1
                                                                              constant:10];
        NSLayoutConstraint *bioLabelConstraintTop = [NSLayoutConstraint constraintWithItem:self.bioLabel
                                                                                attribute:NSLayoutAttributeTop
                                                                                relatedBy:NSLayoutRelationEqual
                                                                                   toItem:self.nameLabel
                                                                                attribute:NSLayoutAttributeBottom
                                                                               multiplier:1
                                                                                 constant:0];
        
        NSLayoutConstraint *bioLabelWidthConstraint = [NSLayoutConstraint constraintWithItem:self.bioLabel
                                                                                   attribute:NSLayoutAttributeWidth
                                                                                   relatedBy:NSLayoutRelationEqual
                                                                                      toItem:self.nameLabel
                                                                                   attribute:NSLayoutAttributeWidth
                                                                                  multiplier:1
                                                                                    constant:0];
        NSLayoutConstraint *bioLabelHeightConstraint = [NSLayoutConstraint constraintWithItem:self.bioLabel
                                                                                   attribute:NSLayoutAttributeHeight
                                                                                   relatedBy:NSLayoutRelationEqual
                                                                                      toItem:nil
                                                                                   attribute:NSLayoutAttributeNotAnAttribute
                                                                                  multiplier:1
                                                                                    constant:30];
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
        
        
        [self.contentView addConstraints:@[imageViewConstraint,
                                           imageViewConstraintTop,
                                           imageViewWidthConstraint,
                                           imageViewHeightConstraint,
                                           nameLabelConstraint,
                                           nameLabelConstraintTop,
                                           nameLabelWidthConstraint,
                                           nameLabelHeightConstraint,
                                           bioLabelConstraint,
                                           bioLabelConstraintTop,
                                           bioLabelWidthConstraint,
                                           bioLabelHeightConstraint,
                                           actIndX,
                                           actIndY]];
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
