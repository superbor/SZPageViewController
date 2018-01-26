//
//  GYPageViewController.m
//  SZPageViewController
//
//  Created by app-dev on 2018/1/24.
//  Copyright © 2018年 app-dev. All rights reserved.
//

#import "GYPageViewController.h"
#import "oneViewController.h"
#import "twoViewController.h"
#import "UIViewController+ChildController.h"
typedef enum _GYPageScrollDirection {
    left  = 0,
    right
} GYPageScrollDirection;

@interface GYPageViewController () <UIScrollViewDelegate,NSCacheDelegate>{
    oneViewController *one;
    twoViewController *two;
  
    UIEdgeInsets contentEdgeInsets;
    NSMutableArray *childsToClean;
  
    int guessToIndex ;                   //用于手势拖动scrollView时，判断要去的页面
    int lastSelectedIndex ;            //用于记录上次选择的index
    BOOL firstWillAppear ;           //用于界定页面首次WillAppear。
    BOOL firstDidAppear ;               //用于界定页面首次DidAppear。
    BOOL firstDidLayoutSubViews ;     //用于界定页面首次DidLayoutsubviews。
    BOOL firstWillLayoutSubViews ;     //用于界定页面首次WillLayoutsubviews。

    

}


@end

@implementation GYPageViewController

- (NSCache *)memCache {
    if (_memCache == nil) {
        _memCache = [[NSCache alloc] init];
        // 设置数量限制,最大限制为10
        _memCache.countLimit = 10;
        _memCache.delegate = self;
    }
    return _memCache;
}
-(int)pageCount{
   return  [self.dataSource numberOfControllers:self ];
}
-(void)configScrollView{
    
    _scrollView =[[UIScrollView alloc]init ];
    contentEdgeInsets =UIEdgeInsetsZero;
    _scrollView.translatesAutoresizingMaskIntoConstraints = false;
    _scrollView.delegate = self;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    [_scrollView setPagingEnabled:YES];
    _scrollView.backgroundColor = [UIColor clearColor];
   
    _scrollView.scrollsToTop = NO;
    childsToClean =[[NSMutableArray alloc] init];
    [self.view addSubview:_scrollView];
    NSMutableArray<NSLayoutConstraint *> *constraints =[[NSMutableArray alloc]init];
    
    
    NSLayoutConstraint *constraint=[NSLayoutConstraint constraintWithItem:_scrollView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0];
    NSLayoutConstraint *constraint2=[NSLayoutConstraint constraintWithItem:_scrollView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0];
    
    
    NSLayoutConstraint *topconstraint=[NSLayoutConstraint constraintWithItem:_scrollView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.topLayoutGuide attribute:NSLayoutAttributeBottom multiplier:1.0 constant:contentEdgeInsets.top];
    
    NSLayoutConstraint *bottomconstraint=[NSLayoutConstraint constraintWithItem:_scrollView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.bottomLayoutGuide attribute:NSLayoutAttributeTop multiplier:1.0 constant:contentEdgeInsets.bottom];
    
    [constraints addObject:constraint];
    [constraints addObject:constraint2];
    [constraints addObject:topconstraint];
    [constraints addObject:bottomconstraint];
    
    [self.view addConstraints:constraints];
}
- (IBAction)toone:(id)sender {
    
    __weak typeof(self) weakSelf = self;
    [self transitionFromViewController:two
                      toViewController:one
                              duration:10
                               options:UIViewAnimationOptionLayoutSubviews
                            animations:nil
                            completion:^(BOOL finished)
     {
         //        [fromViewController removeFromParentViewController];
         //        [toViewController didMoveToParentViewController:weakSelf];
         //        if (completion) {
         //            completion(finished);
         //        }
     }];
    
    
}
- (IBAction)totwo:(id)sender {
    
    __weak typeof(self) weakSelf = self;
    [self transitionFromViewController:one
                      toViewController:two
                              duration:10
                               options:UIViewAnimationOptionLayoutSubviews
                            animations:nil
                            completion:^(BOOL finished)
     {
         //        [fromViewController removeFromParentViewController];
         //        [toViewController didMoveToParentViewController:weakSelf];
         //        if (completion) {
         //            completion(finished);
         //        }
     }];
}

/*  ScrollView 初始化宽高
 
 */
