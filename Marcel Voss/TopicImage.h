//
//  TopicImage.h
//  Marcel Voss
//
//  Created by Marcel Voß on 25.04.16.
//  Copyright © 2016 Marcel Voß. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface TopicImage : NSObject

@property (nonatomic) UIImage *topicImage;
@property (nonatomic) NSString *topicAnnotation;

- (instancetype)initWithImage:(UIImage *)image
                   annotation:(NSString *)annotation;

@end
