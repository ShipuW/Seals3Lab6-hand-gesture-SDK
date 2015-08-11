//
// Created by Veight Zhou on 8/8/15.
// Copyright (c) 2015 Veight Zhou. All rights reserved.
//

#import <mach-o/loader.h>
#import "TBGestureSelectViewController.h"
#import "TBEvent.h"
#import "RLMGesture.h"
#import "RLMEvent.h"

static NSString *const kTableViewIdentifier = @"kTableViewIdentifier";
static NSString *const kTableViewCustomGestureIdentifier = @"kTableViewCustomGestureIdentifier";

@interface TBGestureSelectViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) RLMResults *events;
@property (nonatomic, strong) RLMResults *gestures;

@end

@implementation TBGestureSelectViewController {

}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStyleGrouped];
    [self.view addSubview:self.tableView];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView.contentInset = UIEdgeInsetsMake(64, 0, 44, 0);
    self.tableView.dataSource = self;
    self.tableView.delegate = self;

    self.events = [RLMEvent allObjects];
    self.gestures = [RLMGesture objectsWhere:@"objectId > 0"];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 1) {
        return 1;
    }
    return self.gestures.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;

    if (section == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kTableViewIdentifier];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:kTableViewIdentifier];
        }
        return cell;
    } else {
//        if (section == 1) {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kTableViewCustomGestureIdentifier];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kTableViewCustomGestureIdentifier];
            }
        return cell;
//        }
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        RLMGesture *gesture = self.gestures[indexPath.row];
//        cell.textLabel.text = gesture.name;
    }
}

@end