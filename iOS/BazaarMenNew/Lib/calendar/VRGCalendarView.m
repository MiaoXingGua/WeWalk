//
//  VRGCalendarView.m
//  Vurig
//
//  Created by in 't Veen Tjeerd on 5/8/12.
//  Copyright (c) 2012 Vurig Media. All rights reserved.
//

#import "VRGCalendarView.h"
#import <QuartzCore/QuartzCore.h>
#import "NSDate+convenience.h"
#import "NSMutableArray+convenience.h"
#import "UIView+convenience.h"

@implementation VRGCalendarView
@synthesize currentMonth,delegate,labelCurrentMonth, animationView_A,animationView_B;
@synthesize markedDates,markedColors,calendarHeight,selectedDate;
@synthesize userDate = _userDate;

#pragma mark - Select Date
-(void)selectDate:(int)date
{
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comps = [gregorian components:NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit fromDate:self.currentMonth];
    [comps setDay:date];
    self.selectedDate = [gregorian dateFromComponents:comps];
    
    int selectedDateYear = [selectedDate year];
    int selectedDateMonth = [selectedDate month];
    int currentMonthYear = [currentMonth year];
    int currentMonthMonth = [currentMonth month];
    
    if (selectedDateYear < currentMonthYear) {
        [self showPreviousMonth];
    } else if (selectedDateYear > currentMonthYear) {
        [self showNextMonth];
    } else if (selectedDateMonth < currentMonthMonth) {
        [self showPreviousMonth];
    } else if (selectedDateMonth > currentMonthMonth) {
        [self showNextMonth];
    } else {
        [self setNeedsDisplay];
    }
    
    if ([delegate respondsToSelector:@selector(calendarView:dateSelected:)]) [delegate calendarView:self dateSelected:self.selectedDate];
}

#pragma mark - Mark Dates
//NSArray can either contain NSDate objects or NSNumber objects with an int of the day.
-(void)markDates:(NSArray *)dates {
    self.markedDates = dates;
    NSMutableArray *colors = [[NSMutableArray alloc] init];
    
    for (int i = 0; i<[dates count]; i++) {
        [colors addObject:[UIColor colorWithHexString:@"0x383838"]];
    }
    
    self.markedColors = [NSArray arrayWithArray:colors];
    [colors release];
    
    NSLog(@"%@",self.markedColors);

    
    [self setNeedsDisplay];
}

//NSArray can either contain NSDate objects or NSNumber objects with an int of the day.
-(void)markDates:(NSArray *)dates withColors:(NSArray *)colors {
    self.markedDates = dates;
    
    self.markedColors = [NSArray arrayWithArray:colors];
    NSLog(@"%@",self.markedColors);
    
    [self setNeedsDisplay];
}

#pragma mark - Set date to now
-(void)reset
{
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components =
    [gregorian components:(NSYearCalendarUnit | NSMonthCalendarUnit |
                           NSDayCalendarUnit) fromDate: self.userDate];
    self.currentMonth = [gregorian dateFromComponents:components]; //clean month
    
    [self updateSize];
    [self setNeedsDisplay];
    [delegate calendarView:self switchedToMonth:currentMonth targetHeight:self.calendarHeight animated:NO];
}

