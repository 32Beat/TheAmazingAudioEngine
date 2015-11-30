//
//  AEGroupChannel.m
//  TheEngineSample
//
//  Created by 32BT on 30/11/15.
//  Copyright © 2015 A Tasty Pixel. All rights reserved.
//

#import "AEGroupChannel.h"

@interface AEGroupChannel ()
{
//	AEChannelGroupRef _groupRef;
}
@end

@implementation AEGroupChannel

- (instancetype) initWithAudioController:(AEAudioController *)audioController
{
	return [self initWithGroupRef:[audioController createChannelGroup]];
}

- (instancetype) initWithGroupRef:(AEChannelGroupRef)groupRef
{
	self = [super init];
	if (self != nil)
	{
		_groupRef = groupRef;
	}
	
	return self;
}


- (void) addChannels:(NSArray*)channels
{
	AEAudioController *audioController = (__bridge AEAudioController *)
	AEChannelGroupGetAudioController(_groupRef);
	
	[audioController addChannels:channels toChannelGroup:_groupRef];
}

- (void) addOutputReceiver:(id<AEAudioReceiver>)receiver
{
	AEAudioController *audioController = (__bridge AEAudioController *)
	AEChannelGroupGetAudioController(_groupRef);
	
	[audioController addOutputReceiver:receiver forChannelGroup:_groupRef];
}



static OSStatus renderCallback(
	__unsafe_unretained 	AEGroupChannel *THIS,
	__unsafe_unretained 	AEAudioController *audioController,
	const AudioTimeStamp 	*time,
	UInt32 					frames,
	AudioBufferList 		*audio)
{
	AEChannelGroupRef group = THIS->_groupRef;
	if (group == nil) return paramErr;
	
	AudioUnit audioUnit = AEChannelGroupGetAudioUnit(group);
	if (audioUnit == nil) return paramErr;
		
	// Tell mixer/mixer's converter unit to render into audio
	return AudioUnitRender(audioUnit, nil, time, 0, frames, audio);
}

-(AEAudioRenderCallback)renderCallback {
return renderCallback;
}

@end
