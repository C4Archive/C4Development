//
//  CFANoise.h
//  Perlin
//
//  Created by moi on 11-04-08.
//  Copyright 2011 mediart. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface CFANoise : CFAObject {
@private
    
}
-(id)_init;
-(void)_dealloc;
+(CFANoise *)sharedManager;

+(CGFloat)noiseX:(CGFloat)x;
+(CGFloat)noiseX:(CGFloat)x Y:(CGFloat)y;
+(CGFloat)noiseX:(CGFloat)x Y:(CGFloat)y Z:(CGFloat)z;
@end
