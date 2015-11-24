//
//  AERMSStereoLevels.m
//  TheEngineSample
//
//  Created by 32BT on 24/11/15.
//  Copyright © 2015 A Tasty Pixel. All rights reserved.
//

#import "AERMSStereoLevels.h"
#import "RMSStereoView.h"


@interface AERMSStereoLevels ()
{
	Float64 mSampleRate;
	rmsengine_t mEngineL;
	rmsengine_t mEngineR;
}
@end


////////////////////////////////////////////////////////////////////////////////
@implementation AERMSStereoLevels
////////////////////////////////////////////////////////////////////////////////

-(AEAudioReceiverCallback)receiverCallback
{ return &audioCallback; }

////////////////////////////////////////////////////////////////////////////////

static void audioCallback(__unsafe_unretained AERMSStereoLevels *THIS,
                          __unsafe_unretained AEAudioController *audioController,
                          void *source,
                          const AudioTimeStamp *time,
                          UInt32 frames,
                          AudioBufferList *audio)
{
	// (re)initialize engines if necessary
	Float64 sampleRate = audioController.audioDescription.mSampleRate;
	if (THIS->mSampleRate != sampleRate)
	{
		THIS->mSampleRate = sampleRate;
		THIS->mEngineL = RMSEngineInit(sampleRate);
		THIS->mEngineR = RMSEngineInit(sampleRate);
	}

	// Process first output buffer through left engine
	if (audio->mNumberBuffers > 0)
	{
		Float32 *srcPtr = audio->mBuffers[0].mData;
		RMSEngineAddSamples32(&THIS->mEngineL, srcPtr, frames);
	}
	
	// Process second output buffer through right engine
	if (audio->mNumberBuffers > 1)
	{
		Float32 *srcPtr = audio->mBuffers[1].mData;
		RMSEngineAddSamples32(&THIS->mEngineR, srcPtr, frames);
	}
}

////////////////////////////////////////////////////////////////////////////////
/*
	If there is any advantage to multithreaded processing, 
	then this isn't it according to TAAE_REPORT_RENDER_TIME
	
	if (audio->mNumberBuffers > 1)
	{
		dispatch_queue_t globalQueue = dispatch_get_global_queue \
		(QOS_CLASS_USER_INITIATED, DISPATCH_QUEUE_PRIORITY_HIGH);

		// Get current and global queue
		dispatch_queue_t currentQueue = dispatch_get_current_queue();
 
		// Make sure this isn't the global queue
		if (currentQueue != globalQueue)

			// dispatch for each channel
			dispatch_apply(audio->mNumberBuffers, globalQueue,
			
			^(size_t index)
			{
				Float32 *srcPtr = audio->mBuffers[index].mData;
				rmsengine_t *enginePtr = index == 0 ?
				&THIS->mEngineL:
				&THIS->mEngineR;

				RMSEngineAddSamples32(enginePtr, srcPtr, frames);
			});
		
	}
*/
////////////////////////////////////////////////////////////////////////////////

- (void) setView:(RMSStereoView *)view
{
	if (_view != view)
	{
		_view = view;
		view.enginePtrL = &mEngineL;
		view.enginePtrR = &mEngineR;
	}
}

////////////////////////////////////////////////////////////////////////////////

- (void) startUpdating
{ [RMSTimer addRMSTimerObserver:self]; }

- (void) stopUpdating
{ [RMSTimer removeRMSTimerObserver:self]; }

- (void) globalRMSTimerDidFire
{ [_view updateLevels]; }

////////////////////////////////////////////////////////////////////////////////
@end
////////////////////////////////////////////////////////////////////////////////
