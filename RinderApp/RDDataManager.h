//
//  RDDataSourseIterator.h
//  RinderApp
//
//  Created by Enze Li on 4/22/15.
//  Copyright (c) 2015 RD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RDDataManager : NSObject

+ (instancetype)sharedInstance;
- (id)nextPost;
- (BOOL)upvote;
- (BOOL)downvote;

@end
