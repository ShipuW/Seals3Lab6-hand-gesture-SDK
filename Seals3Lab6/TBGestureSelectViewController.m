//
// Created by Veight Zhou on 8/8/15.
// Copyright (c) 2015 Veight Zhou. All rights reserved.
//

#import <mach-o/loader.h>
#import "TBGestureSelectViewController.h"
#import "TBGEvent.h"
#import "RLMGesture.h"
#import "RLMEvent.h"
#import "MacroUtils.h"
#import "TBCreateGesture.h"
#import "TBGestureRecognizer.h"
#import "RLMImage.h"

typedef NS_ENUM(NSInteger, kTableViewSection) {
    kTableViewSectionGestures = 0,
    kTableViewSectionCustomGesture,
    kTableViewSectionClear,
    kTableViewSectionCount
};

static NSString *const kTableViewIdentifier = @"kTableViewIdentifier";
static NSString *const kTableViewCustomGestureIdentifier = @"kTableViewCustomGestureIdentifier";
static NSInteger kImageViewTag = 1024;

@interface TBGestureSelectViewController () <UITableViewDataSource, UITableViewDelegate, TBGestureDrawDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) RLMEvent *event;
@property (nonatomic, strong) RLMGesture *gesture;
@property (nonatomic, strong) RLMResults *events;
@property (nonatomic, strong) RLMResults *gestures;
@property (nonatomic, strong) UIImage *capture;
@property (nonatomic, strong) TBCreateGesture *cg;

@end

@implementation TBGestureSelectViewController {

}


- (UIImage *)capture {
    if (!_capture) {
        RLMImage *rlmImage = [RLMImage objectForPrimaryKey:@(self.gesture.objectId)];
        _capture = [UIImage imageWithData:rlmImage.imageData];
    }
    return _capture;
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
    return kTableViewSectionCount;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    kTableViewSection tableViewSection = section;
    switch (tableViewSection) {
        case kTableViewSectionGestures: {
            return self.gestures.count;
            break;
        }
        case kTableViewSectionCustomGesture: {
            return 1;
            break;
        }
        case kTableViewSectionClear: {
            return 1;
            break;
        }
        case kTableViewSectionCount: {
            return 1;
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    kTableViewSection section = indexPath.section;

    if (section == kTableViewSectionGestures) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kTableViewIdentifier];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:kTableViewIdentifier];
        }
        return cell;
    }
    
    if (section == kTableViewSectionCustomGesture) {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kTableViewCustomGestureIdentifier];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kTableViewCustomGestureIdentifier];
            }
            return cell;
    }
    
    if (section == kTableViewSectionClear) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kTableViewIdentifier];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kTableViewIdentifier];
        }
        return cell;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == kTableViewSectionGestures) {
        RLMGesture *gesture = self.gestures[indexPath.row];
        cell.textLabel.text = gesture.name;
    }
    if (indexPath.section == kTableViewSectionCustomGesture) {
        if (self.event.gestureId < TBGestureTypeCustom) {
            cell.textLabel.text = @"点击绘制自定义手势";
            UIImageView *iv = (UIImageView *)[cell.contentView viewWithTag:kImageViewTag];
            [iv removeFromSuperview];
        } else {
            CGRect frame = CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds), CGRectGetWidth([UIScreen mainScreen].bounds));
            UIImageView *iv = (UIImageView *)[cell.contentView viewWithTag:kImageViewTag];
            if (!iv) {
                iv = [[UIImageView alloc] initWithFrame:frame];
            }
            iv.tag = kImageViewTag;
//            iv.backgroundColor = [UIColor greenColor];
            if (self.capture) {
                iv.image = self.capture;
            }
            cell.textLabel.text = @"";
            [cell.contentView addSubview:iv];
        }
    }
    if (indexPath.section == kTableViewSectionClear) {
        cell.textLabel.text = @"解除手势";
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    kTableViewSection section = indexPath.section;
    if (section == kTableViewSectionGestures) {
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
            alert = nil;
            [self.navigationController popViewControllerAnimated:YES];
        }
    }

    if (section == kTableViewSectionCustomGesture) {
//        if (self.gesture.type == TBGestureTypeCustom) {
//            return;
//        }
        TBCreateGesture* createGesture = [[TBCreateGesture alloc] init];
//        createGesture.frame = CGRectMake(10, 20, [UIScreen mainScreen].bounds.size.width-20, [UIScreen mainScreen].bounds.size.height-40);
        createGesture.frame = CGRectMake(0, 20, CGRectGetWidth([UIScreen mainScreen].bounds), CGRectGetWidth([UIScreen mainScreen].bounds));
//        createGesture.center = self.view.center;
        createGesture.backgroundColor = [UIColor whiteColor];
        createGesture.alpha = 0.9;
        createGesture.delegate = self;
        self.cg = createGesture;
        [[UIApplication sharedApplication].keyWindow addSubview:createGesture];
    }

    if (section == kTableViewSectionClear) {
        UIAlertView *av;
        if (self.gesture.type == TBGestureTypeCustom) {
            RLMRealm *realm = [RLMRealm defaultRealm];
            [realm beginWriteTransaction];
            [realm deleteObject:self.gesture];
            self.event.gestureId = 0;
            [realm commitWriteTransaction];
            av = [[UIAlertView alloc] initWithTitle:@"解绑自定义手势成功" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [av show];
//            [self.tableView reloadData];
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            if (self.gesture.type > 0) {
                RLMRealm *realm = [RLMRealm defaultRealm];
                [realm beginWriteTransaction];
                self.event.gestureId = 0;
                [realm commitWriteTransaction];
                [self.navigationController popViewControllerAnimated:YES];
//                [self.tableView reloadData];
            } else {
                [[[UIAlertView alloc] initWithTitle:@"没绑啥" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
            }
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == kTableViewSectionCustomGesture) {
        if (self.gesture.type == TBGestureTypeCustom) {
            return CGRectGetWidth([UIScreen mainScreen].bounds);
        }
    }
    return 44;
}
- (void)gestureDidDrawAtPosition:(NSArray *)trackPoints {
    debugLog(@"%@", trackPoints);
    RLMArray *ra = [[RLMArray alloc] initWithObjectClassName:@"RLMPoint"];
   // RLMArray *racopy =[[RLMArray alloc] initWithObjectClassName:@"RLMPoint"];
    [ra addObjects:trackPoints];
    //[racopy addObjects:trackPoints];
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
                self.gesture = g;  //
                RLMRealm *realm = [RLMRealm defaultRealm];
                [realm beginWriteTransaction];
                [realm addObject:g];
                self.event.gestureId = g.objectId;
                [realm commitWriteTransaction];
            }
            NSString *warning = [NSString stringWithFormat:@"绑定自定义手势成功"];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:warning message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
            alert = nil;
            self.capture = self.cg.capture;
            self.cg = nil;
            
            RLMImage *rlmImage = [RLMImage objectForPrimaryKey:@(self.gesture.objectId)];
            if (!rlmImage) {
                rlmImage = [[RLMImage alloc] init];
                rlmImage.gestureId = self.gesture.objectId;
            }
            
            if (self.capture) {
//                rlmImage.imageData = UIImagePNGRepresentation(self.capture);
                RLMRealm *realm = [RLMRealm defaultRealm];
                [realm beginWriteTransaction];
                rlmImage.imageData = UIImagePNGRepresentation(self.capture);
                [realm addOrUpdateObject:rlmImage];
                [realm commitWriteTransaction];
            }
            
            
            [self.tableView reloadData];
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