//
//  CFAShape.m
//  Created by Travis Kirton
//

#import "CFAShape.h"

static CFAShape *cfaShape;

@interface CFAShape (private)
+(void)fillColorSet;
+(void)strokeColorSet;
+(void)cgFillColorSet;
+(void)cgStrokeColorSet;
@end

@implementation CFAShape
GENERATE_SINGLETON(CFAShape, cfaShape);

+(void)load {
	if(VERBOSELOAD) printf("CFAShape\n");
}

-(id)_init {
	strokeWidth = 1.0f;
	fillColor =     [[CFAColor colorWithGrey:1] retain];	//white
	strokeColor =   [[CFAColor colorWithGrey:0] retain];	//black
	ellipseMode =   CENTER;
	rectMode =      CORNER;
    
    useFill = YES;
    useStroke = YES;
    checkShape = NO;
    firstPoint	= YES;
    drawShapesToPDF = NO;
    
    rectMode = CORNER;
    ellipseMode = CENTER;
    
    strokeWidth = 0.1f;
    
	return self;
}

-(void)_dealloc {
}

#pragma mark Shapes
+(void)arcWithCenterAt:(NSPoint)p radius:(float)r startAngle:(float)startAngle endAngle:(float)endAngle {
	if([CFAGlobalShapeAttributes sharedManager].useFill == YES) {
		NSBezierPath *arcPath = [NSBezierPath bezierPath];
		[arcPath appendBezierPathWithArcWithCenter:p radius:r startAngle:startAngle endAngle:endAngle];
		[arcPath lineToPoint:p];
		[arcPath closePath];
		[self fillColorSet];
		[arcPath fill];
		if ([CFAGlobalShapeAttributes sharedManager].drawShapesToPDF == YES) {
			[self cgFillColorSet];
			CGContextBeginPath([CFAGlobalShapeAttributes sharedManager].pdfContext);
			CGContextAddArc([CFAGlobalShapeAttributes sharedManager].pdfContext, p.x, p.y, r, DEGREES_TO_RADIANS(startAngle),DEGREES_TO_RADIANS(endAngle), 0);
			CGContextAddLineToPoint([CFAGlobalShapeAttributes sharedManager].pdfContext,p.x,p.y);
			CGContextFillPath([CFAGlobalShapeAttributes sharedManager].pdfContext);
		}
	}
	
	if ([CFAGlobalShapeAttributes sharedManager].useStroke == YES) {
		NSBezierPath *arcPath = [NSBezierPath bezierPath];
		[arcPath appendBezierPathWithArcWithCenter:p radius:r startAngle:startAngle endAngle:endAngle];
		[self strokeColorSet];
		[arcPath setLineWidth:[CFAGlobalShapeAttributes sharedManager].strokeWidth];
		[arcPath stroke];
		if ([CFAGlobalShapeAttributes sharedManager].drawShapesToPDF == YES) {
			[self cgStrokeColorSet];
			CGContextBeginPath([CFAGlobalShapeAttributes sharedManager].pdfContext);
			CGContextAddArc([CFAGlobalShapeAttributes sharedManager].pdfContext, p.x, p.y, r, startAngle, endAngle, 0);
			CGContextClosePath([CFAGlobalShapeAttributes sharedManager].pdfContext);
			CGContextStrokePath([CFAGlobalShapeAttributes sharedManager].pdfContext);
		}
	}
    //	if ([CFAGlobalShapeAttributes sharedManager].drawShapesToPDF == YES) {
    //		CFALog(@"Should draw - arc");
    //	}
}

+(void)curveFromPoint:(NSPoint)p1 toPoint:(NSPoint)p2 controlPoint1:(NSPoint)c1 controlPoint2:(NSPoint)c2 {
	if ([CFAGlobalShapeAttributes sharedManager].useStroke == YES) {
		NSBezierPath *curvePath = [NSBezierPath bezierPath];
		[curvePath moveToPoint:p1];
		[curvePath curveToPoint:p2 controlPoint1:c1 controlPoint2:c2];
		[self strokeColorSet];
		[curvePath setLineWidth:[CFAGlobalShapeAttributes sharedManager].strokeWidth];
		[curvePath stroke];
		if ([CFAGlobalShapeAttributes sharedManager].drawShapesToPDF) {
			[self cgStrokeColorSet];
			CGContextBeginPath([CFAGlobalShapeAttributes sharedManager].pdfContext);
			CGContextMoveToPoint([CFAGlobalShapeAttributes sharedManager].pdfContext, p1.x, p1.y);
			CGContextAddCurveToPoint([CFAGlobalShapeAttributes sharedManager].pdfContext, c1.x, c1.y, c2.x, c2.y, p2.x, p2.y);
			CGContextStrokePath([CFAGlobalShapeAttributes sharedManager].pdfContext);
		}
	}
    //	if ([CFAGlobalShapeAttributes sharedManager].drawShapesToPDF == YES) {
    //		CFALog(@"Should draw - curve");
    //	}
}

