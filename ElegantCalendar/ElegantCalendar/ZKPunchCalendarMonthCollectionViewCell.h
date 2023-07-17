//
//  ZKPunchCalendarMonthCollectionViewCell.h
//  PalmBeiT
//
//  Created by zhangkeqin on 2023/7/12.
//  Copyright © 2023 ZK. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZKPunchCalendarMonthCollectionViewCell : UICollectionViewCell
//日
@property (nonatomic, strong)UICollectionViewFlowLayout *dayFlowLayout;

@property (nonatomic, strong) UICollectionView *dayCollectionView;

@property (nonatomic, copy) NSArray *dayArray;

@end

NS_ASSUME_NONNULL_END
