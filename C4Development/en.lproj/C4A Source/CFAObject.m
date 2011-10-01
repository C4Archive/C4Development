//
//  CFAObject.m
//  C4A
//
//  Created by moi on 11-02-20.
//  Copyright 2011 Travis Kirton. All rights reserved.
//

#import "CFAObject.h"

@interface CFAObject () {}
-(void)checkFrameCountAndUpdate;
@end

@implementation CFAObject

-(void)dealloc {
    [self stopUpdating];
    [updateTimer release];
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	[super dealloc];
}

-(void)listenFor:(NSString *)aNotification andRunMethod:(NSString *)aMethodName{
	[[NSNotificationCenter defaultCenter] addObserver:self selector:NSSelectorFromString(aMethodName) name:aNotification object:nil];
}

-(void)stopListeningFor:(NSString *)aMethodName {
	[[NSNotificationCenter defaultCenter] removeObserver:self name:aMethodName object:nil];
}

-(void)postNotification:(NSString *)aNotification {
	[[NSNotificationCenter defaultCenter] postNotificationName:aNotification object:self];
}

-(void)update {
}

-(void)updateAutomaticallyUsingSeconds:(CGFloat)seconds {
    [self stopUpdating];
    if(seconds > 0.001f) {
        updatingBySeconds = YES;
        updateTimer = [NSTimer timerWithTimeInterval:seconds
                                              target:self
                                            selector:@selector(update)
                                            userInfo:nil
                                             repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:updateTimer forMode:NSDefaultRunLoopMode];
    } else {
        CFALog(@"seconds must be greater than 0");
    }
}

-(void)updateAutomaticallyUsingFrames:(NSInteger)frames {
    [self stopUpdating];
    if(frames >=1) {
        frameCountMeasure = frames;
        updatingByFrames = YES;
        [self listenFor:@"frameCountUpdated" andRunMethod:@"checkFrameCountAndUpdate"];
    } else {
        CFALog(@"frame count must be greater than 1");
    }
}

-(void)stopUpdating {
    if(updatingBySeconds) {
        updatingBySeconds = NO;
        [updateTimer invalidate];
    }
    if(updatingByFrames) {
        updatingByFrames = NO;
        [self stopListeningFor:@"frameCountUpdated"];
    }
}

-(BOOL)isUpdating {
    if(updatingByFrames || updatingBySeconds) return YES;
    return NO;
}

-(void)checkFrameCountAndUpdate {
    int actualFrameCount = (int)[CFACanvas getFrameCount];
    if(actualFrameCount%frameCountMeasure == 0) [self update];
}
@end
