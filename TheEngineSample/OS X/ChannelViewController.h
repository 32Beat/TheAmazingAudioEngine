//
//  ChannelViewController.h
//  TheEngineSample
//
//  Created by 32BT on 24/11/15.
//  Copyright © 2015 A Tasty Pixel. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "AEAudioController.h"

@interface ChannelViewController : NSViewController

- (instancetype) initWithAudioController:(AEAudioController *)audioController
					channel:(id<AEAudioPlayable>)channel;

@end
