//
//  CDPullTopbarMetro.h
//  CDPullControllerMetro
//
//  Created by William Remaerd on 1/24/13.
//  Copyright (c) 2013 Coder Dreamer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CDTypes.h"
#import "CDScrollLabel.h"
#import "CDPullBottomBar.h"

@protocol CDPullTopBarDelegate, CDPullTopBarDataSource;
@class CDInfoPad, CDStateButton;
@interface CDPullTopBar : UIControl {
    CDDirection _startDirection;
    CDDirection _currentDirection;
    CGPoint _lastPoint;
    
    CDInfoPad* _infoPad;
    UIButton* _leftButton;
    UIButton* _rightButton;
    
    __weak id<CDPullTopBarDelegate> _delegate;
    __weak id<CDPullTopBarDataSource> _dataSource;
    __weak UIView *_stableView;
}
@property(nonatomic, weak)id<CDPullTopBarDelegate> delegate;
@property(nonatomic, weak)id<CDPullTopBarDataSource> dataSource;
@property(nonatomic, weak)UIView *stableView;
@property(nonatomic, readonly)UIButton *leftButton;
@property(nonatomic, readonly)UIButton *rightButton;
- (void)setTitleText:(NSString *)text;  //This temp in HoldLanguages 3.0
- (void)reloadData;
@end

@protocol CDPullTopBarDelegate <NSObject>
@optional
- (void)topBarStartPulling:(CDPullTopBar*)topBar onDirection:(CDDirection)direction;
- (CGFloat)topBarContinuePulling:(CDPullTopBar*)topBar onDirection:(CDDirection)direction shouldMove:(CGFloat)increment;
- (void)topBarFinishPulling:(CDPullTopBar*)topBar onDirection:(CDDirection)direction;
- (void)topBarCancelPulling:(CDPullTopBar*)topBar onDirection:(CDDirection)direction;
- (void)topBar:(CDPullTopBar*)topBar buttonTouched:(NSUInteger)position;
@end

@protocol CDPullTopBarDataSource <NSObject>
@optional
- (NSString*)topBarLabel:(CDPullTopBar*)topBar textAtIndex:(NSUInteger)index;
@end

@class CDScrollLabel;
@interface CDInfoPad : UIView <CDScrollLabelDelegate>
@property(nonatomic, strong)IBOutlet CDScrollLabel* artist;
@property(nonatomic, strong)IBOutlet CDScrollLabel* title;
@property(nonatomic, strong)IBOutlet CDScrollLabel* albumTitle;
@end