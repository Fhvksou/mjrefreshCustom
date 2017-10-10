//
//  NormalFooterView.m
//  TableViewRefresh
//
//  Created by fhkvsou on 2017/10/9.
//  Copyright © 2017年 fhkvsou. All rights reserved.
//

#import "NormalFooterView.h"

#define ScreenWidth self.bounds.size.width

@interface NormalFooterView ()

@property (nonatomic ,strong) NSArray * stateTexts;

@property (nonatomic ,strong) UILabel * stateLabel;

@end
@implementation NormalFooterView

- (void)prepare{
    [super prepare];
    
    self.stateTexts = [[NSArray alloc]initWithObjects:@"上拉即可刷新..",@"释放即可刷新..",@"正在加载中..",@"上拉即可刷新..",@"已经加载全部数据", nil];
    
    self.stateLabel = [[UILabel alloc]init];
    self.stateLabel.textAlignment = NSTextAlignmentCenter;
    self.stateLabel.text = self.stateTexts[0];
    self.stateLabel.font = [UIFont systemFontOfSize:13];
    self.stateLabel.textColor = [UIColor grayColor];
    
    [self addSubview:self.stateLabel];
}

- (void)placeSubviews{
    [super placeSubviews];
    self.stateLabel.frame = CGRectMake(0, (self.frame.size.height - 20.f) / 2, ScreenWidth, 20.f);
}

- (void)setState:(MJRefreshState)state{
    MJRefreshCheckState;
    switch (state) {
        case MJRefreshStateIdle:
            self.stateLabel.text = self.stateTexts[0];
            break;
        case MJRefreshStatePulling:
            self.stateLabel.text = self.stateTexts[1];
            break;
        case MJRefreshStateRefreshing:
            self.stateLabel.text = self.stateTexts[2];
            break;
        case MJRefreshStateWillRefresh:
            self.stateLabel.text = self.stateTexts[3];
            break;
        case MJRefreshStateNoMoreData:
            self.stateLabel.text = self.stateTexts[4];
            break;
        default:
            break;
    }
}

@end
