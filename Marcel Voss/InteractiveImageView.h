//
//  InteractiveImageView.h
//  Marcel Voss
//
//  Created by Marcel Voß on 22.04.16.
//  Copyright © 2016 Marcel Voß. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InteractiveImageView : UIImageView <UIGestureRecognizerDelegate>

@property (nonatomic) NSString *annotationString;

- (instancetype)initWithImage:(UIImage *)image annotation:(NSString *)annotation;

@end
