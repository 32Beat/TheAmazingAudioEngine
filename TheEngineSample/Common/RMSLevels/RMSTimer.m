////////////////////////////////////////////////////////////////////////////////
/*
	RMSTimerView.m
	
	Created by 32BT on 15/11/15.
	Copyright © 2015 32BT. All rights reserved.
*/
////////////////////////////////////////////////////////////////////////////////

#import "RMSTimer.h"


@interface RMSTimer ()
{
	NSTimer *mTimer;
	NSMutableArray *mObservers;
}
@end



@implementation RMSTimer

////////////////////////////////////////////////////////////////////////////////

+ (instancetype) globalTimer
{
	static RMSTimer *timer = nil;
	if (timer == nil)
	{
		timer = [RMSTimer new];
	}
	
	return timer;
}

////////////////////////////////////////////////////////////////////////////////

+ (void) addRMSTimerObserver:(id<RMSTimerProtocol>)observer
{ [[self globalTimer] addRMSTimerObserver:observer]; }

+ (void) removeRMSTimerObserver:(id<RMSTimerProtocol>)observer
{ [[self globalTimer] removeRMSTimerObserver:observer]; }

////////////////////////////////////////////////////////////////////////////////
#pragma mark
#pragma mark Observer Management
////////////////////////////////////////////////////////////////////////////////

- (NSMutableArray *) observers
{
	if (mObservers == nil)
	{ mObservers = [NSMutableArray new]; }
	return mObservers;
}

////////////////////////////////////////////////////////////////////////////////

- (void) addRMSTimerObserver:(id<RMSTimerProtocol>)observer
{
	if ([observer respondsToSelector:@selector(globalRMSTimerDidFire)])
	{
		[self.observers addObject:observer];
		if (self.observers.count != 0)
		{ [self startTimer]; }
	}
}

////////////////////////////////////////////////////////////////////////////////

- (void) removeRMSTimerObserver:(id)observer
{
	[mObservers removeObject:observer];
}

////////////////////////////////////////////////////////////////////////////////
#pragma mark
#pragma mark Timer Management
////////////////////////////////////////////////////////////////////////////////

- (void) startTimer
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

- (void) stopTimer
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
	if (self.observers.count == 0)
		[self stopTimer];
	else
		[self.observers makeObjectsPerformSelector:
		@selector(globalRMSTimerDidFire)];
}

////////////////////////////////////////////////////////////////////////////////



////////////////////////////////////////////////////////////////////////////////



////////////////////////////////////////////////////////////////////////////////

@end







