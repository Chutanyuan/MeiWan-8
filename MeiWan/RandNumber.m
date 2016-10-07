//
//  RandNumber.m
//  MeiWan
//
//  Created by apple on 15/8/10.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "RandNumber.h"

@implementation RandNumber
-(id)init{
    if (self=[super init]) {
        self.oddNums = [NSMutableArray arrayWithObjects:@50,@70,@90,@110,@140,@160, nil];
        self.oddCounts=6;
        self.evenNums = [NSMutableArray arrayWithObjects:@60,@80,@100,@120,@130,@150, nil];
        self.evenCounts=6;

    }
    return self;
}
-(int)getOddRandNumber{
    int num=0;
    if (self.oddNums.count>0) {
        int i = arc4random()%self.oddCounts;
        num = [self.oddNums[i] intValue];
        [self.oddNums removeObject:self.oddNums[i]];
        //NSLog(@"%d+++++++%d+++++++++%d",self.oddNums.count,self.oddCounts,num);
        self.oddCounts--;
        //NSLog(@"%d+++++++%d+++++++++%d",self.oddNums.count,self.oddCounts,num);

    }else{
        [self resetOdd];
        int i = arc4random()%self.oddCounts;
        num = [self.oddNums[i] intValue];
        [self.oddNums removeObject:self.oddNums[i]];
        self.oddCounts--;
        //NSLog(@"%ld+++++++%d+++++++++%d",self.oddNums.count,self.oddCounts,num);
    }
    return num;
}
-(int)getEvenRandNumber{
    int num;
    if (self.evenNums.count>0) {
        int i = arc4random()%self.evenCounts;
        num = [self.evenNums[i] intValue];
        [self.evenNums removeObject:self.evenNums[i]];
        self.evenCounts--;
        
    }else{
        [self resetEven];
        int i = arc4random()%self.evenCounts;
        num = [self.evenNums[i] intValue];
        [self.evenNums removeObject:self.evenNums[i]];
        self.evenCounts--;
    }
    return num;
}
-(void)resetOdd{
    self.oddNums = [NSMutableArray arrayWithObjects:@50,@70,@90,@110,@140,@160, nil];
    self.oddCounts=6;

}
-(void)resetEven{
    self.evenNums = [NSMutableArray arrayWithObjects:@60,@80,@100,@110,@130,@150, nil];
    self.evenCounts=6;
}
+(NSString*)getRandNumberString{
    NSMutableString *number128 = [NSMutableString string];
    for (int i = 0; i<128; i++) {
        int r = arc4random()%10;
        [number128 appendFormat:@"%d",r];
    }
    return number128;
}
+(NSString*)getRandNumberString:(int)length{
    NSMutableString *number128 = [NSMutableString string];
    for (int i = 0; i<length; i++) {
        int r = arc4random()%10;
        [number128 appendFormat:@"%d",r];
    }
    return number128;
}
@end
