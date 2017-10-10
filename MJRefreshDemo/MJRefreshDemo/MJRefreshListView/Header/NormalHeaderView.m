//
//  NormalHeaderView.m
//  TableViewRefresh
//
//  Created by fhkvsou on 2017/10/9.
//  Copyright © 2017年 fhkvsou. All rights reserved.
//

#import "NormalHeaderView.h"

#define ScreenWidth self.bounds.size.width

@interface NormalHeaderView ()

@property (nonatomic ,strong) NSArray * stateTexts;

@property (nonatomic ,strong) UILabel * stateLabel;

@end

@implementation NormalHeaderView

- (void)prepare{
    [super prepare];
    
//    self.mj_h = 64;
    
    self.stateTexts = [[NSArray alloc]initWithObjects:@"下拉即可刷新..",@"释放即可刷新..",@"正在加载中..",@"下拉即可刷新..", nil];
    
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
        default:
            break;
    }
}

@end
