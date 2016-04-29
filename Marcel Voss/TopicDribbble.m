//
//  TopicDribbble.m
//  Marcel Voss
//
//  Created by Marcel Voß on 29.04.16.
//  Copyright © 2016 Marcel Voß. All rights reserved.
//

#import "TopicDribbble.h"

@implementation TopicDribbble

- (instancetype)initWithImage:(UIImage *)image title:(NSString *)itemTitle author:(NSString *)authorName
{
    self = [super init];
    if (self) {
        _itemTitle = itemTitle;
        _image = image;
        _authorName = authorName;
    }
    return self;
}

@end
