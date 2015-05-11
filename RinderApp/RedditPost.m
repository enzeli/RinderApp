//
//  RedditPost.m
//  RinderApp
//
//  Created by Enze Li on 4/24/15.
//  Copyright (c) 2015 RD. All rights reserved.
//

#import "RedditPost.h"

@implementation RedditPost

- (instancetype)initWithJSON:(id)JSONObject
{
    if (self = [super init])
    {
        self.postid = [JSONObject objectForKey:@"id"];
        self.score = [JSONObject objectForKey:@"score"];
        self.title = [JSONObject objectForKey:@"title"];
        self.url = [JSONObject objectForKey:@"url"];
        self.permalink = [JSONObject objectForKey:@"permalink"];
    }
    
    return  self;
}

@end
