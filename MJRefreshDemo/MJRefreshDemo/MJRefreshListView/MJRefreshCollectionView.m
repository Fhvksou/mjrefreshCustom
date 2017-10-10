//
//  MJRefreshCollectionView.m
//  TableViewRefresh
//
//  Created by fhkvsou on 2017/10/10.
//  Copyright © 2017年 fhkvsou. All rights reserved.
//

#import "MJRefreshCollectionView.h"
#import "NormalHeaderView.h"
#import "NormalFooterView.h"

@implementation MJRefreshCollectionView

#pragma 初始化

- (void)awakeFromNib{
    [super awakeFromNib];
    
    [self configDefault];
}

- (id)initWithFrame:(CGRect)frame{
    if (self == [super initWithFrame:frame]) {
        [self configDefault];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout{
    if (self = [super initWithFrame:frame collectionViewLayout:layout]) {
        [self configDefault];
    }
    return self;
}

- (void)configDefault{
    self.addHeaderView = NO;
    self.addFooterView = NO;
    self.headerStyle = MDrefreshHeaderStyleNormal;
    self.footerStyle = MDrefreshFooterStyleNormal;
    self.triggerAutomaticallyRefreshPercent = 1.0;
    self.automaticallyRefresh = NO;
}

- (void)updateViews:(BOOL)isHeader{
    if (isHeader) {
        if (!self.addHeaderView) {
            if (self.mj_header) {
                [self.mj_header removeFromSuperview];
                self.mj_header = nil;
            }
        }else{
            [self updateHeaderView];
        }
    }else{
        if (!self.addFooterView) {
            if (self.mj_footer) {
                [self.mj_footer removeFromSuperview];
                self.mj_footer = nil;
            }
        }else{
            [self updateFooterView];
        }
    }
}

#pragma 配置headerView

- (void)updateHeaderView{
    if (self.headerStyle == MDrefreshHeaderStyleNormal && ![self.refreshHeaderView isKindOfClass:[NormalHeaderView class]]) {
        self.refreshHeaderView = [NormalHeaderView headerWithRefreshingTarget:self refreshingAction:@selector(refreshData)];
    }
    // 可添加自定义header
    
    //
    self.mj_header = self.refreshHeaderView;
}

- (void)setHeaderStyle:(MDrefreshHeaderStyle)headerStyle{
    _headerStyle = headerStyle;
    [self updateViews:YES];
}

- (void)setAddHeaderView:(BOOL)addHeaderView{
    _addHeaderView = addHeaderView;
    [self updateViews:YES];
}

- (void)setStopHeaderRefresh:(BOOL)stopHeaderRefresh{
    _stopHeaderRefresh = stopHeaderRefresh;
    if (_stopHeaderRefresh == YES && self.refreshHeaderView.isRefreshing == YES) {
        [self.refreshHeaderView endRefreshing];
    }else if (_stopHeaderRefresh == NO && self.refreshHeaderView.isRefreshing == NO) {
        [self.refreshHeaderView beginRefreshing];
    }
}

#pragma 配置footerView

- (void)updateFooterView{
    if (self.footerStyle == MDrefreshFooterStyleNormal && ![self.refreshFooterView isKindOfClass:[NormalFooterView class]]) {
        self.refreshFooterView = [NormalFooterView footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    }
    // 可添加自定义header
    
    //
    BaseFooterView * footView = (BaseFooterView *)self.refreshFooterView;
    footView.automaticallyRefresh = self.automaticallyRefresh;
    footView.triggerAutomaticallyRefreshPercent = self.triggerAutomaticallyRefreshPercent;
    self.mj_footer = self.refreshFooterView;
}

- (void)setFooterStyle:(MDrefreshFooterStyle)footerStyle{
    _footerStyle = footerStyle;
    [self updateViews:NO];
}

- (void)setAddFooterView:(BOOL)addFooterView{
    _addFooterView = addFooterView;
    [self updateViews:NO];
}

- (void)setStopFooterLoadMore:(BOOL)stopFooterLoadMore{
    _stopFooterLoadMore = stopFooterLoadMore;
    if (_stopFooterLoadMore == YES && self.refreshFooterView.isRefreshing == YES) {
        [self.refreshFooterView endRefreshing];
    }else if (_stopFooterLoadMore == NO && self.refreshFooterView.isRefreshing == NO){
        [self.refreshFooterView beginRefreshing];
    }
}

- (void)setHaveLoadAllDatas:(BOOL)haveLoadAllDatas{
    _haveLoadAllDatas = haveLoadAllDatas;
    if (_haveLoadAllDatas == YES) {
        [self.refreshFooterView endRefreshingWithNoMoreData];
    }else{
        [self.refreshFooterView resetNoMoreData];
    }
}

- (void)setAutomaticallyRefresh:(BOOL)automaticallyRefresh{
    _automaticallyRefresh = automaticallyRefresh;
    [self resertFootView];
    [self updateViews:NO];
}

- (void)setTriggerAutomaticallyRefreshPercent:(CGFloat)triggerAutomaticallyRefreshPercent{
    _triggerAutomaticallyRefreshPercent = triggerAutomaticallyRefreshPercent;
    [self resertFootView];
    [self updateViews:NO];
}

- (void)resertFootView{
    if (self.refreshFooterView && self.mj_footer) {
        [self.mj_footer removeFromSuperview];
        self.mj_footer = nil;
    }
}

#pragma 回调

- (void)refreshData{
    if (_refreshDelegate && [_refreshDelegate respondsToSelector:@selector(mdrefreshCollectionViewDidRefresh:)]) {
        [_refreshDelegate mdrefreshCollectionViewDidRefresh:self];
    }
}

- (void)loadMoreData{
    if (_refreshDelegate && [_refreshDelegate respondsToSelector:@selector(mdrefreshCollectionViewDidLoadMore:)]) {
        [_refreshDelegate mdrefreshCollectionViewDidLoadMore:self];
    }
}

@end