+(void)curveFromX:(int)x1 Y:(int)y1 toX:(int)x2 Y:(int)y2 controlPoint1X:(int)cx1 Y:(int)cy1 controlPoint2X:(int)cx2 Y:(int)cy2 {
	[self curveFromPoint:NSMakePoint(x1, y1) 
				 toPoint:NSMakePoint(x2, y2) 
		   controlPoint1:NSMakePoint(cx1, cy1)
		   controlPoint2:NSMakePoint(cx2, cy2)];
}

+(void)circleAt:(NSPoint)p radius:(int)r {
	[self ellipseAt:p size:NSMakeSize(r*2, r*2)];
}

+(void)ellipseAt:(NSPoint)p	size:(NSSize)s {
	NSRect circleRect = NSZeroRect;
	circleRect.origin = p;
	circleRect.size = s;
	if ([CFAGlobalShapeAttributes sharedManager].ellipseMode == CENTER) {
		circleRect.origin.x -= circleRect.size.width/2;
		circleRect.origin.y -= circleRect.size.height/2;
	}
	NSBezierPath *ellipse = [NSBezierPath bezierPathWithOvalInRect:circleRect];
	
	if([CFAGlobalShapeAttributes sharedManager].useFill == YES) {
		[self fillColorSet];
		[ellipse fill];
		if ([CFAGlobalShapeAttributes sharedManager].drawShapesToPDF == YES) {
			[self cgFillColorSet];
			CGContextFillEllipseInRect([CFAGlobalShapeAttributes sharedManager].pdfContext, NSRectToCGRect(circleRect));
		}
	}
	
	if([CFAGlobalShapeAttributes sharedManager].useStroke == YES) {
		[ellipse setLineWidth:[CFAGlobalShapeAttributes sharedManager].strokeWidth];
		[self strokeColorSet];
		[ellipse stroke];
		if ([CFAGlobalShapeAttributes sharedManager].drawShapesToPDF == YES) {
			[self cgStrokeColorSet];
			CGContextStrokeEllipseInRect([CFAGlobalShapeAttributes sharedManager].pdfContext, NSRectToCGRect(circleRect));
		}
	}
}

+(void)ellipseWithXPos:(int)x yPos:(int)y width:(int)w andHeight:(int)h {
	[self ellipseAt:NSMakePoint(x,y) size:NSMakeSize(w, h)];
}

+(void)lineFromX:(int)x1 Y:(int)y1 toX:(int)x2 Y:(int)y2 {
        [self lineFromPoint:NSMakePoint(x1, y1) toPoint:NSMakePoint(x2, y2)];
}

+(void)lineFromPoint:(NSPoint)p1 toPoint:(NSPoint)p2 {
    if([CFAGlobalShapeAttributes sharedManager].strokeWidth - floorf([CFAGlobalShapeAttributes sharedManager].strokeWidth) == 0) {
        
        if(((int)[CFAGlobalShapeAttributes sharedManager].strokeWidth)%2 == 1 && [CFAGlobalShapeAttributes sharedManager].useStroke == YES) {
            p1.x = floorf(p1.x)+0.5;
            p1.y = floorf(p1.y)+0.5;
            p2.x = floorf(p2.x)+0.5;
            p2.y = floorf(p2.y)+0.5;
        }
    }

	if([CFAGlobalShapeAttributes sharedManager].useStroke == YES) {
		NSBezierPath *linePath = [NSBezierPath bezierPath];
		[linePath moveToPoint:p1];
		[linePath lineToPoint:p2];
		[self strokeColorSet];
		[linePath setLineWidth:[CFAGlobalShapeAttributes sharedManager].strokeWidth];
		[linePath stroke];
        
        if ([CFAGlobalShapeAttributes sharedManager].drawShapesToPDF == YES) {
            [self cgStrokeColorSet];
            
            CGContextSetLineCap([CFAGlobalShapeAttributes sharedManager].pdfContext,kCGLineCapRound);
            CGContextBeginPath([CFAGlobalShapeAttributes sharedManager].pdfContext);
            CGContextMoveToPoint([CFAGlobalShapeAttributes sharedManager].pdfContext, p1.x, p1.y);
            CGContextAddLineToPoint([CFAGlobalShapeAttributes sharedManager].pdfContext, p2.x, p2.y);
            CGContextClosePath([CFAGlobalShapeAttributes sharedManager].pdfContext);
            CGContextStrokePath([CFAGlobalShapeAttributes sharedManager].pdfContext);
        }
    }
}

