//
//  RDDataSourseIterator.h
//  RinderApp
//
//  Created by Enze Li on 4/22/15.
//  Copyright (c) 2015 RD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RedditPost.h"

@interface RDDataManager : NSObject

@property (strong, nonatomic) RedditPost *currentPost;
@property (strong, nonatomic) RedditPost *nextPost;


+ (instancetype)sharedInstance;
- (BOOL)upvote;
- (BOOL)downvote;

@end