-(void)updateScrollViewLayoutIfNeeded{
    if (_scrollView.frame.size.width>0.0) {
        CGFloat width= (CGFloat )[self pageCount] *_scrollView.frame.size.width;
        CGFloat height= _scrollView.frame.size.height;
        CGSize oldContentSize = _scrollView.contentSize;
        
        if (width!=oldContentSize.width||height!=oldContentSize.height) {
            _scrollView.contentSize=CGSizeMake(width, height);
        }
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor =[UIColor whiteColor];
    _originOffset =0.0;
    guessToIndex =-1;
    lastSelectedIndex =0;
    firstWillAppear=YES;
    firstDidAppear=YES;
    firstDidLayoutSubViews=YES;
    firstWillLayoutSubViews=YES;
    _isDecelerating=NO;
    _currentPageIndex=0;
    [self memCache];
    [self configScrollView];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if (firstWillAppear) {
        //Config init page
        
        [self gy_pageViewControllerWillShow:lastSelectedIndex toindex:_currentPageIndex animated:NO];
        
        
        if ([self.delegate respondsToSelector:@selector(gy_pageViewController:)]) {
            [self.delegate gy_pageViewController:self willTransitonFrom:[self controllerAtIndex:lastSelectedIndex] toViewController:[self controllerAtIndex:_currentPageIndex] animated:(YES)];
        }
       
      
        //            print("viewWillAppear beginAppearanceTransition  self.currentPageIndex  \(self.currentPageIndex)")
        firstWillAppear = NO;
    }
    [[self controllerAtIndex:lastSelectedIndex] beginAppearanceTransition:YES animated:YES];
}
-(void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];

}
-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    
    if (firstDidLayoutSubViews) {
        if (self.navigationController) {
            if (self.navigationController.viewControllers[self.navigationController.viewControllers.count-1]==self) {
                _scrollView.contentOffset= CGPointZero;
                _scrollView.contentInset=UIEdgeInsetsZero;
            }
        }
        
        dispatch_after(DISPATCH_TIME_NOW+ (double)(int64_t)(0.0 * (float)NSEC_PER_SEC)/(double)NSEC_PER_SEC,dispatch_get_main_queue(), ^(void){
            [self updateScrollViewLayoutIfNeeded];
            [self updateScrollViewDisplayIndexIfNeeded ];
            firstDidLayoutSubViews=NO;
            
        });
    }else{
        dispatch_after(DISPATCH_TIME_NOW+ (double)(int64_t)(0.0 * (float)NSEC_PER_SEC)/(double)NSEC_PER_SEC,dispatch_get_main_queue(), ^(void){
           [self updateScrollViewLayoutIfNeeded];
            
        });
    }
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (firstDidAppear) {
        [self gy_pageViewControllerWillShow:lastSelectedIndex toindex:_currentPageIndex animated:YES];
        
        if ([self.delegate respondsToSelector:@selector(gy_pageViewController:)]) {
            [self.delegate gy_pageViewController:self didLeaveViewController:[self controllerAtIndex:lastSelectedIndex] toViewController:[self controllerAtIndex:_currentPageIndex] finished:YES];
        }
       
        firstDidAppear =NO;
    }
    [[self controllerAtIndex:_currentPageIndex] endAppearanceTransition];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[self controllerAtIndex:_currentPageIndex] beginAppearanceTransition:NO animated:YES];
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [[self controllerAtIndex:_currentPageIndex] endAppearanceTransition];
}
-(void)didReceiveMemoryWarning{
    
    [super didReceiveMemoryWarning];
    
    [self.memCache removeAllObjects];
}

