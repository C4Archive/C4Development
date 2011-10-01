//
//  CFAGlobalShapeAttributes.m
//  C4A
//
//  Created by moi on 11-02-28.
//  Copyright 2011 Travis Kirton. All rights reserved.
//

#import "CFAGlobalShapeAttributes.h"
static CFAGlobalShapeAttributes *cfaGlobalShapeAttributes;

@implementation CFAGlobalShapeAttributes
GENERATE_SINGLETON(CFAGlobalShapeAttributes, cfaGlobalShapeAttributes);
//BOOL
@synthesize useFill, useStroke, checkShape, drawShapesToPDF, firstPoint, isClean;

//CFAColor
@synthesize fillColor, strokeColor;

//NSInteger
@synthesize ellipseMode, rectMode;

//CGFloat
@synthesize strokeWidth;

//CGPathRef
@synthesize currentShape;

//CGContextRef
@synthesize pdfContext;

//NSBezierPath
@synthesize vertexPath;

-(id)_init {
	strokeWidth = 1.0f;
	fillColor = [[CFAColor colorWithGrey:1] retain];		//white
	strokeColor = [[CFAColor	colorWithGrey:0] retain];	//black
	ellipseMode = CENTER;
	rectMode = CORNER;
    
    useFill = YES;
    useStroke = YES;
    checkShape = NO;
    firstPoint	= YES;
    drawShapesToPDF = NO;
    
    rectMode = CORNER;
    ellipseMode = CENTER;
    
	return self;
}

-(void)_dealloc {
}

@end
