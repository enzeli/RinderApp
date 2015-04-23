//
//  ViewController.m
//  RinderApp
//
//  Created by Enze Li on 4/22/15.
//  Copyright (c) 2015 RD. All rights reserved.
//

#import "ViewController.h"
#import "RDMockDataManager.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    NSLog(@"View did load");
    RDMockDataManager * mng = [RDMockDataManager sharedInstance];
    NSLog(@"Current post:%@",mng.currentPost);
    NSLog(@"Current post:%@",[mng nextPost]);
    NSLog(@"Current post:%@",[mng nextPost]);
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