+(void)pointAtX:(int)x1 Y:(int)y1 {
	[self pointAt:NSMakePoint(x1, y1)];
}

+(void)pointAt:(NSPoint)p {
	[self noStroke];
	[self fill];
	[self rectWithXPos:p.x yPos:p.y width:1 andHeight:1];
	if ([CFAGlobalShapeAttributes sharedManager].useStroke == YES) [self stroke]; //set stroke on if it was on before
	if ([CFAGlobalShapeAttributes sharedManager].useFill == NO) [self noFill]; //set fill off if it was off before
}

+(void)rectWithXPos:(int)x yPos:(int)y width:(float)w andHeight:(float)h {
    /*
     if (w < 1) {
     NSLog(@"Value for width (%f) invalid, width must be >= 1",w);
     return;
     }
     if (h < 1) {
     NSLog(@"Value for height (%f) invalid, width must be >= 1",h);
     return;
     }
     */
    
	NSRect rect = NSMakeRect(x, y, [CFAMath ceil:w], [CFAMath ceil:h]);
	if ([CFAGlobalShapeAttributes sharedManager].rectMode == CENTER) {
		rect.origin.x -= w/2;
		rect.origin.y -= h/2;
	}
    
    if ([CFAGlobalShapeAttributes sharedManager].useStroke == YES) {
    rect.origin.x = [CFAMath floor:rect.origin.x]+0.5f;
    rect.origin.y = [CFAMath floor:rect.origin.y]+0.5f;
    }
    
	
	NSBezierPath *rectPath = [NSBezierPath bezierPathWithRect:rect];
    
	if ([CFAGlobalShapeAttributes sharedManager].useFill == YES) {
		[self fillColorSet];
		[rectPath fill];
		if ([CFAGlobalShapeAttributes sharedManager].drawShapesToPDF == YES) {
			[self cgFillColorSet];
			CGContextFillRect([CFAGlobalShapeAttributes sharedManager].pdfContext, NSRectToCGRect(rect));
		}
	}
	if ([CFAGlobalShapeAttributes sharedManager].useStroke == YES) {
		[self strokeColorSet];
		[rectPath setLineWidth:[CFAGlobalShapeAttributes sharedManager].strokeWidth];
		[rectPath stroke];
		if ([CFAGlobalShapeAttributes sharedManager].drawShapesToPDF == YES) {
			[self cgStrokeColorSet];
			CGContextStrokeRect([CFAGlobalShapeAttributes sharedManager].pdfContext, CGRectMake(x, y, w, h));
		}
	}
}

+(void)rectAt:(NSPoint)p size:(NSSize)s {
	[self rectWithXPos:p.x yPos:p.y width:s.width andHeight:s.height];
}


+(void)triangleFromX:(int)x1 Y:(int)y1 toX:(int)x2 Y:(int)y2 toX:(int)x3 Y:(int)y3 {
	[self triangleUsingPoint:NSMakePoint(x1, y1) point:NSMakePoint(x2, y2) point:NSMakePoint(x3, y3)];
}

+(void)triangleUsingPoint:(NSPoint)p1 point:(NSPoint)p2 point:(NSPoint)p3 {
	NSBezierPath *trianglePath = [NSBezierPath bezierPath];
	[trianglePath moveToPoint:p1];
	[trianglePath lineToPoint:p2];
	[trianglePath lineToPoint:p3];
	[trianglePath lineToPoint:p1];
	
	if ([CFAGlobalShapeAttributes sharedManager].useFill == YES) {
		[self fillColorSet];
		[trianglePath fill];
		if([CFAGlobalShapeAttributes sharedManager].drawShapesToPDF == YES) {
			[self cgFillColorSet];
			CGContextBeginPath([CFAGlobalShapeAttributes sharedManager].pdfContext);
			CGContextMoveToPoint([CFAGlobalShapeAttributes sharedManager].pdfContext, p1.x, p1.y);
			CGContextAddLineToPoint([CFAGlobalShapeAttributes sharedManager].pdfContext, p2.x, p2.y);
			CGContextAddLineToPoint([CFAGlobalShapeAttributes sharedManager].pdfContext, p3.x, p3.y);
			CGContextClosePath([CFAGlobalShapeAttributes sharedManager].pdfContext);
			CGContextFillPath([CFAGlobalShapeAttributes sharedManager].pdfContext);
		}
	}
	if([CFAGlobalShapeAttributes sharedManager].useStroke == YES){
		[self strokeColorSet];
		[trianglePath setLineWidth:[CFAGlobalShapeAttributes sharedManager].strokeWidth];
		[trianglePath stroke];
		if ([CFAGlobalShapeAttributes sharedManager].drawShapesToPDF == YES) {
			[self cgStrokeColorSet];
			
			CGContextBeginPath([CFAGlobalShapeAttributes sharedManager].pdfContext);
			CGContextMoveToPoint([CFAGlobalShapeAttributes sharedManager].pdfContext, p1.x, p1.y);
			CGContextAddLineToPoint([CFAGlobalShapeAttributes sharedManager].pdfContext, p2.x, p2.y);
			CGContextAddLineToPoint([CFAGlobalShapeAttributes sharedManager].pdfContext, p3.x, p3.y);
			CGContextAddLineToPoint([CFAGlobalShapeAttributes sharedManager].pdfContext, p1.x, p1.y);
			CGContextClosePath([CFAGlobalShapeAttributes sharedManager].pdfContext);
			CGContextStrokePath([CFAGlobalShapeAttributes sharedManager].pdfContext);
		}
	}
}