-(void)showPageAtIndex:(int)index animated:(BOOL)animated {
    if (index < 0 || index >= [self pageCount]) {
        return;
    }
    CGFloat oldSelectedIndex=lastSelectedIndex;
    lastSelectedIndex=_currentPageIndex;
    _currentPageIndex=index;
    if (_scrollView.frame.size.width>0.0&&
        _scrollView.contentSize.width>0.0) {
        [self gy_pageViewControllerWillShow:lastSelectedIndex toindex:_currentPageIndex animated:animated];
        
        if ([self.delegate respondsToSelector:@selector(gy_pageViewController)]) {
            [self.delegate gy_pageViewController:self willTransitonFrom:[self controllerAtIndex:lastSelectedIndex]
                                toViewController:[self controllerAtIndex:_currentPageIndex]  animated:animated];
        }
     
        
        [self addVisibleViewContorllerWith:index];
    }
    
    // Scroll to current index if scrollView is initialized and displayed correctly
    if( _scrollView.frame.size.width > 0.0 &&
       _scrollView.contentSize.width > 0.0){
        void(^scrollBeginAnimation)()= ^{
            [[self controllerAtIndex:_currentPageIndex] beginAppearanceTransition:YES animated:animated];
            if (_currentPageIndex!=lastSelectedIndex) {
                [[self controllerAtIndex:lastSelectedIndex] beginAppearanceTransition:NO animated:animated];
            }
//            self.controllerAtIndex(self.currentPageIndex).beginAppearanceTransition(true, animated: animated)
//            if self.currentPageIndex != self.lastSelectedIndex {
//                self.controllerAtIndex(self.lastSelectedIndex).beginAppearanceTransition(false, animated: animated)
//            }
            
        };
        
        
        
        void(^scrollAnimation)()= ^{
           
            [_scrollView setContentOffset:[self calcOffsetWithIndex:_currentPageIndex width:_scrollView.frame.size.width
                                                            maxWidth:_scrollView.contentSize.width] animated:NO] ;
            
  
            
        };
        void(^scrollEndAnimation)()= ^{
            
        
            [[self controllerAtIndex:_currentPageIndex]endAppearanceTransition ];
            if (_currentPageIndex !=lastSelectedIndex) {
                [[self controllerAtIndex:lastSelectedIndex] endAppearanceTransition];
            }
            [self gy_pageViewControllerDidShow:lastSelectedIndex toindex:_currentPageIndex finished:animated];
            if ([self.delegate respondsToSelector:@selector(gy_pageViewController:)]) {
                [self.delegate gy_pageViewController:self didLeaveViewController:[self controllerAtIndex:lastSelectedIndex] toViewController:[self controllerAtIndex:_currentPageIndex] finished:animated];
            }
           
            
            [self cleanCacheToClean];
        };
        
        scrollBeginAnimation();
        
        if(animated){
            if (lastSelectedIndex !=_currentPageIndex) {
                CGSize  pageSize = _scrollView.frame.size;
                GYPageScrollDirection direction= lastSelectedIndex < _currentPageIndex? right:left;
                
                UIView *lastView =[self controllerAtIndex:lastSelectedIndex].view ;
                UIView *currentView =[self controllerAtIndex:_currentPageIndex].view;
                 UIView *oldSelectView =[self controllerAtIndex:oldSelectedIndex].view;
                
                CGFloat duration =0.3 ;
                CGFloat backgroundIndex =[self calcIndexWithOffset:_scrollView.contentOffset.x width:_scrollView.frame.size.width];
                UIView *backgroundView;
                
                if (oldSelectView.layer.animationKeys.count>0&&
                    lastView.layer.animationKeys.count>0) {
                    UIView *tmpView =[self controllerAtIndex:backgroundIndex].view;
                    if (tmpView !=currentView && tmpView!=lastView) {
                        backgroundView =tmpView;
                        [backgroundView setHidden:YES];
                    }
                }
                
                [_scrollView.layer removeAllAnimations];
                [oldSelectView.layer removeAllAnimations];
                [lastView.layer removeAllAnimations];
                    [currentView.layer removeAllAnimations];
                [self moveBackToOriginPositionIfNeeded:oldSelectView index:oldSelectedIndex];
                
                [_scrollView bringSubviewToFront:lastView];
                [_scrollView bringSubviewToFront:currentView];
                
                [lastView setHidden: NO];
                [currentView setHidden:NO];
                
                CGPoint lastView_StartOrigin=lastView.frame.origin;
                CGPoint  currentView_StartOrigin=lastView.frame.origin;
                if (direction == right) {
                    currentView_StartOrigin.x += _scrollView.frame.size.width;
                }else{
                    currentView_StartOrigin.x -= _scrollView.frame.size.width;
                }
                
                CGPoint lastView_AnimateToOrigin =lastView.frame.origin;
                
                if (direction == right) {
                    lastView_AnimateToOrigin.x -= _scrollView.frame.size.width;
                }else{
                    lastView_AnimateToOrigin.x +=_scrollView.frame.size.width;
                }
                 CGPoint currentView_AnimateToOrigin =lastView.frame.origin;
                
                CGPoint lastView_EndOrigin = lastView.frame.origin;
                CGPoint currentView_EndOrigin = currentView.frame.origin;
                
                /*
                 *  Simulate scroll animation
                 *  Bring two views(lastView, currentView) to front and simulate scroll in neighbouring position.
                 */
                lastView.frame = CGRectMake( lastView_StartOrigin.x, lastView_StartOrigin.y, pageSize.width, pageSize.height);
                currentView.frame = CGRectMake(currentView_StartOrigin.x, currentView_StartOrigin.y,  pageSize.width,pageSize.height) ;
                
                [UIView animateWithDuration:duration delay:0.0 options:UIViewAnimationOptionLayoutSubviews animations:^{
                    
                    lastView.frame = CGRectMake(lastView_AnimateToOrigin.x, lastView_AnimateToOrigin.y,  pageSize.width,  pageSize.height);
                    currentView.frame = CGRectMake( currentView_AnimateToOrigin.x, currentView_AnimateToOrigin.y,  pageSize.width, pageSize.height);
                    
                } completion:^(BOOL finished){
                    if (finished) {
                        lastView.frame = CGRectMake(lastView_EndOrigin.x,  lastView_EndOrigin.y, pageSize.width,  pageSize.height);
                        currentView.frame = CGRectMake(currentView_EndOrigin.x, currentView_EndOrigin.y,  pageSize.width, pageSize.height);
                        [backgroundView setHidden:NO];
                        
                         __weak typeof(self) weakSelf = self;
                        
                        [weakSelf moveBackToOriginPositionIfNeeded:currentView index:_currentPageIndex];
                          [weakSelf moveBackToOriginPositionIfNeeded:lastView index:lastSelectedIndex];
                       
                        
                        scrollAnimation();
                        scrollEndAnimation();
                    }
                }];
 
            }
            else{
                scrollAnimation();
                scrollEndAnimation();
        }
       
    }
        else{
            scrollAnimation();
            scrollEndAnimation();
        }
    }
                // Aciton closure before simulated scroll animation
        
    
}
-(void)cleanCacheToClean{
    
    UIViewController *currentPage=[self controllerAtIndex:_currentPageIndex];
    if ([childsToClean containsObject:currentPage]) {
        [childsToClean removeObject:currentPage];
        [self.memCache setObject:currentPage forKey:[NSNumber numberWithInt:_currentPageIndex]];
    }
    
    
    for (UIViewController *vc in childsToClean) {
        [vc gy_removeFromParentViewController];  //等待
    }
    
    [childsToClean removeAllObjects];
}
-(void)updateScrollViewDisplayIndexIfNeeded{
     if (_scrollView.frame.size.width>0.0) {
         [self addVisibleViewContorllerWith:_currentPageIndex];
         CGPoint newOffset=[self calcOffsetWithIndex:_currentPageIndex width:_scrollView.frame.size.width
                                            maxWidth:_scrollView.contentSize.width];
         
         if (newOffset.x != _scrollView.contentOffset.x ||
             newOffset.y != _scrollView.contentOffset.y)
         {
             _scrollView.contentOffset = newOffset;
         }
         
         [self controllerAtIndex:_currentPageIndex].view.frame=[self calcVisibleViewControllerFrameWith:_currentPageIndex];
     }
   
    
}
-(void) addVisibleViewContorllerWith:(int) index{
    if (index < 0 || index > self.pageCount ){
        return;
    }
    UIViewController *vc = [self.memCache objectForKey:[NSNumber numberWithInt:index]] ;
    if( vc == nil){
        vc =[self controllerAtIndex:index];
    }
    CGRect childViewFrame = [self calcVisibleViewControllerFrameWith:index];
    [self gy_addChildViewController:vc inView:self.scrollView withFrame:childViewFrame];
    [self.memCache setObject:[self controllerAtIndex:index] forKey:[NSNumber numberWithInt:index]];
}

