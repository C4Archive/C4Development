//
//  C4Canvas.m
//
//	A C4 project
//  Created by Travis Kirton
//

//#import "C4Canvas.h"
//int line[1024][768];
//int rule[2][2][2];
//int currentStartCell, startCellCount;
//
//@interface C4Canvas()
//    -(void)generateLines;
//@end
//
//@implementation C4Canvas 
//
//-(id)init {
//    self = [super init];
//    if(self) {
//        [self generateLines];
//    }
//    return self;
//}
//
//-(void)setup {
//    [self windowWidth:768 andHeight:1024];
//    startCellCount = 3;
//}
//
//-(void)draw {
//    for(int a = 0; a < 2; a++) {
//        rule[1][1][1] = a;
//        for(int b = 0; b < 2; b++) {
//            rule[1][1][0] = b;
//            for(int c = 0; c < 2; c++) {
//                rule[1][0][1] = c;
//                for(int d = 0; d < 2; d++) {
//                    rule[1][0][0] = d;
//                    for(int e = 0; e < 2; e++) {
//                        rule[0][1][1] = e;
//                        for(int f = 0; f < 2; f++) {
//                            rule[0][1][0] = f;
//                            for(int g = 0; g < 2; g++) {
//                                rule[0][0][1] = g;
//                                for(int h = 0; h < 2; h++) {
//                                    rule[0][0][0] = h;
//                                    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
//                                    [self generateLines];
//                                    NSString *name = [NSString stringWithFormat:@"CA_%d%d%d%d%d%d%d%d.pdf",a,b,c,d,e,f,g,h];
//                                    [self setupPDFWithName:name];
//                                    [self background:0];
//                                    [self drawBackground];
//                                    for (int y = 0; y < 1024; y++) {
//                                        for(int x = 0; x < 768; x++) {
//                                            if(line[y][x] == 1){
//                                                [C4Shape pointAt:NSMakePoint(768-x, 1024-y)];
//                                            }
//                                        }
//                                    }
//                                    [self endPDF];
//                                    [pool drain];
//                                }
//                            }
//                        }
//                    }
//                }
//            }
//        }
//    }
//}
//
//-(void)generateLines {
//    for(int y = 0; y < 768; y++) {
//        line[0][y] = 0;
//    }
//    for(int i = 0; i < startCellCount; i++) {
//        currentStartCell = [C4Math randomIntBetweenA:0 andB:1024];
//        line[0][currentStartCell] = 1;
//    }
//    int a,b,c;
//    
//    for (int currentLine = 1; currentLine <1024; currentLine++) {
//        for(int currentCell = 1; currentCell < 768; currentCell++) {
//            if(currentCell == 0) {
//                b = line[currentLine-1][currentCell];
//                c = line[currentLine-1][currentCell+1];
//                line[currentLine][currentCell] = rule[0][b][c];
//            }
//            else if(currentCell == 767) {
//                a = line[currentLine-1][currentCell-1];
//                b = line[currentLine-1][currentCell];
//                line[currentLine][currentCell] = rule[a][b][0];
//            }
//            else {
//                a = line[currentLine-1][currentCell-1];
//                b = line[currentLine-1][currentCell];
//                c = line[currentLine-1][currentCell+1];
//                line[currentLine][currentCell] = rule[a][b][c];
//            }
//        }
//    }
//}
//
//@end

#import "C4Canvas.h"



@interface C4Canvas()
    -(void)setData;
@end

int count;

unsigned	raster_width,		/* Width of page image */
raster_height,		/* Height of page image */
raster_depth,		/* Depth of page image - 1 (grayscale) or 3 (RGB) */
raster_size;

unsigned char	*raster_data,		/* Page buffer */
*raster_ptr,		/* Pointer into page buffer */
*raster_end;		/* Pointer to end of page buffer */
CGColorSpaceRef colorspace;
CGDataProviderRef provider;
CGImageRef imageRef;
int rule[2][2][2];
int currentStartCell, startCellCount;


static void	free_data(void *info, const void *data, size_t size);

@implementation C4Canvas

-(void)setup {
    startCellCount = 3;
    raster_height = 1024;
    raster_width = 768;
    raster_depth = 1;
    raster_size = raster_height *raster_width * raster_depth;
    raster_data = malloc(raster_size);
//    memset(raster_data, 0, raster_size);
//    for(int i = 0; i < raster_size; i+=4) {
//        if((i/4)%2 == 1) {
//            raster_data[i] = 0;
//            raster_data[i+1] = 0;
//            raster_data[i+2] = 0;
//            raster_data[i+3] = 0;
//        }
//    }

    colorspace = CGColorSpaceCreateWithName(kCGColorSpaceGenericGray);
    provider = CGDataProviderCreateWithData(NULL, raster_data, raster_size, free_data);
    [self windowWidth:200 andHeight:200];
}

