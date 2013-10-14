//
//  CDPullTopbarMetro.m
//  CDPullControllerMetro
//
//  Created by William Remaerd on 1/24/13.
//  Copyright (c) 2013 Coder Dreamer. All rights reserved.
//

#import "CDPullTopBar.h"
#import "CDColorFinder.h"

@interface CDPullTopBar ()
@property(nonatomic, strong)CDInfoPad *infoPad;
@property(nonatomic, strong)UIButton *leftButton;
@property(nonatomic, strong)UIButton *rightButton;
@end

@implementation CDPullTopBar
@synthesize infoPad = _infoPad, leftButton = _leftButton, rightButton = _rightButton;
@synthesize stableView = _stableView;
- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.5];
        [self shadowed];

        CGRect sF = self.bounds; //stage Frame
        CGFloat gap = 3;
        
        CGRect lBF = sF;    //left Button Frame
        lBF.size.width = sF.size.height;
        self.leftButton = [[UIButton alloc] initWithFrame:lBF];
        [_leftButton addTarget:self action:@selector(buttonTouched:) forControlEvents:UIControlEventTouchUpInside];

        CGRect rBF = lBF;   //right Button Frame
        rBF.origin.x = CGRectGetMaxX(sF) - CGRectGetWidth(rBF);
        self.rightButton = [[UIButton alloc] initWithFrame:rBF];
        [_rightButton addTarget:self action:@selector(buttonTouched:) forControlEvents:UIControlEventTouchUpInside];

        CGRect iF = sF; //infoPad Frame
        iF.origin.x = CGRectGetMaxX(lBF) + gap;
        iF.size.width = CGRectGetWidth(sF) - CGRectGetWidth(lBF) - CGRectGetWidth(rBF) - 2 * gap;
        self.infoPad = [[CDInfoPad alloc] initWithFrame:iF];
        _infoPad.userInteractionEnabled = NO;
        
        [self addSubview:_rightButton];
        [self addSubview:_leftButton];
        [self addSubview:_infoPad];
    }
    return self;
}

- (void)setBackgroundColor:(UIColor *)backgroundColor{
    _leftButton.backgroundColor = backgroundColor;
    _rightButton.backgroundColor = backgroundColor;
    _infoPad.backgroundColor = backgroundColor;
}

- (void)setTitleText:(NSString *)text{  //This temp in HoldLanguages 3.0
    _infoPad.title.text = text;
}

#pragma mark - Reload
- (void)reloadData{
    if (_dataSource && [_dataSource respondsToSelector:@selector(topBarLabel:textAtIndex:)]) {
        _infoPad.artist.text = [_dataSource topBarLabel:self textAtIndex:0];
        _infoPad.title.text = [_dataSource topBarLabel:self textAtIndex:1];
        _infoPad.albumTitle.text = [_dataSource topBarLabel:self textAtIndex:2];
    }
    //[_leftButton changeStateTo:0];
}

#pragma mark - Touch
- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event{
    _lastPoint = [touch locationInView:_stableView];

    return YES;
}

