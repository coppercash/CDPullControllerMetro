//
//  CDMetroView.m
//  CDPullControllerMetro
//
//  Created by William Remaerd on 1/24/13.
//  Copyright (c) 2013 Coder Dreamer. All rights reserved.
//

#import "CDMetroView.h"

@implementation CDMetroView
@synthesize presentDuration = _presentDuration, dismissDuration = _dismissDuration;
@synthesize contentClass = _contentClass, metroColor = _metroColor;

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.clipsToBounds = YES;
        _presentDuration = _dismissDuration = 0.3f;
        self.contentClass = [UIView class];
    }
    return self;
}

- (void)setBackgroundColor:(UIColor *)backgroundColor{
    _contentView.backgroundColor = backgroundColor;
    _metroColor = backgroundColor;
}

- (UIColor *)backgroundColor{
    return _contentView.backgroundColor;
}

#pragma mark - Present & Dismiss
- (BOOL)isPresented{
    return _contentView != nil;
}

- (void)present{
    [self presentDelay:0.0f completion:nil];
}

- (void)presentDelay:(NSTimeInterval)interval completion:(void (^)(BOOL))completion{
    CDDirection d = randomDirection();   //direction
    [self presentFrom:d delay:interval completion:completion];
}

- (void)presentFrom:(CDDirection)direction{
    [self presentFrom:direction delay:0.0 completion:nil];
}

- (void)presentFrom:(CDDirection)direction delay:(NSTimeInterval)interval completion:(void (^)(BOOL finished))completion{

    CGRect frame = self.bounds;
    switch (direction) {
        case CDDirectionLeft:{
            frame.origin.x -= frame.size.width;
        }break;
        case CDDirectionRight:{
            frame.origin.x += frame.size.width;
        }break;
        case CDDirectionUp:{
            frame.origin.y -= frame.size.height;
        }break;
        case CDDirectionDown:{
            frame.origin.y += frame.size.height;
        }break;
        default:
            break;
    }
    if (_contentView == nil) {
        _contentView = [[_contentClass alloc] initWithFrame:frame];
        [self loadContentView:_contentView];
        [self addSubview:_contentView];
    }
    _contentView.autoresizingMask = CDViewAutoresizingNoMaigin;
    _contentView.backgroundColor = _metroColor;
    
    if (direction != CDDirectionNone) {
        CGPoint target = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
        [UIView animateWithDuration:_presentDuration delay:interval options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             _contentView.center = target;
                         } completion:^(BOOL finished) {
                             if (completion != nil) completion(finished);
                         }];
    }
}

- (void)dismiss{
    [self dismissDelay:0.0f completion:nil];
}

- (void)dismissDelay:(NSTimeInterval)interval completion:(void (^)(BOOL))completion{
    CDDirection d = randomDirection();   //direction
    [self dismissTo:d delay:interval completion:completion];
}

- (void)dismissTo:(CDDirection)direction{
    [self dismissTo:direction delay:0.0f completion:nil];
}

- (void)dismissTo:(CDDirection)direction delay:(NSTimeInterval)interval completion:(void (^)(BOOL finished))completion{
    CGSize size = self.bounds.size;
    CGPoint target = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    switch (direction) {
        case CDDirectionLeft:{
            target.x -= size.width;
        }break;
        case CDDirectionRight:{
            target.x += size.width;
        }break;
        case CDDirectionUp:{
            target.y -= size.height;
        }break;
        case CDDirectionDown:{
            target.y += size.height;
        }break;
        default:
            break;
    }
    
    if (direction == CDDirectionNone) {
        [self cleanContentView];
        [_contentView removeFromSuperview];
        SafeMemberRelease(_contentView);
    }else{
        [UIView animateWithDuration:_presentDuration delay:interval options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             _contentView.center = target;
                         } completion:^(BOOL finished) {
                             if (completion != nil) completion(finished);
                             if (finished) {
                                 [self cleanContentView];
                                 [_contentView removeFromSuperview];
                                 SafeMemberRelease(_contentView);
                             }
                         }];
    }
}

- (void)loadContentView:(UIView *)contentView{}

- (void)cleanContentView{}

@end

@implementation CDMetroDraw
@synthesize inset = _inset, shorterInset = _shorterInset;
@synthesize drawColor = _drawColor;
- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.drawColor = [UIColor whiteColor];
        _shorterInset = 0.1 * CGRectGetWidth(frame);
        _inset = CGSizeMake(0.05 * CGRectGetWidth(frame), 0.1 * CGRectGetHeight(frame));
    }
    return self;
}
@end

@implementation UIView (AnimateControl)
- (void)setIsAnimating:(BOOL)isAnimating{
    self.userInteractionEnabled = !isAnimating;
}

- (BOOL)isAnimating{
    return !self.isUserInteractionEnabled;
}
@end

CDDirection randomDirection(){
    NSUInteger index = arc4random() % 4;
    
    CDDirection d = CDDirectionNone;    //direction;
    switch (index) {
        case 0:
            d = CDDirectionUp;
            break;
        case 1:
            d = CDDirectionDown;
            break;
        case 2:
            d = CDDirectionLeft;
            break;
        case 3:
            d = CDDirectionRight;
            break;
        default:
            break;
    }
    return d;
}