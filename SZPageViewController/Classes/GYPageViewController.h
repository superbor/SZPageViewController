//
//  GYPageViewController.h
//  SZPageViewController
//
//  Created by app-dev on 2018/1/24.
//  Copyright © 2018年 app-dev. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GYPageViewController;
@protocol GYPageViewControllerDelegate <NSObject>
@optional
-(void)gy_pageViewController:(GYPageViewController *) pageViewController
                           willTransitonFrom:(UIViewController *) fromVC
                           toViewController:(UIViewController *) toVC
                           animated:(BOOL) animated;

-(void)gy_pageViewController:(GYPageViewController *) pageViewController
           willTransitonFrom:(UIViewController *) fromVC
            toViewController:(UIViewController *) toVC;

-(void)gy_pageViewController:(GYPageViewController *) pageViewController
           didLeaveViewController:(UIViewController *) fromVC
            toViewController:(UIViewController *) toVC
                    finished:(BOOL) finished;


@end

@protocol GYPageViewControllerDataSource <NSObject>

-(UIViewController *)gy_pageViewController:(GYPageViewController *) pageViewController
           controllerAtIndex:(int) index;
-(int )numberOfControllers:(GYPageViewController *) pageViewController;
@end





@interface GYPageViewController : UIViewController
@property (nonatomic, strong) NSCache *memCache;
@property (nonatomic,weak)id<GYPageViewControllerDelegate> delegate;

@property (nonatomic,weak)id<GYPageViewControllerDataSource> dataSource;
@property (nonatomic, assign) int currentPageIndex;
@property (nonatomic, assign) int guessToIndex;   //用于手势拖动scrollView时，判断要去的页面
 @property (nonatomic, assign) CGFloat originOffset  ;                 //用于手势拖动scrollView时，判断方向
 @property (nonatomic, strong)UIScrollView    *scrollView;
@property (nonatomic,assign)   BOOL isDecelerating ;           //正在减速操作
-(int)pageCount;


-(void) gy_pageViewControllerDidTransitonFrom:(int)fromIndex toindex:(int)toIndex ;
-(void)gy_pageViewControllerDidShow:(int)fromIndex toindex:(int)toIndex finished:(BOOL) finished;


-(void)showPageAtIndex:(int)index animated:(BOOL)animated ;


- (UIViewController *)controllerAtIndex:(int ) index;

-(int)calcIndexWithOffset:(float) offset width :(float) width ;
-(void)cleanCacheToClean;
@end