#pragma mark - Next & Previous
-(void)showNextMonth
{
    if (isAnimating) return;
    self.markedDates=nil;
    isAnimating=YES;
    prepAnimationNextMonth=YES;
    
    [self setNeedsDisplay];
    
    int lastBlock = [currentMonth firstWeekDayInMonth]+[currentMonth numDaysInMonth]-1;
    int numBlocks = [self numRows]*7;
    BOOL hasNextMonthDays = lastBlock<numBlocks;
    
    //Old month
    float oldSize = 320;
    UIImage *imageCurrentMonth = [self drawCurrentState];
    
    //New month
    self.currentMonth = [currentMonth offsetMonth:1];
    if ([delegate respondsToSelector:@selector(calendarView:switchedToMonth:targetHeight: animated:)]) [delegate calendarView:self switchedToMonth:currentMonth targetHeight:self.calendarHeight animated:YES];
    prepAnimationNextMonth=NO;
    [self setNeedsDisplay];
    
    UIImage *imageNextMonth = [self drawCurrentState];
    NSLog(@"%f",imageNextMonth.size.height);
    
  //  float targetSize = fmaxf(oldSize, self.calendarHeight);
    UIView *animationHolder = [[UIView alloc] initWithFrame:CGRectMake(0, 50, kVRGCalendarViewWidth, 155)];
    [animationHolder setClipsToBounds:YES];
    animationHolder.backgroundColor = [UIColor clearColor];
    [self addSubview:animationHolder];
    [animationHolder release];
    
    //Animate
    self.animationView_A = [[UIImageView alloc] initWithImage:imageCurrentMonth];
    self.animationView_B = [[UIImageView alloc] initWithImage:imageNextMonth];
    [animationHolder addSubview:animationView_A];
    [animationHolder addSubview:animationView_B];
    
    if (hasNextMonthDays) {
        animationView_B.frameX = animationView_A.frameX + animationView_A.frameWidth - (kVRGCalendarViewDayHeight+3);
    } else {
        animationView_B.frameX = animationView_A.frameX + animationView_A.frameWidth -3;
    }
    
    //Animation
    __block VRGCalendarView *blockSafeSelf = self;
    [UIView animateWithDuration:0.35
                     animations:^{
                         [self updateSize];
                         //blockSafeSelf.frameHeight = 100;
                         if (hasNextMonthDays) {
                             animationView_A.frameX = -animationView_A.frameWidth +3;
                         } else {
                             animationView_A.frameX = -animationView_A.frameWidth + 3;
                         }
                         animationView_B.frameX = 0;
                     }
                     completion:^(BOOL finished) {
                         [animationView_A removeFromSuperview];
                         [animationView_B removeFromSuperview];
                         blockSafeSelf.animationView_A=nil;
                         blockSafeSelf.animationView_B=nil;
                         isAnimating=NO;
                         [animationHolder removeFromSuperview];
                     }
     ];
}

-(void)showPreviousMonth
{
    if (isAnimating) return;
    isAnimating=YES;
    self.markedDates=nil;
    //Prepare current screen
    prepAnimationPreviousMonth = YES;
    [self setNeedsDisplay];
    BOOL hasPreviousDays = [currentMonth firstWeekDayInMonth]>1;
    float oldSize = 320;
    UIImage *imageCurrentMonth = [self drawCurrentState];
    
    //Prepare next screen
    self.currentMonth = [currentMonth offsetMonth:-1];
    if ([delegate respondsToSelector:@selector(calendarView:switchedToMonth:targetHeight:animated:)]) [delegate calendarView:self switchedToMonth:currentMonth targetHeight:self.calendarHeight animated:YES];
    prepAnimationPreviousMonth=NO;
    [self setNeedsDisplay];
    UIImage *imagePreviousMonth = [self drawCurrentState];
    
   // float targetSize = fmaxf(oldSize, self.calendarHeight-300);
    
    UIView *animationHolder = [[UIView alloc] initWithFrame:CGRectMake(0, 50, kVRGCalendarViewWidth, 150)];
    animationHolder.backgroundColor = [UIColor clearColor];
    [animationHolder setClipsToBounds:YES];
    [self addSubview:animationHolder];
    [animationHolder release];
    
    self.animationView_A = [[UIImageView alloc] initWithImage:imageCurrentMonth];
    self.animationView_B = [[UIImageView alloc] initWithImage:imagePreviousMonth];
    [animationHolder addSubview:animationView_A];
    [animationHolder addSubview:animationView_B];
    
    if (hasPreviousDays) {
        animationView_B.frameX = animationView_A.frameX - (animationView_B.frameWidth-kVRGCalendarViewDayHeight) + 3;
    } else {
        animationView_B.frameX = animationView_A.frameX - animationView_B.frameWidth + 3;
    }
    
    __block VRGCalendarView *blockSafeSelf = self;
    [UIView animateWithDuration:0.35
                     animations:^{
                         [self updateSize];
                         
                         if (hasPreviousDays) {
                             animationView_A.frameX = animationView_B.frameWidth-3;
                             
                         } else {
                             animationView_A.frameX = animationView_B.frameWidth-3;
                         }
                         
                         animationView_B.frameX = 0;
                     }
                     completion:^(BOOL finished) {
                         [animationView_A removeFromSuperview];
                         [animationView_B removeFromSuperview];
                         blockSafeSelf.animationView_A=nil;
                         blockSafeSelf.animationView_B=nil;
                         isAnimating=NO;
                         [animationHolder removeFromSuperview];
                     }
     ];
}


