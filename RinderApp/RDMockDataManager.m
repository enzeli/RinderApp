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
@property (strong, nonatomic) NSArray* data;

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
    if ([self.data count] == 0) {
        return;
    }
    _idx = idx;
    
    self.currentPost = [[RedditPost alloc] initWithJSON: [self.data objectAtIndex:idx]];
    
    int nextIdx = (_idx+1) % [self.data count];
    
    self.nextPost = [[RedditPost alloc] initWithJSON: [self.data objectAtIndex:nextIdx]];
    
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
        self.data = (NSArray *) JSONObject;
    }
}


- (BOOL)upvote
{
    NSLog(@"You upvoted %@.", self.currentPost.title);
    [self userDidVote];
    return YES;
}

-(BOOL)downvote
{
    NSLog(@"You downvoted %@.", self.currentPost.title);
    [self userDidVote];
    return YES;
}

- (void)userDidVote
{
    if (self.data.count == 0){
        return;
    }
    
    int nextIdx = self.idx+1 % self.data.count;
    
    _idx = nextIdx;
    
    if (self.nextPost){
        self.currentPost = self.nextPost;
    } else{
        self.currentPost = [[RedditPost alloc] initWithJSON: [self.data objectAtIndex:nextIdx]];
    }
    
    int nextNextIdx = (nextIdx+1) % [self.data count];
    
    self.nextPost = [[RedditPost alloc] initWithJSON: [self.data objectAtIndex:nextNextIdx]];
    
}


@end
