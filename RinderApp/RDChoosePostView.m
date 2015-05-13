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
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *titleLabel2;


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
        self.imageView.backgroundColor =[UIColor greenColor];
        self.imageView.image = Nil;
        self.imageView.contentMode = UIViewContentModeScaleAspectFill;
        [self.imageView sd_setImageWithURL:[NSURL URLWithString:post.url]
                          placeholderImage:[UIImage imageNamed:@"rinder.png"]];
        
        self.autoresizingMask = UIViewAutoresizingFlexibleHeight |
            UIViewAutoresizingFlexibleWidth |
            UIViewAutoresizingFlexibleBottomMargin;
        self.imageView.autoresizingMask = self.autoresizingMask;
        
        [self constructInformationView];

    }
    return self;
}

- (void)constructInformationView {
    CGFloat bottomHeight = 60.f;
    CGRect bottomFrame = CGRectMake(0,
                                    CGRectGetHeight(self.bounds) - bottomHeight,
                                    CGRectGetWidth(self.bounds),
                                    bottomHeight);
    _informationView = [[UIView alloc] initWithFrame:bottomFrame];
    _informationView.backgroundColor = [UIColor darkGrayColor];
    _informationView.clipsToBounds = YES;
    _informationView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    _informationView.alpha = 0.5;
    
    [self addSubview:_informationView];

    [self constructTitleLabel];
//    [self constructTitleView];
}

//- (void)constructTitleView {
//    CGFloat leftPadding = 12.f;
//    CGFloat topPadding = 12.f;
//    CGRect frame = CGRectMake(leftPadding,
//                              topPadding,
//                              CGRectGetWidth(_informationView.frame),
//                              CGRectGetHeight(_informationView.frame) - topPadding);
//    _titleView = [[UITextView alloc] initWithFrame:frame];
//    _titleView.textColor = [UIColor whiteColor];
//    _titleView.text = [NSString stringWithFormat:@"%@", _post.title];
//    [_informationView addSubview:_titleLabel];
//}

- (void)constructTitleLabel {
    CGFloat leftPadding = 8.f;
    CGFloat topPadding = 8.f;
    
    CGRect frame = CGRectMake(leftPadding,
                              topPadding,
                              CGRectGetWidth(_informationView.frame) - leftPadding*2,
                              CGRectGetHeight(_informationView.frame) - topPadding*2);
    _titleLabel = [[UILabel alloc] initWithFrame:frame];
    _titleLabel.textColor = [UIColor whiteColor];
//    _titleLabel.backgroundColor = [UIColor greenColor];
    
    if (!_post.title) {
        _titleLabel.text = @"Rindering...";
        [_titleLabel sizeToFit];
        [_informationView addSubview:_titleLabel];
        return;
    }
    
    if (_post.title.length <= 40) {
        _titleLabel.text = _post.title;
        
        [_titleLabel sizeToFit];
        [_informationView addSubview:_titleLabel];
        return;
    }
    
    
    NSArray *lines = [self splitString:_post.title maxCharacters:35];
//    NSLog(@"%@", lines);
    
    _titleLabel.text = lines[0];
    
    [_titleLabel sizeToFit];
    [_informationView addSubview:_titleLabel];
    
    if (lines.count > 1)
    {
        frame = CGRectMake(leftPadding,
                           topPadding +2.f+ _titleLabel.frame.size.height,
                           CGRectGetWidth(_informationView.frame) - leftPadding*2,
                           _titleLabel.frame.size.height);
        
        _titleLabel2 = [[UILabel alloc] initWithFrame:frame];
        _titleLabel2.textColor = [UIColor whiteColor];
        //    _titleLabel2.backgroundColor = [UIColor greenColor];
        _titleLabel2.text = lines[1];
        [_titleLabel2 sizeToFit];
        [_informationView addSubview:_titleLabel2];
    }
    
    
    
}


- (NSArray *)splitString:(NSString*)str maxCharacters:(NSInteger)maxLength {
    NSMutableArray *tempArray = [NSMutableArray arrayWithCapacity:1];
    NSArray *wordArray = [str componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSInteger numberOfWords = [wordArray count];
    NSInteger index = 0;
    NSInteger lengthOfNextWord = 0;
    
    while (index < numberOfWords) {
        NSMutableString *line = [NSMutableString stringWithCapacity:1];
        while ((([line length] + lengthOfNextWord + 1) <= maxLength) && (index < numberOfWords)) {
            lengthOfNextWord = [[wordArray objectAtIndex:index] length];
            [line appendString:[wordArray objectAtIndex:index]];
            index++;
            if (index < numberOfWords) {
                [line appendString:@" "];
            }
        }
        [tempArray addObject:line];
    }
    return tempArray;
}
@end