+(void)quadUsingPoint:(NSPoint)p1 point:(NSPoint)p2 point:(NSPoint)p3 point:(NSPoint)p4 {
	NSBezierPath *quadPath = [NSBezierPath bezierPath];
	[quadPath moveToPoint:p1];
	[quadPath lineToPoint:p2];
	[quadPath lineToPoint:p3];
	[quadPath lineToPoint:p4];
	[quadPath lineToPoint:p1];
	
	if([CFAGlobalShapeAttributes sharedManager].useFill == YES) {
		[self fillColorSet];
		[quadPath fill];
		if([CFAGlobalShapeAttributes sharedManager].drawShapesToPDF) {
			[self cgFillColorSet];
			CGContextBeginPath([CFAGlobalShapeAttributes sharedManager].pdfContext);
			CGContextMoveToPoint([CFAGlobalShapeAttributes sharedManager].pdfContext, p1.x, p1.y);
			CGContextAddLineToPoint([CFAGlobalShapeAttributes sharedManager].pdfContext, p2.x, p2.y);
			CGContextAddLineToPoint([CFAGlobalShapeAttributes sharedManager].pdfContext, p3.x, p3.y);
			CGContextAddLineToPoint([CFAGlobalShapeAttributes sharedManager].pdfContext, p4.x, p4.y);
			CGContextClosePath([CFAGlobalShapeAttributes sharedManager].pdfContext);
			CGContextFillPath([CFAGlobalShapeAttributes sharedManager].pdfContext);
		}
	}
	if([CFAGlobalShapeAttributes sharedManager].useStroke == YES){ 
		[self strokeColorSet];
		[quadPath setLineWidth:[CFAGlobalShapeAttributes sharedManager].strokeWidth];
		[quadPath stroke];
		if ([CFAGlobalShapeAttributes sharedManager].drawShapesToPDF == YES) {
			[self cgStrokeColorSet];
			CGContextBeginPath([CFAGlobalShapeAttributes sharedManager].pdfContext);
			CGContextMoveToPoint([CFAGlobalShapeAttributes sharedManager].pdfContext, p1.x, p1.y);
			CGContextAddLineToPoint([CFAGlobalShapeAttributes sharedManager].pdfContext, p2.x, p2.y);
			CGContextAddLineToPoint([CFAGlobalShapeAttributes sharedManager].pdfContext, p3.x, p3.y);
			CGContextAddLineToPoint([CFAGlobalShapeAttributes sharedManager].pdfContext, p4.x, p4.y);
			CGContextAddLineToPoint([CFAGlobalShapeAttributes sharedManager].pdfContext, p1.x, p1.y);
			CGContextClosePath([CFAGlobalShapeAttributes sharedManager].pdfContext);
			CGContextStrokePath([CFAGlobalShapeAttributes sharedManager].pdfContext);
		}
	}
}

+(void)quadFromX:(int)x1 Y:(int)y1 toX:(int)x2 Y:(int)y2 toX:(int)x3 Y:(int)y3 toX:(int)x4 Y:(int)y4 {	
	[self quadUsingPoint:NSMakePoint(x1, y1) point:NSMakePoint(x2, y2) point:NSMakePoint(x3, y3) point:NSMakePoint(x4, y4)];
}

