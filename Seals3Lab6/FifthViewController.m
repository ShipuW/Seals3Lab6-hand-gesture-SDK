//
//  FifthViewController.m
//  Seals3Lab6
//
//  Created by Veight Zhou on 8/5/15.
//  Copyright (c) 2015 Veight Zhou. All rights reserved.
//

#import "FifthViewController.h"
#import "Aspects.h"
#import "TBGestureEventManagerViewController.h"
#import "TBDataManager.h"
#import "MacroUtils.h"
#import "TBAllGesturesViewController.h"
#import "TBCellViewModel.h"
#import "TBJoinGestureSimulationViewController.h"
#import "TBTableViewSimulationViewController.h"
#import "TBGesture.h"

static NSString *const kTableViewCellIdentifier = @"kTableViewCellIdentifier";

@interface FifthViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *cellsList;
@end

@implementation FifthViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.tableView = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStyleGrouped];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView.contentInset = UIEdgeInsetsMake(64, 0, 44, 0);
    self.hidesBottomBarWhenPushed = YES;
    
    @weakify(self);

    TBCellViewModel *vm0 = [[TBCellViewModel alloc] init];
    vm0.text = @"事件管理";
    vm0.didSelectAction = ^{
        @strongify(self);
        TBGestureEventManagerViewController *vc = [[TBGestureEventManagerViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    };

    TBCellViewModel *vm1 = [[TBCellViewModel alloc] init];
    vm1.text = @"模拟接入";
    vm1.didSelectAction = ^{
        @strongify(self);
        TBJoinGestureSimulationViewController *vc = [[TBJoinGestureSimulationViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    };

    TBCellViewModel *vm2 = [[TBCellViewModel alloc] init];
    vm2.text = @"所有手势";
    vm2.didSelectAction = ^{
        @strongify(self);
        TBAllGesturesViewController *vc = [[TBAllGesturesViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    };

    TBCellViewModel *vm3 = [[TBCellViewModel alloc] init];
    vm3.text = @"本地写入自定义手势";
    vm3.didSelectAction = ^{
        @strongify(self);

        [SharedDataManager loadLocalGestureTemplets:^(NSArray *results, NSError *error) {
            TBGesture *gesture = results[0];
            [SharedDataManager addCustomGesture:gesture completion:^(TBGesture *gesture, NSError *error) {
                if (error) {
                    debugLog(@"%@", error);
                } else {
                    debugLog(@"写入成功");
                }
            }];
        }];
    };

    
    TBCellViewModel *vm4 = [[TBCellViewModel alloc] init];
    vm4.text = @"TableView模拟接入";
    vm4.didSelectAction = ^{
        @strongify(self);
        TBTableViewSimulationViewController *vc = [[TBTableViewSimulationViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
        
    };
    
    self.cellsList = @[
            vm0,
            vm1,
            vm2,
            vm3,
            vm4,
    ];
    
    
    [SharedDataManager loadAllEventsFromDatabase:^(NSArray *results, NSError *error) {
        debugLog(@"%@", results);
    }];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


- (void)buttonAction:(id)sender {
    NSLog(@"action.");
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.cellsList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = indexPath.row;

    UITableViewCell *cell = nil;
    cell = [tableView dequeueReusableCellWithIdentifier:kTableViewCellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kTableViewCellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }

    TBCellViewModel *vm = self.cellsList[row];
    cell.textLabel.text = vm.text;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSInteger row = indexPath.row;
    TBCellViewModel *vm = self.cellsList[row];
    !vm.didSelectAction ?: vm.didSelectAction();
}


@end
