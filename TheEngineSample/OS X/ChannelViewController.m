//
//  ChannelViewController.m
//  TheEngineSample
//
//  Created by 32BT on 24/11/15.
//  Copyright © 2015 A Tasty Pixel. All rights reserved.
//

#import "ChannelViewController.h"
#import "AERMSStereoLevels.h"

@interface ChannelViewController ()
{
	id<AEAudioPlayable> mChannel;
}

@property (nonatomic, assign) AEAudioController *audioController;

// Interface elements
@property (nonatomic, assign) IBOutlet AERMSStereoLevels *stereoLevels;
@property (nonatomic, assign) IBOutlet NSButton *playButton;
@property (nonatomic, assign) IBOutlet NSSlider *volumeSlider;

@end

@implementation ChannelViewController

- (instancetype) initWithAudioController:(AEAudioController *)audioController
					channel:(id<AEAudioPlayable>)channel
{
	self = [super init];
	if (self != nil)
	{
		self.audioController = audioController;
		mChannel = channel;
	}
	return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do view setup here.
	
	if (mChannel.channelIsMuted == YES)
		self.playButton.state = NSOffState;
	else
		self.playButton.state = NSOnState;
	
	self.volumeSlider.floatValue = mChannel.volume;
	
	[self.audioController addOutputReceiver:self.stereoLevels forChannel:mChannel];
}

- (void) viewWillAppear
{
	[super viewWillAppear];
	[self.stereoLevels startUpdating];
}

- (void) viewWillDisappear
{
	[self.stereoLevels stopUpdating];
	[super viewWillDisappear];
}


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




