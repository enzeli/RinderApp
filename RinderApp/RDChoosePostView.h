//
//  RDChoosePostView.h
//  RinderApp
//
//  Created by Enze Li on 4/23/15.
//  Copyright (c) 2015 RD. All rights reserved.
//

#import "MDCSwipeToChooseView.h"
#import "RedditPost.h"

@interface RDChoosePostView : MDCSwipeToChooseView

@property (nonatomic, strong, readonly) RedditPost *post;

- (instancetype)initWithFrame:(CGRect)frame
                       post:(RedditPost *)post
                      options:(MDCSwipeToChooseViewOptions *)options;

@end
