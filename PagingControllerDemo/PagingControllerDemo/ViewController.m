//
//  ViewController.m
//  PagingControllerDemo
//
//  Created by Zgmanhui on 2017/8/7.
//  Copyright © 2017年 Zgmanhui. All rights reserved.
//

#import "ViewController.h"
#import "PagingMenuView.h"
#import "SubView.h"

@interface ViewController ()<PagingMenuViewDelegate>
@property (nonatomic, strong) PagingMenuView *pagingView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    PagingMenuModel *model = [[PagingMenuModel alloc] init];
    model.titles = @[@"标题1", @"标题2标题2标题2", @"标", @"标题4标题4标题4", @"标题5", @"标题6", @"标题7"];
    model.titleWidth = [UIScreen mainScreen].bounds.size.width / 5;
    model.adaptiveWidth = YES;
    model.adaptiveSliderWidth = YES;
//    model.shieldingDragAnimation = YES;
    model.sliderCorners = 1;
    NSMutableArray *views = [NSMutableArray array];
    for (NSInteger i = 0; i < 7; i ++) {
        SubView *view = [[SubView alloc] init];
        view.idx = i;
        [views addObject:view];
    }
    model.views = views;
    _pagingView = [[PagingMenuView alloc] initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.height - 64) model:model];
    _pagingView.delegate = self;
    [self.view addSubview:_pagingView];
}

- (void)pagingMenuView:(PagingMenuView *)pagingMenuView currentPage:(NSInteger)currentPage {
    NSLog(@"%ld", currentPage);

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
