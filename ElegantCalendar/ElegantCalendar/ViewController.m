//
//  ViewController.m
//  ElegantCalendar
//
//  Created by zhangkeqin on 2023/7/14.
//

#import "ViewController.h"
#import "ZKPunchCalendarMonthCollectionViewCell.h"
#import "ZKPunchWeekCollectionViewCell.h"
// 屏幕宽高
#define Screen_Width self.view.bounds.size.width
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
@interface ViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, strong) UILabel *yearAndMonthLabel;//年月
//周
@property (nonatomic, strong)UICollectionViewFlowLayout *weekFlowLayout;

@property (nonatomic, strong) UICollectionView *weekCollectionView;

//月
@property (nonatomic, strong)UICollectionViewFlowLayout *monthFlowLayout;

@property (nonatomic, strong) UICollectionView *monthCollectionView;

@property (nonatomic, copy) NSArray *weekArray;

@property (nonatomic, copy) NSArray *monthArray;//月份数组

@property (nonatomic, assign) CGFloat monthHeight;//日历部分高度

@property (nonatomic, copy) NSMutableArray *monthHeightArray;

@property (nonatomic, assign) CGFloat offx;

@property (nonatomic, assign) int toIndex;//即将要去的index

@property (nonatomic, assign) int lastIndex;//滑动时的index

@end

@implementation ViewController

-(NSMutableArray *)monthHeightArray{
    if(!_monthHeightArray){
        _monthHeightArray = [[NSMutableArray alloc]init];
    }
    return _monthHeightArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor grayColor];
    self.weekArray = @[@"日",@"一",@"二",@"三",@"四",@"五",@"六"];
    self.offx = 0;
    [self getData];
}

-(void)configUI{
    self.yearAndMonthLabel.frame = CGRectMake(0, 64, Screen_Width, 40);
    [self.view addSubview:self.yearAndMonthLabel];
    
    self.weekCollectionView.frame = CGRectMake(0, CGRectGetMaxY(self.yearAndMonthLabel.frame), Screen_Width, 50);
    [self.view addSubview:self.weekCollectionView];
    
    self.monthCollectionView.frame = CGRectMake(0, CGRectGetMaxY(self.weekCollectionView.frame), Screen_Width, self.monthHeight);
    [self.view addSubview:self.monthCollectionView];
}

#pragma mark - 更新月度 高度
-(void)updateUI{
    //更新日历高度
    self.monthFlowLayout.itemSize = CGSizeMake(Screen_Width , self.monthHeight);
    
    self.monthCollectionView.frame = CGRectMake(0, CGRectGetMaxY(self.weekCollectionView.frame), Screen_Width, self.monthHeight);
    
    [self.monthCollectionView reloadData];;
    
}

//读取json数据
-(void)getData{
    //获取文件路径
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"ElegantCalendar" ofType:@"json"];
    //获取文件内容
    NSString *jsonStr  = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    //将文件内容转成数据
    NSData *jaonData   = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
    //将数据转成数组
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:jaonData options:NSJSONReadingMutableContainers error:nil];
    
    self.monthArray = dict[@"list"];
    
    
    
    //计算第一个需要展示的月份高度   7：一行展示的个数   50：一行的高度 可随意更改
    NSArray *currentdayArray = self.monthArray[0][@"day"];
    int rows = (int)(currentdayArray.count / 7);
    int remainder = (int)currentdayArray.count % 7;
    if(remainder) {
        rows++;
    }
    self.monthHeight = rows * 50;
    
    
    //遍历月份
    for (int i = 0; i < self.monthArray.count; i++) {
        NSArray *currentdayArray = self.monthArray[i][@"day"];
        int rows = (int)(currentdayArray.count / 7);
        int remainder = (int)currentdayArray.count % 7;
        if(remainder) {
            rows++;
        }
        [self.monthHeightArray addObject:[NSNumber numberWithInt:rows * 50]];
    }
    
    self.yearAndMonthLabel.text = [NSString stringWithFormat:@"%@",self.monthArray[0][@"month"]];
    
    [self configUI];
    
    [self.monthCollectionView reloadData];
}


