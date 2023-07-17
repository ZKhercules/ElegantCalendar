//
//  ZKPunchCalendarMonthCollectionViewCell.m
//  PalmBeiT
//
//  Created by zhangkeqin on 2023/7/12.
//  Copyright © 2023 ZK. All rights reserved.
//

#import "ZKPunchCalendarMonthCollectionViewCell.h"
#import "ZKPunchCalendarCollectionViewCell.h"//日
// 屏幕宽高
#define Screen_Width [UIScreen mainScreen].bounds.size.width
#define Screen_Height [UIScreen mainScreen].bounds.size.height

#define iPhoneX \
({BOOL isPhoneX = NO;\
if (@available(iOS 11.0, *)) {\
isPhoneX = [[UIApplication sharedApplication] delegate].window.safeAreaInsets.bottom > 0.0;\
}\
(isPhoneX);})

// 判断是否是ipad
#define isIPad ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)

#pragma mark - 比例计算
#define pixelValue(number) (isIPad ? (number) / 2048.0 * Screen_Height : (iPhoneX ? (number) / 750.0 * Screen_Width : (number) / 1334.0 * Screen_Height))

@interface ZKPunchCalendarMonthCollectionViewCell()<UICollectionViewDelegate,UICollectionViewDataSource>

@end

@implementation ZKPunchCalendarMonthCollectionViewCell

-(void)configUI{
    self.dayCollectionView.frame = CGRectMake(0, 0, Screen_Width, self.contentView.frame.size.height);
    [self.contentView addSubview:self.dayCollectionView];
 
}

- (UICollectionViewFlowLayout *)dayFlowLayout{
    if (!_dayFlowLayout) {
        _dayFlowLayout = [[UICollectionViewFlowLayout alloc] init];
        _dayFlowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _dayFlowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    }
    return _dayFlowLayout;
}

- (UICollectionView *)dayCollectionView{
    if (!_dayCollectionView) {
        _dayCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0,0,0,0) collectionViewLayout:self.dayFlowLayout];
        _dayCollectionView.showsHorizontalScrollIndicator = NO;
        _dayCollectionView.showsVerticalScrollIndicator = NO;
        _dayCollectionView.delegate = self;
        _dayCollectionView.dataSource = self;
        _dayCollectionView.backgroundColor = [UIColor whiteColor];
        _dayCollectionView.alwaysBounceVertical = YES;
        [_dayCollectionView registerClass:[ZKPunchCalendarCollectionViewCell class] forCellWithReuseIdentifier:@"ZKPunchCalendarCollectionViewCell"];
        _dayCollectionView.scrollEnabled = NO;
    }
    return _dayCollectionView;
}

#pragma mark - UICollectionDelegate & dataSource
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dayArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ZKPunchCalendarCollectionViewCell *cell = [[ZKPunchCalendarCollectionViewCell alloc]init];
    cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ZKPunchCalendarCollectionViewCell" forIndexPath:indexPath];
    cell.cellDict = self.dayArray[indexPath.row];
    cell.dayLabel.backgroundColor = [UIColor whiteColor];
    cell.dayLabel.textColor = [UIColor blackColor];
    return cell;
    
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(Screen_Width / 7 , 50);
    
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{

}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 0;//行间距
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}

-(void)setDayArray:(NSArray *)dayArray{
    _dayArray = dayArray;
    [self configUI];
    [self.dayCollectionView reloadData];
}
@end
