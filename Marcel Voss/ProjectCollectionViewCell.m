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
#import "UIImage+Helpers.h"

@interface ProjectCollectionViewCell ()
{
    UILabel *appLabel;
    UILabel *subtitleLabel;
    UILabel *textLabel;
    
    UIButton *appIconButton;
    UIView *backgroundView;
    UIView *dockView;
    
    TopicApp *topicApp;
    BOOL drawerOpen;
    BOOL enabledOverlayBlur;
    
    NSLayoutConstraint *heightConstraint;
    NSLayoutConstraint *dockHeightConstraint;
    
    UIBezierPath *maskPathTop;
    UIBezierPath *maskPathBottom;
    
    CAShapeLayer *maskLayerTop;
    CAShapeLayer *maskLayerBottom;
    UIButton *moreButton;
    
    InteractiveImageView *screen1;
    InteractiveImageView *screen2;
    InteractiveImageView *screen3;
}

@property (nonatomic) UIVisualEffectView *visualEffectView;

@end

@implementation ProjectCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = 12;
        
        drawerOpen = NO;
        enabledOverlayBlur = NO;
        
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
        
        
        dockView = [[UIView alloc] init];
        dockView.translatesAutoresizingMaskIntoConstraints = NO;
        dockView.backgroundColor = [UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1.00];
        [self.contentView addSubview:dockView];
        
        [self addConstraint:[NSLayoutConstraint constraintWithItem:dockView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:backgroundView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];
        
        [self addConstraint:[NSLayoutConstraint constraintWithItem:dockView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:backgroundView attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
        
        [self addConstraint:[NSLayoutConstraint constraintWithItem:dockView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:backgroundView attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0]];
        
        dockHeightConstraint = [NSLayoutConstraint constraintWithItem:dockView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1.0 constant:50];
        [self addConstraint:dockHeightConstraint];
        
        
        textLabel = [[UILabel alloc] init];
        textLabel.textAlignment = NSTextAlignmentCenter;
        textLabel.font = [UIFont systemFontOfSize:15];
        textLabel.numberOfLines = 0;
        textLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [self.contentView addSubview:textLabel];
        
        [self addConstraint:[NSLayoutConstraint constraintWithItem:textLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
        
        [self addConstraint:[NSLayoutConstraint constraintWithItem:textLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:dockView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:10]];
        
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

- (void)setupDribbble
{
    // TODO: Implement MVDribbbleKit features
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
        
        [self addButtonToDock];
    } else if ([topicApp.name isEqualToString:@"Grain"]) {
        backgroundView.backgroundColor = [UIColor colorWithRed:0.09 green:0.60 blue:0.89 alpha:1.00];
        appLabel.textColor = [UIColor whiteColor];
        
        [self addButtonToDock];
    } else if ([topicApp.name isEqualToString:@"MVDribbbleKit"]) {
        backgroundView.backgroundColor = [UIColor colorWithRed:0.89 green:0.19 blue:0.46 alpha:1.00];
        appLabel.textColor = [UIColor colorWithRed:0.15 green:0.15 blue:0.15 alpha:1.00];
        
        dockHeightConstraint.constant = 80;
        [self layoutIfNeeded];
        
        //UILabel
    }
    
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineSpacing = 6;
    [paraStyle setAlignment:NSTextAlignmentCenter];
    
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:topicApp.descriptionText];
    [string addAttribute:NSParagraphStyleAttributeName value:paraStyle range:NSMakeRange(0, string.length)];
    textLabel.attributedText = string;
}

- (void)addButtonToDock
{
    dockHeightConstraint.constant = 50;
    [self layoutIfNeeded];
    
    moreButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [moreButton setTitle:@"Show More" forState:UIControlStateNormal];
    [moreButton setImage:[UIImage imageFromColor:[UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1.00]] forState:UIControlStateNormal];
    moreButton.titleLabel.font = [UIFont systemFontOfSize:14];
    moreButton.contentHorizontalAlignment = NSTextAlignmentLeft;
    moreButton.translatesAutoresizingMaskIntoConstraints = NO;
    [moreButton addTarget:self action:@selector(moreButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [moreButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    moreButton.titleLabel.textAlignment = UIControlContentHorizontalAlignmentLeft;
    [dockView addSubview:moreButton];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:moreButton attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:dockView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:moreButton attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:dockView attribute:NSLayoutAttributeHeight multiplier:1.0 constant:0]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:moreButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:dockView attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:moreButton attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:dockView attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
    
    
    _visualEffectView = [[UIVisualEffectView alloc] initWithFrame:backgroundView.frame];
    
    
    
}

- (void)moreButtonPressed:(id)sender
{
    if ([topicApp.name isEqualToString:@"PhoneBattery"]) {
        [self showOverlayView];
        
        screen1 = [[InteractiveImageView alloc] initWithImage:[UIImage imageNamed:@"PhoneBattery1"]];
        screen1.translatesAutoresizingMaskIntoConstraints = NO;
        screen1.contentMode = UIViewContentModeScaleAspectFill;
        screen1.clipsToBounds = YES;
        screen1.alpha = 0;
        screen1.layer.masksToBounds = YES;
        screen1.layer.cornerRadius = 6;
        [backgroundView addSubview:screen1];
        
        [self addConstraint:[NSLayoutConstraint constraintWithItem:screen1 attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:backgroundView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
        
        [self addConstraint:[NSLayoutConstraint constraintWithItem:screen1 attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1.0 constant:75]];
        
        [self addConstraint:[NSLayoutConstraint constraintWithItem:screen1 attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeWidth multiplier:1.0 constant:75]];
        
        [self addConstraint:[NSLayoutConstraint constraintWithItem:screen1 attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:backgroundView attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
        
        
        screen2 = [[InteractiveImageView alloc] initWithImage:[UIImage imageNamed:@"PhoneBattery2"]];
        screen2.translatesAutoresizingMaskIntoConstraints = NO;
        screen2.contentMode = UIViewContentModeScaleAspectFill;
        screen2.clipsToBounds = YES;
        screen2.alpha = 0;
        screen2.layer.masksToBounds = YES;
        screen2.layer.cornerRadius = 6;
        [backgroundView addSubview:screen2];
        
        [self addConstraint:[NSLayoutConstraint constraintWithItem:screen2 attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:backgroundView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
        
        [self addConstraint:[NSLayoutConstraint constraintWithItem:screen2 attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1.0 constant:75]];
        
        [self addConstraint:[NSLayoutConstraint constraintWithItem:screen2 attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeWidth multiplier:1.0 constant:75]];
        
        [self addConstraint:[NSLayoutConstraint constraintWithItem:screen2 attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:screen1 attribute:NSLayoutAttributeLeft multiplier:1.0 constant:-40]];
        
        
        screen3 = [[InteractiveImageView alloc] initWithImage:[UIImage imageNamed:@"PhoneBattery3"]];
        screen3.translatesAutoresizingMaskIntoConstraints = NO;
        screen3.contentMode = UIViewContentModeScaleAspectFill;
        screen3.clipsToBounds = YES;
        screen3.alpha = 0;
        screen3.layer.masksToBounds = YES;
        screen3.layer.cornerRadius = 6;
        [backgroundView addSubview:screen3];
        
        [self addConstraint:[NSLayoutConstraint constraintWithItem:screen3 attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:backgroundView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
        
        [self addConstraint:[NSLayoutConstraint constraintWithItem:screen3 attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1.0 constant:75]];
        
        [self addConstraint:[NSLayoutConstraint constraintWithItem:screen3 attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeWidth multiplier:1.0 constant:75]];
        
        [self addConstraint:[NSLayoutConstraint constraintWithItem:screen3 attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:screen1 attribute:NSLayoutAttributeRight multiplier:1.0 constant:40]];
        
        
        [UIView animateWithDuration:0.3 delay:0.1 options:UIViewAnimationOptionCurveEaseIn animations:^{
            screen1.alpha = 1;
            screen2.alpha = 1;
            screen3.alpha = 1;
        } completion:^(BOOL finished) {
            
        }];
        
        
    } else if ([topicApp.name isEqualToString:@"Grain"]) {
        [self showOverlayView];
        
        screen1 = [[InteractiveImageView alloc] initWithImage:[UIImage imageNamed:@"Grain1"]];
        screen1.translatesAutoresizingMaskIntoConstraints = NO;
        screen1.contentMode = UIViewContentModeScaleAspectFill;
        screen1.clipsToBounds = YES;
        screen1.alpha = 0;
        screen1.layer.masksToBounds = YES;
        screen1.layer.cornerRadius = 6;
        [backgroundView addSubview:screen1];
        
        [self addConstraint:[NSLayoutConstraint constraintWithItem:screen1 attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:backgroundView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
        
        [self addConstraint:[NSLayoutConstraint constraintWithItem:screen1 attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1.0 constant:75]];
        
        [self addConstraint:[NSLayoutConstraint constraintWithItem:screen1 attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeWidth multiplier:1.0 constant:75]];
        
        [self addConstraint:[NSLayoutConstraint constraintWithItem:screen1 attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:backgroundView attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
        
        
        screen2 = [[InteractiveImageView alloc] initWithImage:[UIImage imageNamed:@"Grain2"]];
        screen2.translatesAutoresizingMaskIntoConstraints = NO;
        screen2.contentMode = UIViewContentModeScaleAspectFill;
        screen2.clipsToBounds = YES;
        screen2.alpha = 0;
        screen2.layer.masksToBounds = YES;
        screen2.layer.cornerRadius = 6;
        [backgroundView addSubview:screen2];
        
        [self addConstraint:[NSLayoutConstraint constraintWithItem:screen2 attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:backgroundView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
        
        [self addConstraint:[NSLayoutConstraint constraintWithItem:screen2 attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1.0 constant:75]];
        
        [self addConstraint:[NSLayoutConstraint constraintWithItem:screen2 attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeWidth multiplier:1.0 constant:75]];
        
        [self addConstraint:[NSLayoutConstraint constraintWithItem:screen2 attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:screen1 attribute:NSLayoutAttributeLeft multiplier:1.0 constant:-40]];
        
        
        screen3 = [[InteractiveImageView alloc] initWithImage:[UIImage imageNamed:@"Grain3"]];
        screen3.translatesAutoresizingMaskIntoConstraints = NO;
        screen3.contentMode = UIViewContentModeScaleAspectFill;
        screen3.clipsToBounds = YES;
        screen3.alpha = 0;
        screen3.layer.masksToBounds = YES;
        screen3.layer.cornerRadius = 6;
        [backgroundView addSubview:screen3];
        
        [self addConstraint:[NSLayoutConstraint constraintWithItem:screen3 attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:backgroundView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
        
        [self addConstraint:[NSLayoutConstraint constraintWithItem:screen3 attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1.0 constant:75]];
        
        [self addConstraint:[NSLayoutConstraint constraintWithItem:screen3 attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeWidth multiplier:1.0 constant:75]];
        
        [self addConstraint:[NSLayoutConstraint constraintWithItem:screen3 attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:screen1 attribute:NSLayoutAttributeRight multiplier:1.0 constant:40]];
        
        
        [UIView animateWithDuration:0.3 delay:0.1 options:UIViewAnimationOptionCurveEaseIn animations:^{
            screen1.alpha = 1;
            screen2.alpha = 1;
            screen3.alpha = 1;
        } completion:^(BOOL finished) {
            
        }];
    }
}

- (void)showOverlayView
{
    if (enabledOverlayBlur) {
        
        [UIView animateWithDuration:0.2 animations:^{
            screen1.alpha = 0;
            screen2.alpha = 0;
            screen3.alpha = 0;
        } completion:^(BOOL finished) {
            [screen1 removeFromSuperview];
            [screen2 removeFromSuperview];
            [screen3 removeFromSuperview];
        }];
        
        [UIView animateWithDuration:0.4 animations:^{
            
            [moreButton setTitle:@"Show More" forState:UIControlStateNormal];
            _visualEffectView.effect = nil;
            NSLog(@"Hide");
            
        } completion:^(BOOL finished) {
            [_visualEffectView removeFromSuperview];
            enabledOverlayBlur = NO;
            
        }];
        
    } else {
        [backgroundView addSubview:_visualEffectView];
        
        
        [UIView animateWithDuration:0.4 animations:^{
            
            NSLog(@"Show");
            [moreButton setTitle:@"Show Less" forState:UIControlStateNormal];
            _visualEffectView.effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
            
        } completion:^(BOOL finished) {
            enabledOverlayBlur = YES;
        }];
    }
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    
    [moreButton removeFromSuperview];
    [screen1 removeFromSuperview];
    [screen2 removeFromSuperview];
    [screen3 removeFromSuperview];
    enabledOverlayBlur = NO;
    _visualEffectView.effect = nil;
    [_visualEffectView removeFromSuperview];
    appLabel.text = nil;
    subtitleLabel.text = nil;
    textLabel.text = nil;
    _topic = nil;
    topicApp = nil;

    [self setNeedsLayout];
}

@end
