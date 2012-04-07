//
//  CULoggingUtils.m
//  DjvuViewer
//
//  Created by Alex Martynov on 2/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CULoggingUtils.h"

void CULogHex(const unsigned char* data, NSUInteger length)
{
	NSMutableString *str = [NSMutableString string];
    
    for (int i = 0; i < length; i++)
    {
        [str appendFormat:@"%02X ", data[i]];
    }

    NSLog(@"Hex dump at %p length %u: %@", data, length, str);
}
