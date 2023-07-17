//
//  ZKPunchWeekCollectionViewCell.m
//  SSAI
//
//  Created by zhangkeqin on 2023/3/22.
//  Copyright © 2023 ZK. All rights reserved.
//

#import "ZKPunchWeekCollectionViewCell.h"
// 屏幕宽高
#define Screen_Width [UIScreen mainScreen].bounds.size.width
#define Screen_Height [UIScreen mainScreen].bounds.size.height
@implementation ZKPunchWeekCollectionViewCell

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){

    }
    return self;
}

-(void)configUI{
    self.weekLabel.frame = self.contentView.bounds;
    [self.contentView addSubview:self.weekLabel];
}

-(UILabel *)weekLabel{
    if(!_weekLabel){
        _weekLabel = [[UILabel alloc]init];
        _weekLabel.backgroundColor = [UIColor whiteColor];
        _weekLabel.textColor = [UIColor blackColor];
        _weekLabel.font = [UIFont systemFontOfSize:12];
        _weekLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _weekLabel;
}


-(void)setWeekString:(NSString *)weekString{
    _weekString = weekString;
    
    self.backgroundColor = [UIColor whiteColor];
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    self.weekLabel.text = weekString;
    
    [self configUI];
}

@end
