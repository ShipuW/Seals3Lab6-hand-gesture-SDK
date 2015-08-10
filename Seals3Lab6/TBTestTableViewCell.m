//
//  TBTestTableViewCell.m
//  Seals3Lab6
//
//  Created by Frank on 15/8/7.
//  Copyright (c) 2015年 Veight Zhou. All rights reserved.
//

#import "TBTestTableViewCell.h"

@implementation TBTestTableViewCell

+(instancetype)initWithTableView:(UITableView *)tableView {
    static NSString *ID=@"test";
    TBTestTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:ID];
    if (cell==nil) {
        cell = [[TBTestTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    
    cell.textLabel.text = [NSString stringWithFormat:@"text--"];

    return cell;
}

@end
