////////////////////////////////////////////////////////////////////////////////
/*
	RMSTimerView.m
	
	Created by 32BT on 15/11/15.
	Copyright © 2015 32BT. All rights reserved.
*/
////////////////////////////////////////////////////////////////////////////////

#import "RMSTimerView.h"


@interface RMSTimerView ()
{
	// Update timer
	NSTimer *mTimer;
}
@end

////////////////////////////////////////////////////////////////////////////////
@implementation RMSTimerView
////////////////////////////////////////////////////////////////////////////////

- (void) startUpdating
{
	if (mTimer == nil)
	{
		// set timer to appr 25 updates per second
		mTimer = [NSTimer timerWithTimeInterval:1.0/25.0
		target:self selector:@selector(timerDidFire:) userInfo:nil repeats:YES];
		
		// add tolerance down to appr 20 updates per second
		[mTimer setTolerance:(1.0/20.0)-(1.0/25.0)];
		
		// add to runloop
		[[NSRunLoop currentRunLoop] addTimer:mTimer forMode:NSRunLoopCommonModes];
		
		/*
			Note that a scheduledTimer will only run in default runloopmode,
			which means it doesn't fire during tracking or modal panels, etc...
		*/
	}
}

////////////////////////////////////////////////////////////////////////////////

- (void) stopUpdating
{
	if (mTimer != nil)
	{
		[mTimer invalidate];
		mTimer = nil;
	}
}

////////////////////////////////////////////////////////////////////////////////

- (void) timerDidFire:(NSTimer *)timer
{
	NSLog(@"%@", @"timerDidFire not implemented");
	[self stopUpdating];
}

////////////////////////////////////////////////////////////////////////////////
@end
////////////////////////////////////////////////////////////////////////////////






