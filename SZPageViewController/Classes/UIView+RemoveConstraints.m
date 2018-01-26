//
//  UIView+RemoveConstraints.m
//  SZPageViewController
//
//  Created by app-dev on 2018/1/25.
//  Copyright © 2018年 app-dev. All rights reserved.
//

#import "UIView+RemoveConstraints.h"
#import <UIKit/UIKit.h>
@implementation UIView (RemoveConstraints)


-(void) gy_removeConstraintsAffectingView {
    UIView *currentSuperView = self.superview;
    NSMutableArray *constraintsToRemove = [[NSMutableArray alloc] init];
    while (currentSuperView != nil) {
       NSArray *constraints = currentSuperView.constraints;
       
            for (NSLayoutConstraint *c in constraints ){
                if( [NSStringFromClass([c class]) isEqualToString:@"NSContentSizeLayoutConstraint"] ){
                    
                  
                        if ([self isEqual:c.firstItem] || [self isEqual:c.secondItem] ) {
                            [constraintsToRemove addObject:c];
                        }
                    
                }
              
               
            }
        
        currentSuperView = currentSuperView.superview;
    }
    
   // constraintsToRemove.gy_autoRemoveConstraints()
}

-(UIView *) gy_commonSuperviewWithView:(UIView *)otherView  {
    UIView *startView = self;
    UIView *commonSuperview;
    
 
    
    do {
        UIView *obj = startView;
        if ( obj){
            
            UIView *obj = startView;
            if ([otherView isDescendantOfView:obj]) {
                commonSuperview =obj;
            }
           
        }
        startView = startView.superview;
    } while (startView != nil && commonSuperview == nil);
        
        return commonSuperview;
    
    
    }


@end
