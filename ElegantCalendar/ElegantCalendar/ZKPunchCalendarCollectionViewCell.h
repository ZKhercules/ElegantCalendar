//
//  ZKPunchCalendarCollectionViewCell.h
//  SSAI
//
//  Created by zhangkeqin on 2023/3/21.
//  Copyright © 2023 ZK. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZKPunchCalendarCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) UILabel *dayLabel;//日期

@property (nonatomic, strong) UIImageView *punchImageView;//打卡标识

@property (nonatomic, copy) NSDictionary *cellDict;
@end

NS_ASSUME_NONNULL_END
