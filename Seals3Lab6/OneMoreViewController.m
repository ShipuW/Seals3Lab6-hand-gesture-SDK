//
//  OneMoreViewController.m
//  Seals3Lab6
//
//  Created by Veight Zhou on 8/13/15.
//  Copyright (c) 2015 Veight Zhou. All rights reserved.
//

#import "OneMoreViewController.h"
#import "TBGesture.h"
#import "TBGEvent.h"
@interface OneMoreViewController () <TBGestureDelegate>
@property (nonatomic, strong) UIView *testView;
@end

@implementation OneMoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"收藏 & 分享";
    
    self.view.backgroundColor = [UIColor whiteColor];
    CGRect frame = CGRectMake(0, 0, 150, 150);
    self.testView = [[UIView alloc] initWithFrame:frame];
    self.testView.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:self.testView];
    self.testView.center = self.view.center;
    self.hidesBottomBarWhenPushed = YES;
    
    
    TBGesture *gesture = [[TBGesture alloc] initWithEventNames:@[@"收藏", @"分享"]];
    [gesture addToView:self.testView completion:nil];
    gesture.delegate = self;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)recogizedEvent:(TBGEvent *)event {
    NSString *eventName = [NSString stringWithFormat:@"%@ 手势被识别", event.name];
    UIAlertView *a = [[UIAlertView alloc] initWithTitle:@"回调被触发" message:eventName delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [a show];
    a=nil;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
