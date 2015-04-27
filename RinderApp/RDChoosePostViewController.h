//
//  RDChoosePostViewController.h
//  RinderApp
//
//  Created by Enze Li on 4/23/15.
//  Copyright (c) 2015 RD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MDCSwipeToChoose/MDCSwipeToChoose.h>
#import "RDChoosePostView.h"

@interface RDChoosePostViewController : UIViewController <MDCSwipeToChooseDelegate>

@property (nonatomic, strong) RDChoosePostView *frontCardView;
@property (nonatomic, strong) RDChoosePostView *backCardView;

@end
