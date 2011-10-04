//
//  CFATransform.m
//  Created by Travis Kirton
//

#import "CFATransform.h"

static CFATransform *sharedCFATransform = nil;

@implementation CFATransform

@synthesize transformArray;

+(void)load {
	if(VERBOSELOAD) printf("CFATransform\n");
}

+(void)begin{
	[[CFATransform sharedManager] begin];
}

+(void)concat{
	[[CFATransform sharedManager] concat];
}

+(void)end {
	[[CFATransform sharedManager] end];
}

+(void)translateBy:(NSPoint)point {
	[[CFATransform sharedManager] translateBy:point];
}

+(void)translateByX:(CGFloat)x andY:(CGFloat)y {
	[[CFATransform sharedManager] translateByX:x andY:y];
}

+(void)rotateByAngle:(CGFloat)angle {
	[[CFATransform sharedManager] rotateByAngle:angle];
}

-(void)begin{
	[[NSGraphicsContext currentContext] saveGraphicsState];
	[transformArray addObject:[NSAffineTransform transform]];
}

-(void)concat{
	[[transformArray lastObject] concat];
}

-(void)end {
	NSInteger count = [transformArray count];
	if(count > 1) [[transformArray objectAtIndex:count-2] prependTransform:[transformArray lastObject]];
	[transformArray removeLastObject];
	[[NSGraphicsContext currentContext] restoreGraphicsState];
}

-(void)translateBy:(NSPoint)point {
	[[CFATransform sharedManager] translateByX:point.x andY:point.y];
}

-(void)translateByX:(CGFloat)x andY:(CGFloat)y {
	[[transformArray lastObject] translateXBy:x yBy:y];
}

-(void)rotateByAngle:(CGFloat)angle {
	[[transformArray lastObject] rotateByRadians:angle];
}

#pragma mark Singleton

-(id) init
{
    if((self = [super init]))
    {
        transformArray = [[NSMutableArray alloc] initWithCapacity:0];
    }
    
    return self;
}

+ (CFATransform *)sharedManager
{
    if (sharedCFATransform == nil) {
        static dispatch_once_t once;
        dispatch_once(&once, ^ { sharedCFATransform = [[super allocWithZone:NULL] init]; 
        });
        return sharedCFATransform;
    }
    return sharedCFATransform;
}

+ (id)allocWithZone:(NSZone *)zone
{
    return [[self sharedManager] retain];
}

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}

@end
