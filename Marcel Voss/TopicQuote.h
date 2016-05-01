//
//  TopicQuote.h
//  Marcel Voss
//
//  Created by Marcel Voß on 01.05.16.
//  Copyright © 2016 Marcel Voß. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TopicQuote : NSObject

@property (nonatomic) NSString *quoteItemtitle;
@property (nonatomic) NSString *quoteDescription;
@property (nonatomic) NSString *quote;
@property (nonatomic) NSString *quoteItemAuthor;

- (instancetype)initWithTitle:(NSString *)title
                  description:(NSString *)description
                        quote:(NSDictionary *)quoteDictionary;

@end
