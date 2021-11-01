//
//  LTSCalendarScrollView.h
//  LTSCalendar
//
//  Created by 李棠松 on 2018/1/13.
//  Copyright © 2018年 leetangsong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LTSCalendarContentView.h"
#import "LTSCalendarWeekDayView.h"

//@protocol  LTSCDelegate <NSObject>
//
//- (void)withOfDeleteSection:(NSInteger)section IndexPath:(NSInteger)indexPath;
//
//@end
@interface LTSCalendarScrollView : UIScrollView
//@property (nonatomic, strong) id<LTSCDelegate>delegate;
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic , strong) UICollectionView * collectionView;
@property (nonatomic,strong)LTSCalendarContentView *calendarView;
@property (nonatomic , strong) NSMutableArray * listArray;
@property (nonatomic,strong)UIColor *bgColor;
/**
 *  数据模型数组
 */
@property(nonatomic,strong) NSMutableArray * modelArrs;
/**
 *  组数据模型
 */
@property(nonatomic,strong) NSMutableArray * groupArrs;
- (void)scrollToSingleWeek;

- (void)scrollToAllWeek;
@end
