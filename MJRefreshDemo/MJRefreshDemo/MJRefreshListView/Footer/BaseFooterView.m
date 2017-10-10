//
//  BaseFooterView.m
//  TableViewRefresh
//
//  Created by fhkvsou on 2017/10/10.
//  Copyright © 2017年 fhkvsou. All rights reserved.
//

#import "BaseFooterView.h"

@interface BaseFooterView ()

@property (assign, nonatomic) NSInteger lastRefreshCount;
@property (assign, nonatomic) CGFloat lastBottomDelta;

@end

@implementation BaseFooterView

#pragma mark - 初始化
- (void)willMoveToSuperview:(UIView *)newSuperview{
    [super willMoveToSuperview:newSuperview];

    if (self.automaticallyRefresh) {
        if (newSuperview) { // 新的父控件
            if (self.hidden == NO) {
                self.scrollView.mj_insetB += self.mj_h;
            }
            
            // 设置位置
            self.mj_y = _scrollView.mj_contentH;
        } else { // 被移除了
            if (self.hidden == NO) {
                self.scrollView.mj_insetB -= self.mj_h;
            }
        }
    }else{
        [self scrollViewContentSizeDidChange:nil];
    }
}

- (void)prepare{
    [super prepare];
}

#pragma mark - 实现父类的方法
- (void)scrollViewContentOffsetDidChange:(NSDictionary *)change{
    [super scrollViewContentOffsetDidChange:change];
    
    if (self.automaticallyRefresh) {
        if (self.state != MJRefreshStateIdle || !self.automaticallyRefresh || self.mj_y == 0) return;
        
        if (_scrollView.mj_insetT + _scrollView.mj_contentH > _scrollView.mj_h) { // 内容超过一个屏幕
            // 这里的_scrollView.mj_contentH替换掉self.mj_y更为合理
            if (_scrollView.mj_offsetY >= _scrollView.mj_contentH - _scrollView.mj_h + self.mj_h * self.triggerAutomaticallyRefreshPercent + _scrollView.mj_insetB - self.mj_h) {
                // 防止手松开时连续调用
                CGPoint old = [change[@"old"] CGPointValue];
                CGPoint new = [change[@"new"] CGPointValue];
                if (new.y <= old.y) return;
                
                // 当底部刷新控件完全出现时，才刷新
                [self beginRefreshing];
            }
        }
    }else{
        // 如果正在刷新，直接返回
        if (self.state == MJRefreshStateRefreshing) return;
        
        _scrollViewOriginalInset = self.scrollView.contentInset;
        
        // 当前的contentOffset
        CGFloat currentOffsetY = self.scrollView.mj_offsetY;
        // 尾部控件刚好出现的offsetY
        CGFloat happenOffsetY = [self happenOffsetY];
        // 如果是向下滚动到看不见尾部控件，直接返回
        if (currentOffsetY <= happenOffsetY) return;
        
        CGFloat pullingPercent = (currentOffsetY - happenOffsetY) / self.mj_h;
        
        // 如果已全部加载，仅设置pullingPercent，然后返回
        if (self.state == MJRefreshStateNoMoreData) {
            self.pullingPercent = pullingPercent;
            return;
        }
        
        if (self.scrollView.isDragging) {
            self.pullingPercent = pullingPercent;
            // 普通 和 即将刷新 的临界点
            CGFloat normal2pullingOffsetY = happenOffsetY + self.mj_h;
            
            if (self.state == MJRefreshStateIdle && currentOffsetY > normal2pullingOffsetY) {
                // 转为即将刷新状态
                self.state = MJRefreshStatePulling;
            } else if (self.state == MJRefreshStatePulling && currentOffsetY <= normal2pullingOffsetY) {
                // 转为普通状态
                self.state = MJRefreshStateIdle;
            }
        } else if (self.state == MJRefreshStatePulling) {// 即将刷新 && 手松开
            // 开始刷新
            [self beginRefreshing];
        } else if (pullingPercent < 1) {
            self.pullingPercent = pullingPercent;
        }
    }
}

- (void)scrollViewContentSizeDidChange:(NSDictionary *)change{
    [super scrollViewContentSizeDidChange:change];
    
    if (self.automaticallyRefresh) {
        // 设置位置
        self.mj_y = self.scrollView.mj_contentH;
    }else{
        // 内容的高度
        CGFloat contentHeight = self.scrollView.mj_contentH + self.ignoredScrollViewContentInsetBottom;
        // 表格的高度
        CGFloat scrollHeight = self.scrollView.mj_h - self.scrollViewOriginalInset.top - self.scrollViewOriginalInset.bottom + self.ignoredScrollViewContentInsetBottom;
        // 设置位置和尺寸
        self.mj_y = MAX(contentHeight, scrollHeight);
    }
}

