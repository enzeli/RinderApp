//
//  RedditPost.h
//  RinderApp
//
//  Created by Enze Li on 4/24/15.
//  Copyright (c) 2015 RD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RedditPost : NSObject

//@property (strong, nonatomic) NSArray *comments;
@property (strong, nonatomic) NSString *postid;
@property (assign, nonatomic) NSString *score;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *url;
@property (strong, nonatomic) NSString *permalink;

- (instancetype)initWithJSON:(id)JSONObject;

@end
