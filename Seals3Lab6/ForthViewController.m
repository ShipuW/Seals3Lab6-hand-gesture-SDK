//
//  ForthViewController.m
//  Seals3Lab6
//
//  Created by Veight Zhou on 8/5/15.
//  Copyright (c) 2015 Veight Zhou. All rights reserved.
//

#import "ForthViewController.h"
#import "Aspects.h"
#import "TBGesture.h"
#import "TBTestTableViewCell.h"
#import "TBIndexPathCellModel.h"
#import "TBIndexPathCellModelArray.h"
#import "TBHookOperation.h"

@interface ForthViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property(nonatomic, strong) NSArray *indexPathAndCells;

@end

@implementation ForthViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    TBGesture *gesture = [[TBGesture alloc]init];
    gesture.objectId=@"1";
    gesture.name=@"name1";
    
    [TBHookOperation hookDataSource:self withTableView:self.tableView withGesture:(TBGesture *)gesture forKeyPath:@"textLabel"];
    
}


#pragma tableView数据源方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 20;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TBTestTableViewCell *cell = [TBTestTableViewCell initWithTableView:tableView];
        
    TBGesture *gesture = [[TBGesture alloc]init];
    [gesture setName:[NSString stringWithFormat:@"test--%ld",indexPath.row]];
    [gesture setObjectId:[NSString stringWithFormat:@"%ld",indexPath.row]];
    [gesture setType:TBGestureTypeCustom];
    
    [cell setGesture:gesture];

//    static NSString *ID=@"test";
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
//    if (cell==nil) {
//        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
//    }
//    cell.textLabel.text = [NSString stringWithFormat:@"text--%d",indexPath.row];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

-(void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section {
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row==5) {
        TBIndexPathCellModelArray *array = [TBIndexPathCellModelArray sharedManager];
        NSLog(@"count=%lu",(unsigned long)array.modelArray.count);
    }
}



@end