-(void)draw {
    for(int a = 0; a < 2; a++) {
        rule[1][1][1] = a;
        for(int b = 0; b < 2; b++) {
            rule[1][1][0] = b;
            for(int c = 0; c < 2; c++) {
                rule[1][0][1] = c;
                for(int d = 0; d < 2; d++) {
                    rule[1][0][0] = d;
                    for(int e = 0; e < 2; e++) {
                        rule[0][1][1] = e;
                        for(int f = 0; f < 2; f++) {
                            rule[0][1][0] = f;
                            for(int g = 0; g < 2; g++) {
                                rule[0][0][1] = g;
                                for(int h = 0; h < 2; h++) {
                                    rule[0][0][0] = h;
                                    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
                                    
                                    [self setData];
                                    [self createImageFromData:data];
                                    
                                    imageRef = CGImageCreate(raster_width, raster_height, 8, raster_depth * 8, raster_width * raster_depth, colorspace, kCGImageAlphaNone, provider, NULL, false, kCGRenderingIntentDefault);
                                    
                                    NSAssert( imageRef != 0, @"cgImageFromPixelBuffer failed");
                                    
                                    NSString *path = nil;
                                    NSArray	*paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDirectory, YES);
                                    if([paths count]) {		
                                        path = [paths objectAtIndex:0];
                                        NSString *folderName = @"CA_Wolfram_SinglePointAdditive";
                                        path = [path stringByAppendingPathComponent:folderName];
                                        
                                        BOOL isDir;
                                        NSFileManager *defaultManager = [NSFileManager defaultManager];
                                        [defaultManager fileExistsAtPath:path isDirectory:&isDir];
                                        if (isDir) {
                                            [defaultManager createDirectoryAtPath:path withIntermediateDirectories:NO attributes:nil error:nil];
                                        }                                     
                                    
                                    NSMutableString *fullFilePathStr = [NSMutableString stringWithString:path];
                                    NSAssert( fullFilePathStr != nil, @"stringWithString failed");
                                    
                                    NSString *fileName = [NSString stringWithFormat:@"/CA_%d%d%d%d%d%d%d%d.tiff",a,b,c,d,e,f,g,h];
                                    
                                    [fullFilePathStr appendString:fileName];
                                    
                                    NSString *finalPath = [NSString stringWithString:fullFilePathStr];
                                    NSAssert( finalPath != nil, @"stringWithString failed");
                                    
                                    CFURLRef url = CFURLCreateWithFileSystemPath (
                                                                                  kCFAllocatorDefault,
                                                                                  (CFStringRef)finalPath,
                                                                                  kCFURLPOSIXPathStyle,
                                                                                  false);
                                    NSAssert( url != 0, @"CFURLCreateWithFileSystemPath failed");
                                    
                                        
                                    // Save the image to the file
                                    CGImageDestinationRef dest = CGImageDestinationCreateWithURL(url, CFSTR("public.tiff"), 1, nil);
                                    NSAssert( dest != 0, @"CGImageDestinationCreateWithURL failed");
                                    
                                    // Set the image in the image destination to be `image' with
                                    // optional properties specified in saved properties dict.
                                    CGImageDestinationAddImage(dest, imageRef, nil);
                                    
                                    bool success = CGImageDestinationFinalize(dest);
                                    NSAssert( success != 0, @"Image could not be written successfully");
                                    
                                    CFRelease(dest);
                                    CFRelease(url);
                                    CFRelease(imageRef);
                                    [pool drain];
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}


-(void)setData {
    memset(raster_data, 0, raster_size);
    count ++;

    for (int i = 0; i < count; i++) {
        raster_data[[C4Math randomInt:768]] = 255;
    }
//    raster_data[[C4Math randomInt:768]] = 255;
//    raster_data[[C4Math randomInt:768]] = 255;

//    raster_data[192] = 255;
//    raster_data[512] = 255;
    
    int a,b,c;

    for (int currentLine = 1; currentLine < 1024; currentLine++) {
        for(int currentCell = 0; currentCell < 768; currentCell++) {
            if(currentCell == 0) {
                a = 0;
            } else {
                a = raster_data[(currentLine-1)*768+currentCell-1];
                if(a > 0) a = 1;
            }
            
            b = raster_data[(currentLine-1)*768+currentCell];
            if(b > 0) b = 1;

            if (currentCell == 767) {
                c = 0;
            } else {
                c = raster_data[(currentLine-1)*768+currentCell+1];
                if(c > 0) c = 1;
            }
            
            raster_data[currentLine*768 + currentCell] = rule[a][b][c]*255;
        }
    }
}

static void
free_data(void       *info,		/* I - Context pointer (unused) */
          const void *data,		/* I - Pointer to data */
          size_t     size)		/* I - Size of data buffer (unused) */
{
    (void)info;
    (void)size;
    
    free((void *)data);
}
@end