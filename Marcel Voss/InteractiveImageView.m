//
//  InteractiveImageView.m
//  Marcel Voss
//
//  Created by Marcel Voß on 22.04.16.
//  Copyright © 2016 Marcel Voß. All rights reserved.
//

#import "InteractiveImageView.h"

//#import "ImageViewer.h"

#import "Marcel_Voss-Swift.h"

@implementation InteractiveImageView

- (instancetype)initWithImage:(UIImage *)image
{
    self = [super initWithImage:image];
    if (self) {
        self.userInteractionEnabled = YES;
        self.contentMode = UIViewContentModeScaleToFill;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showImageView)];
        [self addGestureRecognizer:tap];
    }
    return self;
}

- (instancetype)initWithImage:(UIImage *)image annotation:(NSString *)annotation
{
    self = [super initWithImage:image];
    if (self) {
        _annotationString = annotation;
        
        self.userInteractionEnabled = YES;
        self.contentMode = UIViewContentModeScaleToFill;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showImageView)];
        [self addGestureRecognizer:tap];
    }
    return self;
}

- (void)showImageView
{
    ImageViewer *viewer = [[ImageViewer alloc] init];
    
    if (_annotationString != nil) {
        viewer.annotationLabel.text = self.annotationString;
    }
    
    if (self.image != nil) {
        [viewer show:self.image];
    }
}


@end
