//
//  RDMockDataManager.m
//  RinderApp
//
//  Created by Enze Li on 4/22/15.
//  Copyright (c) 2015 RD. All rights reserved.
//

#import "RDMockDataManager.h"

@interface RDMockDataManager()

@property (assign) int idx;
@property (strong, nonatomic) NSArray* mockdata;

@end

@implementation RDMockDataManager


-(id)init {
    if ( self = [super init] ) {
        self.mockdata = [[NSArray alloc] initWithContentsOfFile:@"data.json"];
        self.idx = 0;
    }
    return self;
}

@end
