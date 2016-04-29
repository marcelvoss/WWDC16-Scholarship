//
//  ProjectCollectionViewCell.h
//  Marcel Voss
//
//  Created by Marcel Voß on 25.04.16.
//  Copyright © 2016 Marcel Voß. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SafariServices/SafariServices.h>

@class Topic;

@interface ProjectCollectionViewCell : UICollectionViewCell

@property (nonatomic) NSArray *popularItems;
@property (nonatomic) Topic *topic;

@end
