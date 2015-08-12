//
//  TBJoinGestureSimulationViewController.m
//  Seals3Lab6
//
//  Created by Veight Zhou on 8/10/15.
//  Copyright (c) 2015 Veight Zhou. All rights reserved.
//

#import "TBJoinGestureSimulationViewController.h"
#import "TBEvent.h"
#import "TBGesture.h"

@interface TBJoinGestureSimulationViewController () <TBGestureDelegate>

@property (nonatomic, strong) UIView *testView;

@end

@implementation TBJoinGestureSimulationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor grayColor];
    self.testView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
    self.testView.center = self.view.center;
    self.testView.backgroundColor = [UIColor redColor];
    [self.view addSubview:self.testView];
    
    TBEvent *event = [[TBEvent alloc] initWithEventType:TBEventTypeCollect];
    TBGesture *gesture = [TBGesture gestureForEvent:event];
    [gesture addToView:self.testView completion:^(NSError *error) {
        
    }];
    
    gesture.delegate = self;
    
    TBEvent *e2 = [[TBEvent alloc] initWithEventType:TBEventTypeShare];
    TBGesture *g2 = [TBGesture gestureForEvent:e2];
    [g2 addToView:self.testView completion:^(NSError *error) {
        
    }];
    g2.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
