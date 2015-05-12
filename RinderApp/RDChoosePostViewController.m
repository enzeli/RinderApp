//
//  RDChoosePostViewController.m
//  RinderApp
//
//  Created by Enze Li on 4/23/15.
//  Copyright (c) 2015 RD. All rights reserved.
//

#import "RDChoosePostViewController.h"
#import "MBProgressHUD.h"

static const CGFloat ChoosePersonButtonHorizontalPadding = 80.f;
static const CGFloat ChoosePersonButtonVerticalPadding = 20.f;

@interface RDChoosePostViewController ()

@property (strong, nonatomic) RDHostDataManager* mng;
@property (strong, nonatomic) MBProgressHUD* hud;
@property (strong, nonatomic) UITapGestureRecognizer * recognizer;
@property (strong, nonatomic) UIImageView * imageView;

@end

@implementation RDChoosePostViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view.
    NSLog(@"View did load");
    _mng = [RDHostDataManager sharedInstance];
    _mng.delegate = self;

    NSLog(@"Manager did load");
    
    self.recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTapped:)];
    
    [self reloadCardViews];
    
    [self constructDownvoteButton];
    [self constructUpvoteButton];
    
    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.hud.mode = MBProgressHUDModeIndeterminate;
    self.hud.labelText = @"Loading";
}

- (void)reloadCardViews
{
    self.frontCardView =[self popPostViewWithFrame:[self backCardViewFrame]
                                              post:_mng.currentPost];
    [self.view addSubview:self.frontCardView];
    
    [self.frontCardView addGestureRecognizer:self.recognizer];
    
    self.backCardView = [self popPostViewWithFrame:[self backCardViewFrame]
                                              post:_mng.nextPost];
    [self.view insertSubview:self.backCardView belowSubview:self.frontCardView];
}

- (RDChoosePostView *)popPostViewWithFrame:(CGRect)frame post:(RedditPost*) post{
    
    // UIView+MDCSwipeToChoose and MDCSwipeToChooseView are heavily customizable.
    // Each take an "options" argument. Here, we specify the view controller as
    // a delegate, and provide a custom callback that moves the back card view
    // based on how far the user has panned the front card view.
    MDCSwipeToChooseViewOptions *options = [MDCSwipeToChooseViewOptions new];
    options.delegate = self;
    options.threshold = 160.f;
    options.onPan = ^(MDCPanState *state){
        CGRect frame = [self backCardViewFrame];
        self.backCardView.frame = CGRectMake(frame.origin.x,
                                             frame.origin.y - (state.thresholdRatio * 10.f),
                                             CGRectGetWidth(frame),
                                             CGRectGetHeight(frame));
    };
    
    // Create a personView with the top person in the people array, then pop
    // that person off the stack.
    RDChoosePostView *postView = [[RDChoosePostView alloc] initWithFrame:frame
                                                                  post:post
                                                                 options:options];
    
    return postView;
}



#pragma mark - MDCSwipeToChooseDelegate Protocol Methods

// This is called when a user didn't fully swipe left or right.
- (void)viewDidCancelSwipe:(UIView *)view {
    NSLog(@"You couldn't decide on %@.", _mng.currentPost.title);
}

// This is called then a user swipes the view fully left or right.
- (void)view:(UIView *)view wasChosenWithDirection:(MDCSwipeDirection)direction {
    // MDCSwipeToChooseView shows "NOPE" on swipes to the left,
    // and "LIKED" on swipes to the right.
    if (direction == MDCSwipeDirectionLeft) {
        [_mng downvote];
    } else {
        [_mng upvote];
    }
    
    // MDCSwipeToChooseView removes the view from the view hierarchy
    // after it is swiped (this behavior can be customized via the
    // MDCSwipeOptions class). Since the front card view is gone, we
    // move the back card to the front, and create a new back card.
    self.frontCardView = self.backCardView;
    [self.frontCardView addGestureRecognizer:self.recognizer];
    self.backCardView = [self popPostViewWithFrame:[self backCardViewFrame]
                                              post:_mng.nextPost];
    if ((self.backCardView)) {
        // Fade the back card into view.
        self.backCardView.alpha = 0.f;
        [self.view insertSubview:self.backCardView belowSubview:self.frontCardView];
        [UIView animateWithDuration:0.5
                              delay:0.0
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             self.backCardView.alpha = 1.f;
                         }
                         completion:nil];
    }
}


