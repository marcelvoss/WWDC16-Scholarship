//
//  CustomMenuButton.m
//  Marcel Voss
//
//  Created by Marcel Voß on 22.04.16.
//  Copyright © 2016 Marcel Voß. All rights reserved.
//

#import "CustomMenuButton.h"

@implementation CustomMenuButton
{
    UIImageView *gradientImageView;
    UIImageView *overlayView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        CGFloat cornerRadius = 5;
        self.layer.cornerRadius = cornerRadius;
        
        gradientImageView = [[UIImageView alloc] init];
        gradientImageView.translatesAutoresizingMaskIntoConstraints = NO;
        gradientImageView.clipsToBounds = YES;
        gradientImageView.layer.cornerRadius = cornerRadius;
        gradientImageView.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:gradientImageView];
        
        [self addConstraint:[NSLayoutConstraint constraintWithItem:gradientImageView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
        
        [self addConstraint:[NSLayoutConstraint constraintWithItem:gradientImageView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
        
        [self addConstraint:[NSLayoutConstraint constraintWithItem:gradientImageView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeHeight multiplier:1.0 constant:0]];
        
        [self addConstraint:[NSLayoutConstraint constraintWithItem:gradientImageView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0]];
        
        
        overlayView = [[UIImageView alloc] init];
        overlayView.clipsToBounds = YES;
        overlayView.translatesAutoresizingMaskIntoConstraints = NO;
        overlayView.contentMode = UIViewContentModeScaleAspectFill;
        [gradientImageView addSubview:overlayView];
        
        
        [self addConstraint:[NSLayoutConstraint constraintWithItem:overlayView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:gradientImageView attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
        
        [self addConstraint:[NSLayoutConstraint constraintWithItem:overlayView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:gradientImageView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
        
        [self addConstraint:[NSLayoutConstraint constraintWithItem:overlayView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:gradientImageView attribute:NSLayoutAttributeHeight multiplier:1.0 constant:0]];
        
        [self addConstraint:[NSLayoutConstraint constraintWithItem:overlayView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:gradientImageView attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0]];

        
/*        UIInterpolatingMotionEffect *verticalMotionEffect = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.y" type:UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis];
        verticalMotionEffect.minimumRelativeValue = @(-10);
        verticalMotionEffect.maximumRelativeValue = @(10);
        
        UIInterpolatingMotionEffect *horizontalMotionEffect = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.x" type:UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis];
        horizontalMotionEffect.minimumRelativeValue = @(-10);
        horizontalMotionEffect.maximumRelativeValue = @(10);
        
        UIMotionEffectGroup *group = [[UIMotionEffectGroup alloc] init];
        group.motionEffects = @[verticalMotionEffect, horizontalMotionEffect];
        [gradientImageView addMotionEffect:group];*/
        
        
        
        _mainLabel = [[UILabel alloc] init];
        _mainLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _mainLabel.font = [UIFont boldSystemFontOfSize:18];
        _mainLabel.textColor = [UIColor whiteColor];
        [overlayView addSubview:_mainLabel];
        
        [overlayView addConstraint:[NSLayoutConstraint constraintWithItem:_mainLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:overlayView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:10]];
        
        [overlayView addConstraint:[NSLayoutConstraint constraintWithItem:_mainLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:overlayView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
        
        
        
        UIImageView *arrowImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ArrowIcon"]];
        arrowImageView.clipsToBounds = YES;
        arrowImageView.transform = CGAffineTransformMakeRotation(3 * M_PI_2);
        arrowImageView.contentMode = UIViewContentModeScaleAspectFit;
        arrowImageView.translatesAutoresizingMaskIntoConstraints = NO;
        [overlayView addSubview:arrowImageView];
        
        [overlayView addConstraint:[NSLayoutConstraint constraintWithItem:arrowImageView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:overlayView attribute:NSLayoutAttributeRight multiplier:1.0 constant:0]];
        
        
        [overlayView addConstraint:[NSLayoutConstraint constraintWithItem:arrowImageView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:overlayView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
        
        //[overlayView addConstraint:[NSLayoutConstraint constraintWithItem:arrowImageView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeWidth multiplier:1.0 constant:18]];
        
        [overlayView addConstraint:[NSLayoutConstraint constraintWithItem:arrowImageView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1.0 constant:13]];
        
        
        
    }
    return self;
}

- (void)setGradientImage:(UIImage *)gradientImage
{
    _gradientImage = gradientImage;
    
    gradientImageView.image = gradientImage;
}

- (void)setBackgroundImage:(UIImage *)backgroundImage
{
    _backgroundImage = backgroundImage;
    
    overlayView.image = backgroundImage;
}

@end
