//
//  FirstViewController.m
//  Seals3Lab6
//
//  Created by Veight Zhou on 8/5/15.
//  Copyright (c) 2015 Veight Zhou. All rights reserved.
//

#import "FirstViewController.h"
#import "GLGestureRecognizer.h"
#import "TBGestureRecognizer.h"

@interface FirstViewController () {
    GLGestureRecognizer *recognizer;
}

@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    recognizer = [[GLGestureRecognizer alloc] init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [recognizer resetTouches];
    [recognizer addTouches:touches fromView:self.view];
}
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [recognizer addTouches:touches fromView:self.view];
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [recognizer addTouches:touches fromView:self.view];
    [[TBGestureRecognizer shareGestureRecognizer]matchGestureFrom:recognizer.touchPoints completion:^(NSString *gestureId, NSArray *resampledGesture) {
        NSLog(@"%@..", gestureId);
    }];
}

@end
