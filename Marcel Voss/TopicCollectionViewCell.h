//
//  TopicCollectionViewCell.h
//  Marcel Voss
//
//  Created by Marcel Voß on 22.04.16.
//  Copyright © 2016 Marcel Voß. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Topic.h"
#import "InteractiveImageView.h"

@interface TopicCollectionViewCell : UICollectionViewCell

@property (nonatomic) Topic *topic;
@property (nonatomic) UILabel *headlineLabel;
@property (nonatomic) InteractiveImageView *headerImageView;
@property (nonatomic) UILabel *textLabel;

@end
