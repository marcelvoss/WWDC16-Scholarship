//
//  InteractiveImageView.h
//  Marcel Voss
//
//  Created by Marcel Voß on 22.04.16.
//  Copyright © 2016 Marcel Voß. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TopicImage.h"

typedef NS_ENUM(NSInteger, ViewerType) {
    ViewerTypeMap,
    ViewerTypeImage
};

@interface InteractiveImageView : UIImageView <UIGestureRecognizerDelegate>

@property (nonatomic) NSArray *imageArray; // TODO: implement
@property (nonatomic) ViewerType viewerType;
@property (nonatomic) CGFloat slideTime; // Time in seconds for each image in imageArray
@property (nonatomic) CGFloat fadeTime; // Time in seconds for each image in imageArray
@property (nonatomic) NSMutableArray *temporaryArray;
@property (nonatomic) NSTimer *timer;

- (instancetype)initWithImages:(NSArray *)imageArray type:(ViewerType)viewerType;
- (void)setImages:(NSArray *)imageArray type:(ViewerType)viewerType;

@end
