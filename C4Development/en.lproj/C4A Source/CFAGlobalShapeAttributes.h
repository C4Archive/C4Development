//
//  CFAGlobalShapeAttributes.h
//  C4A
//
//  Created by moi on 11-02-28.
//  Copyright 2011 Travis Kirton. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "CFAObject.h"

@interface CFAGlobalShapeAttributes : CFAObject {
    BOOL useFill, useStroke, checkShape, firstPoint, drawShapesToPDF, isClean;
    
    CGContextRef pdfContext;
    
    NSInteger rectMode, ellipseMode;
    
    CGFloat strokeWidth;
    
    CFAColor		*fillColor;
    CFAColor		*strokeColor;
    NSBezierPath	*vertexPath;
    CGFloat			fillColorComponents[4];
    CGFloat			strokeColorComponents[4];
    
    CGMutablePathRef currentShape;
}

-(id)_init;
-(void)_dealloc;
+(CFAGlobalShapeAttributes *)sharedManager;

@property(readwrite) NSInteger rectMode, ellipseMode;
@property(readwrite) CGFloat strokeWidth;
@property(readwrite) BOOL useFill, useStroke, checkShape, firstPoint, drawShapesToPDF, isClean;
@property(readwrite) CGContextRef pdfContext;
@property(readwrite,retain) CFAColor *fillColor, *strokeColor;
@property(readwrite) CGMutablePathRef currentShape;
@property(readwrite, retain) NSBezierPath *vertexPath;
@end
