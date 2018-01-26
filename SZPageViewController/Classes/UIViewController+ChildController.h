//
//  UIViewController+ChildController.h
//  SZPageViewController
//
//  Created by app-dev on 2018/1/25.
//  Copyright © 2018年 app-dev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (ChildController)
-(void)gy_addChildViewController:(UIViewController *)viewController;
-(void)gy_addChildViewController:(UIViewController *)viewController  frame:(CGRect)frame;
-(void)gy_addChildViewController:(UIViewController *)viewController inView:(UIView *)inView withFrame:(CGRect)withFrame;
-(void)gy_addChildViewController:(UIViewController *)viewController setSubViewAction:(void (^)(UIViewController *,UIViewController *)) setSubViewAction;
-(void) gy_removeFromParentViewControllerOnly;

-(void) gy_removeFromParentViewController;
@end
