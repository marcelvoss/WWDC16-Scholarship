//
//  TopicDribbble.h
//  Marcel Voss
//
//  Created by Marcel Voß on 29.04.16.
//  Copyright © 2016 Marcel Voß. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MVDribbbleKit.h"

@interface TopicDribbble : NSObject

@property (nonatomic) UIImage *image;
@property (nonatomic) NSString *itemTitle;
@property (nonatomic) NSString *authorName;

- (instancetype)initWithImage:(UIImage *)image title:(NSString *)itemTitle author:(NSString *)authorName;

@end
