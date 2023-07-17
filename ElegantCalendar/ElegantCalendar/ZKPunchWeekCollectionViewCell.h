//
//  ZKPunchWeekCollectionViewCell.h
//  SSAI
//
//  Created by zhangkeqin on 2023/3/22.
//  Copyright © 2023 ZK. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZKPunchWeekCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) UILabel *weekLabel;

@property (nonatomic, copy) NSString *weekString;
@end

NS_ASSUME_NONNULL_END
