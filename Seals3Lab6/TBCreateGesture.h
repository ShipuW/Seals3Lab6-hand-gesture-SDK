//
//  SmoothLineView.h
//  Smooth Line View
//
//  Created by Levi Nunnink on 8/15/11.
//  Copyright 2011 culturezoo. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TBGestureDrawDelegate <NSObject>

- (void)gestureDidDrawAtPosition:(NSArray *)trackPoints;

@end

@interface TBCreateGesture : UIView {
    @private
    CGPoint currentPoint;
    CGPoint previousPoint1;
    CGPoint previousPoint2;
    CGFloat lineWidth;
    UIColor *lineColor;
    UIImage *curImage;
}
@property (nonatomic, retain) UIColor *lineColor;
@property (readwrite) CGFloat lineWidth;
@property(nonatomic,strong) UIImage* capture;
@property(nonatomic,weak) id<TBGestureDrawDelegate> delegate;

@end
