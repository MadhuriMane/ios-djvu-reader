//
//  DRBooksBrowserService.m
//  DjvuViewer
//
//  Created by Alex Martynov on 2/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DRBooksBrowserService.h"

#import "DRBook.h"
#import "DRCachedBook.h"
#import "NSString+MD5.h"
#import "CUSpecialFolders.h"


#import "DRBooksThumbnailer.h"
#import "DRCachedBooksService.h"

@interface DRBooksBrowserService()

-(NSArray*)cachedBooks;

-(NSString*)checksumForBookAtPath:(NSString*)path;

@end

@implementation DRBooksBrowserService

-(id)init
{
	if (self = [super init])
	{
		books = nil;
		serv = [[DRCachedBooksService alloc] init];
	}
	return self;
}

-(void)dealloc
{
	[serv release];
	[books release];
	[super dealloc];
}

#pragma mark -
#pragma mark properties

@synthesize delegate;

-(NSArray*)books
{
	if (books == nil)
		books = [[self cachedBooks]retain];
	return books;
}

#pragma mark -
#pragma mark public

-(void)startUpdating
{
	[self performSelectorInBackground:@selector(pppp_rename) withObject:nil];
}

-(void)syncCache:(NSArray*)theBooks
{
	NSInteger order = 0;
	
	for (DRBook* book in theBooks)
	{
		book.order = order;
		[serv addBook:book];
		order++;
	}
}
	 
-(void)pppp_rename
{
	/**/
	NSFileManager* fileManager = [[NSFileManager alloc]init];
	
	NSError *err = nil;
	NSArray *files = nil;
	
	DRCachedBooksService *serv = [[DRCachedBooksService alloc] init];
	
	for (DRCachedBook *cachedBook in [serv cachedBooks])
	{
		if ([fileManager fileExistsAtPath:cachedBook.url])
		{
//			NSString* fileChecksum = [self checksumForBookAtPath:path];
//			
//			[result addObject:[DRBook bookWithPath:cachedBook.url
//										  checksum:]];
		}
		else
		{
			//TODO: use bulk delete
			[serv deleteCachedBook:cachedBook];
		}
	}
	
	/**/
	files = [fileManager contentsOfDirectoryAtPath:CSUserDocumentsDirectory() error:&err];
	
	if (err != nil)
		return;
	
	NSPredicate *filter = [NSPredicate predicateWithFormat:@"self ENDSWITH '.djvu'"];
	NSArray *filteredFiles = [files filteredArrayUsingPredicate:filter];
	
	[fileManager release];
	
	NSLog(@"filtered items = %@", filteredFiles);
	
	NSArray* cachedBooks = [self cachedBooks];

	for (NSString *path in filteredFiles)
	{
		NSString* fileChecksum = [self checksumForBookAtPath:path];
		
		NSUInteger index =
		[cachedBooks indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
			DRBook* book = (DRBook*)obj;
			if ([book.checksum isEqualToString:fileChecksum])
			{
				*stop = YES;
				return YES;
			}
			return NO;
		}
		 ];
		
		if (index == NSNotFound)
			[serv addItem:[CSUserDocumentsDirectory() stringByAppendingPathComponent:path]
					order:0
				 checksum:fileChecksum];
	}
	
	NSArray* p_books = [self cachedBooks];
	
	NSLog(@"books = %@", p_books);
}

#pragma mark -
#pragma mark private

-(NSArray*)cachedBooks
{
	NSMutableArray* result = [NSMutableArray array];
	NSFileManager* fileManager = [[NSFileManager alloc]init];
	
	DRCachedBooksService *serv = [[DRCachedBooksService alloc] init];
	
	NSArray* cachedBoks = [serv cachedBooks];
	
	for (DRCachedBook *cachedBook in cachedBoks)
	{
		NSLog(@"cachedBook %@ with order %ld", cachedBook.url, [cachedBook.order integerValue]);
		if ([fileManager fileExistsAtPath:cachedBook.url])
		{
			[result addObject:[DRBook bookWithPath:cachedBook.url
										  checksum:cachedBook.checksum]];
		}
	}
	
	[fileManager release];
	[serv release];
	
	return result;
}

-(NSString*)checksumForBookAtPath:(NSString*)path
{
	return [path MD5];
}

@end