#pragma mark Vertex Shapes
+(void)beginShape {
	if ([CFAGlobalShapeAttributes sharedManager].checkShape == YES) {
		[NSException raise:@"[CFAShape beginShape] Exception" format:@"[CFAShape beginShape] already called, you must call [CFAShape endShape] before beginning another shape."];
	}
	[CFAGlobalShapeAttributes sharedManager].checkShape = YES;
	[CFAGlobalShapeAttributes sharedManager].firstPoint = YES;
	[CFAGlobalShapeAttributes sharedManager].vertexPath = [NSBezierPath bezierPath];
	if ([CFAGlobalShapeAttributes sharedManager].drawShapesToPDF == YES) {
		CGContextBeginPath([CFAGlobalShapeAttributes sharedManager].pdfContext);
	}
}

+(void)endShape {
	if ([CFAGlobalShapeAttributes sharedManager].checkShape == NO) {
		[NSException raise:@"[CFAShape endShape] Exception" format:@"[CFAShape endShape] already called, you must call [CFAShape beginShape] to start a new shape."];
	} else if ([[CFAGlobalShapeAttributes sharedManager].vertexPath elementCount] < 2){
		[NSException raise:@"[CFAShape endShape] Exception" format:@"The current shape has %d points, but needs at least 2 points.", [[CFAGlobalShapeAttributes sharedManager].vertexPath elementCount]];
	}
	[CFAGlobalShapeAttributes sharedManager].checkShape = NO;
	
	if([CFAGlobalShapeAttributes sharedManager].useFill == YES) {
		[self fillColorSet];
		[[CFAGlobalShapeAttributes sharedManager].vertexPath fill];
		if ([CFAGlobalShapeAttributes sharedManager].drawShapesToPDF == YES) {
			[self cgFillColorSet];
			CGContextFillPath([CFAGlobalShapeAttributes sharedManager].pdfContext);
		}
	}
	if([CFAGlobalShapeAttributes sharedManager].useStroke == YES){ 
		[self strokeColorSet];
		[[CFAGlobalShapeAttributes sharedManager].vertexPath setLineWidth:[CFAGlobalShapeAttributes sharedManager].strokeWidth];
		[[CFAGlobalShapeAttributes sharedManager].vertexPath stroke];
		if([CFAGlobalShapeAttributes sharedManager].drawShapesToPDF == YES) {
			[self cgStrokeColorSet];
			CGContextStrokePath([CFAGlobalShapeAttributes sharedManager].pdfContext);
		}
	}
}

+(void)closeShape {
	if ([CFAGlobalShapeAttributes sharedManager].checkShape == NO) {
		[NSException raise:@"[CFAShape endShape] Exception" format:@"[CFAShape endShape] already called, you must call [CFAShape beginShape] to start a new shape."];
	} else if ([[CFAGlobalShapeAttributes sharedManager].vertexPath elementCount] < 2){
		[NSException raise:@"[CFAShape closeShape] Exception" format:@"The current shape has %d points, but needs at least 2 points.", [[CFAGlobalShapeAttributes sharedManager].vertexPath elementCount]];
	}
	[[CFAGlobalShapeAttributes sharedManager].vertexPath closePath];
	CGContextClosePath([CFAGlobalShapeAttributes sharedManager].pdfContext);
}

+(void)vertexAtX:(int)x Y:(int)y {
	[self vertexAt:NSMakePoint(x, y)];
}

+(void)vertices:(NSPoint *)points length:(NSInteger)length{
    for(int i = 0; i < length; i++) {
        [self vertexAt:points[i]];
    }
}

+(void)vertexAt:(NSPoint)point {
    point.x = [CFAMath floor:point.x] + 0.5;
    point.y = [CFAMath floor:point.y] + 0.5;

	if ([CFAGlobalShapeAttributes sharedManager].checkShape == NO) {
		[NSException raise:@"[CFAShape vertexAt:] Exception" format:@"You must call [CFAShape beginShape] before adding vertices."];
	}
	if ([CFAGlobalShapeAttributes sharedManager].firstPoint == YES) {
		[[CFAGlobalShapeAttributes sharedManager].vertexPath moveToPoint:point];
		if ([CFAGlobalShapeAttributes sharedManager].drawShapesToPDF == YES) {
			CGContextMoveToPoint([CFAGlobalShapeAttributes sharedManager].pdfContext, point.x, point.y);
		}
		[CFAGlobalShapeAttributes sharedManager].firstPoint = NO;
	} else {
		[[CFAGlobalShapeAttributes sharedManager].vertexPath lineToPoint:point];
		if ([CFAGlobalShapeAttributes sharedManager].drawShapesToPDF == YES) {
			CGContextAddLineToPoint([CFAGlobalShapeAttributes sharedManager].pdfContext, point.x, point.y);
		}
	}
}

#pragma mark Current Shape
+(void)clearCurrentShape {
	[CFAGlobalShapeAttributes sharedManager].currentShape = CGPathCreateMutable();
}

