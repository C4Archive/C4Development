//
//  CFATransform.h
//  Created by Travis Kirton
//

#import <Cocoa/Cocoa.h>
#import "CFACanvas.h"

@interface CFATransform : CFAObject {
	@private
	NSMutableArray *transformArray;
}

-(id)_init;
-(void)_dealloc;
+(CFATransform *)sharedManager;

+(void)begin;
+(void)concat;
+(void)end;

+(void)translateBy:(NSPoint)point;
+(void)translateByX:(CGFloat)x andY:(CGFloat)y;
+(void)rotateByAngle:(CGFloat)angle;

-(void)begin;
-(void)concat;
-(void)end;
-(void)translateBy:(NSPoint)p;
-(void)translateByX:(CGFloat)x andY:(CGFloat)y;
-(void)rotateByAngle:(CGFloat)angle;

@property(readwrite,retain) NSMutableArray *transformArray;
@end
