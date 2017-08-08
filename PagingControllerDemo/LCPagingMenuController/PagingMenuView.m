//
//  PagingMenuView.m
//  PagingControllerDemo
//
//  Created by Zgmanhui on 2017/8/7.
//  Copyright © 2017年 Zgmanhui. All rights reserved.
//

#import "PagingMenuView.h"

#define PM_SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define PM_SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

@interface PagingMenuView ()<UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) PagingMenuModel *model;

@property (nonatomic, strong) NSMutableArray *buttons;

@property (nonatomic, strong) UIView *sliderView;

@property (nonatomic, strong) UIButton *selectButton;

/** collectionView子视图的宽 */
@property (nonatomic, assign) CGFloat content_width;

@end

@implementation PagingMenuView

- (instancetype)initWithFrame:(CGRect)frame model:(PagingMenuModel *)model
{
    self = [super initWithFrame:frame];
    if (self) {
        _model = model;
        [self initScrollView];
        
        if (_model.views.count == _model.titles.count) {
            [self initCollectionView];
        }

    }
    return self;
}

- (void)initScrollView {
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, PM_SCREEN_WIDTH, _model.headerHight)];
    _scrollView.showsHorizontalScrollIndicator = NO;
    [self addSubview:_scrollView];
    __weak typeof(self) wself = self;
    
    __block CGFloat titleWidth = _model.titleWidth;
    __block CGFloat lastView_right_x = 0;
    _buttons = [NSMutableArray array];
    [_model.titles enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (wself.model.adaptiveWidth) {
            titleWidth = [self getViewWidthForTextContentWithTitle:obj] + wself.model.widthOffButtonWidth;
        }
        UIButton *titlesButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [titlesButton setTitle:obj forState:UIControlStateNormal];
        [titlesButton setTitleColor:wself.model.titleNormalColor forState:UIControlStateNormal];
        [titlesButton setTitleColor:wself.model.titleSelectColor forState:UIControlStateSelected];
        titlesButton.titleLabel.font = wself.model.titleFont;
        titlesButton.frame = CGRectMake(lastView_right_x, 0, titleWidth, wself.model.headerHight);
        lastView_right_x = lastView_right_x + titleWidth;
        titlesButton.tag = 1000 + idx;
        [_buttons addObject:titlesButton];
        [_scrollView addSubview:titlesButton];
        [titlesButton addTarget:self action:@selector(handleTitleEvent:) forControlEvents:UIControlEventTouchUpInside];
        if (idx == 0) {
            _selectButton = titlesButton;
            _selectButton.selected = YES;
        }
    }];
    
    _sliderView = [[UIView alloc] init];
    _sliderView.layer.cornerRadius = _model.sliderCorners;
    _sliderView.center = CGPointMake(titleWidth / 2, _model.headerHight - _model.sliderHeight / 2);
    
    CGFloat sliderWidth = _model.sliderWidth;
    if (_model.adaptiveSliderWidth) {
        sliderWidth = _selectButton.bounds.size.width + _model.widthOffWidth - _model.widthOffButtonWidth;
    }
    
    _sliderView.bounds = CGRectMake(0, 0, sliderWidth, _model.sliderHeight);
    _sliderView.backgroundColor = _model.sliderColor;
    [_scrollView addSubview:_sliderView];
    _scrollView.contentSize = CGSizeMake(lastView_right_x, _model.headerHight);
}

