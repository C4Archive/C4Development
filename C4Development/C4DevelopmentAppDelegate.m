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
	/* create instances of singletons */
	cfaOpenGLView	= [[[CFAOpenGLView alloc] init] retain];
	cfaDateTime		= [[[CFADateTime alloc] init] retain];
	cfaFoundation	= [[[CFAFoundation alloc] init] retain];
	cfaMath			= [[[CFAMath alloc] init] retain];
	cfaShape		= [[[CFAShape alloc] init] retain];
	cfaTransform	= [[[CFATransform alloc] init] retain];
	cfaGlobalTypeAttributes = [[[CFAGlobalTypeAttributes alloc] init] retain];
	cfaGlobalStringAttributes = [[[CFAGlobalStringAttributes alloc] init] retain];
	cfaGlobalShapeAttributes = [[[CFAGlobalShapeAttributes alloc] init] retain];
}

-(void)applicationWillFinishLaunching:(NSNotification *)notification {
	[cfaCanvas setupRect];
}

@end





