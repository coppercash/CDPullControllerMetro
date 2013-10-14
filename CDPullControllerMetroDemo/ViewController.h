//
//  ViewController.h
//  CDPullControllerMetroDemo
//
//  Created by William Remaerd on 1/24/13.
//  Copyright (c) 2013 Coder Dreamer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CDPullControllerMetro.h"

@class CDMetroView, CDProgressDraw, CDMasterPresentDraw, CDMasterPlayerDraw, CDBackwardDraw, CDForwardDraw, CDMasterButton;
@interface ViewController : CDPullControllerMetro {
    CDMetroView *_metro0;
    CDMasterPresentDraw *_presentDraw;
    CDMasterPlayerDraw *_playerDraw;
    
    CDBackwardDraw *_back;
    CDForwardDraw *_for;
    CDMasterButton *_master;
    
    CDProgressDraw *_progressDraw;
}

- (void)setBarsHidden:(BOOL)barsHidden animated:(BOOL)animated;

@end
