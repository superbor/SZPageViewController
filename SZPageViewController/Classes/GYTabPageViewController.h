//
//  GYTabPageViewController.h
//  SZPageViewController
//
//  Created by app-dev on 2018/1/25.
//  Copyright © 2018年 app-dev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GYPageViewController.h"
#import "HMSegmentedControl.h"



@protocol GYTabPageViewControllerDelegate <NSObject>
@optional

-(void)pageViewDidSelectedIndex:(int ) index;
;


@end
@interface GYTabPageViewController : GYPageViewController
- (instancetype)initWithpageTitles:(NSArray *)pageTitles;

@property (nonatomic, copy) NSArray *pageTitles;
@property (nonatomic, strong) HMSegmentedControl *segmentedControl;
@end
