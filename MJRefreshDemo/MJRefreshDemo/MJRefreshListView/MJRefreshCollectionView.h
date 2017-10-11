//
//  MJRefreshCollectionView.h
//  TableViewRefresh
//
//  Created by fhkvsou on 2017/10/10.
//  Copyright © 2017年 fhkvsou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MJRefreshHeader.h"
#import "BaseFooterView.h"
#import "MJConstant.h"

@class MJRefreshCollectionView;

@protocol MDRefreshCollectionViewDelegate <NSObject>

/******代理回调 */

- (void)mdrefreshCollectionViewDidRefresh:(MJRefreshCollectionView *)collectionView;

- (void)mdrefreshCollectionViewDidLoadMore:(MJRefreshCollectionView *)collectionView;

@end

@interface MJRefreshCollectionView : UICollectionView

/******刷新控件 */
@property (nonatomic ,strong) MJRefreshHeader * refreshHeaderView;
@property (nonatomic ,strong) BaseFooterView * refreshFooterView;

@property (nonatomic ,assign) MDrefreshHeaderStyle headerStyle;
@property (nonatomic ,assign) MDrefreshFooterStyle footerStyle;

/******是否添加刷新控件 */
@property (nonatomic ,assign) BOOL addHeaderView;
@property (nonatomic ,assign) BOOL addFooterView;

/******停止刷新 */
@property (nonatomic ,assign) BOOL stopHeaderRefresh;
@property (nonatomic ,assign) BOOL stopFooterLoadMore;

@property (nonatomic ,assign) BOOL haveLoadAllDatas;

/******自动刷新/无感知(默认为NO) */
@property (nonatomic ,assign) BOOL automaticallyRefresh;

/** 当底部控件出现多少时就自动刷新(默认为1.0，也就是底部控件完全出现时，才会自动刷新) */
@property (assign, nonatomic) CGFloat triggerAutomaticallyRefreshPercent;

@property (nonatomic ,weak) id<MDRefreshCollectionViewDelegate> refreshDelegate;

@end