- (void)initCollectionView {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(self.frame.size.width, self.frame.size.height);
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.minimumLineSpacing = 0;
    _content_width = self.frame.size.width;
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, _model.headerHight, self.frame.size.width, self.frame.size.height) collectionViewLayout:layout];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.pagingEnabled = YES;
    _collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [self addSubview:_collectionView];
    [_collectionView registerClass:[PagingMenuCell class] forCellWithReuseIdentifier:NSStringFromClass([PagingMenuCell class])];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _model.views.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PagingMenuCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([PagingMenuCell class]) forIndexPath:indexPath];
    cell.subView = _model.views[indexPath.row];
    return cell;
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (_model.shieldingDragAnimation) {
        return;
    }
    CGFloat off_x = scrollView.contentOffset.x;
    CGFloat current_off_x = off_x - (_currentPage * (scrollView.contentSize.width / _model.views.count));
    
    CGFloat current_wdith = _model.sliderWidth;
    if (_model.adaptiveSliderWidth) {
        current_wdith = _selectButton.bounds.size.width + _model.widthOffWidth - _model.widthOffButtonWidth;
    }
    
    CGFloat current_x = _selectButton.center.x - current_wdith / 2;

    UIButton *nextButton = nil;
    if (current_off_x > 0) {//往下一页滑动
        if (_currentPage == _model.views.count - 1) {
            return;//最后一页的话 返回
        }
        nextButton = [_scrollView viewWithTag:1000 + _currentPage + 1];//得到下一页的按钮对象
    }else {
        if (_currentPage == 0) {
            return;//最后一页的话 返回
        }
        nextButton = [_scrollView viewWithTag:1000 + _currentPage - 1];//得到下一页的按钮对象
    }
    CGFloat next_wdith = _model.sliderWidth;
    if (_model.adaptiveSliderWidth) {
        next_wdith = nextButton.bounds.size.width + _model.widthOffWidth - _model.widthOffButtonWidth;
    }
    CGFloat distance = 0;
    
    CGFloat all_width =  distance + next_wdith;
    
    CGFloat off_percentage = current_off_x / _content_width;
    if (current_off_x > 0) {
        distance = nextButton.center.x - _selectButton.center.x - current_wdith / 2 - next_wdith / 2;
        CGFloat next_right_x = nextButton.center.x + next_wdith / 2;

        if (off_percentage < 0.5) {
            CGFloat slider_width = current_wdith + off_percentage * all_width * 2;
            _sliderView.frame = CGRectMake(current_x, _sliderView.center.y - _sliderView.bounds.size.height / 2, slider_width, _sliderView.bounds.size.height);
        }else {
            all_width = distance + current_wdith;
            CGFloat slider_width = next_wdith + (1 - off_percentage) * all_width * 2;
            CGFloat current_left_x = next_right_x - slider_width;
            _sliderView.frame = CGRectMake(current_left_x, _sliderView.center.y - _sliderView.bounds.size.height / 2, slider_width, _sliderView.bounds.size.height);
        }
    }else {
        distance = _selectButton.center.x - nextButton.center.x - current_wdith / 2 - next_wdith / 2;
        CGFloat current_right_x = _selectButton.center.x + current_wdith / 2;
        if (off_percentage > -0.5) {
            all_width = distance + next_wdith;
            CGFloat slider_width = current_wdith + (-off_percentage) * all_width * 2;
            CGFloat current_left_x = current_right_x - slider_width;
            _sliderView.frame = CGRectMake(current_left_x, _sliderView.center.y - _sliderView.bounds.size.height / 2, slider_width, _sliderView.bounds.size.height);
        }else {
            CGFloat next_left_x = nextButton.center.x - next_wdith / 2 ;
            all_width = current_wdith + distance;
            CGFloat slider_width = next_wdith + (1 + off_percentage) * all_width * 2;
            _sliderView.frame = CGRectMake(next_left_x, _sliderView.center.y - _sliderView.bounds.size.height / 2, slider_width, _sliderView.bounds.size.height);
        }
        
    }

    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    self.currentPage = scrollView.contentOffset.x / (scrollView.contentSize.width / _model.views.count);
}


- (CGFloat)getViewWidthForTextContentWithTitle:(NSString *)title {
    CGSize size = [title sizeWithAttributes:@{NSFontAttributeName:_model.titleFont}];
    return size.width;
}

- (void)handleTitleEvent:(UIButton *)sender {
    if (_selectButton == sender) {
        return;
    }
    self.currentPage = sender.tag - 1000;
}

