//
// Created by Veight Zhou on 8/5/15.
// Copyright (c) 2015 Veight Zhou. All rights reserved.
//

#import "TBEventDisplayModel.h"


@implementation TBEventDisplayModel {

}
+ (TBEventDisplayModel *)instance {
    static TBEventDisplayModel *_instance = nil;

    @synchronized (self) {
        if (_instance == nil) {
            _instance = [[self alloc] init];
        }
    }

    return _instance;
}
@end