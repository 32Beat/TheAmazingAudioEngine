//
//  ViewController.h
//  TheEngineSample
//
//  Created by Steve Rubin on 8/5/15.
//  Copyright (c) 2015 A Tasty Pixel. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "RMSBalanceView.h"
#import "RMSIndexView.h"


@class AEAudioController;

@interface ViewController : NSViewController <NSTableViewDataSource, NSTableViewDelegate>

@property (nonatomic, assign) IBOutlet RMSBalanceView *balanceView;
@property (nonatomic, assign) IBOutlet RMSIndexView *indexViewL;
@property (nonatomic, assign) IBOutlet RMSIndexView *indexViewR;

@property (nonatomic, assign) IBOutlet NSView *groupView;

- (instancetype)initWithAudioController:(AEAudioController *)audioController;

@end
