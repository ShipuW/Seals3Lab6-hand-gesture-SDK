//
//  MoreOneViewController.m
//  Seals3Lab6
//
//  Created by Veight Zhou on 8/13/15.
//  Copyright (c) 2015 Veight Zhou. All rights reserved.
//

#import "MoreOneViewController.h"

#import "TBGesture.h"

@interface MoreOneViewController () <TBGestureDelegate, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation MoreOneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.hidesBottomBarWhenPushed= YES;
    
    self.tableView = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStyleGrouped];
    [self.view addSubview:self.tableView];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView.contentInset = UIEdgeInsetsMake(64, 0, 44, 0);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
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
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)recogizedEvent:(TBGEvent *)event {
    NSString *eventName = [NSString stringWithFormat:@"%@ 手势被识别", event.name];
    [[[UIAlertView alloc] initWithTitle:@"回调被触发" message:eventName delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
}
- (void)tableView:(UITableView *)tableView gesture:(TBGesture *)gesture forEvent:(TBGEvent *)event atIndexPath:(NSIndexPath *)indexPath {
    NSString *s = [NSString stringWithFormat:@"%@事件对应手势被识别,对应第%ld行", event.name, (long)indexPath.row];
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:s message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [av show];
    av = nil;
}


@end
