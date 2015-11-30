//
//  ChannelViewController.m
//  TheEngineSample
//
//  Created by 32BT on 24/11/15.
//  Copyright © 2015 A Tasty Pixel. All rights reserved.
//

#import "ChannelViewController.h"
#import "AERMSStereoLevels.h"
#import "AEChannelGroup.h"

@interface ChannelViewController ()
{
	id<AEAudioPlayable> mSource;
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
		mSource = channel;
	}
	return self;
}

////////////////////////////////////////////////////////////////////////////////

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do view setup here.
	
	if ([mSource isKindOfClass:[AEChannelGroup class]])
		[(id)mSource addOutputReceiver:self.stereoLevels];
	else
		[self.audioController addOutputReceiver:self.stereoLevels forChannel:mSource];

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
	// Enable button only if mute is settable
	BOOL enabledState =
	[mSource respondsToSelector:@selector(setChannelIsMuted:)];

	if (self.playButton.enabled != enabledState)
	{ self.playButton.enabled = enabledState; }
	
	// Fetch mute if available, default to ON
	NSInteger switchState =
	[mSource respondsToSelector:@selector(channelIsMuted)] ?
	mSource.channelIsMuted ? NSOffState : NSOnState : NSOnState;
	
	if (self.playButton.state != switchState)
	{ self.playButton.state = switchState; }
}

- (void) updateLevels
{
	[self.stereoLevels.view updateLevels];
}

- (void) updateVolume
{
	// Enable slider only if volume is settable
	BOOL enabledState =
	[mSource respondsToSelector:@selector(setVolume:)];
	
	if (self.volumeSlider.enabled != enabledState)
	{ self.volumeSlider.enabled = enabledState; }
	
	// Fetch volume if available, default to 1.0
	float volume = [mSource respondsToSelector:@selector(volume)] ?
	mSource.volume : 1.0;
	
	if (self.volumeSlider.floatValue != volume)
	{ self.volumeSlider.floatValue = volume; }
}

////////////////////////////////////////////////////////////////////////////////

- (void) setButtonTitle:(NSString *)str
{ self.playButton.title = str; }

- (IBAction) didAdjustButton:(NSButton *)button
{
	if ([mSource respondsToSelector:@selector(setChannelIsMuted:)])
	[(id)mSource setChannelIsMuted:(button.state == NSOffState)];
}

- (IBAction) didAdjustSlider:(NSSlider *)slider
{
	if ([mSource respondsToSelector:@selector(setVolume:)])
	[(id)mSource setVolume:slider.floatValue];
}

@end




