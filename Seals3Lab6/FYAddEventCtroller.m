//
//  FYGestureController.m
//  TBCreateGusture
//
//  Created by feiyangzhang on 15/8/10.
//  Copyright (c) 2015年 feiyangzhang. All rights reserved.
//

#import "FYAddEventCtroller.h"
#import "FYCreateGesture.h"
#import "UISwitch+tag.h"
#import "TBGEvent.h"
#import "TBGesture.h"
#import "TBDataManager.h"
#import "FYEventData.h"

@interface FYAddEventCtroller ()<FYCreateGestureDelegate>
@property(nonatomic,strong) NSMutableArray* guestArray;

//默认手势开关
@property(nonatomic,strong) NSMutableArray* switchButtonArray;
@property(nonatomic,weak) UISwitch* selectedSwitchButton;

@end

@implementation FYAddEventCtroller

-(NSMutableArray *)switchButtonArray
{
    if (_switchButtonArray == nil) {
        _switchButtonArray = [NSMutableArray array];
    }
    return _switchButtonArray;
}
-(NSMutableArray *)guestArray
{
    if (_guestArray == nil) {
        _guestArray = [NSMutableArray array];
    }
    return _guestArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //加载手势数据
    [self loadcanSelectedGesture];
    
}
-(void)loadcanSelectedGesture
{
    if (self.guestArray.count>0) {
        [self.guestArray removeAllObjects];
    }
    NSArray* array = [[[TBGEvent alloc] init] canSelectedGestures];
    for (TBGesture*gesture in array) {
        [self.guestArray addObject:gesture];
    }
    [self addSwitchButton]; //switchButton的个数等于当前默认手势的个数
    
    [self.tableView reloadData];
}
-(void)addSwitchButton
{
    for (int i=0; i<self.guestArray.count; i++) {
        UISwitch* switchButton = [[UISwitch alloc] init];
        switchButton.tag = i;
        [self.switchButtonArray addObject:switchButton];
        
        [switchButton addTarget:self action:@selector(switchBuutonChanged:) forControlEvents:UIControlEventValueChanged];
    }
}
-(void)switchBuutonChanged:(UISwitch*)sender
{
    if (sender.isOn) {
        [self.selectedSwitchButton  setOn:NO animated:YES];
        self.selectedSwitchButton = sender;
        
        //展示选中的手势图片,作为用户的提示
        [self showGestureWithTag:sender.tag iamgeName:@"long_gusture"];
        self.eventData.isCustom = YES;
        
    }else{
        self.selectedSwitchButton = nil;
    }

}
-(void)showGestureWithTag:(NSInteger)tag iamgeName:(NSString*)imageName
{
    NSLog(@"showGestureWithTag");
    __block UIButton* button = [[UIButton alloc] init];
    [self.view addSubview:button];
    button.center = CGPointMake(self.view.superview.frame.size.width*0.5, self.view.superview.frame.size.height*0.5);
    [UIView animateWithDuration:1.0 animations:^{
        
        button.frame = CGRectMake(0, 0, self.view.superview.frame.size.width, self.view.superview.frame.size.height);
        button.backgroundColor = [UIColor clearColor];
        [button setTitle:@"双手捏合" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
        
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:1.0 animations:^{
            button.frame = CGRectZero;
        } completion:^(BOOL finished) {
            [button removeFromSuperview];
            button = nil;
        }];
    }];
    
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.guestArray.count+1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //创建cell
    static NSString* ID = @"event";
    UITableViewCell* cell = [tableView dequeueReusableHeaderFooterViewWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] init];
    }
    //赋值
    if (indexPath.row == self.guestArray.count) {
        cell.textLabel.text = @"自定义手势";
        return cell;
    }
    TBGesture* gesture = self.guestArray[indexPath.row];
    cell.textLabel.text = gesture.name;
    cell.accessoryView = self.switchButtonArray[indexPath.row];

    //返回
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //点击自定义手势
    if (indexPath.row == self.guestArray.count) {
        FYCreateGesture* createGesture = [[FYCreateGesture alloc] init];
        createGesture.delegate =self;
        createGesture.eventData = self.eventData;
        createGesture.frame = CGRectMake(10, 20, [UIScreen mainScreen].bounds.size.width-20, [UIScreen mainScreen].bounds.size.height-40);
        createGesture.backgroundColor = [UIColor whiteColor];
        createGesture.alpha = 0.9;
        [[UIApplication sharedApplication].keyWindow addSubview:createGesture];
    }
}

//已经画完手势，自动跳转到上一个界面
-(void)createGestureDidFinishedDrawPath
{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
