//
//  ViewController.m
//  CDPullControllerMetroDemo
//
//  Created by William Remaerd on 1/24/13.
//  Copyright (c) 2013 Coder Dreamer. All rights reserved.
//

#import "ViewController.h"
#import "CDPullTopBar.h"
#import "CDCategories.h"
#import "CDMetroView.h"
#import "CDProgressView.h"
#import "CDMasterButton.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor darkGrayColor];
    _bottomBar.backgroundColor = [UIColor blueColor];
    
    self.wantsFullScreenLayout = YES;
    
    UIButton *button0 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button0 addTarget:self action:@selector(button0Clicked:) forControlEvents:UIControlEventTouchUpInside];
    button0.frame = CGRectMake(10.0f, 70.0f, 40.0f, 40.0f);
    [self.view addSubview:button0];
    
    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button1 addTarget:self action:@selector(button1Clicked:) forControlEvents:UIControlEventTouchUpInside];
    button1.frame = CGRectMake(CGRectGetMaxX(button0.frame) + 10.0f, CGRectGetMinY(button0.frame), CGRectGetWidth(button0.frame), CGRectGetHeight(button0.frame));
    [self.view addSubview:button1];

    UIButton *button2 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button2 addTarget:self action:@selector(button2Clicked:) forControlEvents:UIControlEventTouchUpInside];
    button2.frame = CGRectMake(CGRectGetMaxX(button1.frame) + 10.0f, CGRectGetMinY(button0.frame), CGRectGetWidth(button0.frame), CGRectGetHeight(button0.frame));
    [self.view addSubview:button2];

    UIButton *button3 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button3 addTarget:self action:@selector(button3Clicked:) forControlEvents:UIControlEventTouchUpInside];
    button3.frame = CGRectMake(CGRectGetMaxX(button2.frame) + 10.0f, CGRectGetMinY(button0.frame), CGRectGetWidth(button0.frame), CGRectGetHeight(button0.frame));
    [self.view addSubview:button3];

    UIButton *button4 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button4 addTarget:self action:@selector(button4Clicked:) forControlEvents:UIControlEventTouchUpInside];
    button4.frame = CGRectMake(CGRectGetMaxX(button3.frame) + 10.0f, CGRectGetMinY(button0.frame), CGRectGetWidth(button0.frame), CGRectGetHeight(button0.frame));
    [self.view addSubview:button4];

    UIButton *button5 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button5 addTarget:self action:@selector(button5Clicked:) forControlEvents:UIControlEventTouchUpInside];
    button5.frame = CGRectMake(CGRectGetMaxX(button4.frame) + 10.0f, CGRectGetMinY(button0.frame), CGRectGetWidth(button0.frame), CGRectGetHeight(button0.frame));
    [self.view addSubview:button5];

    
    _metro0 = [[CDMetroView alloc] initWithFrame:CGRectMake(10.0f, 150.0f, 90.0f, 90.0f)];
    _metro0.backgroundColor = [UIColor blueColor];
    [self.view addSubview:_metro0];
    
    _presentDraw = [[CDMasterPresentDraw alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_metro0.frame) + 10, CGRectGetMinY(_metro0.frame), 90.0f, 90.0f)];
    //_presentDraw.shorterInset = 10.0f;
    [self.view addSubview:_presentDraw];
    _presentDraw.progress = 0.0815742;
    [_presentDraw setRange:CDMakeFloatRange(0.0209435, 0.0703111)];
    //_presentDraw.progress = 0.4f;
    //[_presentDraw setRange:CDMakeProgressRange(0.3, 0.3)];
    
    _playerDraw = [[CDMasterPlayerDraw alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_presentDraw.frame) + 10, CGRectGetMinY(_metro0.frame), 90.0f, 90.0f)];
    [self.view addSubview:_playerDraw];

    _back = [[CDBackwardDraw alloc] initWithFrame:CGRectMake(10.0f, 250.0f, 90.0f, 90.0f)];
    [self.view addSubview:_back];

    _for = [[CDForwardDraw alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_back.frame) + 10, 250.0f, 90.0f, 90.0f)];
    [self.view addSubview:_for];

    _master = [[CDMasterButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_for.frame) + 10, 250.0f, 90.0f, 90.0f)];
    [self.view addSubview:_master];
    
    _progressDraw = [[CDProgressDraw alloc] initWithFrame:CGRectMake(10.0f, 360.0f, 300.0f, 40.0f)];
    [self.view addSubview:_progressDraw];
    _progressDraw.progress = 0.4f;
    [_progressDraw setRange:CDMakeFloatRange(0.3, 0.3)];

    
    [self endOfViewDidLoad];
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - CDPullTopBarDataSource
- (NSString*)topBarLabel:(CDPullTopBar *)topBar textAtIndex:(NSUInteger)index{
    switch (index) {
        case 0:
            return @"CDPullViewController CDPullViewControllerrr";
            break;
        case 1:
            return @"CDPullViewController CDPullViewController CDPullViewController";
            break;
        case 2:
            return @"rtt";
            break;
        default:
            break;
    }
    return @"CDPullViewController CDPullViewController CDPullViewController";
}

#pragma mark - Test
- (void)button0Clicked:(id)sender{
    DLogCurrentMethod;
    [self setBarsHidden:!_barsHidden animated:YES];

}

- (void)button1Clicked:(id)sender{
    DLogCurrentMethod;
    CDDirection direction = CDDirectionNone;
    static int index = 0;
    switch (index) {
        case 0:{
            direction = CDDirectionNone;
            if (_metro0.isPresented) index = 1;
        }break;
        case 1:{
            direction = CDDirectionLeft;
            if (_metro0.isPresented) index = 2;
        }break;
        case 2:{
            direction = CDDirectionRight;
            if (_metro0.isPresented) index = 3;
        }break;
        case 3:{
            direction = CDDirectionUp;
            if (_metro0.isPresented) index = 4;
        }break;
        case 4:{
            direction = CDDirectionDown;
            if (_metro0.isPresented) index = 0;
        }break;
        default:
            break;
    }
    if (_metro0.isPresented) {
        [_metro0 dismissTo:direction];
    }else{
        [_metro0 presentFrom:direction];
    }
}

- (void)button2Clicked:(id)sender{
    if (_bottomBar.isPresented) {
        [_bottomBar dismissAnimated:YES];
    }else{
        [_bottomBar presentAnimated:YES];
    }
}

- (void)button3Clicked:(id)sender{
    if (_bottomBar.isTimeLabelPresented) {
        [_bottomBar dismissTimeLabelCell:YES];
    }else{
        [_bottomBar presentTimeLabelCell:YES];
    }
}

- (void)button4Clicked:(id)sender{
    _playerDraw.isPlaying = !_playerDraw.isPlaying;
}

- (void)button5Clicked:(id)sender{
    if (_master.isPresented) {
        [_master dismissAnimated:YES];
    }else{
        [_master presentAnimated:YES];
    }
}

@end
