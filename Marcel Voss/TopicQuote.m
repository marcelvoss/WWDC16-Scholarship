//
//  TopicQuote.m
//  Marcel Voss
//
//  Created by Marcel Voß on 01.05.16.
//  Copyright © 2016 Marcel Voß. All rights reserved.
//

#import "TopicQuote.h"

@implementation TopicQuote

- (instancetype)initWithTitle:(NSString *)title description:(NSString *)description quote:(NSDictionary *)quoteDictionary
{
    self = [super init];
    if (self) {
        _quote = quoteDictionary[@"quote"];
        _quoteItemtitle = title;
        _quoteItemAuthor = quoteDictionary[@"author"];
        _quoteDescription = description;
    }
    return self;
}

@end
