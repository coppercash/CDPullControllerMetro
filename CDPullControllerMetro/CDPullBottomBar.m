//
//  CDPullBottomBar.m
//  CDPullControllerMetro
//
//  Created by William Remaerd on 1/24/13.
//  Copyright (c) 2013 Coder Dreamer. All rights reserved.
//

#import "CDPullBottomBar.h"
#import "CDMasterButton.h"
#import "CDProgressView.h"
#import "CDTimeLableView.h"
#import "CDProgressView.h"
#import "CDColorFinder.h"

@interface CDPullBottomBar ()
- (void)sliderThumbChangedTouchDown:(id)sender;
- (void)sliderThumbChangedValue:(id)sender;
- (void)sliderThumbTouchUpInside:(id)sender;
- (CGRect)frameSelfPresented:(BOOL)isPresented;
- (CGRect)frameMasterButtonpPresented:(BOOL)isPresented situation:(BOOL)isStagePresented;
@end

@implementation CDPullBottomBar
@synthesize masterButton = _masterButton, progressView = _progressView, cells = _cells;
@synthesize scale = _scale;
@synthesize presentDuration = _presentDuration, dismissDuration = _dismissDuration;
@synthesize dataSource = _dataSource, delegate = _delegate;
@synthesize isPresented = _isPresented;

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        _scale = 0.618;
        _presentDuration = _dismissDuration = 0.3f;
        
        _isPresented = NO;
        self.frame = [self frameSelfPresented:_isPresented];
        
        [self shadowed];
         
        _metroColor = [UIColor blackColor];
        
        CGRect mF = [self frameMasterButtonpPresented:_isPresented situation:_isPresented];  //master button frame
        _masterButton = [[CDMasterButton alloc] initWithFrame:mF];
        _masterButton.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin;
        _masterButton.backgroundColor = _metroColor;
        _masterButton.delegate = self;
        
        [self addSubview:_masterButton];
    }
    return self;
}

- (void)setBackgroundColor:(UIColor *)backgroundColor{
    _metroColor = backgroundColor;
    _masterButton.backgroundColor = backgroundColor;
    _progressView.backgroundColor = backgroundColor;
    for (CDMetroCell *c in _cells) {
        c.backgroundColor = backgroundColor;
    }
}

- (UIColor*)backgroundColor{
    return _metroColor;
}
/*
- (void)setFrame:(CGRect)frame{
    [super setFrame:frame];
}*/

#pragma mark - Reload
- (void)reloadData{
    if (_timeLabel != nil && _dataSource && [_dataSource respondsToSelector:@selector(bottomBarAskForDuration:)]) {
        _timeLabel.duration = [_dataSource bottomBarAskForDuration:self];
    }
}

#pragma mark - Present & Dismiss
- (void)presentAnimated:(BOOL)animated{
    if (_isPresented == YES) return;
    _isPresented = YES;
    [self deshadowed];
    
    self.frame = [self frameSelfPresented:YES];
        
    CGRect sF = CGRectInset(self.bounds, 0.0f, 0.0f);   //stage frame
    
    CGRect mF = [self frameMasterButtonpPresented:YES situation:YES]; //master button frame.
    
    CGRect csF = sF;    //cells frame
    csF.origin.x = CGRectGetMaxX(mF) + kGap;
    csF.size.width = CGRectGetWidth(sF) - CGRectGetWidth(mF) - kGap;
    csF.size.height *= 0.618;
    
    NSUInteger number = [_dataSource numberOfCellsInBottomBar:self];
    CGFloat unitWidth = (CGRectGetWidth(csF) - (number - 1) * kGap) / number;
    
    _cells = [[NSMutableArray alloc] initWithCapacity:number];
    for (NSUInteger index = 0; index < number; index++) {
        CGRect cF = csF;    //cell frame
        cF.origin.x += index * (kGap + unitWidth);
        cF.size.width = unitWidth;
        CDMetroCell *cell = [_dataSource bottomBar:self cellAtIndex:index boundIn:cF];
        cell.delegate = self;
        cell.autoresizingMask = CDViewAutoresizingFloat;
        [cell setBackgroundColor:_metroColor];
        
        [_cells addObject:cell];
        [self addSubview:cell];
    }
        
    CGRect pF = csF; //progress frame
    pF.origin.y = CGRectGetMaxY(csF) + kGap;
    pF.size.height = CGRectGetHeight(sF) - CGRectGetHeight(csF)- kGap;
    _progressView = [[CDProgressView alloc] initWithFrame:pF];
    _progressView.autoresizingMask = CDViewAutoresizingFloat;
    _progressView.backgroundColor = _metroColor;
    _progressView.progress = _masterButton.present.progress;
    [self addSubview:_progressView];
    
    if (animated) {
        [UIView animateWithDuration:_presentDuration delay:0.0f options:UIViewAnimationOptionCurveEaseOut animations:^{
            _masterButton.frame = mF;
        } completion:^(BOOL finished) {
            [_masterButton presentAnimated:animated];
        }];
        
        [_progressView presentFrom:CDDirectionLeft delay:0.3f completion:^(BOOL finished) {
            _progressView.progressView.range = _masterButton.present.range;
        }];
        
        NSTimeInterval delay = 0.3;
        NSTimeInterval increment = delay / _cells.count;
        NSInteger count = _cells.count;
        for (int index = 0; index < count; index++) {
            CDMetroCell *cell = [_cells objectAtIndex:index];
            if (index == count - 1) {
                [cell presentFrom:CDDirectionDown delay:delay completion:^(BOOL finished) {
                    [self shadowed];    //last animation of whole present movation, show the shadow again.
                }];
            }else{
                [cell presentFrom:CDDirectionDown delay:delay completion:nil];
            }
            delay += increment;
        }

    }else{
        _masterButton.frame = mF;
        [_masterButton presentAnimated:animated];
    }
}

