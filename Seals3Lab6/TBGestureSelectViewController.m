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
#import "TBGestureRecognizer.h"


//typedef NS_ENUM(<#_type#>, <#_name#>) <#new#>;

static NSString *const kTableViewIdentifier = @"kTableViewIdentifier";
static NSString *const kTableViewCustomGestureIdentifier = @"kTableViewCustomGestureIdentifier";

@interface TBGestureSelectViewController () <UITableViewDataSource, UITableViewDelegate, TBGestureDrawDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) RLMEvent *event;
@property (nonatomic, strong) RLMGesture *gesture;
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

- (RLMGesture *)gesture {
    if (!_gesture) {
        _gesture = [RLMGesture objectForPrimaryKey:@(self.event.gestureId)];
    }
    return _gesture;
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
    self.gestures = [RLMGesture objectsWhere:@"objectId > 0 AND type != %d", TBGestureTypeCustom];
    
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
            if (event.objectId == self.event.objectId) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"已经绑定啦" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                [alert show];
                [self.navigationController popViewControllerAnimated:YES];
            } else {
                NSString *warning = [NSString stringWithFormat:@"和事件%@的手势冲突", event.name];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"冲突" message:warning delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                [alert show];
            }
            
        } else {
            RLMRealm *realm = [RLMRealm defaultRealm];
            [realm beginWriteTransaction];
            if (self.event.gestureId >= TBGestureTypeCustom) {
                RLMGesture *gesture = [RLMGesture objectForPrimaryKey:@(self.event.gestureId)];
                if (gesture) {
                    [realm deleteObject:gesture];
                }
            }
            self.event.gestureId = gestureId;
            
            [realm commitWriteTransaction];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"绑定成功" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
            [self.navigationController popViewControllerAnimated:YES];
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
    RLMArray *ra = [[RLMArray alloc] initWithObjectClassName:@"RLMPoint"];
    [ra addObjects:trackPoints];
    [[TBGestureRecognizer shareGestureRecognizer] matchGestureFrom:ra GesturesToMatch:nil completion:^(NSString *matchResultId, RLMArray *resampledPoints) {
        if (!matchResultId) {
            if (self.gesture.type == TBGestureTypeCustom) {
                RLMRealm *realm = [RLMRealm defaultRealm];
                [realm beginWriteTransaction];
                self.gesture.path = (RLMArray<RLMPoint> *)resampledPoints;
                self.gesture.rawPath = (RLMArray<RLMPoint> *)ra;
//                [realm addObject:g];
//                self.event.gestureId = g.objectId;
                [realm commitWriteTransaction];
            } else {
                RLMGesture *g = [[RLMGesture alloc] init];
                g.objectId = randomId();
                g.name = @"自定义手势";
                g.type = TBGestureTypeCustom;
                g.path = (RLMArray<RLMPoint> *)resampledPoints;
                g.rawPath = (RLMArray<RLMPoint> *)ra;
                RLMRealm *realm = [RLMRealm defaultRealm];
                [realm beginWriteTransaction];
                [realm addObject:g];
                self.event.gestureId = g.objectId;
                [realm commitWriteTransaction];
            }
            NSString *warning = [NSString stringWithFormat:@"绑定自定义手势成功"];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:warning message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
            [self.navigationController popViewControllerAnimated:YES];

        } else {
            NSString *warning = [NSString stringWithFormat:@"和现有手势冲突"];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:warning message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
        }
    }];
}


int randomId() {
    double ts = [[NSDate date] timeIntervalSince1970];
    ts = fmod(ts, @(1000000).doubleValue);
    ts = ts * 1000;
    int objectId = @(ts).intValue;
    return objectId;
}


@end