//
//  Topic.h
//  Marcel Voss
//
//  Created by Marcel Voß on 22.04.16.
//  Copyright © 2016 Marcel Voß. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

#import "TopicImage.h"

@class TopicApp;

typedef NS_ENUM(NSInteger, Options) {
    OptionsMap,
    OptionsGeneric,
    OptionsApp,
    OptionsIntro,
    OptionsNone
};

@interface Topic : NSObject

@property (nonatomic) NSString *topicTitle;
@property (nonatomic) NSString *topicSubtitle;
@property (nonatomic) NSString *topicText;
@property (nonatomic) Options topicOption;
@property (nonatomic) NSURL *topicURL;
@property (nonatomic) NSArray *images; // An array of TopicImage objects


@property (nonatomic) TopicApp *topicApp;
@property (nonatomic) MKCoordinateRegion *locationRegion;

//options.region = MKCoordinateRegionMake(CLLocationCoordinate2DMake(HEIDE_LATITUDE, HEIDE_LONGTITUDE),

- (instancetype)initWithTitle:(NSString *)topicTitle
                     subtitle:(NSString *)topicSubtitle
                         text:(NSString *)topicText
                       images:(NSArray *)imagesArray
                       option:(Options)topicOption;

- (instancetype)initWithApp:(TopicApp *)appItem;

@end
