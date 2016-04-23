//
//  Topic.h
//  Marcel Voss
//
//  Created by Marcel Voß on 22.04.16.
//  Copyright © 2016 Marcel Voß. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

// TODO: Good idea -> continue it
typedef NS_ENUM(NSInteger, Options) {
    OptionsMap,
    OptionsGeneric,
    OptionsNone
};

@interface Topic : NSObject

@property (nonatomic) NSString *topicTitle;
@property (nonatomic) NSString *topicText;
@property (nonatomic) UIImage *topicImage;
//@property (nonatomic)

- (instancetype)initWithTitle:(NSString *)topicTitle text:(NSString *)topicText image:(UIImage *)topicImage option:(Options)topicOption;

@end
