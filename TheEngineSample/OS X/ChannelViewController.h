//
//  ChannelViewController.h
//  TheEngineSample
//
//  Created by 32BT on 24/11/15.
//  Copyright © 2015 A Tasty Pixel. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "AEAudioController.h"
#import "RMSTimer.h"

@interface ChannelViewController : NSViewController <RMSTimerProtocol>

- (instancetype) initWithAudioController:(AEAudioController *)audioController
					channel:(id<AEAudioPlayable>)channel;

- (void) setButtonTitle:(NSString *)str;

@end
