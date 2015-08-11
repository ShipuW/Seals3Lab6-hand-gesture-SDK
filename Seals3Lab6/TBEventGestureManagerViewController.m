//
//  TBEventGestureManagerViewController.m
//  Seals3Lab6
//
//  Created by Veight Zhou on 8/11/15.
//  Copyright (c) 2015 Veight Zhou. All rights reserved.
//

#import "TBEventGestureManagerViewController.h"
#import "RLMEvent.h"
#import "TBGestureSelectViewController.h"
static NSString *const kTableViewCellIdentifier = @"kTableViewCellIdentifier";

@interface TBEventGestureManagerViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
//@property (nonatomic, strong) NSArray *events;
@property (nonatomic, strong) RLMResults *events;
@end

@implementation TBEventGestureManagerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"管理器";
    self.events = [RLMEvent allObjects];

    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStyleGrouped];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
    self.tableView.contentInset = UIEdgeInsetsMake(64, 0, 44, 0);
}

- (void)viewWillAppear:(BOOL)animated {
    [self refreshEvents];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return section == 0 ? 1 : self.events.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kTableViewCellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:kTableViewCellIdentifier];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 1) {
        RLMEvent *event = self.events[indexPath.row];
        TBGestureSelectViewController *vc = [[TBGestureSelectViewController alloc] init];
        vc.eventId = event.objectId;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        cell.textLabel.text = @"手势开关";
        cell.detailTextLabel.text = @"";
        return;
    }

//    if (indexPath.section == 1) {
//        RLMEvent *event = self.events[indexPath.row];
//        cell.textLabel.text = event.name;
//        if (event.gesture.name.length) {
//            cell.detailTextLabel.text = event.gesture.name;
//        } else {
//            cell.detailTextLabel.text = @"暂无手势";
//        }
//        return;
//    }
}

- (void)refreshEvents {
    self.events = [RLMEvent allObjects];
    [self.tableView reloadData];
}

@end
