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
#import "TBEvent.h"
#import "TBGesture.h"
#import "TBDataManager.h"

@interface FYAddEventCtroller ()<FYCreateGestureDelegate>
@property(nonatomic,strong) NSMutableArray* guestArray;

@end

@implementation FYAddEventCtroller

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
    NSArray* array = [[[TBEvent alloc] init] canSelectedGestures];
    for (TBGesture*gesture in array) {
        [self.guestArray addObject:gesture];
    }
    [self.tableView reloadData];
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
    UISwitch* switchButton = [[UISwitch alloc] init];
    cell.accessoryView = switchButton;

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
-(void)createGestureDidFinishedDrawPath
{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
