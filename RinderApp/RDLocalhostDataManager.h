//
//  RDLocalhostDataManager.h
//  RinderApp
//
//  Created by Enze Li on 5/9/15.
//  Copyright (c) 2015 RD. All rights reserved.
//

#import "RDDataManager.h"

@class RDLocalhostDataManager;

@protocol RDDataMangerDelegate <NSObject>

-(void)didFinishLoadingData:(RDLocalhostDataManager *)manager;

@end

@interface RDLocalhostDataManager : RDDataManager

@property (nonatomic, weak) id <RDDataMangerDelegate> delegate;

@end

