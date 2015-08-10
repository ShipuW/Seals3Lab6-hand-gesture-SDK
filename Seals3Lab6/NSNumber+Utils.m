//
//  NSNumber+Utils.m
//  Seals3Lab6
//
//  Created by Veight Zhou on 8/9/15.
//  Copyright (c) 2015 Veight Zhou. All rights reserved.
//

#import "NSNumber+Utils.h"

@implementation NSNumber (Utils)

- (CGFloat)CGFloatValue {
#if defined(__LP64__) && __LP64__
    return [self doubleValue];
#else
    return [self floatValue];
#endif
}

@end
