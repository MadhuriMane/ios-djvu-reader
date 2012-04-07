//
//  CUCodeProfiling.h
//  DjvuViewer
//
//  Created by Alex Martynov on 2/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#define CULogCodeTime(comment,code)											\
{																				\
	NSDate* startTimeMarker = [NSDate date];									\
	code;																		\
	NSLog(@"%@ time=%lf",comment,[[NSDate date] timeIntervalSinceDate:startTimeMarker]);\
}
