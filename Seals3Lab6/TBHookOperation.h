//
//  TBHookOperation.h
//  Seals3Lab6
//
//  Created by Frank on 15/8/10.
//  Copyright (c) 2015年 Veight Zhou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TBGesture.h"

@interface TBHookOperation : NSObject

+(void)hookDataSource:(id)dataSource withTableView:(UITableView *)tableView withGesture:(TBGesture *)gesture forKeyPath:(NSString *)keyPath;

@end
