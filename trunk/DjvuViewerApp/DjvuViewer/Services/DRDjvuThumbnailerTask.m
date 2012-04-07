//
//  DRDjvuThumbnailerTask.m
//  DjvuViewer
//
//  Created by Alex Martynov on 2/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DRDjvuThumbnailerTask.h"

#import "MADjvuParser.h"
#import "DRDjvuThumbnailerTaskDelegate.h"

@interface DRDjvuThumbnailerTask()

@property (nonatomic, copy) NSString *filePath;

@property (nonatomic, assign) CGSize thumbnailSize;

@end

@implementation DRDjvuThumbnailerTask

+ (id) djvuThumbnailerTaskWithFileAtPath:(NSString*)path thumbnailSize:(CGSize)size
{
	return [[[self alloc] initWithFileAtPath:path
							   thumbnailSize:size] autorelease];
}

- (id) initWithFileAtPath:(NSString*)path thumbnailSize:(CGSize)size
{
	if (self = [super init])
	{
		self.filePath = path;
		self.thumbnailSize = size;
	}
	return self;
}

- (void)dealloc
{
	self.filePath = nil;
    [super dealloc];
}

#pragma mark -
#pragma mark properties

@synthesize delegate, filePath, thumbnailSize;

#pragma mark -
#pragma mark NSOperation

- (void)main
{
	//TODO: is cancelled???
	//TODO: size???
	MADjvuParser *djvuParser = [[MADjvuParser alloc]initWithPath:self.filePath];
	UIImage *image = [djvuParser imageForPage:1];
	[djvuParser release];
	
	[self.delegate thumbnailerTask:self
		  didFinishedWithThumbnail:image];
}

@end
