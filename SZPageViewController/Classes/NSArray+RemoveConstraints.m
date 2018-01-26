//
//  NSArray+RemoveConstraints.m
//  SZPageViewController
//
//  Created by app-dev on 2018/1/25.
//  Copyright © 2018年 app-dev. All rights reserved.
//

#import "NSArray+RemoveConstraints.h"
#import <UIKit/UIKit.h>
#import "NSLayoutConstraint+RemoveConstraints.h"
@implementation NSArray (RemoveConstraints)
-(void) gy_autoRemoveConstraints {
     if (@available(iOS 8, *)){
         
        
             [NSLayoutConstraint deactivateConstraints:self];
         

    }
 
    for (id obj in self) {
        if ([obj isKindOfClass:NSLayoutConstraint.class]) {
            NSLayoutConstraint *objj=  (NSLayoutConstraint *)obj;
            [objj gy_autoRemove];
        }
        
    }
}
@end
