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

@interface ForthViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property(nonatomic, strong) NSIndexPath *indexPath;
@property(nonatomic, strong) UITableViewCell *cell;

@end

@implementation ForthViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    [self aspect_hookSelector:@selector(tableView:cellForRowAtIndexPath:) withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo> aspectInfo,UITableView *tableView,NSIndexPath *path) {
        
        self.indexPath = path;
        
        NSArray *cellArray = [tableView visibleCells];
        for (UITableViewCell *cell in cellArray) {
//            NSLog(@"cell.isHidden=%d",cell.isHidden);
//            NSLog(@"[tableView indexPathForCell:cell]=%@",[tableView indexPathForCell:cell]);
            
            
            if ([path isEqual:[tableView indexPathForCell:cell]]) {
            
                self.cell = cell;
            
                
                NSLog(@"haha==%@",[cell valueForKeyPath:@"gesture"]);
                
            }
        }
        
    } error:NULL];
    
}


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
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

@end