#pragma mark - update size & row count
-(void)updateSize {
    self.frameHeight = self.calendarHeight+15;
    [self setNeedsDisplay];
}

-(float)calendarHeight {
    return kVRGCalendarViewTopBarHeight + [self numRows]*(kVRGCalendarViewDayHeight+2)+1;
}

-(int)numRows {
    float lastBlock = [self.currentMonth numDaysInMonth]+([self.currentMonth firstWeekDayInMonth]-1);
    return ceilf(lastBlock/7);
}

- (void)tap:(UITapGestureRecognizer *)sender
{
    CGPoint touchPoint = [sender locationInView:self];
    
    self.selectedDate=nil;
    
    //Touch a specific day
    if (touchPoint.y > kVRGCalendarViewTopBarHeight) {
        float xLocation = touchPoint.x;
        float yLocation = touchPoint.y-kVRGCalendarViewTopBarHeight;
        
        int column = floorf(xLocation/(kVRGCalendarViewDayWidth+2));
        int row = floorf(yLocation/(kVRGCalendarViewDayHeight+2));
        
        int blockNr = (column+1)+row*7;
        int firstWeekDay = [self.currentMonth firstWeekDayInMonth]-1; //-1 because weekdays begin at 1, not 0
        int date = blockNr-firstWeekDay;
        [self selectDate:date];
        
        return;
    }
    
    self.markedDates=nil;
    self.markedColors=nil;
    
    CGRect rectArrowLeft = CGRectMake(0, 0, 50, 40);
    CGRect rectArrowRight = CGRectMake(self.frame.size.width-50, 0, 50, 40);
    
    //Touch either arrows or month in middle
    if (CGRectContainsPoint(rectArrowLeft, touchPoint)) {
        [self showPreviousMonth];
    } else if (CGRectContainsPoint(rectArrowRight, touchPoint)) {
        [self showNextMonth];
    } else if (CGRectContainsPoint(self.labelCurrentMonth.frame, touchPoint)) {
        //Detect touch in current month
        int currentMonthIndex = [self.currentMonth month];
        int todayMonth = [self.userDate month];
        [self reset];
        if ((todayMonth!=currentMonthIndex) && [delegate respondsToSelector:@selector(calendarView:switchedToMonth:targetHeight:animated:)]) [delegate calendarView:self switchedToMonth:currentMonth targetHeight:self.calendarHeight animated:NO];
    }
}
//#pragma mark - Touches
//-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event 
//{       
////    UITouch *touch = [touches anyObject];
////    CGPoint touchPoint = [touch locationInView:self];
//    
//
//}

