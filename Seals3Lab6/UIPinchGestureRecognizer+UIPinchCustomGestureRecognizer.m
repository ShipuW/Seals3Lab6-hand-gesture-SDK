//
//  UIPinchGestureRecognizer+UIPinchCustomGestureRecognizer.m
//  Seals3Lab6
//
//  Created by 王士溥 on 15/8/10.
//  Copyright (c) 2015年 Veight Zhou. All rights reserved.
//
#import "TBGesture.h"
#import "UIPinchGestureRecognizer+UIPinchCustomGestureRecognizer.h"

@implementation UIPinchCustomGestureRecognizer:UIPinchGestureRecognizer


- (instancetype)initWithTarget:(id)target action:(SEL)action{
    _lastScale=1;
    
    self = [super initWithTarget:self action:@selector(pinchAction:)];
    if (self) {
       // self.minimumPressDuration = Duration;
    }
    
    
    return self;
}


-(void) pinchDirectionRecognizer{

    if (_tureScale>1.5 && self.tbGesture.type == 98) {
        NSLog(@"放大");
        _isMatch = YES;
    }else if(_tureScale<0.5 && self.tbGesture.type == 99){
        NSLog(@"缩小");
        _isMatch = YES;
    }else{
        NSLog(@"匹配错误");
        _isMatch = NO;
    }
}

- (void)pinchAction:(UIPinchGestureRecognizer *)sender{
    //
    
    if (sender.state == UIGestureRecognizerStateBegan) {
        _tureScale=1;
    }
    if (sender.state == UIGestureRecognizerStateChanged) {
        
        
        sender.scale=sender.scale-_lastScale+1;
        _tureScale=_tureScale*sender.scale;
        NSLog(@"Pinch scale: %f", _tureScale);
        sender.view.transform=CGAffineTransformScale(sender.view.transform, sender.scale,sender.scale);
        
        _lastScale=sender.scale;
    }else if(sender.state == UIGestureRecognizerStateEnded){
        [UIView animateWithDuration:0.5 animations:^{
            //[sender.view removeFromSuperview];
            sender.view.transform = CGAffineTransformIdentity;
            sender.view.alpha = 1.0;

            
            [self pinchDirectionRecognizer];
        }];
    
    }
}

@end
