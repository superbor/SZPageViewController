//
//  UIView+RemoveConstraints.h
//  SZPageViewController
//
//  Created by app-dev on 2018/1/25.
//  Copyright © 2018年 app-dev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (RemoveConstraints)
-(void) gy_removeConstraintsAffectingView ;
-(UIView *) gy_commonSuperviewWithView:(UIView *)otherView ;
@end
