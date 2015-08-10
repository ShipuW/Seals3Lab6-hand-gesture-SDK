//
//  TBAllGesturesViewController.m
//  Seals3Lab6
//
//  Created by Veight Zhou on 8/9/15.
//  Copyright (c) 2015 Veight Zhou. All rights reserved.
//

#import "TBAllGesturesViewController.h"
#import "TBDataManager.h"
#import "TBGesture.h"
#import "MacroUtils.h"

static NSString *const kTableViewIdentifier = @"kTableViewIdentifier";

@interface TBAllGesturesViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *gestures;

@end

@implementation TBAllGesturesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStyleGrouped];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView.contentInset = UIEdgeInsetsMake(64, 0, 44, 0);
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
    @weakify(self);
    [SharedDataManager loadLocalGestureTemplets:^(NSArray *results, NSError *error) {
        @strongify(self);
        self.gestures = results;
        [self.tableView reloadData];
    }];
    

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableView DataSource && Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.gestures.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    cell = [tableView dequeueReusableCellWithIdentifier:kTableViewIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kTableViewIdentifier];
    }

    TBGesture *gesture = (TBGesture *)self.gestures[indexPath.row];
    cell.textLabel.text = gesture.name;
    return cell;
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

@end
