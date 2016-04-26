//
//  GenericCollectionViewCell.m
//  Marcel Voss
//
//  Created by Marcel Voß on 25.04.16.
//  Copyright © 2016 Marcel Voß. All rights reserved.
//

#import "GenericCollectionViewCell.h"

#import "Topic.h"
#import "TopicImage.h"
#import "AppCustomButton.h"
#import "AppDelegate.h"

#import "Constants.h"

@interface GenericCollectionViewCell ()
{
    UILabel *headlineLabel;
    UILabel *subtitleLabel;
    UILabel *textLabel;
    
    NSLayoutConstraint *headlineYConstraint;
}

@end

@implementation GenericCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = 12;
        
        _headerImageView = [[InteractiveImageView alloc] init];
        _headerImageView.viewerType = ViewerTypeImage;
        _headerImageView.frame = CGRectMake(0, 0, self.frame.size.width, 150);
        _headerImageView.layer.masksToBounds = YES;
        _headerImageView.contentMode = UIViewContentModeScaleAspectFill;
        [self.contentView addSubview:_headerImageView];
        
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.contentView.bounds byRoundingCorners:( UIRectCornerTopLeft | UIRectCornerTopRight) cornerRadii:CGSizeMake(12.0, 12.0)];
        
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = self.bounds;
        maskLayer.path  = maskPath.CGPath;
        self.contentView.layer.mask = maskLayer;
        
        // Gradient for fading out the image view into the white background
        CAGradientLayer *gradientLayer = [CAGradientLayer layer];
        gradientLayer.frame = _headerImageView.bounds;
        gradientLayer.colors = [NSArray arrayWithObjects:(id)[UIColor whiteColor].CGColor, (id)[UIColor clearColor].CGColor, nil];
        gradientLayer.startPoint = CGPointMake(0.0f, 0.0f);
        gradientLayer.endPoint = CGPointMake(0.0f, 1.f);
        _headerImageView.layer.mask = gradientLayer;
        
        headlineLabel = [[UILabel alloc] init];
        headlineLabel.textAlignment = NSTextAlignmentCenter;
        headlineLabel.font = [UIFont boldSystemFontOfSize:25];
        headlineLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [self.contentView addSubview:headlineLabel];
        
        [self addConstraint:[NSLayoutConstraint constraintWithItem:headlineLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
        
        
        // TODO: Remove headlineYConstraint
        headlineYConstraint = [NSLayoutConstraint constraintWithItem:headlineLabel attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:_headerImageView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-5];
        [self addConstraint:headlineYConstraint];
        
        
        textLabel = [[UILabel alloc] init];
        textLabel.textAlignment = NSTextAlignmentCenter;
        textLabel.font = [UIFont systemFontOfSize:16];
        textLabel.numberOfLines = 0;
        textLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [self.contentView addSubview:textLabel];
        
        [self addConstraint:[NSLayoutConstraint constraintWithItem:textLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
        
        [self addConstraint:[NSLayoutConstraint constraintWithItem:textLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:headlineLabel attribute:NSLayoutAttributeBottom multiplier:1.0 constant:10]];
        
        [self addConstraint:[NSLayoutConstraint constraintWithItem:textLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeWidth multiplier:1.0 constant:-40]];
        
        
    }
    return self;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    [self setNeedsDisplay];
}

- (void)setTopic:(Topic *)topic
{
    _topic = topic;
    
    headlineLabel.text = topic.topicTitle;
    textLabel.text = topic.topicText;
    
    [_headerImageView  setImages:_topic.images type:ViewerTypeImage];
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    
    headlineLabel.text = nil;
    subtitleLabel.text = nil;
    _headerImageView.image = nil;
    [_headerImageView.timer invalidate];
    _headerImageView.timer = nil;
    _headerImageView.imageArray = nil;
    textLabel.text = nil;
    _topic = nil;
    
    [self setNeedsLayout];
}

@end
