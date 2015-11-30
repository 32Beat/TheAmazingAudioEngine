//
//  ChannelViewController.m
//  TheEngineSample
//
//  Created by 32BT on 24/11/15.
//  Copyright © 2015 A Tasty Pixel. All rights reserved.
//

#import "ChannelViewController.h"
#import "AERMSStereoLevels.h"
#import "AEGroupChannel.h"

@interface ChannelViewController ()
{
	id<AEAudioPlayable> mChannel;
}

@property (nonatomic, assign, readonly) AEAudioController *audioController;

// Interface elements
@property (nonatomic, assign) IBOutlet AERMSStereoLevels *stereoLevels;
@property (nonatomic, assign) IBOutlet NSButton *playButton;
@property (nonatomic, assign) IBOutlet NSSlider *volumeSlider;

@end

////////////////////////////////////////////////////////////////////////////////
@implementation ChannelViewController
////////////////////////////////////////////////////////////////////////////////

- (instancetype) initWithAudioController:(AEAudioController *)audioController
					channel:(id<AEAudioPlayable>)channel
{
	self = [super init];
	if (self != nil)
	{
		_audioController = audioController;
		mChannel = channel;
	}
	return self;
}

////////////////////////////////////////////////////////////////////////////////

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do view setup here.
	
	if ([mChannel isKindOfClass:[AEGroupChannel class]])
		[(id)mChannel addOutputReceiver:self.stereoLevels];
	else
		[self.audioController addOutputReceiver:self.stereoLevels forChannel:mChannel];

	[self updateButton];
	[self updateVolume];
	[self updateLevels];
}

////////////////////////////////////////////////////////////////////////////////

- (void) viewWillAppear
{
	[super viewWillAppear];
	[RMSTimer addRMSTimerObserver:self];
}

////////////////////////////////////////////////////////////////////////////////

- (void) viewWillDisappear
{
	[RMSTimer removeRMSTimerObserver:self];
	[super viewWillDisappear];
}

////////////////////////////////////////////////////////////////////////////////
/*
	We are using the global timer for GUI updating as well, 
	since KVO just adds a lot of unnecessary overhead.
*/

- (void) globalRMSTimerDidFire
{
	[self updateButton];
	[self updateVolume];
	[self updateLevels];
}

////////////////////////////////////////////////////////////////////////////////
#pragma mark
////////////////////////////////////////////////////////////////////////////////

- (void) updateButton
{
	// Default to on
	NSInteger state = NSOnState;
	
	if ([mChannel respondsToSelector:@selector(channelIsMuted)])
	{
		state = mChannel.channelIsMuted ? NSOffState : NSOnState;
	}

	if (self.playButton.state != state)
	{ self.playButton.state = state; }
}

- (void) updateLevels
{
	[self.stereoLevels.view updateLevels];
}

- (void) updateVolume
{
	if ([mChannel respondsToSelector:@selector(volume)])
	{
		if (self.volumeSlider.floatValue != mChannel.volume)
		{ self.volumeSlider.floatValue = mChannel.volume; }
	}
}

////////////////////////////////////////////////////////////////////////////////

- (void) setButtonTitle:(NSString *)str
{ self.playButton.title = str; }

- (IBAction) didAdjustButton:(NSButton *)button
{
	if ([mChannel respondsToSelector:@selector(setChannelIsMuted:)])
	[(id)mChannel setChannelIsMuted:(button.state == NSOffState)];
}

- (IBAction) didAdjustSlider:(NSSlider *)slider
{
	if ([mChannel respondsToSelector:@selector(setVolume:)])
	[(id)mChannel setVolume:slider.floatValue];
}

@end




