//
//  TBTableViewSimulationViewController.m
//  Seals3Lab6
//
//  Created by Veight Zhou on 8/10/15.
//  Copyright (c) 2015 Veight Zhou. All rights reserved.
//

#import "TBTableViewSimulationViewController.h"
#import "TBGesture.h"
#import "TBEvent.h"
#import "MacroUtils.h"
static NSString * const kTableViewIdentifier = @"kTableViewIdentifier";

@interface TBTableViewSimulationViewController () <UITableViewDataSource, UITableViewDelegate, TBGestureDelegate>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation TBTableViewSimulationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStyleGrouped];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view addSubview:self.tableView];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.contentInset = UIEdgeInsetsMake(64, 0, 44, 0);
    
    TBEvent *event = [[TBEvent alloc] initWithEventType:TBEventTypeCollect];
    TBGesture *gesture = [TBGesture gestureForEvent:event];
    
    [gesture addToTableView:self.tableView completion:^(NSError *error) {
        debugLog(@"绑定成功.");
    }];
    gesture.delegate = self;
    
    
//    [gesture addToTableView:self.tableView forKeyPath:@"contentView" completion:^(NSError *error) {
//        
//    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kTableViewIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kTableViewIdentifier];
    }
    
    cell.textLabel.text = @(indexPath.row).stringValue;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)tableView:(UITableView *)tableView gesture:(TBGesture *)gesture forEvent:(TBEvent *)event atIndexPath:(NSIndexPath *)indexPath {
    debugLog(@"手势被触发");
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
