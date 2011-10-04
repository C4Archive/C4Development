//
//  CFACanvas.h
//  CodeSamples
//
//	A Cocoa For Artists project
//  Created by Travis Kirton
//

#import "CFACanvas.h"

CFAMovie *simpleMovie;

@implementation CFACanvas

-(void)setup {
    [self drawStyle:ANIMATED];
    [self windowWidth:400 andHeight:320];
    
    simpleMovie = [CFAMovie movieName:@"C4.mov"];
    [simpleMovie rectMode:CENTER];
    
    [simpleMovie setX:self.centerPos.x 
                 andY:self.centerPos.y 
            withWidth:self.canvasWidth 
            andHeight:self.canvasHeight];
    
    [simpleMovie play];
    [simpleMovie setLoops:YES];
}

-(void)mouseMoved {
    [simpleMovie setWidth:mousePos.x andHeight:mousePos.y];
}

@end