//
//  ViewController.m
//  XJFlipViewDemo
//
//  Created by liuxj on 2018/11/20.
//  Copyright © 2018 lxj. All rights reserved.
//

#import "ViewController.h"
#import "XJFlipView/XJFlipView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:.9];
    
    XJFlipView *flipView = [[XJFlipView alloc] initWithImages:@[[UIImage imageNamed:@"bd"],
                                                                [UIImage imageNamed:@"jd"],
                                                                [UIImage imageNamed:@"tm"],
                                                                [UIImage imageNamed:@"eleme"],
                                                                [UIImage imageNamed:@"wm"],
                                                                [UIImage imageNamed:@"mt"]]];
    
    CGSize viewSize = self.view.frame.size;
    
    flipView.frame = CGRectMake((viewSize.width - 200) / 2.0, (viewSize.height - 200) / 2.0, 200, 200);
    [self.view addSubview:flipView];
    
}


@end
