//
//  MapCollectionViewCell.m
//  Marcel Voss
//
//  Created by Marcel Voß on 25.04.16.
//  Copyright © 2016 Marcel Voß. All rights reserved.
//

#import "MapCollectionViewCell.h"

#import "Topic.h"
#import "TopicImage.h"
#import "InteractiveImageView.h"
#import "AppDelegate.h"

#import "Constants.h"

@interface MapCollectionViewCell ()
{
    UILabel *headlineLabel;
    UILabel *subtitleLabel;
    UILabel *textLabel;
    InteractiveImageView *headerImageView;
    
    NSLayoutConstraint *headlineYConstraint;
    
}

@end

@implementation MapCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = 12;
        
        headerImageView = [[InteractiveImageView alloc] init];
        headerImageView.viewerType = ViewerTypeMap;
        headerImageView.frame = CGRectMake(0, 0, self.frame.size.width, 150);
        headerImageView.layer.masksToBounds = YES;
        headerImageView.contentMode = UIViewContentModeScaleAspectFill;
        [self.contentView addSubview:headerImageView];
        
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.contentView.bounds byRoundingCorners:( UIRectCornerTopLeft | UIRectCornerTopRight) cornerRadii:CGSizeMake(12.0, 12.0)];
        
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = self.bounds;
        maskLayer.path  = maskPath.CGPath;
        self.contentView.layer.mask = maskLayer;
        
        
        // Gradient for fading out the image view into the white background
        CAGradientLayer *gradientLayer = [CAGradientLayer layer];
        gradientLayer.frame = headerImageView.bounds;
        gradientLayer.colors = [NSArray arrayWithObjects:(id)[UIColor whiteColor].CGColor, (id)[UIColor clearColor].CGColor, nil];
        gradientLayer.startPoint = CGPointMake(0.0f, 0.0f);
        gradientLayer.endPoint = CGPointMake(0.1f, 0.9f);
        headerImageView.layer.mask = gradientLayer;
        

        
        headlineLabel = [[UILabel alloc] init];
        headlineLabel.textAlignment = NSTextAlignmentCenter;
        headlineLabel.font = [UIFont boldSystemFontOfSize:25];
        headlineLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [self.contentView addSubview:headlineLabel];
        
        [self addConstraint:[NSLayoutConstraint constraintWithItem:headlineLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
        
        headlineYConstraint = [NSLayoutConstraint constraintWithItem:headlineLabel attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:headerImageView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-5];
        [self addConstraint:headlineYConstraint];
        
        
        textLabel = [[UILabel alloc] init];
        textLabel.textAlignment = NSTextAlignmentCenter;
        textLabel.font = [UIFont systemFontOfSize:15];
        textLabel.numberOfLines = 0;
        textLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [self.contentView addSubview:textLabel];
        
        [self addConstraint:[NSLayoutConstraint constraintWithItem:textLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
        
        [self addConstraint:[NSLayoutConstraint constraintWithItem:textLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:headlineLabel attribute:NSLayoutAttributeBottom multiplier:1.0 constant:10]];
        
        [self addConstraint:[NSLayoutConstraint constraintWithItem:textLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeWidth multiplier:1.0 constant:-40]];
    }
    return self;
}

- (void)setTopic:(Topic *)topic
{
    _topic = topic;
    
    headlineLabel.text = _topic.topicTitle;
    
    headerImageView.viewerType = ViewerTypeMap;
    [headerImageView  setImages:_topic.images type:ViewerTypeImage];
    
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineSpacing = 6;
    [paraStyle setAlignment:NSTextAlignmentCenter];
    
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:topic.topicText];
    [string addAttribute:NSParagraphStyleAttributeName value:paraStyle range:NSMakeRange(0, string.length)];
    textLabel.attributedText = string;
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    
    // Clean up collection view cell
    headlineLabel.text = nil;
    subtitleLabel.text = nil;
    textLabel.text = nil;
    _topic = nil;
    
    [self setNeedsLayout];
}

@end
