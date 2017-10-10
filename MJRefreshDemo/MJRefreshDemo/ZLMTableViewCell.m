//
//  ZLMTableViewCell.m
//  TableViewRefresh
//
//  Created by fhkvsou on 2017/10/9.
//  Copyright © 2017年 fhkvsou. All rights reserved.
//

#import "ZLMTableViewCell.h"

@interface ZLMTableViewCell ()

@property (nonatomic ,strong) UIImageView * ckImageView;

@end
@implementation ZLMTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initViews];
    }
    return self;
}

- (void)initViews{
    _ckImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    _ckImageView.contentMode = UIViewContentModeScaleAspectFill;
    _ckImageView.clipsToBounds = YES;
    [self.contentView addSubview:_ckImageView];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    _ckImageView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
}

- (void)updateViews{
    _ckImageView.image = [UIImage imageNamed:@"girlImage.jpg"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