- (void)scrollViewPanStateDidChange:(NSDictionary *)change{
    [super scrollViewPanStateDidChange:change];
    if (self.automaticallyRefresh) {
        if (self.state != MJRefreshStateIdle) return;
        
        if (_scrollView.panGestureRecognizer.state == UIGestureRecognizerStateEnded) {// 手松开
            if (_scrollView.mj_insetT + _scrollView.mj_contentH <= _scrollView.mj_h) {  // 不够一个屏幕
                if (_scrollView.mj_offsetY >= - _scrollView.mj_insetT) { // 向上拽
                    [self beginRefreshing];
                }
            } else { // 超出一个屏幕
                if (_scrollView.mj_offsetY >= _scrollView.mj_contentH + _scrollView.mj_insetB - _scrollView.mj_h) {
                    [self beginRefreshing];
                }
            }
        }
    }
}

- (void)setState:(MJRefreshState)state{
    MJRefreshCheckState
    if (self.automaticallyRefresh) {
        if (state == MJRefreshStateRefreshing) {
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self executeRefreshingCallback];
//            });
        } else if (state == MJRefreshStateNoMoreData || state == MJRefreshStateIdle) {
            if (MJRefreshStateRefreshing == oldState) {
                if (self.endRefreshingCompletionBlock) {
                    self.endRefreshingCompletionBlock();
                }
            }
        }
    }else{
        // 根据状态来设置属性
        if (state == MJRefreshStateNoMoreData || state == MJRefreshStateIdle) {
            // 刷新完毕
            if (MJRefreshStateRefreshing == oldState) {
                [UIView animateWithDuration:MJRefreshSlowAnimationDuration animations:^{
                    self.scrollView.mj_insetB -= self.lastBottomDelta;
                    
                    // 自动调整透明度
                    if (self.isAutomaticallyChangeAlpha) self.alpha = 0.0;
                } completion:^(BOOL finished) {
                    self.pullingPercent = 0.0;
                    
                    if (self.endRefreshingCompletionBlock) {
                        self.endRefreshingCompletionBlock();
                    }
                }];
            }
            
            CGFloat deltaH = [self heightForContentBreakView];
            // 刚刷新完毕
            if (MJRefreshStateRefreshing == oldState && deltaH > 0 && self.scrollView.mj_totalDataCount != self.lastRefreshCount) {
                self.scrollView.mj_offsetY = self.scrollView.mj_offsetY;
            }
        } else if (state == MJRefreshStateRefreshing) {
            // 记录刷新前的数量
            self.lastRefreshCount = self.scrollView.mj_totalDataCount;

            [UIView animateWithDuration:MJRefreshFastAnimationDuration animations:^{
                CGFloat bottom = self.mj_h + self.scrollViewOriginalInset.bottom;
                CGFloat deltaH = [self heightForContentBreakView];
                if (deltaH < 0) { // 如果内容高度小于view的高度
                    bottom -= deltaH;
                }
                self.lastBottomDelta = bottom - self.scrollView.mj_insetB;
                self.scrollView.mj_insetB = bottom;
                self.scrollView.mj_offsetY = [self happenOffsetY] + self.mj_h;
            } completion:^(BOOL finished) {
                [self executeRefreshingCallback];
            }];
        }
    }
}

- (void)endRefreshing{
    if (!self.automaticallyRefresh) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.state = MJRefreshStateIdle;
        });
    }else{
        self.state = MJRefreshStateIdle;
    }
}

- (void)endRefreshingWithNoMoreData{
    if (!self.automaticallyRefresh) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.state = MJRefreshStateNoMoreData;
        });
    }else{
        self.state = MJRefreshStateNoMoreData;
    }
}
#pragma mark - 私有方法
#pragma mark 获得scrollView的内容 超出 view 的高度
- (CGFloat)heightForContentBreakView
{
    CGFloat h = self.scrollView.frame.size.height - self.scrollViewOriginalInset.bottom - self.scrollViewOriginalInset.top;
    return self.scrollView.contentSize.height - h;
}

#pragma mark 刚好看到上拉刷新控件时的contentOffset.y
- (CGFloat)happenOffsetY
{
    CGFloat deltaH = [self heightForContentBreakView];
    if (deltaH > 0) {
        return deltaH - self.scrollViewOriginalInset.top;
    } else {
        return - self.scrollViewOriginalInset.top;
    }
}

#pragma mark autos

- (void)setHidden:(BOOL)hidden
{
    BOOL lastHidden = self.isHidden;
    
    [super setHidden:hidden];
    
    if (!lastHidden && hidden) {
        self.state = MJRefreshStateIdle;
        
        self.scrollView.mj_insetB -= self.mj_h;
    } else if (lastHidden && !hidden) {
        self.scrollView.mj_insetB += self.mj_h;
        
        // 设置位置
        self.mj_y = _scrollView.mj_contentH;
    }
}

@end
