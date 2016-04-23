//
//  Topic.m
//  Marcel Voss
//
//  Created by Marcel Voß on 22.04.16.
//  Copyright © 2016 Marcel Voß. All rights reserved.
//

#import "Topic.h"

@implementation Topic

- (instancetype)initWithTitle:(NSString *)title text:(NSString *)text
{
    self = [super init];
    if (self) {
        _topicTitle = title;
        _text = text;
    }
    return self;
}

@end
