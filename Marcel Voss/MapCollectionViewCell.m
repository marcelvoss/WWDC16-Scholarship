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
#import <MapKit/MapKit.h>

@interface MapCollectionViewCell ()
{
    UILabel *headlineLabel;
    UILabel *subtitleLabel;
    UILabel *textLabel;
    InteractiveImageView *headerImageView;
    
    NSLayoutConstraint *headlineYConstraint;
    
}

@property (nonatomic) UIImage *mapShot;

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
    [self setupLayoutForOption:topic.topicOption];
}

- (void)setupLayoutForOption:(Options)option
{
    [self setupHeaderViewForOption:option];
    headerImageView.viewerType = ViewerTypeMap;
    
    headlineLabel.text = _topic.topicTitle;
    textLabel.text = _topic.topicText;
    
    
    if (self.mapShot == nil) {
        headlineYConstraint.constant = - 75;
        [self layoutIfNeeded];
        
        MKMapSnapshotOptions *options = [[MKMapSnapshotOptions alloc] init];
        options.region = MKCoordinateRegionMake(CLLocationCoordinate2DMake(HEIDE_LATITUDE, HEIDE_LONGTITUDE), MKCoordinateSpanMake(0.05, 0.05));
        options.size = CGSizeMake(self.frame.size.width, 150);
        options.scale = [[UIScreen mainScreen] scale];
        
        MKMapSnapshotter *snapshotter = [[MKMapSnapshotter alloc] initWithOptions:options];
        [snapshotter startWithCompletionHandler:^(MKMapSnapshot *snapshot, NSError *error) {
            if (error) {
                
                // TODO: Add logic for better error instead of alert -> icon or something
                
                
                return;
            } else {
                self.mapShot = snapshot.image;
                headerImageView.alpha = 0;
                
                headlineYConstraint.constant = -5;
                [UIView animateWithDuration:0.3 delay:0.1 options:UIViewAnimationOptionCurveEaseIn animations:^{
                    TopicImage *topicImage = [[TopicImage alloc] initWithImage:self.mapShot annotation:nil];
                    [headerImageView setImages:@[topicImage] type:ViewerTypeMap];
                    headerImageView.alpha = 1;
                    [self layoutIfNeeded];
                } completion:^(BOOL finished) {
                    
                }];
            }
        }];
    } else {
        headlineYConstraint.constant = -5;
        [self layoutIfNeeded];
        
        TopicImage *topicImage = [[TopicImage alloc] initWithImage:self.mapShot annotation:nil];
        [headerImageView setImages:@[topicImage] type:ViewerTypeMap];
    }
    
    
}

- (void)setupHeaderViewForOption:(Options)optionsType
{
    headerImageView = [[InteractiveImageView alloc] init];
    headerImageView.viewerType = ViewerTypeImage;
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
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    
    // Clean up collection view cell
    headlineLabel.text = nil;
    subtitleLabel.text = nil;
    headerImageView.image = nil;
    headerImageView.imageArray = nil;
    headerImageView = nil;
    textLabel.text = nil;
    _topic = nil;
    
    [self setNeedsLayout];
    
}

@end
