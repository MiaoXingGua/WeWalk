//
//  PSBroView.m
//  BroBoard
//
//  Created by Peter Shih on 5/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

/**
 This is an example of a subclass of PSCollectionViewCell
 */

#import "PSBroView.h"
#import "AsyncImageView.h"

#define MARGIN 4.0

@interface PSBroView ()

@property (nonatomic, retain) AsyncImageView *imageView;
@property (nonatomic, retain) UILabel *captionLabel;
@property (nonatomic, retain) UILabel *titleLabel;

@end

@implementation PSBroView

@synthesize
imageView = _imageView,
captionLabel = _captionLabel,
titleLabel = _titleLabel;


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        self.layer.borderColor = [UIColor colorWithRed:0.85 green:0.85 blue:0.85 alpha:1].CGColor;
        self.layer.borderWidth = 1;
        
        self.imageView = [[[AsyncImageView alloc] initWithFrame:CGRectZero ImageState:1] autorelease];
        self.imageView.userInteractionEnabled = NO;
        [self addSubview:self.imageView];
        
        self.titleLabel = [[[UILabel alloc] initWithFrame:CGRectZero] autorelease];
        self.titleLabel.font = [UIFont systemFontOfSize:16];
        self.titleLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:self.titleLabel];
        
        self.captionLabel = [[[UILabel alloc] initWithFrame:CGRectZero] autorelease];
        self.captionLabel.font = [UIFont systemFontOfSize:14.0];
        self.captionLabel.backgroundColor = [UIColor clearColor];
        self.captionLabel.numberOfLines = 0;
        self.captionLabel.textColor = [UIColor grayColor];
        [self addSubview:self.captionLabel];
    }
    return self;
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    
    self.imageView.image = nil;
    self.captionLabel.text = nil;
    self.titleLabel.text = nil;
}

- (void)dealloc
{
    self.imageView = nil;
    self.captionLabel = nil;
    self.titleLabel = nil;
    
    [super dealloc];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    NSLog(@"layout");
    
    CGFloat width = self.frame.size.width - MARGIN * 2;
    CGFloat top = MARGIN;
    CGFloat left = MARGIN+1;
    
    // Image
    CGFloat objectWidth = [[self.object objectForKey:@"width"] floatValue];
    CGFloat objectHeight = [[self.object objectForKey:@"height"] floatValue];
    CGFloat scaledHeight = floorf(objectHeight / (objectWidth / width));

    // Label
    CGSize labelSize = CGSizeZero;
    labelSize = [self.captionLabel.text sizeWithFont:self.captionLabel.font constrainedToSize:CGSizeMake(width, INT_MAX) lineBreakMode:self.captionLabel.lineBreakMode];
    top = self.imageView.frame.origin.y + self.imageView.frame.size.height + MARGIN;
    
    self.imageView.frame = CGRectMake(left, top, width, scaledHeight);
    
    self.titleLabel.frame = CGRectMake(left, top+scaledHeight, width, 25);
    
    self.captionLabel.frame = CGRectMake(left, top+20, labelSize.width, labelSize.height);
}

- (void)fillViewWithObject:(id)object
{
    [super fillViewWithObject:object];
    
    self.imageView.urlString = [object objectForKey:@"url"];
    self.titleLabel.text = [object objectForKey:@"title"];
    self.captionLabel.text = [object objectForKey:@"content"];
}

+ (CGFloat)heightForViewWithObject:(id)object inColumnWidth:(CGFloat)columnWidth {
    CGFloat height = 0.0;
    CGFloat width = columnWidth - MARGIN * 2;
    
    height += MARGIN;
    
    // Image
    CGFloat objectWidth = [[object objectForKey:@"width"] floatValue];
    CGFloat objectHeight = [[object objectForKey:@"height"] floatValue];
    CGFloat scaledHeight = floorf(objectHeight / (objectWidth / width));
    height += scaledHeight;
    
    // Label
    NSString *caption = [object objectForKey:@"content"];
    CGSize labelSize = CGSizeZero;
    UIFont *labelFont = [UIFont boldSystemFontOfSize:14.0];
    labelSize = [caption sizeWithFont:labelFont constrainedToSize:CGSizeMake(width, INT_MAX) lineBreakMode:0];
    height += labelSize.height;
    
    height += MARGIN;
    
    return height+30;
}

@end
