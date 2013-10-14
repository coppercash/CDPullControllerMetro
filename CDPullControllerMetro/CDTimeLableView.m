//
//  CDTimeLableView.m
//  CDPullControllerMetro
//
//  Created by William Remaerd on 1/27/13.
//  Copyright (c) 2013 Coder Dreamer. All rights reserved.
//

#import "CDTimeLableView.h"

@implementation CDTimeLableView
@synthesize duration = _duration, progress = _progress;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //self.darken = NO;
        CGFloat inset = 0.05 * CGRectGetWidth(self.bounds);
        CGRect f = CGRectInset(self.bounds, inset, 0.0f);
        _label = [[UILabel alloc] initWithFrame:f];
        _label.textColor = [UIColor whiteColor];
        _label.backgroundColor = [UIColor clearColor];
        _label.font = [UIFont boldSystemFontOfSize:15];
        _label.autoresizingMask = CDViewAutoresizingNoMaigin;
        _label.adjustsFontSizeToFitWidth = YES;
        _label.textAlignment = UITextAlignmentCenter;
    }
    return self;
}

- (void)loadContentView:(UIView *)contentView{
    [contentView addSubview:_label];
}

- (void)setDuration:(NSTimeInterval)duration{
    if (duration == _duration) return;
    _duration = duration;
    
    NSString *pT = textWithTimeInterval(0.0);  //progress text
    NSString *dT = textWithTimeInterval(duration);  //duration text
    _label.text = [[NSString alloc] initWithFormat:@"%@ / %@",pT, dT];
}

- (void)setProgress:(float)progress{
    if (progress == _progress) return;
    _progress = progress;
    
    NSString *pT = textWithTimeInterval(progress * _duration);  //progress text
    NSString *dT = textWithTimeInterval(_duration);  //duration text
    _label.text = [[NSString alloc] initWithFormat:@"%@ / %@",pT, dT];
}

- (void)setPlayBackTime:(NSTimeInterval)time{
    NSString *pT = textWithTimeInterval(time);  //progress text
    NSString *dT = textWithTimeInterval(_duration);  //duration text
    _label.text = [[NSString alloc] initWithFormat:@"%@ / %@",pT, dT];
}

@end