#pragma mark View Contruction

- (CGRect)frontCardViewFrame {
    CGFloat horizontalPadding = 20.f;
    CGFloat topPadding = 60.f;
    CGFloat bottomPadding = 200.f;
    return CGRectMake(horizontalPadding,
                      topPadding,
                      CGRectGetWidth(self.view.frame) - (horizontalPadding * 2),
                      CGRectGetHeight(self.view.frame) - bottomPadding);
}

- (CGRect)backCardViewFrame {
    CGRect frontFrame = [self frontCardViewFrame];
    return CGRectMake(frontFrame.origin.x,
                      frontFrame.origin.y + 10.f,
                      CGRectGetWidth(frontFrame),
                      CGRectGetHeight(frontFrame));
}

// Create and add the "nope" button.
- (void)constructDownvoteButton {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    UIImage *image = [UIImage imageNamed:@"downvote"];
    button.frame = CGRectMake(ChoosePersonButtonHorizontalPadding,
                              CGRectGetMaxY(self.backCardView.frame) + ChoosePersonButtonVerticalPadding,
                              image.size.width,
                              image.size.height);
    [button setImage:image forState:UIControlStateNormal];
    [button setTintColor:[UIColor colorWithRed:247.f/255.f
                                         green:91.f/255.f
                                          blue:37.f/255.f
                                         alpha:1.f]];
    [button addTarget:self
               action:@selector(downvoteFrontCardView)
     forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

// Create and add the "like" button.
- (void)constructUpvoteButton {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    UIImage *image = [UIImage imageNamed:@"upvote"];
    button.frame = CGRectMake(CGRectGetMaxX(self.view.frame) - image.size.width - ChoosePersonButtonHorizontalPadding,
                              CGRectGetMaxY(self.backCardView.frame) + ChoosePersonButtonVerticalPadding,
                              image.size.width,
                              image.size.height);
    [button setImage:image forState:UIControlStateNormal];
    [button setTintColor:[UIColor colorWithRed:29.f/255.f
                                         green:245.f/255.f
                                          blue:106.f/255.f
                                         alpha:1.f]];
    [button addTarget:self
               action:@selector(upvoteFrontCardView)
     forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

#pragma mark - Comments view


- (void)imageTapped:(UITapGestureRecognizer *)recognizer
{
    self.imageView = [[UIImageView alloc] initWithFrame:self.view.frame];
    self.imageView.backgroundColor = [UIColor blackColor];
    [self.imageView setImage:self.frontCardView.imageView.image];
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.imageView.alpha = 0.0;
    [self.view addSubview:self.imageView];
    [UIView animateWithDuration:0.3
                     animations:^{
                         self.imageView.alpha = 1.0;
                     }];
    self.imageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *dismissTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissTapped:)];
    [self.imageView addGestureRecognizer:dismissTap];
}
                                          
- (void)dismissTapped:(UITapGestureRecognizer *)recognizer
{
    [UIView animateWithDuration:0.3
                     animations:^{
                         self.imageView.alpha = 0.0;
                     }
                     completion:^(BOOL finished){
                         if (finished) {
                             [self.imageView removeFromSuperview];
                             self.imageView = nil;
                         }
                     }];
}

#pragma mark - Control Events

// Programmatically "nopes" the front card view.
- (void)downvoteFrontCardView {
    [self.frontCardView mdc_swipe:MDCSwipeDirectionLeft];
}

// Programmatically "likes" the front card view.
- (void)upvoteFrontCardView {
    [self.frontCardView mdc_swipe:MDCSwipeDirectionRight];
}

#pragma mark - Data Manager Delegate

- (void)didFinishLoadingData:(RDHostDataManager *)manager
{
    NSLog(@"didFinishLoadingData");
    [self reloadCardViews];
    [self.hud hide:YES];
}

@end
