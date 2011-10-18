//
//  C4Canvas.m
//
//	A C4 project
//  Created by Travis Kirton
//

#import "C4Canvas.h"

@interface C4Canvas()
-(void)generateImageData;
@end

unsigned char	*rawData;

CGSize imageSize;
NSInteger dataSize, imageDepth, currentStartCell, startCellCount, rule[2][2][2];

@implementation C4Canvas

-(void)setup {
    [self windowWidth:768 andHeight:1024];
    
    imageSize = CGSizeMake(768,1024);
    
    imageDepth = 1;
    dataSize = imageSize.height *imageSize.width * imageDepth;
    rawData = malloc(dataSize);
    
    startCellCount = 3;
    
    rule[1][1][1] = 0;
    rule[1][1][0] = 1;
    rule[1][0][1] = 0;
    rule[1][0][0] = 0;
    rule[0][0][1] = 0;
    rule[0][1][1] = 0;
    rule[0][1][0] = 1;
    rule[0][0][0] = 1;
}

-(void)draw {
    NSString *folderName = @"test";
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
                                    [self generateImageData];
                                    
                                    C4Image *img = [C4Image imageWithData:rawData andSize:imageSize];
                                    
                                    NSString *fileName = [NSString stringWithFormat:@"/test_%d%d%d%d%d%d%d%d.tiff",a,b,c,d,e,f,g,h];
                                    
                                    [img saveWithFileName:fileName andType:@"tiff" toFolder:folderName inDirectory:DOCUMENTSDIR];
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}

-(void)generateImageData {
    memset(rawData, 0, dataSize); //clears data to black
    
    for (int i = 0; i < startCellCount; i++) {
        rawData[[C4Math randomInt:768]] = 255;
    }
    //    rawData[[C4Math randomInt:768]] = 255;
    //    rawData[[C4Math randomInt:768]] = 255;
    
    //    rawData[192] = 255;
    //    rawData[512] = 255;
    
    int a,b,c;
    
    for (int currentLine = 1; currentLine < 1024; currentLine++) {
        for(int currentCell = 0; currentCell < 768; currentCell++) {
            if(currentCell == 0) {
                a = 0;
            } else {
                a = rawData[(currentLine-1)*768+currentCell-1];
                if(a > 0) a = 1;
            }
            
            b = rawData[(currentLine-1)*768+currentCell];
            if(b > 0) b = 1;
            
            if (currentCell == 767) {
                c = 0;
            } else {
                c = rawData[(currentLine-1)*768+currentCell+1];
                if(c > 0) c = 1;
            }
            
            rawData[currentLine*768 + currentCell] = rule[a][b][c]*255;
        }
    }
}

@end