//
// Created by Veight Zhou on 8/8/15.
// Copyright (c) 2015 Veight Zhou. All rights reserved.
//

#import <mach-o/loader.h>
#import "TBGestureSelectViewController.h"
#import "TBEvent.h"
#import "RLMGesture.h"
#import "RLMEvent.h"
#import "MacroUtils.h"
#import "TBCreateGesture.h"

static NSString *const kTableViewIdentifier = @"kTableViewIdentifier";
static NSString *const kTableViewCustomGestureIdentifier = @"kTableViewCustomGestureIdentifier";

@interface TBGestureSelectViewController () <UITableViewDataSource, UITableViewDelegate, TBGestureDrawDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) RLMEvent *event;
@property (nonatomic, strong) RLMResults *events;
@property (nonatomic, strong) RLMResults *gestures;

@end

@implementation TBGestureSelectViewController {

}


- (RLMEvent *)event {
    if (!_event) {
        _event = [RLMEvent objectForPrimaryKey:@(self.eventId)];
    }
    return _event;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStyleGrouped];
    [self.view addSubview:self.tableView];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView.contentInset = UIEdgeInsetsMake(64, 0, 44, 0);
    self.tableView.dataSource = self;
    self.tableView.delegate = self;

    self.events = [RLMEvent objectsWhere:@"gestureId > 0"];
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
        cell.textLabel.text = gesture.name;
    }
    if (indexPath.section == 1) {
        if (self.event.gestureId < 100) {
            cell.textLabel.text = @"点击绘制自定义手势";
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        RLMGesture *gesture = self.gestures[indexPath.row];
        int gestureId = gesture.objectId;
        RLMResults *results = [RLMEvent objectsWhere:@"gestureId = %d", gestureId];
        if (results.count) {
            RLMEvent *event = results[0];
//            debugLog(@"和事件%@的手势冲突", event.name);
            if (event.objectId == self.event.objectId) {
//                NSString *warning = [NSString stringWithFormat:@"和事件%@的手势冲突", event.name];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"已经绑定啦" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                [alert show];
            } else {
                NSString *warning = [NSString stringWithFormat:@"和事件%@的手势冲突", event.name];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"冲突" message:warning delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                [alert show];
            }
            
        } else {
            RLMRealm *realm = [RLMRealm defaultRealm];
            [realm beginWriteTransaction];
            self.event.gestureId = gestureId;
            [realm commitWriteTransaction];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"绑定成功" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
            
        }
    }else {
        
        TBCreateGesture* createGesture = [[TBCreateGesture alloc] init];
        createGesture.frame = CGRectMake(10, 20, [UIScreen mainScreen].bounds.size.width-20, [UIScreen mainScreen].bounds.size.height-40);
        createGesture.backgroundColor = [UIColor whiteColor];
        createGesture.alpha = 0.9;
        createGesture.delegate = self;
        [[UIApplication sharedApplication].keyWindow addSubview:createGesture];
    }
}

- (void)gestureDidDrawAtPosition:(NSArray *)trackPoints {
    debugLog(@"%@", trackPoints);
}


- (int)randomId {
    double ts = [[NSDate date] timeIntervalSince1970];
    ts = fmod(ts, @(1000000).doubleValue);
    ts = ts * 1000;
    int objectId = @(ts).intValue;
    return objectId;
}


@end