//
//  LTSCalendarScrollView.m
//  LTSCalendar
//
//  Created by 李棠松 on 2018/1/13.
//  Copyright © 2018年 leetangsong. All rights reserved.
//

#import "LTSCalendarScrollView.h"
#import "ClassCell.h"
#import "CollectionViewHeaderView.h"
#import "FootGoodsModel.h"
#import "FootHearModel.h"
#import <MJExtension.h>
#import "FootCollectionReusableView.h"
#define CellIdentifier @"CellIdentifier"
@interface LTSCalendarScrollView()<UICollectionViewDelegate,UICollectionViewDataSource,FootCellDelegate,CollectionViewHeaderViewDelegate>
{
    BOOL status;//yes 编辑状态  no取消编辑
    CGFloat * apl;
}
@property (nonatomic,strong)UIView *line;
@property (nonatomic,strong) UICollectionViewFlowLayout * flowLayout;
@property (nonatomic , strong) UIButton * deleteBtn;

@end
@implementation LTSCalendarScrollView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self == [super initWithFrame:frame]) {
        [self initUI];
        apl=0;
        status = NO;
        //注册通知：
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(footEdit:) name:@"footEdit" object:nil];
    }
    return self;
}
- (void)setBgColor:(UIColor *)bgColor{
    _bgColor = bgColor;
    self.backgroundColor = bgColor;
//    self.tableView.backgroundColor = bgColor;
    self.line.backgroundColor = bgColor;
}

- (void)initUI{
    
    self.delegate = self;
    self.bounces = false;
    self.showsVerticalScrollIndicator = false;
    self.backgroundColor = [LTSCalendarAppearance share].scrollBgcolor;
    LTSCalendarContentView *calendarView = [[LTSCalendarContentView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, [LTSCalendarAppearance share].weekDayHeight*[LTSCalendarAppearance share].weeksToDisplay)];
    calendarView.currentDate = [NSDate date];
    [self addSubview:calendarView];
    self.calendarView = calendarView;
    
        self.line = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(calendarView.frame), CGRectGetWidth(self.frame),0.5)];
    
    self.flowLayout = [[UICollectionViewFlowLayout alloc]init];
    self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(calendarView.frame), CGRectGetWidth(self.frame), CGRectGetHeight(self.frame)-CGRectGetMaxY(calendarView.frame)) collectionViewLayout:self.flowLayout];
    self.flowLayout.minimumLineSpacing = 0;
    self.flowLayout.minimumInteritemSpacing = 0;
//    self.flowLayout.footerReferenceSize = CGSizeMake(0, 50);
    if (@available(iOS 9.0, *)) {
        self.flowLayout.sectionHeadersPinToVisibleBounds = false;
    } else {
        // Fallback on earlier versions
    }
    
    self.flowLayout.itemSize = CGSizeMake(kScreenW/3,[Unity countcoordinatesH:200]);
    self.flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.showsVerticalScrollIndicator = NO;
    [self.collectionView registerClass:[ClassCell class] forCellWithReuseIdentifier:CellIdentifier];
    self.collectionView.backgroundColor = [Unity getColor:@"#f0f0f0"];
    [self.collectionView registerClass:[CollectionViewHeaderView class]
             forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                    withReuseIdentifier:@"CollectionViewHeaderView"];
    [self.collectionView registerClass:[FootCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"foot"];
    [self addSubview:self.collectionView];
    

    
//    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(calendarView.frame), CGRectGetWidth(self.frame), CGRectGetHeight(self.frame)-CGRectGetMaxY(calendarView.frame)-30) style:UITableViewStyleGrouped];
//    self.tableView.backgroundColor = self.backgroundColor;
//    self.tableView.delegate = self;
//    self.tableView.dataSource = self;
//    self.tableView.estimatedRowHeight = 0;
//    self.tableView.sectionHeaderHeight = 0;
//    self.tableView.estimatedSectionHeaderHeight = 0;
//    self.tableView.estimatedSectionFooterHeight = 0;
//    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
//    self.tableView.scrollEnabled = [LTSCalendarAppearance share].isShowSingleWeek;
//
//    [self addSubview:self.tableView];
    self.line.backgroundColor = self.backgroundColor;
    [self addSubview:self.line];
    [LTSCalendarAppearance share].isShowSingleWeek ? [self scrollToSingleWeek]:[self scrollToAllWeek];
    [self addSubview:self.deleteBtn];
}
#pragma mark UICollectionView
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return self.listArray.count;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return [[self.listArray[section]objectForKey:@"data"] count];//每个section有多少个cell
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    ClassCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    
    [cell configWithSection:indexPath.section IndexPath:indexPath.row IsEdit:status];
    cell.model = self.modelArrs[indexPath.section][indexPath.row];
    cell.delegate = self;
    return cell;
}

