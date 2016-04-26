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
    
    [self setupLayoutForOption:topic.topicOption];
}

- (void)setupLayoutForOption:(Options)option
{
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
    textLabel.font = [UIFont systemFontOfSize:15];
    textLabel.numberOfLines = 0;
    textLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:textLabel];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:textLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:textLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:headlineLabel attribute:NSLayoutAttributeBottom multiplier:1.0 constant:10]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:textLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeWidth multiplier:1.0 constant:-40]];
    
    
    // TODO: Make gradient slightly higher
    
    // Gradient for fading out the image view into the white background
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = _headerImageView.bounds;
    gradientLayer.colors = [NSArray arrayWithObjects:(id)[UIColor whiteColor].CGColor, (id)[UIColor clearColor].CGColor, nil];
    gradientLayer.startPoint = CGPointMake(0.0f, 0.0f);
    gradientLayer.endPoint = CGPointMake(0.0f, 1.f);
    _headerImageView.layer.mask = gradientLayer;
    
    headlineLabel.text = _topic.topicTitle;
    textLabel.text = _topic.topicText;
    
    _headerImageView.image = nil;
    _headerImageView.imageArray = nil;
    
    if ([_topic.images count] == 1) {
        [_headerImageView  setImages:_topic.images type:ViewerTypeImage];;
    } else {
        [_headerImageView setImages:_topic.images type:ViewerTypeImage];
    }
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    
    // Clean up collection view cell
    // FIXME: FUCKING THING STILL SHOWS WRONG IMAGES AFTER SCROLLING
    //[textLabel removeFromSuperview];
    //[headlineLabel removeFromSuperview];
    
    
    headlineLabel.text = nil;
    subtitleLabel.text = nil;
    _headerImageView = nil;
    _headerImageView.image = nil;
    _headerImageView.imageArray = nil;
    textLabel.text = nil;
    _topic = nil;
    
    [self setNeedsLayout];
    
}

@end
