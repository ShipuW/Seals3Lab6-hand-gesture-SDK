//
//  ThirdViewController.m
//  Seals3Lab6
//
//  Created by Veight Zhou on 8/5/15.
//  Copyright (c) 2015 Veight Zhou. All rights reserved.
//

#import "ThirdViewController.h"
#import "TBGesture.h"
#import "TBEvent.h"
#import "UIGestureRecognizer+UICustomGestureRecognizer.h"
@interface ThirdViewController ()
@property (weak, nonatomic) IBOutlet UIButton *testButton;
@property (weak, nonatomic) IBOutlet UIView *testView;
@property (weak, nonatomic) IBOutlet UIView *testView2;

@end

@implementation ThirdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated{
    
    //UICustomGestureRecognizer *customRecognizer = [[UICustomGestureRecognizer alloc] initWithTarget:self action:@selector(test:)];
    //customRecognizer.isSimpleGesture = YES;
    //UICustomGestureRecognizer *customRecognizer2 = [[UICustomGestureRecognizer alloc] initWithTarget:self action:@selector(test:)];
    //customRecognizer2.isSimpleGesture = NO;
    //[self.testView addGestureRecognizer:customRecognizer];
    //[self.testView2 addGestureRecognizer:customRecognizer2];
    
    
    
    
    
    TBEvent *event = [[TBEvent alloc] initWithEventType:TBEventTypeCollect];
    TBGesture *gesture = [TBGesture gestureForEvent:event];
    [gesture addToView:self.testView completion:^(NSError *error) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"AlertViewTest"
                                                        message:@"11"
                                                       delegate:self
                                              cancelButtonTitle:@"Cancel"
                                              otherButtonTitles:@"OtherBtn",nil];
        [alert show];
        
    }];
}


- (void)test:(UICustomGestureRecognizer *)recognizer
{

    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"AlertViewTest"
                                                    message:recognizer.gestureId
                                                   delegate:self
                                          cancelButtonTitle:@"Cancel"
                                          otherButtonTitles:@"OtherBtn",nil];
    [alert show];
    
    //NSLog(@"%@",@(recognizer.direction));
    //NSLog(@"%@",recognizer.trackPoints);
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
