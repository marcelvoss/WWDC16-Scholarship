//
//  TopicCollectionViewCell.m
//  Marcel Voss
//
//  Created by Marcel Voß on 22.04.16.
//  Copyright © 2016 Marcel Voß. All rights reserved.
//

#import "TopicCollectionViewCell.h"

@implementation TopicCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = 12;
        
        _headerImageView = [[InteractiveImageView alloc] initWithImage:[UIImage imageNamed:@"FriendsWWDC"] annotation:@""];
        _headerImageView.frame = CGRectMake(0, 0, self.frame.size.width, 200);
        _headerImageView.contentMode = UIViewContentModeScaleAspectFill;
        _headerImageView.layer.masksToBounds = YES;
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
        gradientLayer.endPoint = CGPointMake(0.1f, 0.9f);
        _headerImageView.layer.mask = gradientLayer;
        
        
        
        _headlineLabel = [[UILabel alloc] init];
        _headlineLabel.textAlignment = NSTextAlignmentCenter;
        _headlineLabel.font = [UIFont boldSystemFontOfSize:25];
        _headlineLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [self.contentView addSubview:_headlineLabel];
        
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_headlineLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
        
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_headlineLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTop multiplier:1.0 constant:20]];
        
        
        _textLabel = [[UILabel alloc] init];
        _textLabel.textAlignment = NSTextAlignmentCenter;
        _textLabel.font = [UIFont systemFontOfSize:17];
        _textLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [self.contentView addSubview:_textLabel];
        
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_textLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
        
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_textLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_headlineLabel attribute:NSLayoutAttributeBottom multiplier:1.0 constant:10]];
    }
    return self;
}

- (void)setTopic:(Topic *)topic
{
    _topic = topic;
    
    // TODO: Continue this
    _headlineLabel.text = topic.topicTitle;
    _textLabel.text = topic.topicText;
    _headerImageView.image = topic.topicImage;
}

@end