- (void)setCurrentPage:(NSInteger)currentPage {
    _currentPage = currentPage;
    UIButton *currentButton = [_scrollView viewWithTag:1000 + currentPage];
    
    
    _selectButton.selected = NO;
    currentButton.selected = YES;
    _selectButton = currentButton;
    
    CGPoint center = _sliderView.center;
    CGFloat sliderWidth = _model.sliderWidth;
    if (_model.adaptiveSliderWidth) {
        sliderWidth = _selectButton.bounds.size.width - _model.widthOffButtonWidth  + _model.widthOffWidth;
    }
    [UIView animateWithDuration:0.3 animations:^{
        _sliderView.bounds = CGRectMake(0, 0, sliderWidth, _model.sliderHeight);
        _sliderView.center = CGPointMake(currentButton.center.x, center.y);
    }];
    
    CGFloat critical_point_x = PM_SCREEN_WIDTH / 2;
    CGFloat critical_point_x_last = _scrollView.contentSize.width - critical_point_x;
    CGFloat button_center_x = currentButton.center.x;
    if (button_center_x >= critical_point_x && button_center_x <= critical_point_x_last) {
        [_scrollView setContentOffset:CGPointMake(currentButton.center.x - critical_point_x, 0) animated:YES];
    }
    if (button_center_x < critical_point_x) {
        [_scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    }
    if (button_center_x > critical_point_x_last) {
        [_scrollView setContentOffset:CGPointMake(_scrollView.contentSize.width - _scrollView.bounds.size.width, 0) animated:YES];
    }
    [_collectionView setContentOffset:CGPointMake(self.frame.size.width * _currentPage, 0) animated:_model.scrollingAnimation];
    if (self.delegate &&[self.delegate respondsToSelector:@selector(pagingMenuView:currentPage:)]) {
        [self.delegate pagingMenuView:self currentPage:_currentPage];
    }
}


@end

@implementation PagingMenuModel

- (CGFloat)sliderWidth {
    if (!_sliderWidth) {
        return PM_SCREEN_WIDTH / 5;
    }
    return _sliderWidth;
}

- (CGFloat)sliderHeight {
    if (!_sliderHeight) {
        return 2;
    }
    return _sliderHeight;
}

- (UIColor *)titleNormalColor {
    if (!_titleNormalColor) {
        _titleNormalColor = [UIColor blackColor];
    }
    return _titleNormalColor;
}

- (UIColor *)titleSelectColor {
    if (!_titleSelectColor) {
        _titleSelectColor = [UIColor colorWithRed:1.00 green:0.40 blue:0.00 alpha:1.00];
    }
    return _titleSelectColor;
}

- (UIFont *)titleFont {
    if (!_titleFont) {
        _titleFont = [UIFont systemFontOfSize:15];
    }
    return _titleFont;
}

- (CGFloat)titleWidth {
    if (!_titleWidth) {
        _titleWidth = _titles.count > 5 ? PM_SCREEN_WIDTH / 5 : PM_SCREEN_WIDTH / _titles.count;
    }
    return _titleWidth;
}

- (CGFloat)headerHight {
    if (!_headerHight) {
        _headerHight = 50;
    }
    return _headerHight;
}

- (UIColor *)sliderColor {
    if (!_sliderColor) {
        _sliderColor = [UIColor colorWithRed:1.00 green:0.40 blue:0.00 alpha:1.00];
    }
    return _sliderColor;
}

- (CGFloat)widthOffButtonWidth {
    if (!_widthOffButtonWidth) {
        _widthOffButtonWidth = 10;
    }
    return _widthOffButtonWidth;
}

- (BOOL)getDragAnimation {
    return YES;
}

@end

@implementation PagingMenuCell

- (void)setSubView:(UIView *)subView {
    _subView = subView;
    [self addSubview:_subView];
    _subView.frame = CGRectMake(0, 0, self.contentView.bounds.size.width, self.contentView.bounds.size.height);
}

@end
