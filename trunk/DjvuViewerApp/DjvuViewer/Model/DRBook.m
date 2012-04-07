//
//  DRBook.m
//  DjvuViewer
//
//  Created by Alex Martynov on 2/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DRBook.h"

@interface DRBook()

@property (nonatomic, retain) NSString *path;
@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *checksum;
@property (nonatomic, retain) UIImage *image;

@end

@implementation DRBook

+ (id) bookWithPath:(NSString*)path checksum:(NSString*)checksum
{
	return [[[self alloc] initWithPath:path checksum:checksum] autorelease];
}

- (id) initWithPath:(NSString*)path checksum:(NSString*)checksum
{
	if (self = [super init])
	{
		self.checksum = checksum;
		self.path = path;
		self.title = [path lastPathComponent];
		self.image = [UIImage imageNamed:@"book_default"];
	}
	
	return self;
}

- (void) dealloc
{
	self.path = nil;
	self.title = nil;
	self.checksum = nil;
	self.image = nil;
	[super dealloc];
}

-(NSString*)description
{
	return [NSString stringWithFormat:@"%@: path = %@", 
			[super description], [self.path lastPathComponent]];
}

#pragma mark -
#pragma mark properties

@synthesize path, title, image, checksum, order;

@end
