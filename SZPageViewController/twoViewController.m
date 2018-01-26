//
//  twoViewController.m
//  SZPageViewController
//
//  Created by app-dev on 2018/1/24.
//  Copyright © 2018年 app-dev. All rights reserved.
//

#import "twoViewController.h"

@interface twoViewController ()

@end

@implementation twoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     [self.view setBackgroundColor:[UIColor greenColor]];
    UILabel *mylabel=  [[UILabel alloc] initWithFrame:CGRectMake(80, 80, 200, 200)];
    [mylabel setText:@"第二个"];
    [self.view addSubview:mylabel];
    
     NSLog(@"viewDidLoad\n ______第二个");
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    NSLog(@"viewWillAppear_____\n ______第二个");
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    NSLog(@"viewDidAppear\n ______第二个");
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    NSLog(@"viewWillDisappear\n ______第二个");
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    NSLog(@"viewDidDisappear\n _____第二个");
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