#pragma mark - Drawing
- (void)drawRect:(CGRect)rect
{
    int firstWeekDay = [self.currentMonth firstWeekDayInMonth]-1; //-1 because weekdays begin at 1, not 0
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy  MM"];
    labelCurrentMonth.text = [formatter stringFromDate:self.currentMonth];
    [formatter release];
    [currentMonth firstWeekDayInMonth];
    
    CGContextClearRect(UIGraphicsGetCurrentContext(),rect);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGRect rectangle = CGRectMake(0,0,self.frame.size.width,kVRGCalendarViewTopBarHeight);
    CGContextAddRect(context, rectangle);
    CGContextSetFillColorWithColor(context, [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1].CGColor);
    CGContextFillPath(context);
    
//    //Arrows
//    int arrowSize = 12;
//    int xmargin = 20;
//    int ymargin = 18;
//    
//    //Arrow Left
//    CGContextBeginPath(context);
//    CGContextMoveToPoint(context, xmargin+arrowSize/1.5, ymargin);
//    CGContextAddLineToPoint(context,xmargin+arrowSize/1.5,ymargin+arrowSize);
//    CGContextAddLineToPoint(context,xmargin,ymargin+arrowSize/2);
//    CGContextAddLineToPoint(context,xmargin+arrowSize/1.5, ymargin);
//    
//    CGContextSetFillColorWithColor(context, 
//                                   [UIColor blackColor].CGColor);
//    CGContextFillPath(context);
//    
//    //Arrow right
//    CGContextBeginPath(context);
//    CGContextMoveToPoint(context, self.frame.size.width-(xmargin+arrowSize/1.5), ymargin);
//    CGContextAddLineToPoint(context,self.frame.size.width-xmargin,ymargin+arrowSize/2);
//    CGContextAddLineToPoint(context,self.frame.size.width-(xmargin+arrowSize/1.5),ymargin+arrowSize);
//    CGContextAddLineToPoint(context,self.frame.size.width-(xmargin+arrowSize/1.5), ymargin);
//    
//    CGContextSetFillColorWithColor(context, 
//                                   [UIColor blackColor].CGColor);
//    CGContextFillPath(context);
    
    //Weekdays
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat=@"EEE";
    //always assume gregorian with monday first
    NSMutableArray *weekdays = [[NSMutableArray alloc] initWithArray:[dateFormatter shortWeekdaySymbols]];
    [weekdays moveObjectFromIndex:0 toIndex:6];
    
    CGContextSetFillColorWithColor(context, 
                                   [UIColor colorWithRed:0.3 green:0.69 blue:0.87 alpha:1].CGColor);
    for (int i =0; i<[weekdays count]; i++)
    {
        NSString *weekdayValue = (NSString *)[weekdays objectAtIndex:i];
        UIFont *font = [UIFont fontWithName:@"HelveticaNeue" size:12];
        [weekdayValue drawInRect:CGRectMake(i*(kVRGCalendarViewDayWidth+2), 31, kVRGCalendarViewDayWidth+2, 30) withFont:font lineBreakMode:UILineBreakModeClip alignment:UITextAlignmentCenter];
    }
    
    int numRows = [self numRows];
    
    CGContextSetAllowsAntialiasing(context, NO);
    
    //Grid background
    float gridHeight = numRows*(kVRGCalendarViewDayHeight+2)+1;
    CGRect rectangleGrid = CGRectMake(0,kVRGCalendarViewTopBarHeight,self.frame.size.width,gridHeight+15);
    CGContextAddRect(context, rectangleGrid);
    CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
    //CGContextSetFillColorWithColor(context, [UIColor colorWithHexString:@"0xff0000"].CGColor);
    CGContextFillPath(context);
    
    //Grid white lines
    CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, 0, kVRGCalendarViewTopBarHeight+1);
    CGContextAddLineToPoint(context, kVRGCalendarViewWidth, kVRGCalendarViewTopBarHeight+1);
    for (int i = 1; i<7; i++) {
        CGContextMoveToPoint(context, i*(kVRGCalendarViewDayWidth+1)+i*1-1, kVRGCalendarViewTopBarHeight);
        CGContextAddLineToPoint(context, i*(kVRGCalendarViewDayWidth+1)+i*1-1, kVRGCalendarViewTopBarHeight+gridHeight);
        
        if (i>numRows-1) continue;
        //rows
        CGContextMoveToPoint(context, 0, kVRGCalendarViewTopBarHeight+i*(kVRGCalendarViewDayHeight+1)+i*1+1);
        CGContextAddLineToPoint(context, kVRGCalendarViewWidth, kVRGCalendarViewTopBarHeight+i*(kVRGCalendarViewDayHeight+1)+i*1+1);
    }
    
    CGContextStrokePath(context);
    
    //Grid dark lines
    CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, 0, kVRGCalendarViewTopBarHeight);
    CGContextAddLineToPoint(context, kVRGCalendarViewWidth, kVRGCalendarViewTopBarHeight);
    for (int i = 1; i<7; i++) {
        //columns
        CGContextMoveToPoint(context, i*(kVRGCalendarViewDayWidth+1)+i*1, kVRGCalendarViewTopBarHeight);
        CGContextAddLineToPoint(context, i*(kVRGCalendarViewDayWidth+1)+i*1, kVRGCalendarViewTopBarHeight+gridHeight);
        
        if (i>numRows-1) continue;
        //rows
        CGContextMoveToPoint(context, 0, kVRGCalendarViewTopBarHeight+i*(kVRGCalendarViewDayHeight+1)+i*1);
        CGContextAddLineToPoint(context, kVRGCalendarViewWidth, kVRGCalendarViewTopBarHeight+i*(kVRGCalendarViewDayHeight+1)+i*1);
    }
    CGContextMoveToPoint(context, 0, gridHeight+kVRGCalendarViewTopBarHeight);
    CGContextAddLineToPoint(context, kVRGCalendarViewWidth, gridHeight+kVRGCalendarViewTopBarHeight);
    
    CGContextStrokePath(context);
    
    CGContextSetAllowsAntialiasing(context, YES);
    
    //Draw days
    CGContextSetFillColorWithColor(context, 
                                   [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:1].CGColor);
    
    
    //NSLog(@"currentMonth month = %i, first weekday in month = %i",[self.currentMonth month],[self.currentMonth firstWeekDayInMonth]);
    
    int numBlocks = numRows*7;
    NSDate *previousMonth = [self.currentMonth offsetMonth:-1];
    int currentMonthNumDays = [currentMonth numDaysInMonth];
    int prevMonthNumDays = [previousMonth numDaysInMonth];
    
    int selectedDateBlock = ([selectedDate day]-1)+firstWeekDay;
    
    //prepAnimationPreviousMonth nog wat mee doen
    
    //prev next month
    BOOL isSelectedDatePreviousMonth = prepAnimationPreviousMonth;
    BOOL isSelectedDateNextMonth = prepAnimationNextMonth;
    
    if (self.selectedDate!=nil) {
        isSelectedDatePreviousMonth = ([selectedDate year]==[currentMonth year] && [selectedDate month]<[currentMonth month]) || [selectedDate year] < [currentMonth year];
        
        if (!isSelectedDatePreviousMonth) {
            isSelectedDateNextMonth = ([selectedDate year]==[currentMonth year] && [selectedDate month]>[currentMonth month]) || [selectedDate year] > [currentMonth year];
        }
    }
    
    if (isSelectedDatePreviousMonth) {
        int lastPositionPreviousMonth = firstWeekDay-1;
        selectedDateBlock=lastPositionPreviousMonth-([selectedDate numDaysInMonth]-[selectedDate day]);
    } else if (isSelectedDateNextMonth) {
        selectedDateBlock = [currentMonth numDaysInMonth] + (firstWeekDay-1) + [selectedDate day];
    }
    
    
    NSDate *todayDate = self.userDate;
    int todayBlock = -1;
    
