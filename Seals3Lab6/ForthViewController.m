//
//  ForthViewController.m
//  Seals3Lab6
//
//  Created by Veight Zhou on 8/5/15.
//  Copyright (c) 2015 Veight Zhou. All rights reserved.
//

#import "ForthViewController.h"
#import "Aspects.h"
#import "TBGesture.h"
#import "TBTestTableViewCell.h"
#import "TBIndexPathCellModel.h"
#import "TBIndexPathCellModelArray.h"
#import "TBHookOperation.h"
#import "TBGesture.h"
#import "TBEvent.h"

@interface ForthViewController ()<UITableViewDataSource,UITableViewDelegate, TBGestureDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property(nonatomic, strong) NSArray *indexPathAndCells;

@end

@implementation ForthViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.tableView.dataSource = self;
    self.tableView.delegate = self;

    TBGesture *gesture = [[TBGesture alloc] initWithEventNames:@[@"收藏"]];
//    gesture.objectId=@"1";
//    gesture.name=@"name1";

    gesture.delegate = self;

    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView.frame = [UIScreen mainScreen].bounds;
    self.tableView.contentInset = UIEdgeInsetsMake(64, 0, 44, 0);

//    [TBHookOperation hookDataSource:self withTableView:self.tableView withGesture:gesture forKeyPath:@"textLabel"];


}

#pragma TBGestureDelegate方法
- (void)tableView:(UITableView *)tableView gesture:(TBGesture *)gesture forEvent:(TBEvent *)event atIndexPath:(NSIndexPath *)indexPath {

    
    NSString *s = [NSString stringWithFormat:@"%@事件对应手势被识别,对应第%d行", event.name, indexPath.row];
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:s message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [av show];
}

- (void)recogizedEvent:(TBEvent *)event {
    //    NSLog(@"%@", event.name);
    NSString *s = [NSString stringWithFormat:@"%@事件对应手势被识别", event.name];
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:s message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [av show];

}

#pragma tableView数据源方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 20;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

//    TBTestTableViewCell *cell = [TBTestTableViewCell initWithTableView:tableView];

//    TBEvent *event = [[TBEvent alloc] initWithEventType:TBEventTypeCollect];

    static NSString *ID=@"test";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell==nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%ld",(long)indexPath.row];

    TBGesture *gesture = [[TBGesture alloc] initWithEventNames:@[@"收藏", @"分享"]];
    gesture.delegate = self;
    gesture.tableView = tableView;
    [gesture addToView:cell completion:nil];
//
//    [gesture addToTableView:tableView dataSource:self completion:^(NSError *error) {
//
//    }];

    return cell;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{

}

-(void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section {

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    if (indexPath.row==5) {
//        TBIndexPathCellModelArray *array = [TBIndexPathCellModelArray sharedManager];
//        NSLog(@"count=%lu",(unsigned long)array.modelArray.count);
//
//        for (TBIndexPathCellModel *model in array.modelArray) {
//            NSLog(@"cell=%@,,indexpath=%@",model.cell,model.indexPath);
//            for (UIView *view in model.subViews) {
//                NSLog(@"view=%@",view);
//            }
//        }
//    }

}

@end
