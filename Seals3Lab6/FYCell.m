//
//  FYTableViewCell.m
//  TBCreateGusture
//
//  Created by feiyangzhang on 15/8/8.
//  Copyright (c) 2015年 feiyangzhang. All rights reserved.
//

#import "FYEventData.h"
#import "FYCreateGesture.h"
#import "FYCell.h"
#import "TBEvent.h"
@interface FYCell()
@property(nonatomic,weak) UIImageView* icon;
@property(nonatomic,weak) UILabel* eventName;
@end

@implementation FYCell

+(instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString* ID = @"event";
    FYCell* cell = [tableView dequeueReusableHeaderFooterViewWithIdentifier:ID];
    if (cell == nil) {
        cell = [[FYCell alloc] init];
    }
    return cell;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        UIImageView* icon = [[UIImageView alloc] init];
        icon.backgroundColor = [UIColor greenColor];
        self.icon = icon;
        [self.contentView addSubview:icon];
        
        UILabel* event = [[UILabel alloc] init];
         self.eventName = event;
        [self.contentView addSubview:event];
      
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    CGSize size = self.frame.size;
    CGFloat merge = 10;
    CGFloat buttonH = 30;
    //图片
    CGFloat iconX = merge;
    CGFloat iconY = merge;
    CGFloat iconW = 50;
    CGFloat iconH = 50;
    self.icon.frame = CGRectMake(iconX, iconY, iconW, iconH);
   
    //文字
    CGFloat eventX = CGRectGetMaxX(self.icon.frame)+merge;
    CGFloat eventH = buttonH;
    CGFloat eventY = (size.height-eventH)*0.5;
    CGFloat eventW = size.width-CGRectGetMaxX(self.icon.frame)-2*merge;
    self.eventName.frame = CGRectMake(eventX, eventY, eventW, eventH);
    
}

-(void)setData:(FYEventData *)data
{
    _data = data;
    [data addObserver:self forKeyPath:@"icon" options:0 context:nil];
    [data addObserver:self forKeyPath:@"event" options:0 context:nil];
    [data addObserver:self forKeyPath:@"isCustom" options:0 context:nil];
   
    //第一次设置值的时候，默认不会调用，所以需要手动调用
    [self observeValueForKeyPath:nil ofObject:nil change:nil context:nil];
}
-(void)dealloc
{
    [self.data removeObserver:self forKeyPath:@"icon"];
    [self.data removeObserver:self forKeyPath:@"event"];
    [self.data removeObserver:self forKeyPath:@"isCustom"];
}
//监听某个对象的属性值改变了，就会调用
//keyPath:哪个属性改变了
//object：哪个对象的属性改变了
//change: 属性发生的改变
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    FYEventData* data = self.data;
    self.eventName.text = data.event.name;
    if (data.isCustom) {//自定义手势，直接加载
        self.icon.image = [UIImage imageNamed:@"long_gusture"];
    }else{//自定义手势，从文件加载
        self.icon.image = [UIImage imageWithContentsOfFile:data.icon];
    }
    self.icon.backgroundColor = [UIColor clearColor];
    self.icon.contentMode = UIViewContentModeScaleToFill;
}

@end
