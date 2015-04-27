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

- (instancetype)initWithJSON:(id)JSONObject;
- (instancetype)initWithId:(NSString *)postid
                     score:(NSString *)score
                     title:(NSString *)title
                       url:(NSString *)url;

@end
