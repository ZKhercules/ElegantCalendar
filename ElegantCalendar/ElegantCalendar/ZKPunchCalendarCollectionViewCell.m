//
//  ZKPunchCalendarCollectionViewCell.m
//  SSAI
//
//  Created by zhangkeqin on 2023/3/21.
//  Copyright © 2023 ZK. All rights reserved.
//

#import "ZKPunchCalendarCollectionViewCell.h"

@implementation ZKPunchCalendarCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {

    }
    return self;
}

-(void)configUI{
    self.dayLabel.frame = self.contentView.bounds;
    [self.contentView addSubview:self.dayLabel];
}

//日期
-(UILabel *)dayLabel{
    if(!_dayLabel){
        _dayLabel = [[UILabel alloc]init];
        _dayLabel.backgroundColor = [UIColor whiteColor];
        _dayLabel.textColor = [UIColor blackColor];
        _dayLabel.textAlignment = NSTextAlignmentCenter;
        _dayLabel.font = [UIFont systemFontOfSize:14];
    }
    return _dayLabel;
}

//打卡标识
-(UIImageView *)punchImageView{
    if(!_punchImageView){
        _punchImageView = [[UIImageView alloc]init];
        
    }
    return _punchImageView;
}

-(void)setCellDict:(NSDictionary *)cellDict{
    _cellDict = cellDict;
    self.backgroundColor = [UIColor whiteColor];
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.dayLabel.text = [NSString stringWithFormat:@"%@",cellDict[@"day"]];
    
    [self configUI];
    
}
@end
