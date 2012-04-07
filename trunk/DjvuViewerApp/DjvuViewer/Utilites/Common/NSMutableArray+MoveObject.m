//
//  NSMutableArray+MoveObject.m
//  DjvuViewer
//
//  Created by Alex Martynov on 2/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NSMutableArray+MoveObject.h"

@implementation NSMutableArray(MoveObject)

-(void)moveObjectAtIndex:(NSUInteger)fromIndex toIndex:(NSUInteger)toIndex
{
	if (fromIndex == toIndex)
		return;
	id obj = [self objectAtIndex:fromIndex];
	[[obj retain] autorelease];
	[self removeObjectAtIndex:fromIndex];
	
	if (toIndex > fromIndex)
		toIndex--;
	
	[self insertObject:obj atIndex:toIndex];
}

@end
