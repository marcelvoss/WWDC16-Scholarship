//
//  ProjectCollectionViewCell.m
//  Marcel Voss
//
//  Created by Marcel Voß on 25.04.16.
//  Copyright © 2016 Marcel Voß. All rights reserved.
//

#import "ProjectCollectionViewCell.h"

#import "Constants.h"
#import "UIColor+Colors.h"
#import "Topic.h"
#import "TopicApp.h"
#import "InteractiveImageView.h"

@interface ProjectCollectionViewCell ()
{
    UILabel *appLabel;
    UILabel *subtitleLabel;
    UILabel *textLabel;
    
    UIButton *appIconButton;
    UIView *backgroundView;
    
    TopicApp *topicApp;
    BOOL drawerOpen;
    
    NSLayoutConstraint *heightConstraint;
    
    UIBezierPath *maskPathTop;
    UIBezierPath *maskPathBottom;
    
    CAShapeLayer *maskLayerTop;
    CAShapeLayer *maskLayerBottom;
}

@end

@implementation ProjectCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = 12;
        
        // TODO: Add 3D Touch to button
        backgroundView = [[UIView alloc] init];
        backgroundView.translatesAutoresizingMaskIntoConstraints = NO;
        backgroundView.layer.masksToBounds = YES;
        [self.contentView addSubview:backgroundView];
        
        
        [self addConstraint:[NSLayoutConstraint constraintWithItem:backgroundView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
        
        [self addConstraint:[NSLayoutConstraint constraintWithItem:backgroundView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTop multiplier:1.0 constant:0]];
        
        [self addConstraint:[NSLayoutConstraint constraintWithItem:backgroundView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0]];
        
        heightConstraint = [NSLayoutConstraint constraintWithItem:backgroundView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1.0 constant:self.frame.size.height];
        [self addConstraint:heightConstraint];
        
        
        maskPathBottom = [UIBezierPath bezierPathWithRoundedRect:self.contentView.bounds byRoundingCorners:( UIRectCornerBottomLeft | UIRectCornerBottomRight | UIRectCornerTopLeft | UIRectCornerTopRight) cornerRadii:CGSizeMake(12.0, 12.0)];
        
        maskLayerBottom = [[CAShapeLayer alloc] init];
        maskLayerBottom.frame = self.bounds;
        maskLayerBottom.path  = maskPathBottom.CGPath;
        self.contentView.layer.mask = maskLayerBottom;
        
        
        
        drawerOpen = NO;
        
        appIconButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [appIconButton addTarget:self action:@selector(appButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        appIconButton.translatesAutoresizingMaskIntoConstraints = NO;
        [backgroundView addSubview:appIconButton];
        
        [self addConstraint:[NSLayoutConstraint constraintWithItem:appIconButton attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:backgroundView attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
        
        [self addConstraint:[NSLayoutConstraint constraintWithItem:appIconButton attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:backgroundView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:-10]];
        
        [self addConstraint:[NSLayoutConstraint constraintWithItem:appIconButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeWidth multiplier:1.0 constant:80]];
        
        [self addConstraint:[NSLayoutConstraint constraintWithItem:appIconButton attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1.0 constant:80]];
        
        
        appLabel = [[UILabel alloc] init];
        appLabel.textAlignment = NSTextAlignmentLeft;
        appLabel.translatesAutoresizingMaskIntoConstraints = NO;
        appLabel.font = [UIFont boldSystemFontOfSize:20];
        [backgroundView addSubview:appLabel];
        
        [self addConstraint:[NSLayoutConstraint constraintWithItem:appLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:appIconButton attribute:NSLayoutAttributeBottom multiplier:1.0 constant:5]];
        
        [self addConstraint:[NSLayoutConstraint constraintWithItem:appLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:backgroundView attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
        
        
        textLabel = [[UILabel alloc] init];
        textLabel.textAlignment = NSTextAlignmentCenter;
        textLabel.font = [UIFont systemFontOfSize:15];
        textLabel.numberOfLines = 0;
        textLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [self.contentView addSubview:textLabel];
        
        [self addConstraint:[NSLayoutConstraint constraintWithItem:textLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
        
        [self addConstraint:[NSLayoutConstraint constraintWithItem:textLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:backgroundView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:10]];
        
        [self addConstraint:[NSLayoutConstraint constraintWithItem:textLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeWidth multiplier:1.0 constant:-40]];
        
    }
    return self;
}

- (void)appButtonPressed:(id)sender
{
    if (drawerOpen) {
        
        heightConstraint.constant = self.frame.size.height;
        [UIView animateWithDuration:0.3 delay:0.0 usingSpringWithDamping:0.8 initialSpringVelocity:0.6 options:UIViewAnimationOptionCurveEaseIn animations:^{
            
            [self layoutIfNeeded];
        } completion:^(BOOL finished) {
            
        }];
        
        drawerOpen = NO;
        
    } else {
        
        heightConstraint.constant = 150;
        [UIView animateWithDuration:0.3 delay:0.0 usingSpringWithDamping:0.8 initialSpringVelocity:0.6 options:UIViewAnimationOptionCurveEaseIn animations:^{
            [self layoutIfNeeded];
        } completion:^(BOOL finished) {
            
        }];
        
        drawerOpen = YES;
        
    }
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    [self setNeedsDisplay];
}

- (void)setTopic:(Topic *)topic
{
    _topic = topic;
    topicApp = topic.topicApp;

    [appIconButton setImage:topicApp.icon forState:UIControlStateNormal];
    appLabel.text = topicApp.name;
    subtitleLabel.text = topicApp.subtitle;
    
    // Terrible way to do it; was to lazy to make it better
    if ([topicApp.name isEqualToString:@"PhoneBattery"]) {
        appLabel.textColor = [UIColor whiteColor];
        backgroundView.backgroundColor = [UIColor colorWithRed:0.29 green:0.82 blue:0.55 alpha:1.00];
    } else if ([topicApp.name isEqualToString:@"BluePixel"]) {
        appLabel.textColor = [UIColor whiteColor];
        backgroundView.backgroundColor = [UIColor colorWithRed:0.06 green:0.45 blue:0.96 alpha:1.00];
    } else if ([topicApp.name isEqualToString:@"Grain"]) {
        backgroundView.backgroundColor = [UIColor colorWithRed:0.09 green:0.60 blue:0.89 alpha:1.00];
        appLabel.textColor = [UIColor whiteColor];
    } else if ([topicApp.name isEqualToString:@"MVDribbbleKit"]) {
        backgroundView.backgroundColor = [UIColor colorWithRed:0.89 green:0.19 blue:0.46 alpha:1.00];
        appLabel.textColor = [UIColor colorWithRed:0.15 green:0.15 blue:0.15 alpha:1.00];
    }
    
    // TODO: Add to other card cells
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineSpacing = 10;
    [paraStyle setAlignment:NSTextAlignmentCenter];
    
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:topicApp.descriptionText];
    [string addAttribute:NSParagraphStyleAttributeName value:paraStyle range:NSMakeRange(0, string.length)];
    textLabel.attributedText = string;
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    
    appLabel.text = nil;
    subtitleLabel.text = nil;
    textLabel.text = nil;
    _topic = nil;
    topicApp = nil;

    [self setNeedsLayout];
}

@end
