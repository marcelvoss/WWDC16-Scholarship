//
//  GRPopupView.m
//  Grain
//
//  Created by Marcel Voß on 07.08.15.
//  Copyright (c) 2015 Marcel Voss. All rights reserved.
//

#import "GRPopupView.h"
#import "UIColor+Colors.h"

@interface GRPopupView () <UIGestureRecognizerDelegate>
{
    UIWindow *window;
    GRPopupType selectedType;
    
    UIButton *hideButton;
    NSLayoutConstraint *heightConstraint;
}

@property (nonatomic) UIView *popupView;

@end


@implementation GRPopupView

- (instancetype)initWithType:(GRPopupType)popupType title:(NSString *)titleString description:(NSString *)descriptionString
{
    self = [super initWithFrame:[UIScreen mainScreen].bounds];
    if (self) {
        selectedType = popupType;
        _titleString = titleString;
        _descriptionString = descriptionString;
    }
    return self;
}

- (void)setupViews
{
    self.alpha = 0;
    self.backgroundColor = [UIColor blackColor];
    

    window = [[[UIApplication sharedApplication] delegate] window];    
    [window addSubview:self];
    
    _popupView = [[UIView alloc] init];
    _popupView.translatesAutoresizingMaskIntoConstraints = NO;
    _popupView.layer.cornerRadius = 9;
    _popupView.alpha = 0;
    _popupView.backgroundColor = [UIColor whiteColor];
    [window addSubview:_popupView];
    
    [window addConstraint:[NSLayoutConstraint constraintWithItem:_popupView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:window attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];

    [window addConstraint:[NSLayoutConstraint constraintWithItem:_popupView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:window attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
    
    heightConstraint = [NSLayoutConstraint constraintWithItem:_popupView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1.0 constant:215];
    [window addConstraint: heightConstraint];
    
    [window addConstraint:[NSLayoutConstraint constraintWithItem:_popupView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeWidth multiplier:1.0 constant:300]];
    
    [window layoutIfNeeded];
    
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = _titleString;
    titleLabel.font = [UIFont systemFontOfSize:20];
    titleLabel.textColor = [UIColor blueDubColor];
    titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [_popupView addSubview:titleLabel];
    
    [_popupView addConstraint:[NSLayoutConstraint constraintWithItem:titleLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:_popupView attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
    
    [_popupView addConstraint:[NSLayoutConstraint constraintWithItem:titleLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_popupView attribute:NSLayoutAttributeTop multiplier:1.0 constant:15]];
    
    UILabel *descriptionLabel = [[UILabel alloc] init];
    descriptionLabel.textAlignment = NSTextAlignmentCenter;
    descriptionLabel.text = _descriptionString;
    descriptionLabel.numberOfLines = 0;
    descriptionLabel.font = [UIFont systemFontOfSize:15];
    descriptionLabel.textColor = [UIColor colorWithRed:0.55 green:0.57 blue:0.58 alpha:1.00];
    descriptionLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [_popupView addSubview:descriptionLabel];
    
    [_popupView addConstraint:[NSLayoutConstraint constraintWithItem:descriptionLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:_popupView attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
    
    [_popupView addConstraint:[NSLayoutConstraint constraintWithItem:descriptionLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:titleLabel attribute:NSLayoutAttributeBottom multiplier:1.0 constant:5]];
    
    [_popupView addConstraint:[NSLayoutConstraint constraintWithItem:descriptionLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:_popupView attribute:NSLayoutAttributeWidth multiplier:1.0 constant:-40]];
    
    [self layoutIfNeeded];
    
    hideButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [hideButton setTitle:@"Got it!" forState:UIControlStateNormal];
    [hideButton setTitleColor:[UIColor blueDubColor] forState:UIControlStateNormal];
    [hideButton addTarget:self action:@selector(hide) forControlEvents:UIControlEventTouchDown];
    hideButton.titleLabel.font = [UIFont boldSystemFontOfSize:17];
    hideButton.translatesAutoresizingMaskIntoConstraints = NO;
    [_popupView addSubview:hideButton];
    
    [_popupView addConstraint:[NSLayoutConstraint constraintWithItem:hideButton attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:_popupView attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
    
    [_popupView addConstraint:[NSLayoutConstraint constraintWithItem:hideButton attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:_popupView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-10]];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hide)];
    _popupView.userInteractionEnabled = YES;
    [_popupView addGestureRecognizer:tap];
}

- (NSString *)stringForType:(GRPopupType)type
{
    switch (type) {
        case GRPopupTypeSuccess:
            return @"SuccessIcon";
            break;
        case GRPopupTypeError:
            return @"ErrorIcon";
            break;
        default:
            return @"ErrorIcon";
            break;
    }
}

- (void)show
{
    [self setupViews];
    
    [UIView animateWithDuration:0.4 animations:^{
        self.alpha = 0.7;
    }];
    
    _popupView.transform = CGAffineTransformMakeScale(0.4, 0.4);
    [UIView animateWithDuration:0.35 delay:0.2 usingSpringWithDamping:0.55 initialSpringVelocity:1.0 options:UIViewAnimationOptionTransitionNone animations:^{
        _popupView.alpha = 1;
        _popupView.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        
        /*double delayInSeconds = 2.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [self hide];
        });*/
    }];
}

- (void)hide
{
    [UIView animateWithDuration:0.4 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        
    }];
    
    [UIView animateWithDuration:0.35 delay:0.2 usingSpringWithDamping:0.55 initialSpringVelocity:1.0 options:UIViewAnimationOptionTransitionNone animations:^{
        _popupView.transform = CGAffineTransformMakeScale(0.4, 0.4);
        _popupView.alpha = 0;
    } completion:^(BOOL finished) {
        [_popupView removeFromSuperview];
        [self removeFromSuperview];
    }];
}

@end
