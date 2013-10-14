//
//  CDTimeLableView.h
//  CDPullControllerMetro
//
//  Created by William Remaerd on 1/27/13.
//  Copyright (c) 2013 Coder Dreamer. All rights reserved.
//

#import "CDMetroCell.h"

@interface CDTimeLableView : CDMetroCell{
    UILabel *_label;
    NSTimeInterval _duration;
    float _progress;
}
@property(nonatomic, assign)NSTimeInterval duration;
@property(nonatomic, assign)float progress;
- (void)setPlayBackTime:(NSTimeInterval)time;
@end
