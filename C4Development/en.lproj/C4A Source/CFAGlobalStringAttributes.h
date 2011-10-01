//
//  CFAGlobalStringAttributes.h
//  C4ARebuild
//
//  Created by moi on 11-04-05.
//  Copyright 2011 mediart. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CFAGlobalStringAttributes : CFAObject {
    CGContextRef pdfContext;
    BOOL drawStringsToPDF;
    BOOL isClean;

}

-(id)_init;
-(void)_dealloc;
+(CFAGlobalStringAttributes *)sharedManager;

@property(readwrite) BOOL drawStringsToPDF, isClean;
@property(readwrite) CGContextRef pdfContext;
@end
