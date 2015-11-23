//
//  ViewController.h
//  TheEngineSample
//
//  Created by Steve Rubin on 8/5/15.
//  Copyright (c) 2015 A Tasty Pixel. All rights reserved.
//

#import <Cocoa/Cocoa.h>


#import "AERMSStereoView.h"
#import "AERMSBalanceView.h"
#import "RMSIndexView.h"

@class AEAudioController;

@interface ViewController : NSViewController <NSTableViewDataSource, NSTableViewDelegate>

@property (nonatomic, assign) IBOutlet AERMSBalanceView *balanceView;
@property (nonatomic, assign) IBOutlet RMSIndexView *indexViewL;
@property (nonatomic, assign) IBOutlet RMSIndexView *indexViewR;

@property (nonatomic, assign) IBOutlet AERMSStereoView *drumLoopRMSView;
@property (nonatomic, assign) IBOutlet AERMSStereoView *organLoopRMSView;
@property (nonatomic, assign) IBOutlet AERMSStereoView *oscillatorRMSView;


@property (nonatomic, assign) IBOutlet NSButton *drumLoopButton;
@property (nonatomic, assign) IBOutlet NSButton *organLoopButton;
@property (nonatomic, assign) IBOutlet NSButton *oscillatorButton;

- (instancetype)initWithAudioController:(AEAudioController *)audioController;

@end
