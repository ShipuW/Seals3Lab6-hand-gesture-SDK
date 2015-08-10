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
    
    [self hookViewController:self withTableView:self.tableView withGesture:(TBGesture *)gesture];
    
}


//hook
-(void)hookViewController:(UIViewController *)vc withTableView:(UITableView *)tableView withGesture:(TBGesture *)gesture{
    
    [vc aspect_hookSelector:@selector(tableView:cellForRowAtIndexPath:) withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo> aspectInfo,UITableView *tableView1,NSIndexPath *path) {
        
        TBIndexPathCellModel *model = [[TBIndexPathCellModel alloc]init];
        model.indexPath = path;
        
        NSArray *cellArray = [tableView visibleCells];
        NSLog(@"cellArray.cout=%lu",(unsigned long)cellArray.count);
       
//        for (UITableViewCell *cell in cellArray) {
//            
//            NSLog(@"===============[tableView indexPathForCell:cell]=%@",[tableView indexPathForCell:cell]);
//            if (([tableView indexPathForCell:cell].row-1 == path.row) || ([tableView indexPathForCell:cell].row+1 == path.row)) {
////                model.cell = cell;
//                
////                NSLog(@"path.row=%d,[tableView indexPathForCell:cell]=%d",path.row,[tableView indexPathForCell:cell].row-1);
//            }
//        }
        
    } error:NULL];
}

#pragma tableView数据源方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 20;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
//    TBTestTableViewCell *cell = [TBTestTableViewCell initWithTableView:tableView];
//        
//    TBGesture *gesture = [[TBGesture alloc]init];
//    [gesture setName:[NSString stringWithFormat:@"test--%ld",indexPath.row]];
//    [gesture setObjectId:[NSString stringWithFormat:@"%ld",indexPath.row]];
//    [gesture setType:TBGestureTypeCustom];
//    
//    [cell setGesture:gesture];

    static NSString *ID=@"test";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell==nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"text--%d",indexPath.row];

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

@end
