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
    
    dispatch_async(dispatch_get_main_queue(), ^{
        TBIndexPathCellModelArray *array = [TBIndexPathCellModelArray sharedManager];
        if((array.times>8)&&(array.times%5==1 || array.times%5==2 || array.times%5==3 || array.times%5==4)){
            return;
        }
        [dataSource aspect_hookSelector:@selector(tableView: willDisplayCell:forRowAtIndexPath:) withOptions:AspectPositionBefore usingBlock:^(id<AspectInfo> aspectInfo,UITableView *tb, UITableViewCell *cell,NSIndexPath *path) {
            
            TBIndexPathCellModel *model = [[TBIndexPathCellModel alloc]init];
            model.indexPath = path;
            model.cell = cell;
            
            if (keyPath!=nil && ![keyPath isEqualToString:@""]) {
                
                UIView *subView = [cell valueForKeyPath:keyPath];
                if (subView != nil) {
                    [model.subViews addObject:subView];
                }
            }
            
            [gesture addToView:cell completion:^(NSError *error) {
//                NSLog(@"--------------------------cell add");
            }];
            
            
            [array.modelArray addObject:model];
//            NSLog(@"array.times=%d",array.times++);
            
        } error:nil];
    });
    

}

@end
