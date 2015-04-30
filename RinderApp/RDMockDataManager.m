//
//  RDMockDataManager.m
//  RinderApp
//
//  Created by Enze Li on 4/22/15.
//  Copyright (c) 2015 RD. All rights reserved.
//

#import "RDMockDataManager.h"
#import "RedditPost.h"

@interface RDMockDataManager()

@property (assign, nonatomic) int idx;
@property (strong, nonatomic) NSArray* mockdata;

@end

@implementation RDMockDataManager

@synthesize idx=_idx;

-(id)init {
    if ( self = [super init] ) {
        [self loadLocalData];
        
        self.idx = 0;
    }
    return self;
}

- (void)setIdx:(int)idx
{
    _idx = idx;
    id JSONPost = [self.mockdata objectAtIndex:idx];
    self.currentPost = [[RedditPost alloc] initWithJSON:JSONPost];
}


-(void)loadLocalData
{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"data" ofType:@"json"];
    
    // Load the file into an NSData object called JSONData
    
    NSError *error = nil;
    
    NSData *JSONData = [NSData dataWithContentsOfFile:filePath options:NSDataReadingMappedIfSafe error:&error];
    
    // Create an Objective-C object from JSON Data
    
    id JSONObject = [NSJSONSerialization
                     JSONObjectWithData:JSONData
                     options:NSJSONReadingAllowFragments
                     error:&error];
    
//    NSLog(@"%@", JSONObject);
    if ([JSONObject isKindOfClass:[NSArray class]])
    {
        self.mockdata = (NSArray *) JSONObject;
    }
}

-(id)nextPost
{
    self.idx = (_idx+1) % [self.mockdata count];
    return self.currentPost;
}

- (BOOL)upvote
{
    return YES;
}

-(BOOL)downvote
{
    return YES;
}



@end
