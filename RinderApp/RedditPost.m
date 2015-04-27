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
    }
    return  self;
}

- (instancetype)initWithId:(NSString *)postid
                     score:(NSString *)score
                     title:(NSString *)title
                       url:(NSString *)url
{
    if (self = [super init])
    {
        self.postid = postid;
        self.score = score;
        self.title = title;
        self.url = url;
    }
    return  self;
}

@end