//年月
-(UILabel *)yearAndMonthLabel{
    if(!_yearAndMonthLabel){
        _yearAndMonthLabel = [[UILabel alloc]init];
        _yearAndMonthLabel.backgroundColor = [UIColor whiteColor];
        _yearAndMonthLabel.font = [UIFont systemFontOfSize:16];
        _yearAndMonthLabel.textColor = [UIColor blackColor];
        _yearAndMonthLabel.textAlignment = NSTextAlignmentCenter;
        
    }
    return _yearAndMonthLabel;
}

- (UICollectionViewFlowLayout *)weekFlowLayout{
    if (!_weekFlowLayout) {
        _weekFlowLayout = [[UICollectionViewFlowLayout alloc] init];
        _weekFlowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _weekFlowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _weekFlowLayout.itemSize = CGSizeMake(Screen_Width / 7 ,50);
    }
    return _weekFlowLayout;
}

- (UICollectionView *)weekCollectionView{
    if (!_weekCollectionView) {
        _weekCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0,0,0,0) collectionViewLayout:self.weekFlowLayout];
        _weekCollectionView.showsHorizontalScrollIndicator = NO;
        _weekCollectionView.showsVerticalScrollIndicator = NO;
        _weekCollectionView.delegate = self;
        _weekCollectionView.dataSource = self;
        _weekCollectionView.backgroundColor = [UIColor whiteColor];
        _weekCollectionView.alwaysBounceVertical = YES;
        [_weekCollectionView registerClass:[ZKPunchWeekCollectionViewCell class] forCellWithReuseIdentifier:@"ZKPunchWeekCollectionViewCell"];
        _weekCollectionView.scrollEnabled = NO;
    }
    return _weekCollectionView;
}

- (UICollectionViewFlowLayout *)monthFlowLayout{
    if (!_monthFlowLayout) {
        _monthFlowLayout = [[UICollectionViewFlowLayout alloc] init];
        _monthFlowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _monthFlowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _monthFlowLayout.itemSize = CGSizeMake(Screen_Width , self.monthHeight);
        
    }
    return _monthFlowLayout;
}

- (UICollectionView *)monthCollectionView{
    if (!_monthCollectionView) {
        _monthCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0,0,0,0) collectionViewLayout:self.monthFlowLayout];
        _monthCollectionView.showsHorizontalScrollIndicator = NO;
        _monthCollectionView.showsVerticalScrollIndicator = NO;
        _monthCollectionView.delegate = self;
        _monthCollectionView.dataSource = self;
        _monthCollectionView.backgroundColor = [UIColor whiteColor];
        _monthCollectionView.alwaysBounceHorizontal = YES;
        [_monthCollectionView registerClass:[ZKPunchCalendarMonthCollectionViewCell class] forCellWithReuseIdentifier:@"ZKPunchCalendarMonthCollectionViewCell"];
        _monthCollectionView.scrollEnabled = YES;
        _monthCollectionView.pagingEnabled = YES;
        _monthCollectionView.bounces = NO;
    }
    return _monthCollectionView;
}


#pragma mark - UICollectionDelegate & dataSource
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if([collectionView isEqual:self.weekCollectionView]){
        return self.weekArray.count;
    }else{
        return self.monthArray.count;
    }
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if([collectionView isEqual:self.weekCollectionView]){
        ZKPunchWeekCollectionViewCell *cell = [[ZKPunchWeekCollectionViewCell alloc]init];
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ZKPunchWeekCollectionViewCell" forIndexPath:indexPath];
        cell.weekString = self.weekArray[indexPath.row];
        return cell;
    }else{
        ZKPunchCalendarMonthCollectionViewCell *cell = [[ZKPunchCalendarMonthCollectionViewCell alloc]init];
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ZKPunchCalendarMonthCollectionViewCell" forIndexPath:indexPath];
        cell.dayArray = self.monthArray[indexPath.row][@"day"];

        return cell;
    }
    
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

