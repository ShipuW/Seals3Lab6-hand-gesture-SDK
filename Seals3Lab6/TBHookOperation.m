//
//  TBHookOperation.m
//  Seals3Lab6
//
//  Created by Frank on 15/8/10.
//  Copyright (c) 2015年 Veight Zhou. All rights reserved.
//

#import "TBHookOperation.h"
#import "Aspects.h"
#import "TBIndexPathCellModel.h"
#import "TBIndexPathCellModelArray.h"

@implementation TBHookOperation

//hook
+(void)hookDataSource:(id)dataSource withTableView:(UITableView *)tableView withGesture:(TBGesture *)gesture forKeyPath:(NSString *)keyPath{
    
    [dataSource aspect_hookSelector:@selector(tableView: willDisplayCell:forRowAtIndexPath:) withOptions:AspectPositionBefore usingBlock:^(id<AspectInfo> aspectInfo,UITableView *tb, UITableViewCell *cell,NSIndexPath *path) {
        
        TBIndexPathCellModel *model = [[TBIndexPathCellModel alloc]init];
        model.indexPath = path;
        model.cell = cell;
        
        if (keyPath!=nil && ![keyPath isEqualToString:@""]) {
            
            UIView *subView = [cell valueForKeyPath:keyPath];
            if (subView != nil) {
                [model.subViews addObject:subView];
                NSLog(@"subview==%@",subView);
            }
        }

//        if (keyPath!=nil && ![keyPath isEqualToString:@""]) {
//            
//            NSLog(@"[cell valueForKeyPath:keyPath]==%@",[cell valueForKeyPath:keyPath]);
//        }
        
        [gesture addToView:cell completion:^(NSError *error) {
            NSLog(@"cell add");
        }];
        
        TBIndexPathCellModelArray *array = [TBIndexPathCellModelArray sharedManager];
        [array.modelArray addObject:model];
        
    } error:NULL];
}

@end
