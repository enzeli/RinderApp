//
//  BSCropImageView.m
//  Birdsnap
//
//  Created by Enze Li on 6/30/14.
//  Copyright (c) 2014 Columbia University. All rights reserved.
//

#import "RDImageScrollView.h"

@interface RDImageScrollView () <UIScrollViewDelegate>

@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) UIImageView *imageView;
@property (nonatomic) CGFloat currentScale;
@property (nonatomic) CGPoint currentCentralOffset;

@end

@implementation RDImageScrollView

-(void)awakeFromNib{
//    NSLog(@"awakeFromNib");
    [super awakeFromNib];
    [self addSubviews];
    self.scrollView.delegate = self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self addSubviews];
    }
    return self;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    [self prepareToResizeTo:frame.size];
    [self recoverFromResizing];
}

- (void)setImage:(UIImage *)image
{
//    NSLog(@"BSCropImageView setImage:");
    if (self.imageView) {
        [self.imageView removeFromSuperview];
    }
    self.imageView = [[UIImageView alloc] initWithImage:image];
    [self.scrollView addSubview:self.imageView];
    [self addSubviews];
    [self updateScroll];
}

- (id)initWithFrame:(CGRect)frame image:(UIImage *)image
{
    self = [self initWithFrame:frame];
    if (self) {
        // Initialization codes
        [self setImage:image];
    }
    return self;
}


- (void)didMoveToSuperview{
//     NSLog(@"didMoveToSuperview");
    [self addSubviews];
    [super didMoveToSuperview];
    
}

- (void)addSubviews
{
//    NSLog(@"BSCropImageView addSubviews");
    self.backgroundColor = [UIColor blackColor];
    self.scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    [self addSubview:self.scrollView];
    
    if (self.imageView) {
        [self.scrollView addSubview:self.imageView];
        [self updateScroll];
    }
    
}


- (void)updateScroll
{
    if (self.scrollView && self.imageView) {
        self.scrollView.delegate = self;
        self.scrollView.contentSize = self.imageView ? self.imageView.bounds.size : CGSizeZero;
        self.scrollView.minimumZoomScale = MIN(self.scrollView.frame.size.height/self.imageView.image.size.height,
                                               self.scrollView.frame.size.width/self.imageView.image.size.width) * 0.85;
        self.scrollView.maximumZoomScale = 3.0;
        [self.scrollView setZoomScale:MIN(self.scrollView.minimumZoomScale/0.85, 1.0)];
        
        self.scrollView.showsHorizontalScrollIndicator = NO;
        self.scrollView.showsVerticalScrollIndicator = NO;
        
        CGFloat viewH = self.frame.size.height;
        CGFloat viewW = self.frame.size.width;
        UIEdgeInsets insets = UIEdgeInsetsMake(viewH/2, viewW/2, viewH/2, viewW/2);
        [self.scrollView setContentInset:insets];
        
        // center image
        [self.scrollView setContentOffset:CGPointMake(self.scrollView.contentSize.width/2 - viewW/2,
                                                      self.scrollView.contentSize.height/2 - viewH/2)];
    }
}

#pragma mark - autolayout view update

-(void)setBounds:(CGRect)newBounds {
    BOOL const isResize = !CGSizeEqualToSize(newBounds.size, self.bounds.size);
    if (isResize) [self prepareToResizeTo:newBounds.size]; // probably saves
    [super setBounds:newBounds];
    if (isResize) [self recoverFromResizing];
}

- (void)prepareToResizeTo:(CGSize)size{
    NSLog(@"Prepare to resize");
    
    CGFloat offsetX = self.scrollView.contentOffset.x;
    CGFloat offsetY = self.scrollView.contentOffset.y;
    CGFloat zoomScale = self.scrollView.zoomScale;
    CGFloat imageW = self.imageView.bounds.size.width;
    CGFloat imageH = self.imageView.bounds.size.height;
    CGFloat scrollW = self.scrollView.bounds.size.width;
    CGFloat scrollH = self.scrollView.bounds.size.height;
    CGFloat centralOffsetX = scrollW/2 + offsetX - imageW*zoomScale/2;
    CGFloat centralOffsetY = scrollH/2 + offsetY - imageH*zoomScale/2;
    
//    NSLog(@"scale: %f", zoomScale);
//    NSLog(@"offset: (%f, %f)", offsetX, offsetY);
//    NSLog(@"scrollview: %f*%f", scrollW, scrollH);
//    NSLog(@"imageview: %f*%f", imageW, imageH);    
//    NSLog(@"centralOffset (%f, %f)", centralOffsetX, centralOffsetY);
    
    self.currentCentralOffset = CGPointMake(centralOffsetX, centralOffsetY);
    self.currentScale = self.scrollView.zoomScale;
    
}

- (void)recoverFromResizing{
    NSLog(@"recoverFromResizing");
    [self.scrollView removeFromSuperview];
    self.scrollView = nil;
    [self addSubviews];
    
    self.scrollView.zoomScale = self.currentScale;
    CGFloat zoomScale = self.scrollView.zoomScale;
    CGFloat imageW = self.imageView.bounds.size.width;
    CGFloat imageH = self.imageView.bounds.size.height;
    CGFloat scrollW = self.scrollView.bounds.size.width;
    CGFloat scrollH = self.scrollView.bounds.size.height;
    
    CGFloat offsetX = self.currentCentralOffset.x - scrollW/2 + imageW*zoomScale/2;
    CGFloat offsetY = self.currentCentralOffset.y - scrollH/2 + imageH*zoomScale/2;
    self.scrollView.contentOffset = CGPointMake(offsetX, offsetY);
}

#pragma mark - UIScrollViewDelegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}


- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
    [scrollView setContentOffset:scrollView.contentOffset animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGPoint offset = scrollView.contentOffset;
    CGFloat minOffsetX = -self.scrollView.frame.size.width/2;
    CGFloat minOffsetY = -self.scrollView.frame.size.height/2;
    CGFloat maxOffsetX = self.imageView.frame.size.width + minOffsetX;
    CGFloat maxOffsetY = self.imageView.frame.size.height + minOffsetY;
    
    // Check if current offset is within limit and adjust if it is not
    if (offset.x < minOffsetX) offset.x = minOffsetX;
    if (offset.y < minOffsetY) offset.y = minOffsetY;
    if (offset.x > maxOffsetX) offset.x = maxOffsetX;
    if (offset.y > maxOffsetY) offset.y = maxOffsetY;
    
    // Set offset to limit value
    [scrollView setContentOffset:offset];
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
