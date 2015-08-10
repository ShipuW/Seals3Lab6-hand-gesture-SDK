//
//  FYCell.h
//  TBCreateGusture
//
//  Created by feiyangzhang on 15/8/10.
//  Copyright (c) 2015年 feiyangzhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FYEventData.h"

@interface FYCell : UITableViewCell

+(instancetype)cellWithTableView:(UITableView*)tableView;
@property(nonatomic,strong) FYEventData* data;

@end
