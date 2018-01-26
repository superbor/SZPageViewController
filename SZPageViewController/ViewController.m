//
//  ViewController.m
//  SZPageViewController
//
//  Created by app-dev on 2018/1/24.
//  Copyright © 2018年 app-dev. All rights reserved.
//

#import "ViewController.h"
#import "oneViewController.h"
#import "twoViewController.h"
#import "UIViewController+ChildController.h"
#import "GYTabPageViewController.h"
@interface ViewController () <UIScrollViewDelegate,NSCacheDelegate,GYPageViewControllerDataSource,GYPageViewControllerDelegate>{
    oneViewController *one;
    twoViewController *two;
    UIScrollView    *scrollView;
    UIEdgeInsets contentEdgeInsets;
    
     CGFloat originOffset  ;                 //用于手势拖动scrollView时，判断方向
     int guessToIndex ;                   //用于手势拖动scrollView时，判断要去的页面
     int lastSelectedIndex ;            //用于记录上次选择的index
     BOOL firstWillAppear ;           //用于界定页面首次WillAppear。
     BOOL firstDidAppear ;               //用于界定页面首次DidAppear。
    BOOL firstDidLayoutSubViews ;     //用于界定页面首次DidLayoutsubviews。
    BOOL firstWillLayoutSubViews ;     //用于界定页面首次WillLayoutsubviews。
    BOOL isDecelerating ;           //正在减速操作
    
    int currentPageIndex;
    
    NSMutableArray *pageControllers;
}
@property (weak, nonatomic) IBOutlet UIView *faview;

@end

@implementation ViewController

- (NSCache *)memCache {
    if (_memCache == nil) {
        _memCache = [[NSCache alloc] init];
        // 设置数量限制,最大限制为10
        _memCache.countLimit = 10;
        _memCache.delegate = self;
    }
    return _memCache;
}
-(void)awakeFromNib{
    [super awakeFromNib];
    HMSegmentedControl *segmentedControl = [[HMSegmentedControl alloc] initWithSectionTitles:@[@"One", @"Two", @"Three"]];
    segmentedControl.frame = CGRectMake(10, 10, 300, 60);
    [segmentedControl addTarget:self action:@selector(segmentedControlChangedValue:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:segmentedControl];
    NSLog(@"awakeFromNib");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    originOffset =0.0;
    guessToIndex =-1;
    lastSelectedIndex =0;
    firstWillAppear=YES;
     firstDidAppear=YES;
     firstDidLayoutSubViews=YES;
     firstWillLayoutSubViews=YES;
      isDecelerating=NO;
     currentPageIndex=0;
    [self configScrollView];
    
    pageControllers=[[NSMutableArray alloc] init];
     one=[[oneViewController alloc] init];
     two=[[twoViewController alloc] init];
    
    [pageControllers addObject:one];
     [pageControllers addObject:two];

}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
//    if (firstWillAppear) {
//        //Config init page
//        
//        [self gy_pageViewControllerWillShow:lastSelectedIndex toindex:currentPageIndex animated:NO];
//        
//        self.delegate?.gy_pageViewController?(self, willLeaveViewController: self.controllerAtIndex(self.lastSelectedIndex), toViewController: self.controllerAtIndex(self.currentPageIndex), animated: false)
//        //            print("viewWillAppear beginAppearanceTransition  self.currentPageIndex  \(self.currentPageIndex)")
//        self.firstWillAppear = false
//    }
//    self.controllerAtIndex(self.currentPageIndex).beginAppearanceTransition(true, animated: true)
}
-(void)configScrollView{
    
    scrollView =[[UIScrollView alloc]init ];
    contentEdgeInsets =UIEdgeInsetsZero;
    scrollView.translatesAutoresizingMaskIntoConstraints = false;
    scrollView.delegate = self;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    [scrollView setPagingEnabled:YES];
    scrollView.backgroundColor = [UIColor clearColor];
     scrollView.backgroundColor = [UIColor redColor];
    scrollView.scrollsToTop = NO;
    
    [self.faview addSubview:scrollView];
    NSMutableArray<NSLayoutConstraint *> *constraints =[[NSMutableArray alloc]init];

 
    NSLayoutConstraint *constraint=[NSLayoutConstraint constraintWithItem:scrollView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0];
        NSLayoutConstraint *constraint2=[NSLayoutConstraint constraintWithItem:scrollView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0];
    
    
      NSLayoutConstraint *topconstraint=[NSLayoutConstraint constraintWithItem:scrollView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.topLayoutGuide attribute:NSLayoutAttributeBottom multiplier:1.0 constant:contentEdgeInsets.top];
    
          NSLayoutConstraint *bottomconstraint=[NSLayoutConstraint constraintWithItem:scrollView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.bottomLayoutGuide attribute:NSLayoutAttributeTop multiplier:1.0 constant:contentEdgeInsets.bottom];
    
     [constraints addObject:constraint];
     [constraints addObject:constraint2];
     [constraints addObject:topconstraint];
     [constraints addObject:bottomconstraint];
    
    [self.view addConstraints:constraints];
}
- (IBAction)toone:(id)sender {
    
    NSLog(@"跳转");
   NSArray *titlesArray=@[@"One", @"Two"];

    GYTabPageViewController *vc =[[GYTabPageViewController alloc] initWithpageTitles:titlesArray];
    vc.delegate = self;
    vc.dataSource = self;
    [vc showPageAtIndex:2 animated:NO];
    [self presentViewController:vc animated:YES completion:nil];
  
   
//    __weak typeof(self) weakSelf = self;
//    [self transitionFromViewController:two
//                      toViewController:one
//                              duration:10
//                               options:UIViewAnimationOptionLayoutSubviews
//                            animations:nil
//                            completion:^(BOOL finished)
//    {
////        [fromViewController removeFromParentViewController];
////        [toViewController didMoveToParentViewController:weakSelf];
////        if (completion) {
////            completion(finished);
////        }
//    }];
    
   
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




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)cache:(NSCache *)cache willEvictObject:(id)obj {
    [NSThread sleepForTimeInterval:0.5];
    NSLog(@"清除了-------> %@", obj);
}

-(UIViewController *)gy_pageViewController:(GYPageViewController *)pageViewController controllerAtIndex:(int)index{
    
    NSLog(@"pageControllers %d",pageControllers[index]);
    return pageControllers[index];
}

-(int)numberOfControllers:(GYPageViewController *)pageViewController{
    
    NSLog(@"numberOfControllers %lu", (unsigned long)pageControllers.count);
    return (int)pageControllers.count;
}
@end
