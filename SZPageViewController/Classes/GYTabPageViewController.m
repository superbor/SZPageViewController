//
//  GYTabPageViewController.m
//  SZPageViewController
//
//  Created by app-dev on 2018/1/25.
//  Copyright © 2018年 app-dev. All rights reserved.
//

#import "GYTabPageViewController.h"
#import "GYPageViewController.h"
#import "HMSegmentedControl.h"
#import "UIView+RemoveConstraints.h"
@interface GYTabPageViewController ()<UIScrollViewDelegate,NSCacheDelegate>{
    
   
   
    CGFloat segmentHeight;
}

@end

@implementation GYTabPageViewController



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (instancetype)initWithpageTitles:(NSArray *)pageTitles
{
   self = [super initWithNibName:nil bundle:nil];
    if (self) {
        _pageTitles=pageTitles;
        if (_pageTitles.count >1) {
            _segmentedControl = [[HMSegmentedControl alloc] initWithSectionTitles:_pageTitles];
            [self setupSegmentedControl:_segmentedControl];
        }
    }
    
    
    return self;
}
- (void)viewDidLoad {
    
    segmentHeight =44.0;
    [super viewDidLoad];
    if (_pageTitles.count!=[self pageCount]) {
        NSLog(@"title count is not equal controllers countA%lu",(unsigned long)_pageTitles.count);
    }
    
    if (_pageTitles.count > 1) {
NSLog(@"layoutSegmentedControl");
        [self layoutSegmentedControl:_segmentedControl];
       
    }
    [self resetScrollViewLayoutConstraints:self.scrollView];
   
    // Do any additional setup after loading the view.
}

