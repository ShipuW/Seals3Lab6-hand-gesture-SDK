//
//  FYGestureController.m
//  TBCreateGusture
//
//  Created by feiyangzhang on 15/8/10.
//  Copyright (c) 2015年 feiyangzhang. All rights reserved.
//

#import "FYAddEventCtroller.h"
#import "FYCreateGesture.h"

@interface FYAddEventCtroller ()
@property(nonatomic,strong) NSMutableArray* guestArray;
@property(nonatomic,strong) FYCreateGesture* createGesture;

@end

@implementation FYAddEventCtroller

-(NSMutableArray *)guestArray
{
    if (_guestArray == nil) {
        _guestArray = [NSMutableArray array];
        [_guestArray addObjectsFromArray:@[@"默认手势1",@"默认手势2",@"默认手势3",@"自定义"]];
    }
    return _guestArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"创建新手势";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.guestArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* ID = @"event";
    UITableViewCell* cell = [tableView dequeueReusableHeaderFooterViewWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] init];
    }
    cell.textLabel.text = self.guestArray[indexPath.row];
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 3) {
    FYCreateGesture* createGesture = [[FYCreateGesture alloc] init];
    createGesture.frame = CGRectMake(10, 20, [UIScreen mainScreen].bounds.size.width-20, [UIScreen mainScreen].bounds.size.height-40);
    createGesture.backgroundColor = [UIColor whiteColor];
    createGesture.alpha = 0.9;
    self.createGesture = createGesture;
    
    [[UIApplication sharedApplication].keyWindow addSubview:createGesture];
    }

}
@end
