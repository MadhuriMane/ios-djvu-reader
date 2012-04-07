//
//  DRCachedBooksService.h
//  DjvuViewer
//
//  Created by Alex Martynov on 2/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DRBook;
@class DRCachedBook;
@class NSManagedObjectContext;

@interface DRCachedBooksService : NSOperation {
	
	@private
	NSURL* persistentStoreURL;
	NSManagedObjectContext* managedObjectContext;
	
}

-(NSArray*)cachedBooks;

-(DRCachedBook*)cachedBookForChecksum:(NSString*)checksum;

- (void)addItem:(NSString*)path
		  order:(NSUInteger)order
	   checksum:(NSString*)checksum;

-(void)addBook:(DRBook*)book;

-(void)deleteCachedBook:(DRCachedBook*)book;

@end
