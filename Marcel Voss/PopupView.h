//
//  GRPopupView.h
//  Grain
//
//  Created by Marcel Voß on 07.08.15.
//  Copyright (c) 2015 Marcel Voss. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, GRPopupType) {
    GRPopupTypeSuccess,
    GRPopupTypeError,
    GRPopupTypeGeneric
};

@interface PopupView : UIView

@property (nonatomic) NSString *titleString;
@property (nonatomic) NSString *descriptionString;

- (instancetype)initWithType:(GRPopupType)popupType title:(NSString *)titleString description:(NSString *)descriptionString;
- (void)show;
- (void)hide;

@end