//    NSLog(@"currentMonth month = %i day = %i, todaydate day = %i",[currentMonth month],[currentMonth day],[todayDate month]);
    
    if ([todayDate month] == [currentMonth month] && [todayDate year] == [currentMonth year]) {
        todayBlock = [todayDate day] + firstWeekDay - 1;
    }
    
    for (int i=0; i<numBlocks; i++) {
        int targetDate = i;
        int targetColumn = i%7;
        int targetRow = i/7;
        int targetX = targetColumn * (kVRGCalendarViewDayWidth+2);
        int targetY = kVRGCalendarViewTopBarHeight + targetRow * (kVRGCalendarViewDayHeight+2);
        
        // BOOL isCurrentMonth = NO;
        if (i<firstWeekDay) { //previous month
            targetDate = (prevMonthNumDays-firstWeekDay)+(i+1);
            NSString *hex = (isSelectedDatePreviousMonth) ? @"0x383838" : @"aaaaaa";
            
            CGContextSetFillColorWithColor(context, 
                                           [UIColor colorWithHexString:hex].CGColor);
        } else if (i>=(firstWeekDay+currentMonthNumDays)) { //next month
            targetDate = (i+1) - (firstWeekDay+currentMonthNumDays);
            NSString *hex = (isSelectedDateNextMonth) ? @"0x383838" : @"aaaaaa";
            CGContextSetFillColorWithColor(context, 
                                           [UIColor colorWithHexString:hex].CGColor);
        } else { //current month
            // isCurrentMonth = YES;
            targetDate = (i-firstWeekDay)+1;
            NSString *hex = (isSelectedDatePreviousMonth || isSelectedDateNextMonth) ? @"0xaaaaaa" : @"0x383838";
            CGContextSetFillColorWithColor(context, 
                                           [UIColor colorWithHexString:hex].CGColor);
        }
        
        NSString *date = [NSString stringWithFormat:@"%i",targetDate];
        
        //draw selected date
        if (selectedDate && i==selectedDateBlock) {  //选中日期
            CGRect rectangleGrid = CGRectMake(targetX+10,targetY+7,kVRGCalendarViewDayWidth-6-10,kVRGCalendarViewDayHeight+2-5);
            CGContextAddRect(context, rectangleGrid);
            CGContextSetFillColorWithColor(context, [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1].CGColor);
            CGContextFillPath(context);
            
            CGContextSetFillColorWithColor(context, 
                                           [UIColor blackColor].CGColor);
        } else if (todayBlock==i) {     //当前日期
            
            CGRect rectangleGrid = CGRectMake(targetX+11.2,targetY+7,kVRGCalendarViewDayWidth-18,kVRGCalendarViewDayHeight+6-8);
//            CGContextAddRect(context, rectangleGrid);
//            CGContextSetFillColorWithColor(context, [UIColor purpleColor].CGColor);
//            CGContextFillPath(context);
            
            CGContextRef ctx = UIGraphicsGetCurrentContext();
            CGContextAddEllipseInRect(ctx, rectangleGrid);
            CGContextSetFillColor(ctx, CGColorGetComponents([[UIColor colorWithRed:0.92 green:0.27 blue:0.23 alpha:1] CGColor]));
            CGContextFillPath(ctx);
            
            CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
        }
        
        [date drawInRect:CGRectMake(targetX+2, targetY+10, kVRGCalendarViewDayWidth, kVRGCalendarViewDayHeight) withFont:[UIFont systemFontOfSize:17] lineBreakMode:UILineBreakModeClip alignment:UITextAlignmentCenter];
    }
    
    //    CGContextClosePath(context);
    
    
    //Draw markings
    if (!self.markedDates) return;
    
    for (int i = 0; i<[self.markedDates count]; i++) {
        id markedDateObj = [self.markedDates objectAtIndex:i];
        
        int targetDate;
        if ([markedDateObj isKindOfClass:[NSNumber class]]) {
            targetDate = [(NSNumber *)markedDateObj intValue];
        } else if ([markedDateObj isKindOfClass:[NSDate class]]) {
            NSDate *date = (NSDate *)markedDateObj;
            targetDate = [date day];
        } else {
            continue;
        }
        
        
        
        int targetBlock = firstWeekDay + (targetDate-1);
        int targetColumn = targetBlock%7;
        int targetRow = targetBlock/7;
        
        int targetX = targetColumn * (kVRGCalendarViewDayWidth+2) + 7;
        int targetY = kVRGCalendarViewTopBarHeight + targetRow * (kVRGCalendarViewDayHeight+2) + 38;
        
        CGRect rectangle = CGRectMake(targetX+7.5,targetY-7,20,4);
        CGContextAddRect(context, rectangle);
        
        UIColor *color;
        if (selectedDate && selectedDateBlock==targetBlock) {
            color  = (UIColor *)[self.markedColors objectAtIndex:i];
        }  else if (todayBlock==targetBlock) {
            color  = (UIColor *)[self.markedColors objectAtIndex:i];
        } else {
            color  = (UIColor *)[self.markedColors objectAtIndex:i];
        }
        
        
        CGContextSetFillColorWithColor(context, color.CGColor);
        CGContextFillPath(context);
    }
}

