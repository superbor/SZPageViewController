//
//  NSLayoutConstraint+RemoveConstraints.m
//  SZPageViewController
//
//  Created by app-dev on 2018/1/25.
//  Copyright © 2018年 app-dev. All rights reserved.
//

#import "NSLayoutConstraint+RemoveConstraints.h"
#import "UIView+RemoveConstraints.h"
@implementation NSLayoutConstraint (RemoveConstraints)
-(void) gy_autoRemove {
    if (@available(iOS 8, *)) {
        [self setActive:NO];
        return;
    }
    
    if (self.secondItem != nil) {
        UIView *commonSuperview;
        commonSuperview = [self.firstItem gy_commonSuperviewWithView:self.secondItem ];
        while (commonSuperview != nil) {
            if ([commonSuperview.constraints containsObject:self] == YES) {
                [commonSuperview removeConstraint:self];
               
                return;
            }
            commonSuperview = commonSuperview.superview;
        }
    }
    else {
        
          [ self.firstItem removeConstraint:self];
      
        return;
    }
  
}

@end
