
//
//  CFAGlobalStringAttributes.m
//  C4ARebuild
//
//  Created by moi on 11-04-05.
//  Copyright 2011 mediart. All rights reserved.
//

#import "CFAGlobalStringAttributes.h"
static CFAGlobalStringAttributes *shareCFAGlobalStringAttributes = nil;

@implementation CFAGlobalStringAttributes
@synthesize pdfContext,drawStringsToPDF,isClean;

#pragma mark Singleton

-(id) init
{
    if((self = [super init]))
    {
    }
    
    return self;
}

+ (CFAGlobalStringAttributes*)sharedManager
{
    if (shareCFAGlobalStringAttributes == nil) {
        static dispatch_once_t once;
        dispatch_once(&once, ^ { shareCFAGlobalStringAttributes = [[super allocWithZone:NULL] init]; 
        });
        return shareCFAGlobalStringAttributes;
        
        
    }
    return shareCFAGlobalStringAttributes;
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
