//
//  InteractiveImageView.h
//  Marcel Voss
//
//  Created by Marcel Voß on 22.04.16.
//  Copyright © 2016 Marcel Voß. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ViewerType) {
    ViewerTypeMap,
    ViewerTypeImage
};

@interface InteractiveImageView : UIImageView <UIGestureRecognizerDelegate>

@property (nonatomic) NSString *annotationString;
@property (nonatomic) ViewerType viewerType;

- (instancetype)initWithImage:(UIImage *)image annotation:(NSString *)annotation type:(ViewerType)viewerType;
- (void)setImage:(UIImage *)image annotation:(NSString *)annotation type:(ViewerType)viewerType;

@end
