//
//  DRCachedBook.h
//  DjvuViewer
//
//  Created by Alex Martynov on 2/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface DRCachedBook : NSManagedObject

@property (nonatomic, retain) NSNumber * book_id;
@property (nonatomic, retain) NSNumber * order;
@property (nonatomic, retain) NSNumber * type;
@property (nonatomic, retain) NSString * url;
@property (nonatomic, retain) NSString * checksum;

@end
