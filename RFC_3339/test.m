//
//  test.m
//  RFC_3339
//
//  Created by Pradeep Singhal on 16/08/13.
//  Copyright (c) 2013 DreamSoft4u. All rights reserved.
//

#import "test.h"

@interface test ()

@end

@implementation test

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSString *)TimeDifference:(NSString *)requestDate
{

    NSString *finalDate;
    NSDate *str=[self dateFromRFC3339String:requestDate];
    NSLog(@"%@",str);
    NSDate *date1=[NSDate date];
    NSLog(@"%@",date1);
    NSTimeInterval distanceBetweenDates = [date1 timeIntervalSinceDate:str];

    double secondsInAnHour = 3600;
    NSInteger hoursBetweenDates = distanceBetweenDates / secondsInAnHour;
    if (hoursBetweenDates>=168) {

        NSDateFormatter *formater=[[NSDateFormatter alloc]init];
        [formater setDateFormat:@"MM'-'dd'-'yyyy'  at  'HH':'mm"];
        finalDate = [formater stringFromDate:str];

        // finalDate =[NSString stringWithFormat:@"%@",str];
      //  finalDate= [finalDate stringByReplacingOccurrencesOfString:@"+0000" withString:@""];
    }

    else if (hoursBetweenDates>=24) {
        NSInteger DayBetweenDates=hoursBetweenDates/24;
        finalDate=[NSString stringWithFormat:@"%ld Days ago",(long)DayBetweenDates];

    }

    else
    {
        if (hoursBetweenDates==0) {

            NSInteger minuteBetweenDates=distanceBetweenDates/60;
            if (minuteBetweenDates>0)
            {
                finalDate=[NSString stringWithFormat:@"%ld Minutes ago",(long)minuteBetweenDates];

            }
            else
            {
                NSLog(@"%ld",(long)minuteBetweenDates);
                finalDate=[NSString stringWithFormat:@"0 Minute ago"];
            }

        }
        else
        {
            finalDate=[NSString stringWithFormat:@"%ld Hours ago",(long)hoursBetweenDates];

        }
    }

    return finalDate;
}

- (NSDate *)dateFromRFC3339String:(NSString *)dateString {

    // Keep dateString around a while (for thread-safety)
    NSDate *date = nil;
    if (dateString) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];

        // Process date
        NSString *RFC3339String = [[NSString stringWithString:dateString] uppercaseString];
        RFC3339String = [RFC3339String stringByReplacingOccurrencesOfString:@"Z" withString:@"-0000"];
        // Remove colon in timezone as it breaks NSDateFormatter in iOS 4+.
        // - see https://devforums.apple.com/thread/45837
        if (RFC3339String.length > 20) {
            RFC3339String = [RFC3339String stringByReplacingOccurrencesOfString:@":"
                                                                     withString:@""
                                                                        options:0
                                                                          range:NSMakeRange(20, RFC3339String.length-20)];
        }




        if (!date) { // 1996-12-19T16:39:57-0800
            [dateFormatter setDateFormat:@"yyyy'-'MM'-'dd'T'HH':'mm':'ssZZZ"];
            date = [dateFormatter dateFromString:RFC3339String];
        }
        if (!date) { // 1937-01-01T12:00:27.87+0020
            [dateFormatter setDateFormat:@"yyyy'-'MM'-'dd'T'HH':'mm':'ss.SSSZZZ"];
            date = [dateFormatter dateFromString:RFC3339String];
        }
        if (!date) { // 1937-01-01T12:00:27
            [dateFormatter setDateFormat:@"yyyy'-'MM'-'dd'T'HH':'mm':'ss"];
            date = [dateFormatter dateFromString:RFC3339String];
        }
        if (!date)
            NSLog(@"Could not parse RFC3339 date: \"%@\" Possible invalid format.", dateString);


    }
    // Finished with date string
	return date;
}

@end