-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    NSString *reuseIdentifier;
    // header
    if ([kind isEqualToString:UICollectionElementKindSectionHeader])
    {
        reuseIdentifier = @"CollectionViewHeaderView";
        CollectionViewHeaderView *view = [collectionView dequeueReusableSupplementaryViewOfKind:kind
                                                                            withReuseIdentifier:reuseIdentifier
                                                                                   forIndexPath:indexPath];
        if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
            view.backgroundColor = [Unity getColor:@"#f0f0f0"];
            [view configWithIsEdit:status Section:indexPath.section];
            view.model = self.groupArrs[indexPath.section];
            view.delegate = self;
        }
        return view;
    }
    FootCollectionReusableView * footerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"foot" forIndexPath:indexPath];
    footerView.backgroundColor = [Unity getColor:@"#f0f0f0"];
    
    return footerView;
    
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    
    return CGSizeMake(kScreenW, [Unity countcoordinatesH:40]);
}
//footer的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    int i = self.groupArrs.count;
    if (section == i-1) {
        return CGSizeMake(kScreenW, 50);
    }
    return CGSizeMake(kScreenW, 0.1);
}
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
//    return self.listArray.count;
//}
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    return  [[self.listArray[section]objectForKey:@"data"] count];
//}
//
////cell高度
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    return [Unity countcoordinatesH:50];
//}
////section高度
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    return [Unity countcoordinatesH:30];
//}
//// 每个分区的页眉
//-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//{
//    return [self.listArray[section] objectForKey:@"days"];
//}
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//
//    UITableViewCell *cell =[UITableViewCell new];
//    cell.textLabel.text = [self.listArray[indexPath.section] objectForKey:@"data"][indexPath.row];
//
//    return cell;
//}
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//
//}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
   
    CGFloat offsetY = scrollView.contentOffset.y;
   
    
    if (scrollView != self) {
        return;
    }
    
    LTSCalendarAppearance *appearce =  [LTSCalendarAppearance share];
    ///表需要滑动的距离
    CGFloat tableCountDistance = appearce.weekDayHeight*(appearce.weeksToDisplay-1);
    ///日历需要滑动的距离
    CGFloat calendarCountDistance = self.calendarView.singleWeekOffsetY;
    CGFloat scale = calendarCountDistance/tableCountDistance;
//     NSLog(@"%lf",offsetY/tableCountDistance);
    ///更新删除按钮的位置
    if (offsetY/tableCountDistance<=0) {
        self.deleteBtn.frame = CGRectMake([Unity countcoordinatesW:10], self.calendarView.bottom+ self.height-45-300, kScreenW-[Unity countcoordinatesW:20], 40);
    }else{
        self.deleteBtn.frame = CGRectMake([Unity countcoordinatesW:10], self.calendarView.bottom+ (self.height-45-300)+(offsetY/tableCountDistance*50), kScreenW-[Unity countcoordinatesW:20], 40);
    }
    
    CGRect calendarFrame = self.calendarView.frame;
    self.calendarView.maskView.alpha = offsetY/tableCountDistance;
    self.calendarView.maskView.hidden = false;
    calendarFrame.origin.y = offsetY-offsetY*scale;
    if(ABS(offsetY) >= tableCountDistance) {
         self.collectionView.scrollEnabled = true;
        self.calendarView.maskView.hidden = true;
        //为了使滑动更加顺滑，这部操作根据 手指的操作去设置
//         [self.calendarView setSingleWeek:true];
        
    }else{
        
        self.collectionView.scrollEnabled = false;
        if ([LTSCalendarAppearance share].isShowSingleWeek) {
           
            [self.calendarView setSingleWeek:false];
        }
    }
    CGRect tableFrame = self.collectionView.frame;
    tableFrame.size.height = CGRectGetHeight(self.frame)-CGRectGetHeight(self.calendarView.frame)+offsetY;
    self.collectionView.frame = tableFrame;
    self.bounces = false;
    if (offsetY<=0) {
        self.bounces = true;
        calendarFrame.origin.y = offsetY;
        tableFrame.size.height = CGRectGetHeight(self.frame)-CGRectGetHeight(self.calendarView.frame);
        self.collectionView.frame = tableFrame;
    }
    self.calendarView.frame = calendarFrame;
    
    
    
   NSLog(@"%lf",self.collectionView.top);
}
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    LTSCalendarAppearance *appearce =  [LTSCalendarAppearance share];
    CGFloat tableCountDistance = appearce.weekDayHeight*(appearce.weeksToDisplay-1);
    if ( appearce.isShowSingleWeek) {
        if (self.contentOffset.y != tableCountDistance) {
            return  nil;
        }
    }
    if ( !appearce.isShowSingleWeek) {
        if (self.contentOffset.y != 0 ) {
            return  nil;
        }
    }

    return  [super hitTest:point withEvent:event];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    
    LTSCalendarAppearance *appearce =  [LTSCalendarAppearance share];
    CGFloat tableCountDistance = appearce.weekDayHeight*(appearce.weeksToDisplay-1);

    if (scrollView.contentOffset.y>=tableCountDistance) {
        [self.calendarView setSingleWeek:true];
    }
    
}


- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
    if (self != scrollView) {
        return;
    }
   
    LTSCalendarAppearance *appearce =  [LTSCalendarAppearance share];
    ///表需要滑动的距离
    CGFloat tableCountDistance = appearce.weekDayHeight*(appearce.weeksToDisplay-1);
    //point.y<0向上
    CGPoint point =  [scrollView.panGestureRecognizer translationInView:scrollView];
    
    if (point.y<=0) {
       
        [self scrollToSingleWeek];
    }
    
    if (scrollView.contentOffset.y<tableCountDistance-20&&point.y>0) {
        [self scrollToAllWeek];
    }
}
//手指触摸完
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    if (self != scrollView) {
        return;
    }
    LTSCalendarAppearance *appearce =  [LTSCalendarAppearance share];
    ///表需要滑动的距离
    CGFloat tableCountDistance = appearce.weekDayHeight*(appearce.weeksToDisplay-1);
    //point.y<0向上
    CGPoint point =  [scrollView.panGestureRecognizer translationInView:scrollView];
    
    
    if (point.y<=0) {
        if (scrollView.contentOffset.y>=20) {
            if (scrollView.contentOffset.y>=tableCountDistance) {
                [self.calendarView setSingleWeek:true];
            }
            [self scrollToSingleWeek];
        }else{
            [self scrollToAllWeek];
        }
    }else{
        if (scrollView.contentOffset.y<tableCountDistance-20) {
            [self scrollToAllWeek];
        }else{
            [self scrollToSingleWeek];
        }
    }
  
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
     [self.calendarView setUpVisualRegion];
}


- (void)scrollToSingleWeek{
    LTSCalendarAppearance *appearce =  [LTSCalendarAppearance share];
    ///表需要滑动的距离
    CGFloat tableCountDistance = appearce.weekDayHeight*(appearce.weeksToDisplay-1);
    [self setContentOffset:CGPointMake(0, tableCountDistance) animated:true];
    
    
}

- (void)scrollToAllWeek{
    [self setContentOffset:CGPointMake(0, 0) animated:true];
}


- (void)layoutSubviews{
    [super layoutSubviews];

    self.contentSize = CGSizeMake(0, CGRectGetHeight(self.frame)+[LTSCalendarAppearance share].weekDayHeight*([LTSCalendarAppearance share].weeksToDisplay-1));
}
- (void)withOfDelete:(NSInteger)section IndexPath:(NSInteger)indexPath{
//    [self.delegate withOfDeleteSection:section IndexPath:indexPath];
    
    //发送通知
    NSDictionary *dict = @{@"section":[NSString stringWithFormat:@"%ld",section],@"indexPath":[NSString stringWithFormat:@"%ld",indexPath]};
    [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"singleDelete" object:nil userInfo:dict]];
}
-(void)footEdit:(NSNotification *)notification
{
    //移除通知
    //    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"loadH5code" object:self];
    if ([notification.userInfo[@"key"]isEqualToString:@"1"]) {
        status = YES;
        self.deleteBtn.hidden=NO;
    }else{
        status = NO;
        self.deleteBtn.hidden=YES;
    }
    [self loadModel];
    [self.collectionView reloadData];
}
- (void)loadModel{
//    _carLists = dict[@"shoppingCar"];
    
    NSMutableArray * modelArrs = [NSMutableArray array];
    for (NSDictionary * dict in self.listArray)
    {
        NSMutableArray * modelArr = [FootGoodsModel mj_objectArrayWithKeyValuesArray:dict[@"data"]];
        
        [modelArrs addObject:modelArr];
    }
    self.modelArrs = modelArrs;
    NSMutableArray * groupArrs = [FootHearModel mj_objectArrayWithKeyValuesArray:self.listArray];
    self.groupArrs = groupArrs;
}
/**
 *  cell的代理方法
 *
 *  @param cell     cell可以拿到indexpath
 *  @param selectBt 选中按钮
 */
