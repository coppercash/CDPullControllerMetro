//
//  CDPullBottomBar.h
//  CDPullControllerMetro
//
//  Created by William Remaerd on 1/24/13.
//  Copyright (c) 2013 Coder Dreamer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CDMetroCell.h"
#import "CDProgress.h"

#define kLabelsUpdateTimes 10
#define kProgressViewUpdateTimes 5
//#define kXMargin 0.0f
//#define kYMargin kXMargin
#define kGap 3.0f
@class CDMasterButton, CDProgressView, CDMetroCell, CDTimeLableView;
@protocol CDPullBottomBarDataSource, CDPullBottomBarDelegate;
@interface CDPullBottomBar : UIView <CDMetroCellDelegate, CDAudioProgressDelegate, CDProgressDelegate>{
    CDMasterButton *_masterButton;
    CDProgressView *_progressView;
    CDTimeLableView *_timeLabel;
    NSMutableArray *_cells;
    
    float _scale;
    NSTimeInterval _presentDuration;
    NSTimeInterval _dismissDuration;
    BOOL _isPresented;
    
    __weak id<CDPullBottomBarDataSource> _dataSource;
    __weak id<CDPullBottomBarDelegate> _delegate;
    
    UIColor *_metroColor;
}
@property(nonatomic, readonly)CDMasterButton *masterButton;
@property(nonatomic, readonly)CDProgressView *progressView;
@property(nonatomic, readonly)NSArray *cells;
@property(nonatomic, assign)float scale;
@property(nonatomic, assign)NSTimeInterval presentDuration;
@property(nonatomic, assign)NSTimeInterval dismissDuration;
@property(nonatomic, weak)id<CDPullBottomBarDataSource> dataSource;
@property(nonatomic, weak)id<CDPullBottomBarDelegate> delegate;
@property(nonatomic, readonly)BOOL isPresented;

- (void)presentAnimated:(BOOL)animated;
- (void)dismissAnimated:(BOOL)animated;

- (CDTimeLableView *)presentTimeLabelCell:(BOOL)animated;
- (void)dismissTimeLabelCell:(BOOL)animated;
- (BOOL)isTimeLabelPresented;

- (void)setRepeatRanege:(CDDoubleRange)range withDuration:(NSTimeInterval)duration;
- (void)cleanRepeatRange;

- (void)reloadData;

@end

@protocol CDPullBottomBarDelegate <NSObject>
@optional
- (void)bottomBar:(CDPullBottomBar *)bottomBar touchCellAtIndex:(NSUInteger)index;
- (void)bottomBarWillPresent:(CDPullBottomBar *)bottomBar;
- (void)bottomBar:(CDPullBottomBar*)bottomButton sliderValueChangedAs:(float)sliderValue;
@end

@protocol CDPullBottomBarDataSource <NSObject>
@required
- (CDMetroCell *)bottomBar:(CDPullBottomBar *)bottomBar cellAtIndex:(NSUInteger)index boundIn:(CGRect)frame;
- (NSUInteger)numberOfCellsInBottomBar:(CDPullBottomBar *)bottomBar;
@optional
- (NSTimeInterval)bottomBarAskForDuration:(CDPullBottomBar*)bottomButton;
@end