//
//  PagingMenuView.h
//  PagingControllerDemo
//
//  Created by Zgmanhui on 2017/8/7.
//  Copyright © 2017年 Zgmanhui. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PagingMenuModel, PagingMenuCell, PagingMenuView;

@protocol PagingMenuViewDelegate <NSObject>

- (void)pagingMenuView:(PagingMenuView *)pagingMenuView currentPage:(NSInteger)currentPage;

@end

@interface PagingMenuView : UIView


- (instancetype)initWithFrame:(CGRect)frame model:(PagingMenuModel *)model;

@property (nonatomic, assign) NSInteger currentPage;

@property (nonatomic, assign) id <PagingMenuViewDelegate> delegate;

@end


@interface PagingMenuModel : NSObject


#pragma mark -- 必传
/** 标题文本 */
@property (nonatomic, strong) NSArray<NSString *> *titles;

/** 子视图 */
@property (nonatomic, strong) NSArray<UIView *> *views;


#pragma mark -- 有默认值的  非必须设置
/** 滑块颜色 */
@property (nonatomic, strong) UIColor *sliderColor;

/** 滑块高度 默认2*/
@property (nonatomic, assign) CGFloat sliderHeight;

/** 滑块宽度 默认屏幕宽五分之一*/
@property (nonatomic, assign) CGFloat sliderWidth;

/** 标题文字颜色正常 默认黑色*/
@property (nonatomic, strong) UIColor *titleNormalColor;

/** 标题文字颜色选中 默认橙色*/
@property (nonatomic, strong) UIColor *titleSelectColor;

/** 标题文字字体 默认15*/
@property (nonatomic, strong) UIFont *titleFont;

/** 标题宽度 默认子视图大于5 屏幕宽五分之一 否则平分屏幕宽*/
@property (nonatomic, assign) CGFloat titleWidth;

/** 顶部高度 默认50*/
@property (nonatomic, assign) CGFloat headerHight;

/** 标题是否自适应宽度 默认NO*/
@property (nonatomic, assign) BOOL adaptiveWidth;

/** 滑块自适应 button宽度附加值 默认10*/
@property (nonatomic, assign) CGFloat widthOffButtonWidth;

/** 滑块自适应宽度 默认NO*/
@property (nonatomic, assign) BOOL adaptiveSliderWidth;

/** 滑块自适应宽度的 滑块宽度附加值 默认0*/
@property (nonatomic, assign) CGFloat widthOffWidth;

/** 点击按钮的时候 底部视图是否需要动画 默认不需要 */
@property (nonatomic, assign) BOOL scrollingAnimation;

/** 滑块圆角 默认0 */
@property (nonatomic, assign) NSInteger sliderCorners;

/** 是否屏蔽拖动动画  默认NO */
@property (nonatomic, assign) BOOL shieldingDragAnimation;

@end


@interface PagingMenuCell : UICollectionViewCell

@property (nonatomic, strong) UIView *subView;

@end

