//
//  RDChoosePostView.m
//  RinderApp
//
//  Created by Enze Li on 4/23/15.
//  Copyright (c) 2015 RD. All rights reserved.
//

#import "RDChoosePostView.h"

#import "RedditPost.h"
#import <SDWebImage/UIImageView+WebCache.h>

//static const CGFloat ChoosePersonViewImageLabelWidth = 42.f;

@interface RDChoosePostView()

@property (nonatomic, strong) UIView *informationView;

@end

@implementation RDChoosePostView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame
                         post:(RedditPost *)post
                      options:(MDCSwipeToChooseViewOptions *)options
{
    self = [super initWithFrame:frame options:options];
    if (self) {
        _post = post;
        self.imageView.image = Nil;
        self.imageView.contentMode = UIViewContentModeScaleAspectFill;
        [self.imageView sd_setImageWithURL:[NSURL URLWithString:post.url]
                          placeholderImage:[UIImage imageNamed:@"rinder.png"]];
        
        self.autoresizingMask = UIViewAutoresizingFlexibleHeight |
        UIViewAutoresizingFlexibleWidth |
        UIViewAutoresizingFlexibleBottomMargin;
        self.imageView.autoresizingMask = self.autoresizingMask;
        
//        [self constructInformationView];
    }
    return self;
}

@end
