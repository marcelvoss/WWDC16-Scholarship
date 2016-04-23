//
//  Topic.m
//  Marcel Voss
//
//  Created by Marcel Voß on 22.04.16.
//  Copyright © 2016 Marcel Voß. All rights reserved.
//

#import "Topic.h"

@implementation Topic

- (instancetype)initWithTitle:(NSString *)topicTitle text:(NSString *)topicText image:(UIImage *)topicImage option:(Options)topicOption
{
    self = [super init];
    if (self) {
        _topicTitle = topicTitle;
        _topicText = topicText;
    }
    return self;
}

@end
