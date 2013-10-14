//
//  CDPullControllerMetro.m
//  CDPullControllerMetro
//
//  Created by William Remaerd on 1/24/13.
//  Copyright (c) 2013 Coder Dreamer. All rights reserved.
//

#import "CDPullControllerMetro.h"
#import "CDMetroCell.h"
#import "CDMasterButton.h"

@interface CDPullControllerMetro ()
@property(nonatomic, strong)CDPullBottomBar *bottomBar;
- (void)setBarsHidden:(BOOL)barsHidden animated:(BOOL)animated;
- (CGRect)topBarFrameWithHidding:(BOOL)hidding;

- (CGRect)pulledViewFrameWithPresented:(BOOL)presented;
- (void)createPulledView;
- (void)destroyPulledView;
- (void)setPulledViewPresented:(BOOL)pulledViewPresented;
- (void)setPullViewPresented:(BOOL)pullViewPresented animated:(BOOL)animated;
@end

@implementation CDPullControllerMetro
@synthesize pulledView = _pulledView, topBar = _topBar, bottomBar = _bottomBar;

- (void)loadView{
    UIView *view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
    
    _barsHidden = YES;
    
    CGRect bF = view.bounds;
    bF = CGRectMake(kMargin,                                            // x
                    CGRectGetHeight(bF) - kBottimBarHeight - kMargin,   // y
                    CGRectGetWidth(bF) - 2 * kMargin,                   //width
                    kBottimBarHeight);                                  //height
    CDPullBottomBar *bottomBar = [[CDPullBottomBar alloc] initWithFrame:bF];
    bottomBar.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    bottomBar.dataSource = self, bottomBar.delegate = self;

    self.bottomBar = bottomBar;
    [view addSubview:bottomBar];
    self.view = view;
}

- (void)viewDidLoad{
    [super viewDidLoad];
	// Do any additional setup after loading the view.

    [[UIApplication sharedApplication] setStatusBarHidden:_barsHidden withAnimation:UIStatusBarAnimationSlide];
}

- (void)endOfViewDidLoad{
    [self.view bringSubviewToFront:_bottomBar];
}



