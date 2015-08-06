//
//  FifthViewController.m
//  Seals3Lab6
//
//  Created by Veight Zhou on 8/5/15.
//  Copyright (c) 2015 Veight Zhou. All rights reserved.
//

#import "FifthViewController.h"
#import "Aspects.h"
@interface FifthViewController ()

@end

@implementation FifthViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self aspect_hookSelector:@selector(viewDidAppear:) withOptions:AspectPositionAfter usingBlock:^(id info, BOOL animated) {
        NSLog(@"viewDidAppear:");
    } error:nil];

//    NSMethodSignature *ms = [[UIControl class] methodSignatureForSelector:@selector(addTarget:action:forControlEvents:)];
//    NSLog(@"%@", ms);

    [UIButton aspect_hookSelector:@selector(addTarget:action:forControlEvents:) withOptions:AspectPositionAfter usingBlock:^(id info, id target, SEL s, UIControlEvents evt) {
//        NSLog(@"%@", info);
//        NSLog(@"%@", target);
//        NSLog(@"%@", evt);
        NSLog(@"before button action");
    } error:nil];

    UIButton *button = [[UIButton alloc] init];
    [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
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


- (void)buttonAction:(id)sender {
    NSLog(@"action.");
}
@end
