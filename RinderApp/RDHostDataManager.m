//
//  RDLocalhostDataManager.m
//  RinderApp
//
//  Created by Enze Li on 5/9/15.
//  Copyright (c) 2015 RD. All rights reserved.
//

#import "RDHostDataManager.h"
#import "AFNetworking.h"

#if TARGET_IPHONE_SIMULATOR
static NSString * const ENDPOINT = @"http://localhost:8080/api/v1/links";
#else
static NSString * const ENDPOINT = @"http://rinder.elasticbeanstalk.com/api/v1/links";
#endif

@interface RDHostDataManager()

@property (assign, nonatomic) int idx;
@property (strong, nonatomic) NSArray* data;
@property (strong, nonatomic) NSArray* nextData;
@property (assign) NSInteger page;

@end


@implementation RDHostDataManager

@synthesize idx=_idx;

-(id)init {
    NSLog(@"Endpoint: %@", ENDPOINT);
    if ( self = [super init] ) {
        self.idx = 0;
        self.data = nil;
        self.page = 0;
        [self loadLocalDataFromURL:[self urlForPage:self.page] toNext:NO];
        self.page += 1;
        [self loadLocalDataFromURL:[self urlForPage:self.page] toNext:YES];
        self.page += 1;
        
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


-(void)loadLocalDataFromURL:(NSString *)urlString toNext:(BOOL)toNext
{
    
    NSLog(@"%@",urlString);
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    operation.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];

    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (toNext) {
            self.nextData = responseObject;
            NSLog(@"Load to next %d posts", (int)self.nextData.count);
        } else {
            self.data = responseObject;
            self.idx = 0;
            NSLog(@"Load to current %d posts", (int)self.data.count);
            [self.delegate didFinishLoadingData:self];
            
        }
        
        
        }
                                     failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error Retrieving Data"
                                                            message:[error localizedDescription]
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
        [alertView show];
    }];
    

    [operation start];
    
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
    
    if (self.idx == self.data.count-1) {
        // switch data to nextdata
        _idx = 0;
        self.data = self.nextData;
        [self loadLocalDataFromURL:[self urlForPage:self.page] toNext:YES];
        self.page += 1;
        
        if (self.nextPost){
            self.currentPost = self.nextPost;
        } else {
            self.currentPost = [[RedditPost alloc] initWithJSON: [self.data objectAtIndex:_idx]];
        }
        
        self.nextPost = [[RedditPost alloc] initWithJSON: [self.data objectAtIndex:_idx+1]];
        
    } else if (self.idx == self.data.count-2) {
        // nextpost to nextdata
        _idx = self.idx+1;
        
        if (self.nextPost){
            self.currentPost = self.nextPost;
        } else {
            self.currentPost = [[RedditPost alloc] initWithJSON: [self.data objectAtIndex:_idx]];
        }
        
        if (self.nextData) {
            self.nextPost = [[RedditPost alloc] initWithJSON: [self.nextData objectAtIndex:0]];
        }
    
    } else {
        // stay on current data
        _idx = self.idx+1;
        
        if (self.nextPost){
            self.currentPost = self.nextPost;
        } else {
            self.currentPost = [[RedditPost alloc] initWithJSON: [self.data objectAtIndex:_idx]];
        }
        
        self.nextPost = [[RedditPost alloc] initWithJSON: [self.data objectAtIndex:_idx+1]];
    }
    
    
}

- (NSString *)urlForPage:(NSInteger)i
{
    return [NSString stringWithFormat:[ENDPOINT stringByAppendingString:@"?page=%d"], i];
}

@end