- (void)dismissAnimated:(BOOL)animated{
    if (_isPresented == NO) return;
    _isPresented = NO;
    [self deshadowed];
    
    _masterButton.present.progress = _progressView.progress;
    
    if (animated) {
        [_progressView dismissTo:CDDirectionLeft delay:0.0f completion:^(BOOL finished) {
            [_progressView removeFromSuperview];
            SafeMemberRelease(_progressView);
        }];
        
        NSTimeInterval delay = 0.3;
        NSTimeInterval increment = delay / _cells.count;
        for (CDMetroCell *cell in _cells) {
            [cell dismissTo:CDDirectionDown delay:delay completion:^(BOOL finished) {
                [cell removeFromSuperview];
            }];
            delay -= increment;
        }
        
        if (self.isTimeLabelPresented) {
            [_timeLabel dismissTo:CDDirectionDown delay:0.25f completion:^(BOOL finished) {
                [_timeLabel removeFromSuperview];
                SafeMemberRelease(_timeLabel);
            }];
        }
        
        [UIView animateWithDuration:_dismissDuration delay:0.3f options:UIViewAnimationOptionCurveEaseOut animations:^{
            _masterButton.frame = [self frameMasterButtonpPresented:NO situation:YES];
        } completion:^(BOOL finished) {
            SafeMemberRelease(_cells);
            self.frame = [self frameSelfPresented:NO];
            [self shadowed];
        }];
    }else{
        self.frame = [self frameSelfPresented:NO];
        [_progressView removeFromSuperview];
        SafeMemberRelease(_progressView);
    }

    [_masterButton dismissAnimated:animated];
}

- (BOOL)isPresented{
    return _isPresented;
}

#pragma mark - Time Label
- (CDTimeLableView *)presentTimeLabelCell:(BOOL)animated{
    
    NSUInteger fI = 0, len = 2; //first index, length
    NSRange range = NSMakeRange(fI, len);
    NSArray *pCs = [_cells subarrayWithRange:range];    //Placed cells
    
    CGRect tmF = [[_cells objectAtIndex:fI] frame];
    BOOL isFirst = YES;
    for (CDMetroCell *c in pCs) {
        if (isFirst) {
            isFirst = NO;
            continue;
        }
        tmF.size.width += kGap + CGRectGetWidth(c.frame);
    }
    
    if (_timeLabel == nil) {
         _timeLabel = [[CDTimeLableView alloc] initWithFrame:tmF];
        [self addSubview:_timeLabel];
    }
    _timeLabel.delegate = self;
    [_timeLabel setBackgroundColor:_metroColor];
    if (_dataSource && [_dataSource respondsToSelector:@selector(bottomBarAskForDuration:)]) {
        _timeLabel.duration = [_dataSource bottomBarAskForDuration:self];
    }
    if (animated) {
        for (CDMetroCell *c in pCs) [c dismissTo:CDDirectionDown];
        [_timeLabel presentFrom:CDDirectionLeft delay:0.3f completion:nil];
    }else{
        for (CDMetroCell *c in pCs) [c dismissTo:CDDirectionNone];
        [_timeLabel presentFrom:CDDirectionNone];
    }
    
    return _timeLabel;
}

- (void)dismissTimeLabelCell:(BOOL)animated{
    NSRange range = NSMakeRange(0, 2);
    NSArray *pCs = [_cells subarrayWithRange:range];    //Placed cells

    if (animated) {
        [_timeLabel dismissTo:CDDirectionLeft delay:0.0f completion:^(BOOL finished) {
            if (finished) {
                [_timeLabel removeFromSuperview];
                SafeMemberRelease(_timeLabel);
            }
        }];
        for (CDMetroCell *c in pCs) [c presentFrom:CDDirectionDown delay:0.3f completion:nil];
    }else{
        for (CDMetroCell *c in pCs) [c presentFrom:CDDirectionNone];
        [_timeLabel dismissTo:CDDirectionNone];
        [_timeLabel removeFromSuperview];
        SafeMemberRelease(_timeLabel);
    }
}