//MARK: - Subviews Configuration
-(void) resetScrollViewLayoutConstraints:(UIScrollView *)scrollView{
    
  
    [scrollView gy_removeConstraintsAffectingView];
    NSMutableArray *constraints = [[NSMutableArray alloc] init];
    
    NSMutableArray *constraintAttributes = [NSMutableArray arrayWithObjects:[NSNumber numberWithInt:NSLayoutAttributeBottom],
                                            [NSNumber numberWithInt:NSLayoutAttributeLeading],
                                            [NSNumber numberWithInt:NSLayoutAttributeTrailing] ,nil];
    NSLayoutConstraint *topConstraint=[NSLayoutConstraint constraintWithItem:scrollView
                                                                   attribute:NSLayoutAttributeTop
                                                                   relatedBy:NSLayoutRelationEqual
                                                                      toItem:_segmentedControl
                                                                   attribute:NSLayoutAttributeBottom
                                                                  multiplier:1.0
                                                                    constant:0];
    
    for (NSNumber *attribute in constraintAttributes) {
        NSLayoutConstraint *constraint=[NSLayoutConstraint constraintWithItem:scrollView
                                                                    attribute:[attribute intValue]
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:self.view
                                                                    attribute:[attribute intValue]
                                                                   multiplier:1.0
                                                                     constant:0];
        [constraints addObject:constraint];
        
        
    }
       [self.view addConstraints:constraints];
 
}
-(void) layoutSegmentedControl:( HMSegmentedControl *)segmentedControl {
    HMSegmentedControl *segControl = segmentedControl ;
    
    
    NSLog(@"segmentedControl.frame%f",segmentedControl.frame.size.width);
    [ self.view addSubview:segControl];
        
    NSMutableArray *constraints = [[NSMutableArray alloc] init];
    
 NSMutableArray *constraintAttributes = [NSMutableArray arrayWithObjects:[NSNumber numberWithInt:NSLayoutAttributeLeading], [NSNumber numberWithInt:NSLayoutAttributeTrailing] ,nil];
    
    for (NSNumber *attribute in constraintAttributes) {
        NSLayoutConstraint *constraint=[NSLayoutConstraint constraintWithItem:segControl
                                                                    attribute:[attribute intValue]
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:self.view
                                                                    attribute:[attribute intValue]
                                                                   multiplier:1.0
                                                                     constant:0];
        [constraints addObject:constraint];
    }
   
    NSLayoutConstraint *topConstraint=[NSLayoutConstraint constraintWithItem:segControl
                                                                attribute:NSLayoutAttributeTop
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:self.topLayoutGuide
                                                                attribute:NSLayoutAttributeBottom
                                                               multiplier:1.0
                                                                 constant:0];
        
      [constraints addObject:topConstraint];

    NSLayoutConstraint *heightConstraint=[NSLayoutConstraint constraintWithItem:segControl
                                                                   attribute:NSLayoutAttributeHeight
                                                                   relatedBy:NSLayoutRelationEqual
                                                                      toItem:nil
                                                                   attribute:NSLayoutAttributeNotAnAttribute
                                                                     multiplier:0.0
                                                                       constant:segmentHeight];
                   [constraints addObject:heightConstraint];
      
    [self.view addConstraints:constraints];
    
}
 // called when scroll view grinds to a halt

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [self updatePageViewAfterTragging:scrollView];
}
//MARK: - Update page after tragging
-(void) updatePageViewAfterTragging:(UIScrollView *)scrollView{
    int newIndex =[self calcIndexWithOffset:self.scrollView.contentOffset.x width:self.scrollView.frame.size.width];
    
   
    int oldIndex = self.currentPageIndex;
    self.currentPageIndex = newIndex;
    
    if (newIndex == oldIndex ){//最终确定的位置与开始位置相同时，需要重新显示开始位置的视图，以及消失最近一次猜测的位置的视图。
        if (self.guessToIndex >= 0 && self.guessToIndex < [self pageCount] ){
            
            [[self controllerAtIndex:oldIndex] beginAppearanceTransition:YES animated:YES];
          
            //                print("EndDecelerating same beginAppearanceTransition  oldIndex  \(oldIndex)")
                [[self controllerAtIndex:oldIndex] endAppearanceTransition];
          
            //                print("EndDecelerating same endAppearanceTransition  oldIndex  \(oldIndex)")
                [[self controllerAtIndex:self.guessToIndex ] beginAppearanceTransition:YES animated:YES];
         
            //                print("EndDecelerating same beginAppearanceTransition  self.guessToIndex  \(self.guessToIndex)")
                [[self controllerAtIndex:self.guessToIndex ] endAppearanceTransition];
          
            //                print("EndDecelerating same endAppearanceTransition  self.guessToIndex  \(self.guessToIndex)")
        }
    } else {
             [[self controllerAtIndex:newIndex ] endAppearanceTransition];
     
        //            print("EndDecelerating endAppearanceTransition  newIndex  \(newIndex)")
         [[self controllerAtIndex:oldIndex ] endAppearanceTransition];
       
        //            print("EndDecelerating endAppearanceTransition  oldIndex  \(oldIndex)")
    }
    
    //归位，用于计算比较
    self.originOffset = self.scrollView.contentOffset.x;
    self.guessToIndex = self.currentPageIndex;
    [self gy_pageViewControllerDidShow:self.guessToIndex toindex:self.currentPageIndex finished:YES];
    if ([self.delegate respondsToSelector:@selector(gy_pageViewController:)]) {
        [self.delegate gy_pageViewController:self didLeaveViewController:[self controllerAtIndex:self.guessToIndex] toViewController:[self controllerAtIndex:self.currentPageIndex] finished:YES];
    }
   
    self.isDecelerating = YES;
    
    [self cleanCacheToClean];
}
- (void) setupSegmentedControl:(HMSegmentedControl*) segmentedControl{
    
    NSLog(@"setupSegmentedControl");
      HMSegmentedControl *segControl =segmentedControl;
    segControl.translatesAutoresizingMaskIntoConstraints = NO;
    segControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
  
//    segControl.selectionIndicatorColor =  [UIColor colorWithRed: 0xdc/0xff green: 0xb6/0xff blue: 0x65/0xff alpha: 1.0];
//    segControl.selectionIndicatorHeight = 3.0;
    segControl.selectionIndicatorColor =  [UIColor greenColor];
    segControl.selectionIndicatorHeight = 3.0;

//    segControl.selectedTitleTextAttributes = @{NSForegroundColorAttributeName:[UIColor colorWithRed: 0xdc/0xff green: 0xb6/0xff blue: 0x65/0xff alpha: 1.0],NSFontAttributeName:[UIFont systemFontOfSize:22]};
//    segControl.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor colorWithRed: 0x84/0xff green: 0xb0/0xff blue: 0xdf/0xff alpha: 1.0],NSFontAttributeName:[UIFont systemFontOfSize:18]};
    
    segControl.selectedTitleTextAttributes = @{NSForegroundColorAttributeName:[UIColor greenColor],NSFontAttributeName:[UIFont systemFontOfSize:22]};
    segControl.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor redColor],NSFontAttributeName:[UIFont systemFontOfSize:18]};
    
    segControl.selectionStyle = HMSegmentedControlSelectionStyleFullWidthStripe;
    segControl.backgroundColor = [UIColor grayColor];
    [segControl addTarget:self action: @selector(segmentValueChanged:) forControlEvents:UIControlEventValueChanged];
     
    
}
-(void)segmentValueChanged:(id) ss{
    NSLog(@"___________segmentValueChanged");
    [self showPageAtIndex:_segmentedControl.selectedSegmentIndex animated:YES];
    
    
    
}
-(void)gy_pageViewControllerDidTransitonFrom:(int)fromIndex toindex:(int)toIndex{
    [super gy_pageViewControllerDidTransitonFrom:fromIndex toindex:toIndex];
    [_segmentedControl setSelectedSegmentIndex:toIndex animated:YES];
   
}
-(void)gy_pageViewControllerDidShow:(int)fromIndex toindex:(int)toIndex finished:(BOOL)finished{
    [super gy_pageViewControllerDidShow:fromIndex toindex:toIndex finished:finished];
     [_segmentedControl setSelectedSegmentIndex:toIndex animated:YES];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
