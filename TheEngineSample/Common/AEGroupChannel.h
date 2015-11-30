//
//  AEGroupChannel.h
//  TheEngineSample
//
//  Created by 32BT on 30/11/15.
//  Copyright © 2015 A Tasty Pixel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TheAmazingAudioEngine.h"

@interface AEGroupChannel : NSObject <AEAudioPlayable>

@property (nonatomic, readonly, assign) AEChannelGroupRef groupRef;

- (instancetype) initWithAudioController:(AEAudioController *)audioController;
- (instancetype) initWithGroupRef:(AEChannelGroupRef)groupRef;
- (void) addChannels:(NSArray*)channels;
- (void) addOutputReceiver:(id<AEAudioReceiver>)receiver;

@end
