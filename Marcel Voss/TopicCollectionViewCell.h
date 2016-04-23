//
//  TopicCollectionViewCell.h
//  Marcel Voss
//
//  Created by Marcel Voß on 22.04.16.
//  Copyright © 2016 Marcel Voß. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "InteractiveImageView.h"

typedef NS_ENUM(NSInteger, TopicType) {
    TopicTypeProject
};

@interface TopicCollectionViewCell : UICollectionViewCell

@property (nonatomic) UILabel *headlineLabel;
@property (nonatomic) InteractiveImageView *headerImageView;
@property (nonatomic) UILabel *textLabel;

@end
