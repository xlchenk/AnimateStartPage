//
//  ViewController.m
//  AnimateStartPage
//
//  Created by inwan on 16/9/14.
//  Copyright © 2016年 inwan. All rights reserved.
//

#import "ViewController.h"
#import "StartAnimatView.h"
#import "HomeController.h"
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGH  [UIScreen mainScreen].bounds.size.height
@interface ViewController ()<StartAnimatDelegete>
@property(nonatomic,strong)StartAnimatView * startVC;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    //获取本地视频地址
    NSString * path = [[NSBundle mainBundle] pathForResource:@"1" ofType:@"mp4"];
    
    CGRect rect = self.view.frame;
    _startVC = [[StartAnimatView alloc]initWithFrame:rect withUrl:path];
    _startVC.delegate = self;
    [self.view addSubview:_startVC];
    
    _startVC.alwaysRepeat = YES;
    [_startVC play];

}
#pragma delegate Method
//登陆
- (void)loginAction{
    HomeController * home = [[HomeController alloc]init];
    [self presentViewController:home animated:YES completion:nil];
}
//注册
- (void)registerAction{
    HomeController * home = [[HomeController alloc]init];
    [self presentViewController:home animated:YES completion:nil];
}

@end
