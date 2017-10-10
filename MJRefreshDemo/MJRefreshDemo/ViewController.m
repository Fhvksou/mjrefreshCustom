//
//  ViewController.m
//  TableViewRefresh
//
//  Created by fhkvsou on 2017/10/9.
//  Copyright © 2017年 fhkvsou. All rights reserved.
//

#import "ViewController.h"
#import "MJRefreshTableView.h"
#import "ZLMTableViewCell.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource,MDRefreshTabelViewDelegate>

@property (nonatomic ,strong) MJRefreshTableView * tableView;

@property (nonatomic ,strong) NSMutableArray * datas;

@property (nonatomic ,assign) NSInteger page;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
    _page = 0;
    [self createData];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (void)createData{
    for (NSInteger i = 0; i< 4; i++) {
        [self.datas addObject:@1];
    }
    [self.tableView reloadData];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 230;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * identify = @"123";
    ZLMTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (!cell) {
        cell = [[ZLMTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    [cell updateViews];
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (void)mdrefreshTableViewDidRefresh:(MJRefreshTableView *)tableView{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        _page = 0;
        [self.datas removeAllObjects];
        [self createData];
        self.tableView.stopHeaderRefresh = YES;
        self.tableView.haveLoadAllDatas = NO;
    });
}

- (void)mdrefreshTableViewDidLoadMore:(MJRefreshTableView *)tableView{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        _page++;
        [self createData];
        if (_page == 10) {
            self.tableView.haveLoadAllDatas = YES;
        }else{
            self.tableView.stopFooterLoadMore = YES;
        }
    });
}

- (MJRefreshTableView *)tableView{
    if (!_tableView) {
        _tableView = [[MJRefreshTableView alloc]initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 64)];
        _tableView.addHeaderView = YES;
        _tableView.addFooterView = YES;
        _tableView.refreshDelegate = self;
        _tableView.automaticallyRefresh = YES;
        _tableView.triggerAutomaticallyRefreshPercent = -3;
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (NSMutableArray *)datas{
    if (!_datas) {
        _datas = [[NSMutableArray alloc]init];
    }
    return _datas;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
