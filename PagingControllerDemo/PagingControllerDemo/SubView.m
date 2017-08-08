//
//  SubView.m
//  PagingControllerDemo
//
//  Created by Zgmanhui on 2017/8/7.
//  Copyright © 2017年 Zgmanhui. All rights reserved.
//

#import "SubView.h"

@implementation SubView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setBackgroundColor:[self getColor]];
    }
    return self;
}


- (UIColor *)getColor {
    int R = (arc4random() % 256) ;
    int G = (arc4random() % 256) ;
    int B = (arc4random() % 256) ;
    return [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:1];
}


- (void)setIdx:(NSInteger)idx {
    _idx = idx;
    UILabel *label = [[UILabel alloc] init];
    label.center = CGPointMake([UIScreen mainScreen].bounds.size.width / 2, [UIScreen mainScreen].bounds.size.height / 2);
    label.bounds = CGRectMake(0, 0, 300, 100);
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:100];
    label.textColor = [UIColor whiteColor];
    [self addSubview:label];
    label.text = [NSString stringWithFormat:@"%ld", idx];
}

@end
