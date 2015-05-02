//
//  PingPongViewController.m
//  Neuralnetwork
//
//  Created by EndoTsuyoshi on 2015/02/28.
//  Copyright (c) 2015年 endo.neural. All rights reserved.
//

#import "PingPongViewController.h"

@interface PingPongViewController ()

@end

@implementation PingPongViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSLog(@"%s", __func__);
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
