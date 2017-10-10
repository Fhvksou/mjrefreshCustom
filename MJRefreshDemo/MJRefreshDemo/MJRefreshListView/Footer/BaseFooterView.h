//
//  BaseFooterView.h
//  TableViewRefresh
//
//  Created by fhkvsou on 2017/10/10.
//  Copyright © 2017年 fhkvsou. All rights reserved.
//

#import "MJRefreshFooter.h"

@interface BaseFooterView : MJRefreshFooter

/** 是否自动刷新 */
@property (assign, nonatomic, getter=isAutomaticallyRefresh) BOOL automaticallyRefresh;

/** 当底部控件出现多少时就自动刷新 */
@property (assign, nonatomic) CGFloat triggerAutomaticallyRefreshPercent;

@end