+(CGMutablePathRef)currentShape {
	return [CFAGlobalShapeAttributes sharedManager].currentShape;
}
+(void)addArcWithCenterAt:(NSPoint)p radius:(float)r startAngle:(float)startAngle endAngle:(float)endAngle {
	CGPathAddArc([CFAGlobalShapeAttributes sharedManager].currentShape, NULL, p.x, p.y, r, DEGREES_TO_RADIANS(startAngle),DEGREES_TO_RADIANS(endAngle), 0);
}

+(void)addCircleAt:(NSPoint)p radius:(int)r{
	CGRect circleRect;
	circleRect.origin = NSPointToCGPoint(p);
	circleRect.size = CGSizeMake(r*2, r*2);
	if ([CFAGlobalShapeAttributes sharedManager].ellipseMode == CENTER) {
		circleRect.origin.x -= r;
		circleRect.origin.y -= r;
	}
	CGPathAddEllipseInRect([CFAGlobalShapeAttributes sharedManager].currentShape, NULL, circleRect);
}

+(void)addCurveFromPoint:(NSPoint)p1 toPoint:(NSPoint)p2 controlPoint1:(NSPoint)c1 controlPoint2:(NSPoint)c2 {
	[self addCurveFromX:p1.x Y:p1.y toX:p2.x Y:p2.y controlPoint1X:c1.x Y:c1.y controlPoint2X:c2.x Y:c2.y];
}

+(void)addCurveFromX:(int)x1 Y:(int)y1 toX:(int)x2 Y:(int)y2 controlPoint1X:(int)cx1 Y:(int)cy1 controlPoint2X:(int)cx2 Y:(int)cy2{
	CGMutablePathRef curvePath = CGPathCreateMutable();
	CGPathMoveToPoint(curvePath, NULL, x1, y1);
	CGPathAddCurveToPoint(curvePath, NULL, cx1, cy1, cx2, cy2, x2, y2);
	CGPathAddPath([CFAGlobalShapeAttributes sharedManager].currentShape, NULL, curvePath);
    CFRelease(curvePath);
}

+(void)addEllipseAt:(NSPoint)p size:(NSSize)s {
	CGRect ellipseRect;
	ellipseRect.origin = NSPointToCGPoint(p);
	ellipseRect.size = NSSizeToCGSize(s);
	if ([CFAGlobalShapeAttributes sharedManager].ellipseMode == CENTER) {
		ellipseRect.origin.x -= ellipseRect.size.width/2;
		ellipseRect.origin.y -= ellipseRect.size.height/2;
	}
	CGPathAddEllipseInRect([CFAGlobalShapeAttributes sharedManager].currentShape, NULL, ellipseRect);
}

+(void)addEllipseWithXPos:(int)x yPos:(int)y width:(int)w andHeight:(int)h {
	[self addEllipseAt:NSMakePoint(x, y) size:NSMakeSize(w, h)];
}

+(void)addLineFromX:(int)x1 Y:(int)y1 toX:(int)x2 Y:(int)y2{
	CGMutablePathRef linePath = CGPathCreateMutable();
	CGPathMoveToPoint(linePath, NULL, x1, y1);
	CGPathAddLineToPoint(linePath, NULL, x2, y2);
	CGPathAddPath([CFAGlobalShapeAttributes sharedManager].currentShape, NULL, linePath);
    CFRelease(linePath);
}

+(void)addLineFromPoint:(NSPoint)p1 toPoint:(NSPoint)p2{ 
	[self addLineFromX:p1.x Y:p1.y toX:p2.x Y:p2.y];
}

+(void)addLineTo:(NSPoint)p {
	[self addLineToX:p.x Y:p.y];
}

+(void)addLineToX:(int)x Y:(int)y {
	CGPathAddLineToPoint([CFAGlobalShapeAttributes sharedManager].currentShape, NULL, x, y);
}

