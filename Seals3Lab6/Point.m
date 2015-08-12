//
// Created by Veight Zhou on 8/12/15.
// Copyright (c) 2015 Veight Zhou. All rights reserved.
//

#import "Point.h"

@implementation RLMPoint {

}

- (CGPoint)CGPoint {
    return CGPointMake(self.x, self.y);
}

- (instancetype)initWithCGPoint:(CGPoint)cgp {
    self = [super init];
    self.x = cgp.x;
    self.y = cgp.y;
    return self;
}
@end