
//
//  CFAGlobalStringAttributes.m
//  C4ARebuild
//
//  Created by moi on 11-04-05.
//  Copyright 2011 mediart. All rights reserved.
//

#import "CFAGlobalStringAttributes.h"
static CFAGlobalStringAttributes *cfaGlobalStringAttributes;

@implementation CFAGlobalStringAttributes
@synthesize pdfContext,drawStringsToPDF,isClean;
GENERATE_SINGLETON(CFAGlobalStringAttributes, cfaGlobalStringAttributes);

- (id)_init
{
   return self;
}

-(void)_dealloc {
}
@end
