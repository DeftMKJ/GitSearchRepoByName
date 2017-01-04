//
//  ViewController.m
//  GitRepoSearch
//
//  Created by 宓珂璟 on 2017/1/3.
//  Copyright © 2017年 Deft_Mikejing_iOS_coder. All rights reserved.
//

#import "ViewController.h"
#import "GitSearchViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor redColor];
    self.title = @"touch screen";
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    GitSearchViewController *search = [[GitSearchViewController alloc] init];
    [self.navigationController pushViewController:search animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
