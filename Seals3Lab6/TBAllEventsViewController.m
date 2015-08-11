//
//  TBAllEventsViewController.m
//  Seals3Lab6
//
//  Created by Veight Zhou on 8/10/15.
//  Copyright (c) 2015 Veight Zhou. All rights reserved.
//

#import "TBAllEventsViewController.h"
#import "TBDataManager.h"
#import "TBEvent.h"
#import "MacroUtils.h"
static NSString * const kTableViewIdentifer = @"kTableViewIdentifer";

@interface TBAllEventsViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *eventsList;

@end

@implementation TBAllEventsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStyleGrouped];
    [self.view addSubview:self.tableView];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView.contentInset = UIEdgeInsetsMake(64, 0, 44, 0);
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    @weakify(self);
    [SharedDataManager loadAllEventsFromDatabase:^(NSArray *results, NSError *error) {
        @strongify(self);
        if (!error) {
            self.eventsList = results;
            [self.tableView reloadData];
        }
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.eventsList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kTableViewIdentifer];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kTableViewIdentifer];
    }
    TBEvent *event = self.eventsList[indexPath.row];
    cell.textLabel.text = event.name;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    TBEvent *event = self.eventsList[indexPath.row];
    [SharedDataManager fetchGestureWithEvent:event completion:^(TBGesture *gesture) {
        if (gesture) {
            debugLog(@"map %@", gesture.name);
        } else {
            debugLog(@"%@事件没有对应的手势", event.name);
        }
    }];
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