- (void)shoppingCellDelegate:(ClassCell *)cell WithSelectButton:(UIButton *)selectBt
{
    NSIndexPath * indexPath = [self.collectionView indexPathForCell:cell];
    NSLog(@"indexpath%@",indexPath);
    FootGoodsModel * model = self.modelArrs[indexPath.section][indexPath.row];
    NSArray * arr = self.modelArrs[indexPath.section];
    model.isSelect = !selectBt.selected;
    //在这里修改 元数据里的状态 默认0 不编辑 改成1   后期点击删除   状态为1的全删
    NSString * isS = @"0";
    NSLog(@"ifReadOnly value: %@" ,model.isSelect?@"YES":@"NO");
    if (model.isSelect) {
        isS = @"1";
    }
    NSMutableDictionary * dict = [NSMutableDictionary new];
    dict = [self.listArray[indexPath.section] mutableCopy];
    NSMutableArray * arr1 = [NSMutableArray new];
    arr1 = [[dict objectForKey:@"data"] mutableCopy];
    NSMutableDictionary * dic = [arr1[indexPath.row] mutableCopy];
    [dic setObject:isS forKey:@"isSelect"];
    [arr1 replaceObjectAtIndex:indexPath.row withObject:dic];
    [dict setObject:arr1 forKey:@"data"];
    [self.listArray replaceObjectAtIndex:indexPath.section withObject:dict];
    
/////////
    
    int counts = 0;
    for (FootGoodsModel * modelArr in arr)
    {
        if(modelArr.isSelect)
        {
            counts ++ ;
        }
    }
    FootHearModel * headerModel = self.groupArrs[indexPath.section];
    if(counts == arr.count)
    {
        headerModel.isSelect = YES;
    }else
    {
        headerModel.isSelect = NO;
    }
    
    [self isallSelectAllPrice];
    [self.collectionView reloadData];
}
/**
 *  遍历所有是否全选
 */
- (void)isallSelectAllPrice
{
    for (NSArray * arr in self.modelArrs)
    {
        for (FootGoodsModel * model in arr)
        {
            if (!model.isSelect)
            {
//                self.bottomModel.isSelect = NO;
                return;
            }else
            {
//                self.bottomModel.isSelect = YES;
            }
        }
    }
}
- (void)shoppingCarHeaderViewDelegat:(UIButton *)bt WithHeadView:(FootHearModel *)view
{
    
    bt.selected = !bt.selected;
    NSInteger indexpath = bt.tag - 1000;
    FootHearModel *headModel = self.groupArrs[indexpath];
    NSArray *allSelectArr = self.modelArrs[indexpath];
    
    NSString * isS = @"0";
    if (bt.selected) {
        isS = @"1";
    }
    NSMutableDictionary * dict = [NSMutableDictionary new];
    dict = [self.listArray[indexpath] mutableCopy];
    NSMutableArray * arr1 = [NSMutableArray new];
    arr1 = [[dict objectForKey:@"data"] mutableCopy];
    NSMutableArray * arr2 = [NSMutableArray new];
    for (int i=0; i<arr1.count; i++) {
        NSMutableDictionary * dic = [arr1[i] mutableCopy];
        [dic setObject:isS forKey:@"isSelect"];
        [arr2 addObject:dic];
    }
    [dict setObject:arr2 forKey:@"data"];
    [self.listArray replaceObjectAtIndex:indexpath withObject:dict];
    NSLog(@"修改后的数据%@",self.listArray);
    
    if(bt.selected)
    {
        for (FootGoodsModel * model in allSelectArr)
        {
            model.isSelect = YES;
            headModel.isSelect = YES;
        }
    }else
    {
        for (FootGoodsModel * model in allSelectArr)
        {
            model.isSelect = NO;
            headModel.isSelect = NO;
        }
    }
    [self isallSelectAllPrice];
    [self.collectionView reloadData];
}
- (UIButton *)deleteBtn{
    if (!_deleteBtn) {
        _deleteBtn = [[UIButton alloc]initWithFrame:CGRectMake([Unity countcoordinatesW:10], self.calendarView.bottom+ self.height-45-300, kScreenW-[Unity countcoordinatesW:20], 40)];
        [_deleteBtn addTarget:self action:@selector(deleteClick) forControlEvents:UIControlEventTouchUpInside];
        [_deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
        [_deleteBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _deleteBtn.layer.cornerRadius = 20;
        _deleteBtn.layer.masksToBounds = YES;
        _deleteBtn.backgroundColor = [Unity getColor:@"#b445c8"];
        _deleteBtn.hidden=YES;
    }
    return _deleteBtn;
}
- (void)deleteClick{
    //发送通知
    NSDictionary *dict = @{@"deleteData":self.listArray};
    [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"allDelete" object:nil userInfo:dict]];
}
@end