- (BOOL)isTimeLabelPresented{
    return _timeLabel != nil;
}

#pragma mark - Frames
- (CGRect)frameSelfPresented:(BOOL)isPresented{
    //New frame is base on current frame
    CGRect frame = self.frame;
    if (isPresented) {
        frame.size.height /= _scale;
        frame.size.width = CGRectGetWidth(self.superview.bounds) - 2 * CGRectGetMinX(self.frame);
    }else{
        CGFloat size = CGRectGetHeight(frame) * _scale;
        frame.size.height = size;
        frame.size.width = size;
    }
    CGFloat yIncrement = CGRectGetHeight(frame) - CGRectGetHeight(self.frame);
    frame.origin.y -= yIncrement;

    return frame;
}

- (CGRect)frameMasterButtonpPresented:(BOOL)isPresented situation:(BOOL)isStagePresented{
    CGRect stageFrame = self.bounds;
    CGRect mF = stageFrame;  //master button frame
    if (isStagePresented) {
        //Base on "presented" situatoin, to "presented/un-presented master button frame"
        if (isPresented) {
            mF.size.width = CGRectGetHeight(stageFrame);
        }else{
            CGFloat size = _scale * CGRectGetHeight(self.bounds);
            mF.origin.y = CGRectGetMaxY(stageFrame) - size;
            mF.size.width = mF.size.height = size;
        }
    }else{
        //Base on "un-presented" situatoin, to "presented/un-presented master button frame"
        if (isPresented) {
            CGFloat size = CGRectGetHeight(self.bounds) / _scale;
            mF.size.width = mF.size.height = size;
        }
    }
    
    return mF;
}

#pragma mark - CDMetroCellDelegate
- (void)touchBeganInCell:(CDMetroCell *)cell{
    
}

- (void)touchEndInCell:(CDMetroCell *)cell{
    if (_delegate == nil || ![_delegate respondsToSelector:@selector(bottomBar:touchCellAtIndex:)]) return;
    for (NSUInteger index = 0; index < _cells.count; index++) {
        CDMetroCell *c = [_cells objectAtIndex:index];
        if (c == cell) {
            [_delegate bottomBar:self touchCellAtIndex:index];
            break;
        }
    }
    if (cell == _masterButton) {
        if (_isPresented) {
            [_delegate bottomBar:self touchCellAtIndex:NSUIntegerMax];
        }else{
            if ([_delegate respondsToSelector:@selector(bottomBarWillPresent:)]) {
                [_delegate bottomBarWillPresent:self];
            }
        }
    }
    if (cell == _timeLabel) {
        [self dismissTimeLabelCell:YES];
    }
}

#pragma mark - CDAudioPregressDelegate
- (void)playbackTimeDidUpdate:(NSTimeInterval)playbackTime withTimes:(NSUInteger)times{
    if (times == kLabelsUpdateTimes && !_progressView.thumb.thumbOn) {
        [_timeLabel setPlayBackTime:playbackTime];
    }
}

- (void)progressDidUpdate:(float)progress withTimes:(NSUInteger)times{
    if (times == kProgressViewUpdateTimes) {
        if (_isPresented) {
            if (!_progressView.thumb.thumbOn) _progressView.progress = progress;
        }else{
            _masterButton.present.progress = progress;
        }
    }
}

#pragma mark - Slider
- (void)sliderThumbChangedTouchDown:(id)sender {
    [self presentTimeLabelCell:YES];
    DLogCurrentMethod;
}

- (void)sliderThumbChangedValue:(id)sender {
    float value = [(CDSliderThumb*)sender value];
    [_progressView setProgress:value];
    
    _timeLabel.progress = value;
    
    DLogCurrentMethod;

    /*
    NSTimeInterval duration = [_delegate bottomBarAskForDuration:self];
    NSTimeInterval playbackTime = value * duration;
    [self setLabelsPlaybackTime:playbackTime];
     */
}

- (void)sliderThumbTouchUpInside:(id)sender {
    DLogCurrentMethod;
    if (_delegate && [_delegate respondsToSelector:@selector(bottomBar:sliderValueChangedAs:)]) {
        float value = [(CDSliderThumb*)sender value];
        [_delegate bottomBar:self sliderValueChangedAs:value];
    }
    //[self dismissTimeLabelCell:YES];
}

- (void)setRepeatRanege:(CDDoubleRange)range withDuration:(NSTimeInterval)duration{
    float location = range.location / duration;
    float length = range.length / duration;
    
    _progressView.progressView.range = CDMakeFloatRange(location, length);
    _masterButton.present.range = CDMakeFloatRange(location, length);
    
    //[_progressView.progressView setRangeLocation:location length:length];
    //[_masterButton.present setRangeLocation:location length:length];
}

- (void)cleanRepeatRange{
    [_progressView.progressView cleanRange];
    [_masterButton.present cleanRange];
}

@end