-(void)moveBackToOriginPositionIfNeeded:(UIView *)view index:(int) index{
    
    
    if (index <0||index>[self pageCount]) {
        return;
    }
    
    if (!view) {
        
        NSLog(@"moveBackToOriginPositionIfNeeded view nil");
        return;
    }
    
    CGPoint originPosition = [self calcOffsetWithIndex:index width:_scrollView.frame.size.width maxWidth:_scrollView.contentSize.width];
    
    if (view.frame.origin.x !=originPosition.x) {
        CGRect newFrame=view.frame;
        newFrame.origin =originPosition;
        view.frame=newFrame;
    }
}
-(int)calcIndexWithOffset:(float) offset width :(float) width {
    
    int startIndex =(int) (offset/width);
    if (startIndex <0) {
        startIndex =0;
    }
    return  startIndex;
    
}
-(CGRect)calcVisibleViewControllerFrameWith:(int ) index{
    CGFloat offsetX = 0.0;
    offsetX =(double)index *(double)_scrollView.frame.size.width;
    return  CGRectMake((CGFloat)offsetX, 0, _scrollView.frame.size.width, _scrollView.frame.size.height);
    
}
-(CGPoint)calcOffsetWithIndex:(int)index width:(float) width maxWidth:(float) maxWidth{
    float offsetX=(float)index*width;
    if (offsetX < 0 ){
        offsetX = 0;
    }
    
    if (maxWidth > 0.0 &&
        offsetX > maxWidth - width)
    {
        offsetX = maxWidth - width;
    }
    return CGPointMake((CGFloat)offsetX, 0);
 
}
- (UIViewController *)controllerAtIndex:(int ) index{
    
    return [self.dataSource gy_pageViewController:self controllerAtIndex:index];
}


