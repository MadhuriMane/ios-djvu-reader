//
//  DRBooksThumbnailer.m
//  DjvuViewer
//
//  Created by Alex Martynov on 2/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DRBooksThumbnailer.h"

#import "DRDjvuThumbnailerTask.h"
#import "DRDjvuThumbnailerTaskDelegate.h"

@interface DRBooksThumbnailer() <DRDjvuThumbnailerTaskDelegate>

@end

@implementation DRBooksThumbnailer

- (id)init
{
    self = [super init];
    if (self)
	{
        tasks = [[NSOperationQueue alloc]init];
		tasks.maxConcurrentOperationCount = 1;
    }
    return self;
}

- (void)dealloc
{
    //TODO: cancel all tasks !!!
	[tasks release];
	[super dealloc];
}

#pragma mark -
#pragma mark properties

@synthesize delegate;

#pragma mark -
#pragma mark public

- (void) start
{
	
}

- (void) stop
{
	
}

- (void) enqeueTaskForFileAtPath:(NSString*)path thumbnailSize:(CGSize)size
{
	NSLog(@"started for %@", path);
	
	DRDjvuThumbnailerTask *task = [DRDjvuThumbnailerTask
										   djvuThumbnailerTaskWithFileAtPath:path
										   thumbnailSize:size];
	task.delegate = self;
	
	[tasks addOperation:task];
}

#pragma mark -
#pragma mark DRDjvuThumbnailerTaskDelegate

- (void) thumbnailerTask:(DRDjvuThumbnailerTask*)task didFinishedWithThumbnail:(UIImage*)image
{
	NSLog(@"finished for %@", [task filePath]);
	
	static int s_counter = 0;
	
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
	
    s_counter++;
	
	NSString *thumbPath = [basePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%ld.png", s_counter]];
	
	NSData *data = UIImagePNGRepresentation(image);
	[data writeToFile:thumbPath atomically:YES];
	
	NSLog(@"saved for %@", [task filePath]);
}

@end
