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

static NSString *const kTableViewCellIdentifier = @"kTableViewCellIdentifier";

@interface FifthViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation FifthViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    [self aspect_hookSelector:@selector(viewDidAppear:) withOptions:AspectPositionAfter usingBlock:^(id info, BOOL animated) {
//        NSLog(@"viewDidAppear:");
//    } error:nil];
//
//    [UIButton aspect_hookSelector:@selector(addTarget:action:forControlEvents:) withOptions:AspectPositionAfter usingBlock:^(id info, id target, SEL s, UIControlEvents evt) {
//        NSLog(@"%@", info);
//        NSLog(@"%@", target);
//        NSLog(@"%@", evt);
//        NSLog(@"before button action");
//    } error:nil];
//
//    UIButton *button = [[UIButton alloc] init];
//    [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];

    self.tableView = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStyleGrouped];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
    [SharedDataManager loadLocalGestureTemplets:^(NSArray *results, NSError *error) {
        if (!error) {
            debugLog(@"%@", results);
        }
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
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = indexPath.row;

    UITableViewCell *cell = nil;
    cell = [tableView dequeueReusableCellWithIdentifier:kTableViewCellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kTableViewCellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }

    if (row == 0) {
        cell.textLabel.text = @"事件管理";
    } else {
        cell.textLabel.text = @"模拟接入";
    }



    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSInteger row = indexPath.row;
    if (row == 0) {
        TBGestureEventManagerViewController *vc = [[TBGestureEventManagerViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }

}


@end
