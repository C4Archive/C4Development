//
//  CFAFoundation.h
//  Created by Travis Kirton
//

#import <Cocoa/Cocoa.h>

@interface CFAFoundation : CFAObject {
    NSComparator floatSortComparator;
}

#pragma mark Singleton
-(id)_init;
-(void)_dealloc;
+(CFAFoundation *)sharedManager;
+(NSComparator)floatComparator;
-(NSComparator)floatComparator;

#pragma mark Foundation 
void CFALog(NSString *logString,...);
NSInteger basicSort(id obj1, id obj2, void *context);
@end