- (void)cache:(NSCache *)cache willEvictObject:(id)obj {
    [NSThread sleepForTimeInterval:0.5];
    NSLog(@"清除了-------> %@", obj);
}
#pragma daa

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView.isTracking == YES &&
        scrollView.isDecelerating == YES)
    {
        NSLog(@"     guessToIndex  \(guessToIndex)   self.currentPageIndex  \(self.currentPageIndex)");
    }
    
    if (scrollView.isDragging == true && scrollView == self.scrollView) {
        CGFloat offset = scrollView.contentOffset.x;
        int width = scrollView.frame.size.width;
        int lastGuessIndex = self.guessToIndex < 0 ? self.currentPageIndex : self.guessToIndex;
        if (self.originOffset < offset){
            self.guessToIndex = (int)(ceil((offset)/width));
        } else if (self.originOffset > offset) {
            self.guessToIndex = (int)(floor((offset)/width));
        } else {}
        int maxCount = self.pageCount;
        
        
        // 1.Decelerating is false when first drag during discontinuous interaction.
        // 2.Decelerating is true when drag during continuous interaction.
        if ((guessToIndex != self.currentPageIndex &&
            self.scrollView.isDecelerating == false) ||
            self.scrollView.isDecelerating == true)
        {
            if (lastGuessIndex != self.guessToIndex &&
                self.guessToIndex >= 0 &&
                self.guessToIndex < maxCount)
            {
                
                [self gy_pageViewControllerWillShow:self.guessToIndex toindex:self.currentPageIndex animated:true];
                if ([self.delegate respondsToSelector:@selector(gy_pageViewController:)]) {
                    [self.delegate gy_pageViewController:self willTransitonFrom:[self controllerAtIndex:self.guessToIndex] toViewController:[self controllerAtIndex:self.guessToIndex] ];
                }
              
                [self addVisibleViewContorllerWith:self.guessToIndex];
              
                [[self controllerAtIndex:self.guessToIndex] beginAppearanceTransition:YES animated:YES];
              
                //                print("scrollViewDidScroll beginAppearanceTransition  self.guessToIndex  \(self.guessToIndex)")
                /**
                 *  Solve problem: When scroll with interaction, scroll page from one direction to the other for more than one time, the beginAppearanceTransition() method will invoke more than once but only one time endAppearanceTransition() invoked, so that the life cycle methods not correct.
                 *  When lastGuessIndex = self.currentPageIndex is the first time which need to invoke beginAppearanceTransition().
                 */
                if (lastGuessIndex == self.currentPageIndex ){
                    
                      [[self controllerAtIndex:self.currentPageIndex] beginAppearanceTransition:false animated:YES];
                 
                    NSLog(@"scrollViewDidScroll beginAppearanceTransition  self.currentPageIndex \(self.currentPageIndex)");
                }
                
                if (lastGuessIndex != self.currentPageIndex &&
                    lastGuessIndex >= 0 &&
                    lastGuessIndex < maxCount){
                    
                      [[self controllerAtIndex:lastGuessIndex] beginAppearanceTransition:false animated:YES];
                    
                    NSLog(@"scrollViewDidScroll beginAppearanceTransition  lastGuessIndex \(lastGuessIndex)");
                    [[self controllerAtIndex:lastGuessIndex]  endAppearanceTransition];
                        //                    print("scrollViewDidScroll endAppearanceTransition  lastGuessIndex \(lastGuessIndex)")
                    }
            }
        }
    }
    NSLog(@"====  DidScroll dragging:  \(scrollView.isDragging)  decelorating: \(scrollView.isDecelerating)  offset:\(scrollView.contentOffset)");
    
}


-(void)gy_pageViewControllerWillShow:(int)fromIndex toindex:(int)toIndex animated:(BOOL) animated{}

-(void)gy_pageViewControllerDidShow:(int)fromIndex toindex:(int)toIndex finished:(BOOL) finished{}

-(void) gy_pageViewControllerDidTransitonFrom:(int)fromIndex toindex:(int)toIndex  { }
@end