#pragma mark - Draw image for animation
-(UIImage *)drawCurrentState
{
    
    float targetHeight = kVRGCalendarViewTopBarHeight + [self numRows]*(kVRGCalendarViewDayHeight+2)+1;
    
    UIGraphicsBeginImageContext(CGSizeMake(kVRGCalendarViewWidth, targetHeight-kVRGCalendarViewTopBarHeight));
    CGContextRef c = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(c, 0, -kVRGCalendarViewTopBarHeight);    // <-- shift everything up by 40px when drawing.
    [self.layer renderInContext:c];
    
    UIImage* viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return viewImage;
}

#pragma mark - Init
-(id)init {
    self = [super initWithFrame:CGRectMake(0, 44, kVRGCalendarViewWidth, 0)];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        self.contentMode = UIViewContentModeTop;
        self.clipsToBounds=YES;
        
        isAnimating=NO;
        
        UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 27)];
        topView.backgroundColor =[UIColor colorWithRed:0.22 green:0.23 blue:0.26 alpha:1];
        [self addSubview:topView];
        [topView release];
        
        self.labelCurrentMonth = [[[UILabel alloc] initWithFrame:CGRectMake(11, 0, 320, 27)] autorelease];
        labelCurrentMonth.backgroundColor=[UIColor clearColor];
        labelCurrentMonth.font = [UIFont systemFontOfSize:15];
        labelCurrentMonth.font = [UIFont boldSystemFontOfSize:15];
        labelCurrentMonth.textColor = [UIColor whiteColor];
        [labelCurrentMonth setTextAlignment:NSTextAlignmentLeft];
        [topView addSubview:labelCurrentMonth];
        

        [self performSelector:@selector(reset) withObject:nil afterDelay:0.1]; //so delegate can be set after init and still get called on init
        //[self reset];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
       // tap.numberOfTouches = 1;
        [self addGestureRecognizer:tap];
        [tap release];
        
        UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(beginLeftGestureRecognizer:)];
        [self addGestureRecognizer:swipe];
        [swipe setDirection:UISwipeGestureRecognizerDirectionLeft];
        [swipe release];
        
        UISwipeGestureRecognizer *swipe2 = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(beginRightGestureRecognizer:)];
        [self addGestureRecognizer:swipe2];
        [swipe2 setDirection:UISwipeGestureRecognizerDirectionRight];
        [swipe2 release];

        
    }
    return self;
}

- (void)beginLeftGestureRecognizer:(UISwipeGestureRecognizer *)sender
{
    self.selectedDate=nil;

    [self showNextMonth];
}

- (void)beginRightGestureRecognizer:(UISwipeGestureRecognizer *)sender
{
    self.selectedDate=nil;

    [self showPreviousMonth];
}



-(void)dealloc {
    
    self.userDate=nil;
    self.delegate=nil;
    self.currentMonth=nil;
    self.labelCurrentMonth=nil;
    
    self.markedDates=nil;
    self.markedColors=nil;
    
    [super dealloc];
}
@end
