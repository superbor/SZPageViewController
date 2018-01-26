//
//  UIViewController+ChildController.m
//  SZPageViewController
//
//  Created by app-dev on 2018/1/25.
//  Copyright © 2018年 app-dev. All rights reserved.
//

#import "UIViewController+ChildController.h"

@implementation UIViewController (ChildController)
-(void)gy_addChildViewController:(UIViewController *)viewController{
    [self gy_addChildViewController:viewController frame:self.view.bounds];
}


-(void)gy_addChildViewController:(UIViewController *)viewController  frame:(CGRect)frame{
    
    [self gy_addChildViewController:viewController setSubViewAction:^(UIViewController * superViewController,UIViewController *childViewController){
        
            childViewController.view.frame = frame;
        if ([superViewController.view.subviews containsObject:viewController.view] == false ){
            [superViewController.view  addSubview:viewController.view];
        }
    }
     ];
}

-(void)gy_addChildViewController:(UIViewController *)viewController inView:(UIView *)inView withFrame:(CGRect)withFrame{
    
    [self gy_addChildViewController:viewController setSubViewAction:^(UIViewController * superViewController,UIViewController *childViewController){
        
        childViewController.view.frame = withFrame;
        if ([inView.subviews containsObject:viewController.view] == false ){
            [inView addSubview:viewController.view];
        }
    }
     ];
}

-(void)gy_addChildViewController:(UIViewController *)viewController setSubViewAction:(void (^)(UIViewController *,UIViewController *)) setSubViewAction{
    BOOL containsVC =[self.childViewControllers containsObject:viewController];
    
    if (!containsVC) {
        [self addChildViewController:viewController];
    }
    
    setSubViewAction(self,viewController);
    if (!containsVC) {
        [viewController didMoveToParentViewController:self];
    }
}


-(void) gy_removeFromParentViewControllerOnly {
    
    [self willMoveToParentViewController:nil];
    [self removeFromParentViewController];
    
}

-(void) gy_removeFromParentViewController{
   [self willMoveToParentViewController:nil];
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
}
@end