+(void)addPointAt:(NSPoint)p{
	[self addRectWithXPos:p.x yPos:p.y width:1 andHeight:1];
}
+(void)addPointAtX:(int)x1 Y:(int)y1{
	[self addPointAt:NSMakePoint(x1,y1)];
}
+(void)addRectWithXPos:(int)x yPos:(int)y width:(float)w andHeight:(float)h { 
	CGPathAddRect([CFAGlobalShapeAttributes sharedManager].currentShape,NULL,CGRectMake(x, y, w, h));
}
+(void)addTriangleFromX:(int)x1 Y:(int)y1 toX:(int)x2 Y:(int)y2 toX:(int)x3 Y:(int)y3{
	[self addTriangleUsingPoint:NSMakePoint(x1, y1) point:NSMakePoint(x2, y2) point:NSMakePoint(x3, y3)];
}
+(void)addTriangleUsingPoint:(NSPoint)p1 point:(NSPoint)p2 point:(NSPoint)p3 {
	CGMutablePathRef trianglePath = CGPathCreateMutable();
	CGPathMoveToPoint(trianglePath, NULL, p1.x, p1.y);
	CGPathAddLineToPoint(trianglePath, NULL, p2.x, p2.y);
	CGPathAddLineToPoint(trianglePath, NULL, p3.x, p3.y);
	CGPathAddLineToPoint(trianglePath, NULL, p1.x, p1.y);
	CGPathAddPath([CFAGlobalShapeAttributes sharedManager].currentShape, NULL, trianglePath);
    CFRelease(trianglePath);
}
+(void)addQuadUsingPoint:(NSPoint)p1 point:(NSPoint)p2 point:(NSPoint)p3 point:(NSPoint)p4{
	[self addQuadFromX:p1.x Y:p1.y toX:p2.x Y:p2.y toX:p3.x Y:p3.y toX:p4.x Y:p4.y];
}
+(void)addQuadFromX:(int)x1 Y:(int)y1 toX:(int)x2 Y:(int)y2 toX:(int)x3 Y:(int)y3 toX:(int)x4 Y:(int)y4{
	CGMutablePathRef quadPath = CGPathCreateMutable();
	CGPathMoveToPoint(quadPath, NULL, x1, y1);
	CGPathAddLineToPoint(quadPath, NULL, x2, y2);
	CGPathAddLineToPoint(quadPath, NULL, x3, y3);
	CGPathAddLineToPoint(quadPath, NULL, x4, y4);
	CGPathAddLineToPoint(quadPath, NULL, x1, y1);
	CGPathAddPath([CFAGlobalShapeAttributes sharedManager].currentShape, NULL, quadPath);
    CFRelease(quadPath);
}

#pragma mark Attributes
+(void)strokeWidth:(float)width {
	if ([CFAGlobalShapeAttributes sharedManager].strokeWidth > 0.1) {
		[CFAGlobalShapeAttributes sharedManager].strokeWidth = width;
	} else {
		[CFAGlobalShapeAttributes sharedManager].strokeWidth = 0.1;
		NSLog(@"stroke width set to 0.1, it cannot be smaller than this");
	}
}

+(void)rectMode:(int)mode {
	if (mode == CENTER || mode == CORNER) {
		[CFAGlobalShapeAttributes sharedManager].rectMode = mode;
	} else {
		NSLog(@"rect mode must be CENTER or CORNER");
	}
}

+(void)ellipseMode:(int)mode {
	if (mode == CENTER || mode == CORNER) {
		[CFAGlobalShapeAttributes sharedManager].ellipseMode = mode;
	} else {
		NSLog(@"ellipse mode must be CENTER or CORNER");
	}
}

+(void)strokeCapMode:(int)mode {
	if(mode >= NSButtLineCapStyle && mode <= NSSquareLineCapStyle)
		[NSBezierPath setDefaultLineCapStyle:mode];
	else
		CFALog(@"Stroke Cap Mode must be one of: CAPBUTT, CAPROUND, CAPSQUARE");		
}

+(void)strokeJoinMode:(int)mode {
	if (mode >= NSMiterLineJoinStyle && mode <= NSBevelLineJoinStyle)
		[NSBezierPath setDefaultLineJoinStyle:mode];
	else
		CFALog(@"Stroke Join Mode must be one of: JOINMITRE, JOINROUND, JOINBEVEL");
}

+(void)strokeDetail:(float)level {
	[NSBezierPath setDefaultFlatness:fabsf(level)];
}

#pragma mark Colors
+(void)fillColor:(CFAColor *)color {
    [CFAGlobalShapeAttributes sharedManager].fillColor = color;
}

+(void)fillColor:(CFAColor *)color alpha:(CGFloat)alpha{
    [CFAGlobalShapeAttributes sharedManager].fillColor = [CFAColor colorWithRed:[color redComponent] green:[color greenComponent] blue:[color blueComponent] alpha:alpha];
}

+(void)fill:(float)grey {
	[CFAGlobalShapeAttributes sharedManager].fillColor = [CFAColor colorWithGrey:grey];
}

+(void)fill:(float)grey alpha:(float)alpha{
	[CFAGlobalShapeAttributes sharedManager].fillColor = [CFAColor colorWithGrey:grey alpha:alpha];
}

+(void)fillRed:(float)red green:(float)green blue:(float)blue {
	[CFAGlobalShapeAttributes sharedManager].fillColor = [CFAColor colorWithRed:red green:green blue:blue];
}