- (BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event{
    CGPoint locationInStableView = [touch locationInView:_stableView];
    if (_startDirection == CDDirectionNone){
        _startDirection = [self determineDirection:locationInStableView];
        if (_delegate && [_delegate respondsToSelector:@selector(topBarStartPulling:onDirection:)]) {
            [_delegate topBarStartPulling:self onDirection:_startDirection];
        }
    }
    if (_delegate && [_delegate respondsToSelector:@selector(topBarContinuePulling:onDirection:shouldMove:)]) {
        if (_startDirection == CDDirectionUp || _startDirection == CDDirectionDown) {
            CGFloat yIncrement = locationInStableView.y - _lastPoint.y;
            CGPoint targetCenter = self.center;
            targetCenter.y += [_delegate topBarContinuePulling:self onDirection:_startDirection shouldMove:yIncrement];
            if (!CGPointEqualToPoint(targetCenter, self.center)) self.center = targetCenter;
        }else if (_startDirection == CDDirectionLeft || _startDirection == CDDirectionRight){
            CGFloat xIncrement = locationInStableView.x - _lastPoint.x;
            CGPoint targetCenter = self.center;
            targetCenter.x += [_delegate topBarContinuePulling:self onDirection:_startDirection shouldMove:xIncrement];
            if (!CGPointEqualToPoint(targetCenter, self.center)) self.center = targetCenter;
        }
    }
    _currentDirection = [self determineDirection:locationInStableView];
    _lastPoint = locationInStableView;

    return YES;
}

- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event{
    BOOL isDirectionSame = _currentDirection == _startDirection;
    if (_startDirection == CDDirectionNone || isDirectionSame) {
        if (_delegate && [_delegate respondsToSelector:@selector(topBarFinishPulling:onDirection:)]) {
            [_delegate topBarFinishPulling:self onDirection:_startDirection];
        }
    }else{
        if (_delegate && [_delegate respondsToSelector:@selector(topBarCancelPulling:onDirection:)]) {
            [_delegate topBarCancelPulling:self onDirection:_startDirection];
        }
    }
    _startDirection = CDDirectionNone;
    _lastPoint = CGPointZero;
}

- (void)cancelTrackingWithEvent:(UIEvent *)event{
    if (_delegate && [_delegate respondsToSelector:@selector(topBarCancelPulling:onDirection:)]) {
        [_delegate topBarCancelPulling:self onDirection:_startDirection];
    }
    _startDirection = CDDirectionNone;
    _lastPoint = CGPointZero;
}

- (CDDirection)determineDirection:(CGPoint)location{
    CGFloat xIncrement = location.x - _lastPoint.x;
    CGFloat yIncrement = location.y - _lastPoint.y;
    if (_startDirection == CDDirectionNone) {
        if (fabsf(xIncrement) > fabsf(yIncrement)) {
            if (xIncrement < 0) return CDDirectionLeft;
            else return CDDirectionRight;
        }else{
            if (yIncrement < 0) return CDDirectionUp;
            else return CDDirectionDown;
        }
    }else if (_startDirection & CDDirectionVertical) {
        if (yIncrement < 0) return CDDirectionUp;
        else return CDDirectionDown;
    }else if (_startDirection & CDDirectionHorizontal){
        if (xIncrement < 0) return CDDirectionLeft;
        else return CDDirectionRight;
    }
    return CDDirectionNone;
}
/*
- (void)buttonTouchDown:(id)sender{
    if (_shade == nil) {
        _shade = [[CALayer alloc] init];
        _shade.frame = _leftButton.bounds;
        _shade.backgroundColor = [[UIColor alloc] initWithWhite:0.0f alpha:0.5f].CGColor;
        [_leftButton.layer addSublayer:_shade];
    }
}*/
/*
- (void)buttonTouchCancel:(id)sender{
    //[_shade removeFromSuperlayer];
    //SafeMemberRelease(_shade);
}
*/
- (void)buttonTouched:(id)sender{
    if (_delegate == nil || ![_delegate respondsToSelector:@selector(topBar:buttonTouched:)]) return;
    if (sender == _leftButton) {
        [_delegate topBar:self buttonTouched:0];
    }else if (sender == _rightButton){
        [_delegate topBar:self buttonTouched:1];
    }
    
    //[_shade removeFromSuperlayer];
    //SafeMemberRelease(_shade);
}

@end

@implementation CDInfoPad
- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        CGRect sF = CGRectInset(self.bounds, 7, 1); //stage Frame
        CGFloat lH = 12;    //Label Height
        
        CGRect arF = sF;    //artist Frame
        arF.size.height = lH;
        _artist = [[CDScrollLabel alloc] initWithFrame:arF];
        
        CGRect tF = sF; //title Frame
        tF.size.height = lH;
        tF.origin.y = CGRectGetMidY(sF) - lH / 2;
        _title = [[CDScrollLabel alloc] initWithFrame:tF];

        CGRect alF = sF; //album Frame
        alF.size.height = lH;
        alF.origin.y = CGRectGetMaxY(sF) - lH;
        _albumTitle = [[CDScrollLabel alloc] initWithFrame:alF];

        _title.textColor = _artist.textColor = _albumTitle.textColor = [UIColor whiteColor];
        _title.delegate = _artist.delegate = _albumTitle.delegate = self;
        _title.font = [UIFont boldSystemFontOfSize:12.0f];
        _artist.font = _albumTitle.font = [UIFont systemFontOfSize:10.0f];
        _title.textAlignment = _artist.textAlignment = _albumTitle.textAlignment = UITextAlignmentLeft;

        [self addSubview:_artist];
        [self addSubview:_title];
        [self addSubview:_albumTitle];
    }
    return self;
}

#pragma mark - CDScrollLabelDelegate
#define kAnimationInterval 3.0f
- (NSTimeInterval)scrollLabelShouldStartAnimating:(CDScrollLabel *)scrollLabel{
    return kAnimationInterval;
}

- (NSTimeInterval)scrollLabelShouldContinueAnimating:(CDScrollLabel *)scrollLabel{
    if (!_artist.isAnimating && !_title.isAnimating && !_albumTitle.isAnimating) {
        [_artist animateAfterDelay:kAnimationInterval];
        [_title animateAfterDelay:kAnimationInterval];
        [_albumTitle animateAfterDelay:kAnimationInterval];
    }
    return -1.0f;
}

@end