//
//  TestShowViewController.m
//  Seals3Lab6
//
//  Created by Veight Zhou on 8/13/15.
//  Copyright (c) 2015 Veight Zhou. All rights reserved.
//

#import "TestShowViewController.h"
#import "OneOneViewController.h"
#import "OneMoreViewController.h"

static NSString *const kI = @"kI";

@interface TestShowViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *titles;
@end

@implementation TestShowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStyleGrouped];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    self.titles = @[@"单视图单事件 - 收藏", @"单视图多事件", @"复用视图"];
    self.hidesBottomBarWhenPushed = YES;
    [self.view addSubview:self.tableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kI];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kI];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *s = self.titles[indexPath.row];
    cell.textLabel.text = s;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.titles.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//     self.titles = @[@"单视图单事件 - 收藏", @"单视图多事件", @"复用视图"];
    NSInteger row = indexPath.row;
    if (row == 0) {
        OneOneViewController *vc = [[OneOneViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    if (row == 1) {
        OneMoreViewController *vc = [[OneMoreViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    if (row == 2) {
        
    }
//    if (row == 0) {
//        
//    }
    
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
