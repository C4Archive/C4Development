//
//  C4DevelopmentAppDelegate.m
//  C4Development
//
//  Created by moi on 11-04-05.
//  Copyright 2011 mediart. All rights reserved.
//

#import "C4DevelopmentAppDelegate.h"

@implementation C4DevelopmentAppDelegate

@synthesize window;
+(void)load {
	if(VERBOSELOAD) printf("C4DevelopmentAppDelegate\n");
}

- (void)awakeFromNib {
}

-(void)applicationWillFinishLaunching:(NSNotification *)notification {
	[_C4Canvas setupRect];
}

@end





