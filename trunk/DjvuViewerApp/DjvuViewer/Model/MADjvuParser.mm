//
//  MADjvuParser.m
//  DjvuViewer
//
//  Created by Alex Martynov on 2/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MADjvuParser.h"

#import "ddjvuapi.h"
#import "NSString+UUID.h"
#import "CUCodeProfiling.h"

struct MADjvuParserContext
{
    ddjvu_context_t *ddjvu_context;
    ddjvu_document_t *ddjvu_document;
};

@interface MADjvuParser()

+ (MADjvuParserContext *) contextWithFilePath:(NSString*)path;

@property(nonatomic, assign) NSUInteger numberOfPages;

- (void) loadFile;

@end

@implementation MADjvuParser

- (id) initWithPath:(NSString*)path
{
    if (self = [super init])
    {
        filePath = [path copy];
		context = [MADjvuParser contextWithFilePath:filePath];
		[self loadFile];
    }
    
    return self;
}

#pragma mark -
#pragma mark properties

@synthesize numberOfPages;

#pragma mark -
#pragma mark public

- (UIImage*)imageForPage:(NSUInteger)page
{
	if (self.numberOfPages == 0)
		return nil;
	
	int pageno = (int)page;
	ddjvu_page_t *djvu_page = NULL;
	ddjvu_rect_t rect;
	ddjvu_format_t *format;
	
	CULogCodeTime(@"Page creating", 
	{	
    djvu_page = ddjvu_page_create_by_pageno(context->ddjvu_document,pageno);
	if (djvu_page == NULL)
	{
		NSLog(@"Can't create djvu page of number %d", pageno);
		return nil;
	}

    rect.x = 0;
    rect.y = 0;
    rect.w = ddjvu_page_get_width  (djvu_page) / 2;
	rect.h = ddjvu_page_get_height (djvu_page) / 2;
    
    format = ddjvu_format_create (DDJVU_FORMAT_RGB24, 0, 0);
	
	if (format == NULL)
	{
		NSLog(@"Can't create djvu format");
		return nil;
	}
    }
				  );
	
    unsigned long rowsize = rect.w * 3;
    
	unsigned char* rgba = NULL;
	
	CULogCodeTime(@"Rendering", 
	//rgba = (unsigned char*)malloc(rect.w*rect.h*3);
	rgba = (unsigned char*)malloc(rect.w*rect.h*4);
	
    
    int rs = ddjvu_page_render (djvu_page,
                                DDJVU_RENDER_COLOR,
                                &rect,
                                &rect,
                                format,
                                rowsize,
                                (char *)rgba);
				  );
	
	unsigned char* img_data = NULL;
	CULogCodeTime(@"Converting", 
    img_data = (unsigned char*)malloc(rect.w*rect.h*4);//RGBA
    
//    for (long i = 0; i < rect.h; i++)
//    {
//        for (long j = 0; j < rect.w*4; j++)
//        {
//            if (j % 4 == 3)
//                img_data[j+i*rect.w*4] = 255;
//            else
//                img_data[j+i*rect.w*4]=rgba[(j-j/4)+i*rect.w*3];
//        }
//    }
				  //http://stackoverflow.com/questions/8451149/yuv-to-rgba-on-apple-a4-should-i-use-shaders-or-neon
				  for (long j = rect.w; j >= 0; j--)
				  {
					  
				  }
				  
				  for (long i = 0; i < rect.h; i++)
				  {
					  for (long j = 0; j < rect.w*4; j++)
					  {
						  if (j % 4 == 3)
							  img_data[j+i*rect.w*4] = 255;
						  else
							  img_data[j+i*rect.w*4]=rgba[(j-j/4)+i*rect.w*3];
					  }
				  }
				  
				  );
	
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef bitmapContext = CGBitmapContextCreate(
                                                       img_data,
                                                       rect.w,
                                                       rect.h,
                                                       8, // bitsPerComponent
													   4*rect.w, // bytesPerRow
                                                       colorSpace,
                                                       kCGImageAlphaNoneSkipLast
                                                       );
    
    CFRelease(colorSpace);
	
	ddjvu_page_release(djvu_page);
	free(rgba);
    
    CGImageRef cgImage = CGBitmapContextCreateImage(bitmapContext);
    
    UIImage *img = [UIImage imageWithCGImage:cgImage];
	
	return img;
}

