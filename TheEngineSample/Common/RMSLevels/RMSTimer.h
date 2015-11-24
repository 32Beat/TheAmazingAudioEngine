////////////////////////////////////////////////////////////////////////////////
/*
	RMSTimer.h
	
	Created by 32BT on 15/11/15.
	Copyright © 2015 32BT. All rights reserved.
*/
////////////////////////////////////////////////////////////////////////////////

#import <Foundation/Foundation.h>

@protocol RMSTimerProtocol <NSObject>
- (void) globalRMSTimerDidFire;
@end

@interface RMSTimer : NSObject
+ (void) addRMSTimerObserver:(id<RMSTimerProtocol>)observer;
+ (void) removeRMSTimerObserver:(id<RMSTimerProtocol>)observer;
@end
