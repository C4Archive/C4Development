//
//  CFAQuartz.m
//  C4
//
//  Created by moi on 11-06-24.
//  Copyright 2011 mediart. All rights reserved.
//

#import "CFAQuartz.h"
@interface CFAQuartz() {}
-(void)receiveMouseNotification:(NSNotification *)notification;
@end

@implementation CFAQuartz

+(CFAQuartz *)patchWithName:(id)patchName {
    return [[[CFAQuartz alloc] initWithPatchName:patchName] retain];
}

-(id)initWithPatchName:(id)patchName {
    self = [super init];
    if (self) {
        patchArguments = [[[NSMutableDictionary alloc] initWithCapacity:0] retain];

        NSString *compositionPath = [[NSBundle mainBundle] pathForResource:[CFAString nsStringFromObject:patchName] ofType:@"qtz"];
        patchRenderer = [[[QCRenderer alloc] initWithOpenGLContext:[CFACanvas sharedManager].openGLContext
                                                       pixelFormat:[CFACanvas sharedManager].pixelFormat
                                                              file:compositionPath] retain];
        
        [self listenFor:MOUSEPRESSED andRunMethod:@"receiveMouseNotification:"];
    }
    return self;
}

- (id)init
{
    self = [super init];
    if (self) {
        patchArguments = [[[NSMutableDictionary alloc] initWithCapacity:0] retain];
        
        NSString *compositionPath = [[NSBundle mainBundle] pathForResource:@"C4" ofType:@"qtz"];
        patchRenderer = [[[QCRenderer alloc] initWithOpenGLContext:[[CFACanvas sharedManager] openGLContext]
                                                       pixelFormat:[[CFACanvas sharedManager] pixelFormat]
                                                              file:compositionPath] retain];

        [self listenFor:MOUSEPRESSED andRunMethod:@"receiveMouseNotification:"];
    }
    
    return self;
}

- (void)dealloc
{
    [patchArguments release];
    [patchRenderer release];
    [super dealloc];
}

-(void)render {
    [patchRenderer renderAtTime:[NSDate timeIntervalSinceReferenceDate] arguments:patchArguments];
}

-(void)renderWithArguments:(NSDictionary *)arguments {
    [patchRenderer renderAtTime:[NSDate timeIntervalSinceReferenceDate] arguments:patchArguments];
}

-(void)receiveMouseNotification:(NSNotification *)notification {
    NSEvent *theEvent = [[notification userInfo] objectForKey:@"mouseEvent"];
    
    [patchArguments setObject:theEvent forKey:QCRendererEventKey];
    
    NSPoint p = [theEvent locationInWindow];
    p.x /= [[notification object] canvasWidth];
    p.y /= [[notification object] canvasHeight];
    
    [patchArguments setObject:[NSValue valueWithPoint:p] forKey:QCRendererMouseLocationKey];
}
@end