+(void)fillRed:(float)red green:(float)green blue:(float)blue alpha:(float)alpha{
	[CFAGlobalShapeAttributes sharedManager].fillColor = [CFAColor colorWithRed:red green:green blue:blue alpha:alpha];
}

+(void)noFill {
	[CFAGlobalShapeAttributes sharedManager].useFill = NO;
}

+(void)fill {
	[CFAGlobalShapeAttributes sharedManager].useFill = YES;
}

+(void)stroke {
	[CFAGlobalShapeAttributes sharedManager].useStroke = YES;
}

+(void)strokeColor:(CFAColor *)color {
	[CFAGlobalShapeAttributes sharedManager].strokeColor = color;
}

+(void)stroke:(float)grey {
	[CFAGlobalShapeAttributes sharedManager].strokeColor = [CFAColor colorWithRed:grey green:grey blue:grey alpha:1.0f];
}

+(void)stroke:(float)grey alpha:(float)alpha {
	[CFAGlobalShapeAttributes sharedManager].strokeColor = [CFAColor colorWithRed:grey green:grey blue:grey alpha:alpha];
}

+(void)strokeRed:(float)red green:(float)green blue:(float)blue {
	[CFAGlobalShapeAttributes sharedManager].strokeColor = [CFAColor colorWithRed:red green:green blue:blue alpha:255];
}

+(void)strokeRed:(float)red green:(float)green blue:(float)blue alpha:(float)alpha{
	[CFAGlobalShapeAttributes sharedManager].strokeColor = [CFAColor colorWithRed:red green:green blue:blue alpha:alpha];
}

+(void)noStroke {
	[CFAGlobalShapeAttributes sharedManager].useStroke = NO;
}

+(void)fillColorSet {
	if ([CFAGlobalShapeAttributes sharedManager].useFill == YES){
        [[CFAGlobalShapeAttributes sharedManager].fillColor set];
    }
	else [[NSColor colorWithCalibratedWhite:1.0f alpha:0.0f] set];
}

+(void)strokeColorSet {
	if ([CFAGlobalShapeAttributes sharedManager].useStroke == YES) [[CFAGlobalShapeAttributes sharedManager].strokeColor set];
	else [[NSColor colorWithCalibratedWhite:1.0f alpha:0.0f] set];
}

+(void)cgFillColorSet {
	CGColorRef c = [[CFAGlobalShapeAttributes sharedManager].fillColor cgColor];	
	const CGFloat *colorComponents = CGColorGetComponents(c);
	if([CFAGlobalShapeAttributes sharedManager].useFill == YES) CGContextSetRGBFillColor([CFAGlobalShapeAttributes sharedManager].pdfContext,colorComponents[0],colorComponents[1],colorComponents[2],colorComponents[3]);
	else CGContextSetRGBFillColor([CFAGlobalShapeAttributes sharedManager].pdfContext, 0, 0, 0, 0);
}

+(void)cgStrokeColorSet {
	CGContextSetLineWidth([CFAGlobalShapeAttributes sharedManager].pdfContext, [CFAGlobalShapeAttributes sharedManager].strokeWidth);
	CGColorRef c = [[CFAGlobalShapeAttributes sharedManager].strokeColor cgColor];	
	const CGFloat *colorComponents = CGColorGetComponents(c);
	if([CFAGlobalShapeAttributes sharedManager].useStroke == YES) CGContextSetRGBStrokeColor([CFAGlobalShapeAttributes sharedManager].pdfContext,colorComponents[0],colorComponents[1],colorComponents[2],colorComponents[3]);
	else CGContextSetRGBStrokeColor([CFAGlobalShapeAttributes sharedManager].pdfContext, 0, 0, 0, 0);
}

#pragma mark Coordinates
-(void)flipCoordinates {
}

-(void)nativeCoordinates {
}

#pragma mark Output
+(BOOL)isClean {
	return [CFAGlobalShapeAttributes sharedManager].isClean;
}

+(void)beginDrawShapesToPDFContext:(CGContextRef)context {
	CFALog(@"beginDrawShapesToPDFContext");
	[CFAGlobalShapeAttributes sharedManager].pdfContext = context;
	[CFAGlobalShapeAttributes sharedManager].drawShapesToPDF = YES;
	[CFAGlobalShapeAttributes sharedManager].isClean = NO;
}

+(void)endDrawShapesToPDFContext {
	[CFAGlobalShapeAttributes sharedManager].drawShapesToPDF = NO;
    [CFAGlobalShapeAttributes sharedManager].pdfContext = nil;
	[CFAGlobalShapeAttributes sharedManager].isClean = YES;
	CFALog(@"endDrawShapesToPDFContext");
}

@end
