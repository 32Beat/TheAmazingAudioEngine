//
//  AERMSStereoLevels.h
//  TheEngineSample
//
//  Created by 32BT on 24/11/15.
//  Copyright © 2015 A Tasty Pixel. All rights reserved.
//

#import "TheAmazingAudioEngine.h"
#import "rmslevels.h"
#import "RMSTimer.h"
#import "RMSStereoView.h"

@interface AERMSStereoLevels : NSObject <AEAudioReceiver, RMSTimerProtocol>

@property (nonatomic) IBOutlet RMSStereoView *view;

- (void) startUpdating;
- (void) stopUpdating;

@end
