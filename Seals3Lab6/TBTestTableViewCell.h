//
//  TBTestTableViewCell.h
//  Seals3Lab6
//
//  Created by Frank on 15/8/7.
//  Copyright (c) 2015年 Veight Zhou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TBGesture.h"

@interface TBTestTableViewCell : UITableViewCell


@property(nonatomic, strong) TBGesture *gesture;

+(instancetype)initWithTableView:(UITableView *)tableView;

@end
