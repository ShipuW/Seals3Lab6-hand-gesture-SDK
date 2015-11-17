//
//  OneOneViewController.m
//  Seals3Lab6
//
//  Created by Veight Zhou on 8/13/15.
//  Copyright (c) 2015 Veight Zhou. All rights reserved.
//

#import "OneOneViewController.h"
#import "TBGEvent.h"
#import "TBGesture.h"

@interface OneOneViewController () <TBGestureDelegate>
@property (nonatomic, strong) UIView *testView;
@end

@implementation OneOneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"收藏";
    
    self.view.backgroundColor = [UIColor whiteColor];
    CGRect frame = CGRectMake(0, 0, 150, 150);
    self.testView = [[UIView alloc] initWithFrame:frame];
    self.testView.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:self.testView];
    self.testView.center = self.view.center;
    self.hidesBottomBarWhenPushed = YES;
    
    TBGesture *gesture = [[TBGesture alloc] initWithEventNames:@[@"收藏"]];
    [gesture addToView:self.testView completion:nil];
    gesture.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)recogizedEvent:(TBGEvent *)event {
    NSString *eventName = [NSString stringWithFormat:@"%@ 手势被识别", event.name];
    [[[UIAlertView alloc] initWithTitle:@"回调被触发" message:eventName delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
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