- (UIImage*)imageForPage:(NSUInteger)page ofSize:(CGSize)size
{
	if (self.numberOfPages == 0)
		return nil;
	
	int pageno = (int)page;
	ddjvu_page_t *djvu_page = NULL;
	ddjvu_rect_t rect;
	ddjvu_format_t *format;
	
	CULogCodeTime(@"Page creating", 
				  {	
					  djvu_page = ddjvu_page_create_by_pageno(context->ddjvu_document,pageno);
					  if (djvu_page == NULL)
					  {
						  NSLog(@"Can't create djvu page of number %d", pageno);
						  return nil;
					  }
					  
					  rect.x = 0;
					  rect.y = 0;
					  rect.w = ddjvu_page_get_width  (djvu_page) / 4;
					  rect.h = ddjvu_page_get_height (djvu_page) / 4;
					  
					  //masks = NULL;
					  unsigned int masks[3];
					  masks[0] = 0xff000000;
					  masks[1] = 0x00ff0000;
					  masks[2] = 0x0000ff00;
					  //masks[3] = 0xff000000;
					  
					  format = ddjvu_format_create (DDJVU_FORMAT_RGBMASK32, 3, masks);
					  
					  if (format == NULL)
					  {
						  NSLog(@"Can't create djvu format");
						  return nil;
					  }
					  ddjvu_format_set_y_direction(format, 1);
				  }
				  );
	
    unsigned long rowsize = rect.w * 4;
    
	unsigned char* rgba = NULL;
	
	CULogCodeTime(@"Rendering", 
				  rgba = (unsigned char*)malloc(rect.w*rect.h*4);
				  
				  
				  int rs = ddjvu_page_render (djvu_page,
											  DDJVU_RENDER_COLOR,
											  &rect,
											  &rect,
											  format,
											  rowsize,
											  (char *)rgba);
				  );
	
//	unsigned char* img_data = NULL;
//	CULogCodeTime(@"Converting", 
//				  img_data = (unsigned char*)malloc(rect.w*rect.h*4);//RGBA
//				  
//				  for (long i = 0; i < rect.h; i++)
//				  {
//					  for (long j = 0; j < rect.w*4; j++)
//					  {
//						  if (j % 4 == 3)
//							  img_data[j+i*rect.w*4] = 255;
//						  else
//							  img_data[j+i*rect.w*4]=rgba[(j-j/4)+i*rect.w*3];
//					  }
//				  }
//				  );
	
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef bitmapContext = CGBitmapContextCreate(
                                                       rgba,
                                                       rect.w,
                                                       rect.h,
                                                       8, // bitsPerComponent
													   4*rect.w, // bytesPerRow
                                                       colorSpace,
                                                       kCGImageAlphaNoneSkipFirst
                                                       );
    
    CFRelease(colorSpace);
	
	ddjvu_page_release(djvu_page);
	//free(rgba);
    
    CGImageRef cgImage = CGBitmapContextCreateImage(bitmapContext);
    
    UIImage *img = [UIImage imageWithCGImage:cgImage];
	
	return img;
}

#pragma mark -
#pragma mark private

//TODO: error handling
+ (MADjvuParserContext *) contextWithFilePath:(NSString*)path
{
    MADjvuParserContext* result = (MADjvuParserContext*)calloc(1, sizeof(MADjvuParserContext));
    
    NSString *uniqueAppID = [NSString stringWithFormat:@"DjvuViewer_%@", [NSString UUID]];
    //ddjvu_document_create_by_filename_utf8
    result->ddjvu_context = ddjvu_context_create([uniqueAppID UTF8String]);
    result->ddjvu_document = ddjvu_document_create_by_filename(result->ddjvu_context,
                                                                [path UTF8String],
                                                                FALSE);
	
	return result;
}

- (void) loadFile
{
	//TODO: fuck!!!
	if (context->ddjvu_document == NULL)
		return;
	int np = ddjvu_document_get_pagenum(context->ddjvu_document);
	
	if (np < 0)
		np = 0;
	
	self.numberOfPages = (NSUInteger)np;
}

@end
