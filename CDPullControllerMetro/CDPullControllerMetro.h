//
//  CDPullControllerMetro.h
//  CDPullControllerMetro
//
//  Created by William Remaerd on 1/24/13.
//  Copyright (c) 2013 Coder Dreamer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CDPullTopBar.h"
#import "CDPullBottomBar.h"

#define kHiddingAniamtionDuration 0.3f
#define kStatusBarHeight 20.0f
#define kTopBarHeight 38.0f
#define kBottimBarHeight 62.0f
#define kGap 3.0f
#define kMargin 7.85f
#define kMarginSecondary 4.85f

@interface CDPullControllerMetro : UIViewController <CDPullTopBarDelegate, CDPullTopBarDataSource, CDPullBottomBarDataSource, CDPullBottomBarDelegate>{
    BOOL _barsHidden;
    BOOL _pulledViewPresented;
    UIView *_pulledView;
    CDPullTopBar *_topBar;
    CDPullBottomBar *_bottomBar;
}
@property(nonatomic, readonly)UIView *pulledView;
@property(nonatomic, readonly)CDPullTopBar *topBar;
@property(nonatomic, readonly)CDPullBottomBar *bottomBar;

- (void)endOfViewDidLoad;
- (void)createPulledView;
- (void)destroyPulledView;
- (void)setBarsHidden:(BOOL)barsHidden animated:(BOOL)animated;
- (void)setPullViewPresented:(BOOL)pullViewPresented animated:(BOOL)animated;
- (void)presentTopBarAnimated:(BOOL)animated;
@end