#pragma mark - 关键代码
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    //即将要去的那个月的高度
    int toMonthHeight = 0;
    //当前月的高度
    int lastMonthHeight = 0;
    
    //正在向右滑动
    if(scrollView.contentOffset.x > self.offx){
        self.offx = scrollView.contentOffset.x;
        //即将要去的那个月的index
        self.toIndex = (self.monthCollectionView.contentOffset.x + Screen_Width * 0.999) / Screen_Width;
        //当前月的index
        self.lastIndex = self.toIndex - 1;
        
        //即将要去的那个月的高度
        toMonthHeight = [self.monthHeightArray[self.toIndex] intValue];
        //当前月的高度
        lastMonthHeight = [self.monthHeightArray[self.lastIndex] intValue];
        
        //即将要去的那个月份高度 大于当前高度
        if(toMonthHeight > lastMonthHeight){
            //差值
            CGFloat between =  toMonthHeight - lastMonthHeight;
            CGFloat scale = (between / Screen_Width * (scrollView.contentOffset.x - self.lastIndex * Screen_Width));
            self.monthHeight = lastMonthHeight + scale;
            //更新高度
            [self updateUI];
        }
        
        //即将要去的那个月份高度 小于当前高度
        if(toMonthHeight < lastMonthHeight){
            //差值
            CGFloat between = lastMonthHeight - toMonthHeight;
            CGFloat scale = (between / Screen_Width * (scrollView.contentOffset.x - self.lastIndex * Screen_Width));
            self.monthHeight = lastMonthHeight - scale;
            //更新高度
            [self updateUI];
        }
        //即将要去的那个月份高度 等于当前高度 直接复制 不用更新高度
        if(toMonthHeight == lastMonthHeight){
            self.monthHeight = toMonthHeight;
        }
        NSLog(@"正在向右->滑动");
        NSLog(@"self.toIndex-------------%d",self.toIndex);
        NSLog(@"self.lastIndex-------------%d",self.lastIndex);
    }
    

    
    //正在向左滑动 由于向左滑动时 contentOffset.x 是一直在减小 所有高度值的更新要和向右滑动时取反 也就是本来需要“加”的改为“减” 然后进行运算
    if(scrollView.contentOffset.x < self.offx){
        self.offx = scrollView.contentOffset.x;
        //即将要去的那个月的index
        self.toIndex = (self.monthCollectionView.contentOffset.x - Screen_Width * 0.001) / Screen_Width;
        //当前月的index
        self.lastIndex = self.toIndex + 1;

        
        toMonthHeight = [self.monthHeightArray[self.toIndex] intValue];
        lastMonthHeight = [self.monthHeightArray[self.lastIndex] intValue];
        
        //即将要去的那个月份高度 大于当前高度
        if(toMonthHeight > lastMonthHeight){
            //差值
            CGFloat between =  toMonthHeight - lastMonthHeight;
            CGFloat scale = (between / Screen_Width * (scrollView.contentOffset.x - self.lastIndex * Screen_Width));
            self.monthHeight = lastMonthHeight - scale;
            //更新高度
            [self updateUI];
        }
        
        
        //即将要去的那个月份高度 小于当前高度
        if(toMonthHeight < lastMonthHeight){
            //差值
            CGFloat between = lastMonthHeight - toMonthHeight;
            CGFloat scale = (between / Screen_Width * (scrollView.contentOffset.x - self.lastIndex * Screen_Width));
            self.monthHeight = lastMonthHeight + scale;
            //更新高度
            [self updateUI];
        }
        
        //即将要去的那个月份高度 等于当前高度 直接复制 不用更新高度
        if(toMonthHeight == lastMonthHeight){
            self.monthHeight = toMonthHeight;
        }
        NSLog(@"正在向左<-滑动");
        NSLog(@"self.toIndex-------------%d",self.toIndex);
        NSLog(@"self.lastIndex-------------%d",self.lastIndex);
    }


}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    //最后滚动停止时 判断当前停在了几月
   int endIndex = (self.monthCollectionView.contentOffset.x + Screen_Width * 0.5) / Screen_Width;
    //更新年月
    self.yearAndMonthLabel.text = [NSString stringWithFormat:@"%@",self.monthArray[endIndex][@"month"]];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if(!decelerate){
        //最后滚动停止时 判断当前停在了几月
       int endIndex = (self.monthCollectionView.contentOffset.x + Screen_Width * 0.5) / Screen_Width;
        //更新年月
        self.yearAndMonthLabel.text = [NSString stringWithFormat:@"%@",self.monthArray[endIndex][@"month"]];
    }
}
@end
