//
//  TopicImage.m
//  Marcel Voss
//
//  Created by Marcel Voß on 25.04.16.
//  Copyright © 2016 Marcel Voß. All rights reserved.
//

#import "TopicImage.h"

#import "UIImage+Helpers.h"

@implementation TopicImage

- (instancetype)initWithImage:(UIImage *)image annotation:(NSString *)annotation
{
    self = [super init];
    if (self) {
        _topicAnnotation = annotation;
        _topicImage = image;
    }
    return self;
}

- (instancetype)initWithSDImage:(UIImage *)imageSD HDImage:(UIImage *)imageHD annotation:(NSString *)annotation
{
    self = [super init];
    if (self) {
        _topicAnnotation = annotation;
        _topicImage = imageSD;
        _topicHQImage = imageHD;
    }
    return self;
}

@end
