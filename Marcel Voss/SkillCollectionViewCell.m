//
//  SkillCollectionViewCell.m
//  Marcel Voss
//
//  Created by Marcel Voß on 28.04.16.
//  Copyright © 2016 Marcel Voß. All rights reserved.
//

#import "SkillCollectionViewCell.h"

#import "Topic.h"
#import "TopicSkill.h"
#import "Marcel_Voss-Swift.h"

@interface SkillCollectionViewCell ()
{
    UIView *innerView;
    
    UILabel *skillLabel;
    UILabel *sinceLabel;
    UILabel *progressLabel;
}

@end

@implementation SkillCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = 12;
        
        innerView = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height, self.frame.size.width, 0)];
        [self.contentView addSubview:innerView];
        
        [self layoutIfNeeded];
        
        skillLabel = [[UILabel alloc] init];
        skillLabel.translatesAutoresizingMaskIntoConstraints = NO;
        skillLabel.font = [UIFont boldSystemFontOfSize:25];
        skillLabel.alpha = 1;
        [self.contentView addSubview:skillLabel];
        
        [self addConstraint:[NSLayoutConstraint constraintWithItem:skillLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
        
        [self addConstraint:[NSLayoutConstraint constraintWithItem:skillLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
        
        sinceLabel = [[UILabel alloc] init];
        sinceLabel.translatesAutoresizingMaskIntoConstraints = NO;
        sinceLabel.font = [UIFont systemFontOfSize:18];
        sinceLabel.alpha = 1;
        [self.contentView addSubview:sinceLabel];
        
        [self addConstraint:[NSLayoutConstraint constraintWithItem:sinceLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
        
        [self addConstraint:[NSLayoutConstraint constraintWithItem:sinceLabel attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:skillLabel attribute:NSLayoutAttributeTop multiplier:1.0 constant:0]];
        
        UIBezierPath *maskPathBottom = [UIBezierPath bezierPathWithRoundedRect:self.contentView.bounds byRoundingCorners:( UIRectCornerBottomLeft | UIRectCornerBottomRight | UIRectCornerTopLeft | UIRectCornerTopRight) cornerRadii:CGSizeMake(12.0, 12.0)];
        
        CAShapeLayer *maskLayerBottom = [[CAShapeLayer alloc] init];
        maskLayerBottom.frame = self.bounds;
        maskLayerBottom.path  = maskPathBottom.CGPath;
        self.contentView.layer.mask = maskLayerBottom;
        
        
        progressLabel = [[UILabel alloc] init];
        progressLabel.translatesAutoresizingMaskIntoConstraints = NO;
        progressLabel.font = [UIFont systemFontOfSize:13];
        progressLabel.alpha = 1;
        [innerView addSubview:progressLabel];
        
        [self addConstraint:[NSLayoutConstraint constraintWithItem:progressLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:innerView attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
        
        [self addConstraint:[NSLayoutConstraint constraintWithItem:progressLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:innerView attribute:NSLayoutAttributeTop multiplier:1.0 constant:15]];
        
        [self layoutIfNeeded];
        
        
    }
    return self;
}

- (void)setTopic:(Topic *)topic
{
    _topic = topic;
    
    skillLabel.text = topic.topicSkill.skillName;
    sinceLabel.text = [NSString stringWithFormat:@"Since %@", [topic.topicSkill.skillSince stringValue]];
    progressLabel.text = [NSString stringWithFormat:@"%@%%", [topic.topicSkill.skillProgress stringValue]];
    
    [self addSkillView:topic.topicSkill];
}

- (void)addSkillView:(TopicSkill *)skill
{
    innerView.backgroundColor = skill.skillColor;
    
    [self showAnimation];
}

- (void)showAnimation
{
    CGFloat skill = [_topic.topicSkill.skillProgress floatValue] / 100;
    CGFloat combinedSkill = self.frame.size.height * skill;
    CGRect newRect = CGRectMake(0, self.frame.size.height - combinedSkill, self.frame.size.width, combinedSkill);
    
    [UIView animateWithDuration:0.6 delay:0.6 usingSpringWithDamping:0.6 initialSpringVelocity:0.8 options:UIViewAnimationOptionCurveEaseIn animations:^{
        
        innerView.frame = newRect;
        
    } completion:^(BOOL finished) {
        
    }];
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    
    innerView.frame = CGRectMake(0, self.frame.size.height, self.frame.size.width, 0);
    _topic = nil;
    skillLabel.text = nil;
    sinceLabel.text = nil;
}

@end
