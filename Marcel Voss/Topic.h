//
//  Topic.h
//  Marcel Voss
//
//  Created by Marcel Voß on 22.04.16.
//  Copyright © 2016 Marcel Voß. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Topic : NSObject

@property (nonatomic) NSString *topicTitle;
@property (nonatomic) NSString *text;

- (instancetype)initWithTitle:(NSString *)title text:(NSString *)text;

@end