#pragma mark - Bars
- (void)setBarsHidden:(BOOL)barsHidden animated:(BOOL)animated{
    if (barsHidden == _barsHidden) return;
    _barsHidden = barsHidden;
    if (barsHidden) {
        [_bottomBar dismissAnimated:animated];
        [self dismissTopBarAnimated:animated];
        if (self.wantsFullScreenLayout) {
            [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
        }
    }else{
        [_bottomBar presentAnimated:animated];
        [self presentTopBarAnimated:animated];
        if (self.wantsFullScreenLayout) {
            [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
        }
    }
}

#pragma mark - Top bar
- (void)presentTopBarAnimated:(BOOL)animated{
    if (_topBar != nil) [_topBar removeFromSuperview];
    _topBar = [[CDPullTopBar alloc] initWithFrame:[self topBarFrameWithHidding:YES]];
    _topBar.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
    _topBar.backgroundColor = _bottomBar.backgroundColor;
    _topBar.delegate = self, _topBar.dataSource = self;

    [_topBar reloadData];
    [self.view addSubview:_topBar];
    
    if (animated) {
        CABasicAnimation* topBarAnimation = [self animationOfBar:_topBar withHidden:NO];
        [_topBar.layer addAnimation:topBarAnimation forKey:self.keyOfTopBarAnimation];
    }
}

- (void)dismissTopBarAnimated:(BOOL)animated{
    if (animated) {
        CABasicAnimation* topBarAnimation = [self animationOfBar:_topBar withHidden:YES];
        [_topBar.layer addAnimation:topBarAnimation forKey:self.keyOfTopBarAnimation];
    } else {
        [_topBar removeFromSuperview];
        SafeMemberRelease(_topBar);
    }
}

- (CGRect)topBarFrameWithHidding:(BOOL)hidding{
    CGFloat statusHeight = self.wantsFullScreenLayout ? 20.0f : 0.0f;
    CGFloat topBarHeight = kTopBarHeight + 2 * kMargin;
    CGRect frame = self.view.bounds;
    
    if (hidding) {
        frame.origin.y = - topBarHeight;
        frame.size.height = topBarHeight;
    }else{
        frame.origin.y = statusHeight;
        frame.size.height = topBarHeight;
    }
    return CGRectInset(frame, kMargin, kMargin);
}

#pragma mark - Animation
- (CABasicAnimation*)animationOfBar:(id)target withHidden:(BOOL)barsHidden{
    CABasicAnimation* barAnimation = [CABasicAnimation animationWithKeyPath:@"position.y"];

    CGFloat to = CGRectGetMidY([self topBarFrameWithHidding:barsHidden]);
    NSNumber* toValue = [[NSNumber alloc] initWithFloat:to];
    barAnimation.toValue = toValue;
    barAnimation.duration = kHiddingAniamtionDuration;
    barAnimation.removedOnCompletion = NO;
    barAnimation.delegate = self;
    barAnimation.fillMode = kCAFillModeForwards;
    return barAnimation;
}

- (NSString*)keyOfTopBarAnimation{
    return @"topAnimationKey";
}

- (void)animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)flag{
    CAAnimation * topBarAnimation = [_topBar.layer animationForKey:self.keyOfTopBarAnimation];
    if (theAnimation == topBarAnimation) {
        _topBar.frame = [self topBarFrameWithHidding:_barsHidden];
        [_topBar.layer removeAnimationForKey:self.keyOfTopBarAnimation];
        if (_barsHidden) {
            [_topBar removeFromSuperview];
            SafeMemberRelease(_topBar);
        }
    }
}

#pragma mark - CDPullTopBarDelegate
- (void)topBarStartPulling:(CDPullTopBar*)topBar onDirection:(CDDirection)direction{
    if (direction == CDDirectionDown) {
        [self createPulledView];
    }
}

- (CGFloat)topBarContinuePulling:(CDPullTopBar *)topBar onDirection:(CDDirection)direction shouldMove:(CGFloat)increment{

    if (direction == CDDirectionDown) {
        CGPoint pullViewCenter = _pulledView.center;
        pullViewCenter.y += increment;
        _pulledView.center = pullViewCenter;

        return increment;
    }
    return 0.0f;
}

- (void)topBarFinishPulling:(CDPullTopBar*)topBar onDirection:(CDDirection)direction{
    if (direction == CDDirectionDown || direction == CDDirectionNone){
        [self setPullViewPresented:YES animated:YES];
    }
}

- (void)topBarCancelPulling:(CDPullTopBar*)topBar onDirection:(CDDirection)direction{
    if (direction == CDDirectionDown){
        [self setPullViewPresented:NO animated:YES];
    }
}

#pragma mark - CDPullBottomBarDataSource
- (CDMetroCell *)bottomBar:(CDPullBottomBar *)bottomBar cellAtIndex:(NSUInteger)index boundIn:(CGRect)frame{
    CDMetroCell *cell = nil;
    switch (index) {
        case 0:{
            cell = [[CDMetroCell alloc] initWithFrame:frame style:CDMetroCellStyleBackward];
        }break;
        case 1:{
            cell = [[CDMetroCell alloc] initWithFrame:frame style:CDMetroCellStyleForward];
        }break;
        default:{
            cell = [[CDMetroCell alloc] initWithFrame:frame];
        }break;
    }
    
    return cell;
}

- (NSUInteger)numberOfCellsInBottomBar:(CDPullBottomBar *)bottomBar{
    return 4;
}

#pragma mark - CDPullBottomBarDelegate
- (void)bottomBar:(CDPullBottomBar *)bottomBar touchCellAtIndex:(NSUInteger)index{
    switch (index) {
        case NSUIntegerMax:{
        }break;
            
        default:
            break;
    }
}

- (void)bottomBarWillPresent:(CDPullBottomBar *)bottomBar{
    [self setBarsHidden:NO animated:YES];
}

#pragma mark - Pulled View
- (CGRect)pulledViewFrameWithPresented:(BOOL)presented{
    CGRect visualBounds = self.view.bounds;
    if (![[UIApplication sharedApplication] isStatusBarHidden]) {
        CGFloat statusBarHeight = 20.0f;
        visualBounds = CGRectInset(visualBounds, 0.0f, statusBarHeight / 2);
        visualBounds = CGRectOffset(visualBounds, 0.0f, statusBarHeight / 2);
    }
    CGRect frame = CGRectZero;
    if (presented) {
        frame = visualBounds;
    }else{
        CGFloat offset = - visualBounds.size.height;
        frame = CGRectOffset(visualBounds, 0.0f, offset);
    }
    return frame;
}

- (void)createPulledView{
    //Alloc and Configure pulledView.
    CGRect pullViewFrame = [self pulledViewFrameWithPresented:NO];
    _pulledView = [[UIView alloc] initWithFrame:pullViewFrame];
    [self.view addSubview:_pulledView];
    _pulledView.autoresizingMask = CDViewAutoresizingNoMaigin;
    _pulledView.backgroundColor = [UIColor whiteColor];
}

- (void)destroyPulledView{
    [_pulledView removeFromSuperview];
    _pulledView = nil;
}

- (void)setPulledViewPresented:(BOOL)pulledViewPresented{
    if (!pulledViewPresented) {
        [self destroyPulledView];
    }
    _pulledView.frame = [self pulledViewFrameWithPresented:pulledViewPresented];
    _pulledViewPresented = pulledViewPresented;
}

- (void)setPullViewPresented:(BOOL)pullViewPresented animated:(BOOL)animated{
    if (animated) {
        if (pullViewPresented && _pulledView == nil) [self createPulledView];
        void(^animations)(void) = ^(void){
            if (pullViewPresented) {
                CGPoint center = _topBar.center;
                center.y = CGRectGetHeight(self.view.bounds) + CGRectGetMidY(_topBar.bounds);
                _topBar.center = center;
            } else {
                _topBar.frame = [self topBarFrameWithHidding:NO];
            }
            _pulledView.frame = [self pulledViewFrameWithPresented:pullViewPresented];
        };
        void(^completion)(BOOL) = ^(BOOL finished){
            [self setPulledViewPresented:pullViewPresented];
        };
        [UIView animateWithDuration:0.3f animations:animations completion:completion];
    } else {
        [self setPulledViewPresented:pullViewPresented];
    }
}

@end
