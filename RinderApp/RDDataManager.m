//
//  RDDataSourseIterator.m
//  RinderApp
//
//  Created by Enze Li on 4/22/15.
//  Copyright (c) 2015 RD. All rights reserved.
//

#import "RDDataManager.h"

@interface RDDataManager()

@end

@implementation RDDataManager

+ (instancetype)sharedInstance {
    static RDDataManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (BOOL)upvote
{
    return YES;
}

- (BOOL)downvote
{
    return NO;
}


@end
