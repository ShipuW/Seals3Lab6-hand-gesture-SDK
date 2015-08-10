//
//  FYViewController.m
//  TBCreateGusture
//
//  Created by feiyangzhang on 15/8/10.
//  Copyright (c) 2015年 feiyangzhang. All rights reserved.
//

#import "FYMainController.h"
#import "FYEventData.h"
#import "FYCreateGesture.h"
#import "FYCell.h"
#import "FYAddEventCtroller.h"
#import "TBEvent.h"
#import "TBDataManager.h"
#import "MacroUtils.h"
@interface FYMainController()<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,weak) UITableView* tableView;
@property(nonatomic,strong) NSMutableArray* eventArray;
@property(nonatomic,weak) UISwitch* switchButton;
@property(nonatomic,weak) UILabel* label;
@property(nonatomic,weak) UIView* footView;

@end

@implementation FYMainController

-(NSMutableArray *)eventArray
{
    if (_eventArray == nil) {
        _eventArray = [NSMutableArray array];
    }
    return _eventArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"设置手势";
    UIBarButtonItem* addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addGesture)];
    self.navigationItem.rightBarButtonItem = addButton;
    
    //添加headView
    [self addHeadView];
    
    //添加tableView
    CGFloat tableX = 0;
    CGFloat tableY = 50+64;
    CGFloat tableW = self.view.frame.size.width;
    CGFloat tableH = self.view.frame.size.height-tableY;
    UITableView* tableView = [[UITableView alloc] initWithFrame:CGRectMake(tableX, tableY, tableW, tableH)];
    self.tableView = tableView;
    
    [self setExtraCellLineHidden:tableView]; //隐藏不显示数据分割线
    
    tableView.delegate = self;
    tableView.dataSource = self;
    
    @weakify(self);
    [SharedDataManager loadAllEventsFromDatabase:^(NSArray *results, NSError *error) {
        @strongify(self);
        for (TBEvent*event in results) {
            FYEventData* data = [[FYEventData alloc] init];
            data.event = event;
            [self.eventArray addObject:data];
        }
        [self.tableView reloadData];
        
    }];
    
    [self.view addSubview:tableView];
}
-(void)addHeadView
{
    UIView* headView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, 50)];
    headView.backgroundColor = [UIColor lightGrayColor];
    
    //创建手势
    UISwitch* switchButton = [[UISwitch alloc] init];
    [switchButton setOn:YES];//默认手势开启
    self.switchButton = switchButton;
    [switchButton addTarget:self action:@selector(shutDown) forControlEvents:UIControlEventValueChanged];
    
    CGFloat w = 40;
    CGFloat h = 30;
    CGFloat x = self.view.frame.size.width-w-10;
    CGFloat y=5;
    switchButton.frame = CGRectMake(x, y, w, h);
    [headView addSubview:switchButton];
    
    UILabel* label =[[UILabel alloc] init];
    label.text = @"开启手势";
    label.frame = CGRectMake(5, 5, 100, 30);
    [headView addSubview:label];
    
    [self.view addSubview:headView];
}
/**
 *  添加一个手势列表
 */
-(void)addGesture
{
    FYAddEventCtroller* ctl = [[FYAddEventCtroller alloc] init];
    [self.navigationController pushViewController:ctl animated:YES];
}
/**
 *  隐藏不显示数据分割线
 */
- (void)setExtraCellLineHidden: (UITableView *)tableView

{
    
    UIView *view = [UIView new];
    
    view.backgroundColor = [UIColor clearColor];
    
    [tableView setTableFooterView:view];
    
}

#pragma mark - Table view data source

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"%lu",(unsigned long)self.eventArray.count);
    return self.eventArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FYEventData* data = self.eventArray[indexPath.row];
    //创建cell
    FYCell* cell = [FYCell cellWithTableView:tableView];
    //赋值
    cell.data = data;
    //返回
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}
-(void)shutDown
{
//    if (self.switchButton.isOn) {//开启手势
//        if (self.eventArray.count == 0) {
//            self.eventArray  = nil;
//        }
//    }else{//关闭手势
//        [self.eventArray removeAllObjects];
//        [self.tableView reloadData];
//    }

}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //调出绘画视图
    FYCreateGesture* drawView = [[FYCreateGesture alloc] init];
    //传入事件和事件ID
    drawView.eventData = self.eventArray[indexPath.row];
    drawView.objectId = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
    
    drawView.frame = CGRectMake(10, 20, [UIScreen mainScreen].bounds.size.width-20, [UIScreen mainScreen].bounds.size.height-40);
    drawView.backgroundColor = [UIColor whiteColor];
    drawView.alpha = 0.9;
    [[UIApplication sharedApplication].keyWindow addSubview:drawView];
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //1、修改数据模型
        [self.eventArray removeObjectAtIndex:indexPath.row];
        //2、重新加载数据
        [self.tableView reloadData];
    }
}

@end
