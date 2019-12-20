//
//  BDChooseDateTimeView1.m
//  Community-Service
//
//  Created by 刘长洋 on 2019/5/5.
//  Copyright © 2019 NJBD. All rights reserved.
//

#import "BDChooseDateTimeView.h"

@interface BDChooseDateTimeView ()<UIPickerViewDelegate,UIPickerViewDataSource,UIPickerViewDelegate>

//年
@property (nonatomic, assign) NSInteger yearRange;
//天
@property (nonatomic, assign) NSInteger dayRange;
//开始年
@property (nonatomic, assign) NSInteger startYear;
//
@property (nonatomic, assign) NSInteger selectedYear;

@property (nonatomic, assign) NSInteger selectedMonth;

@property (nonatomic, assign) NSInteger selectedDay;

@property (nonatomic, assign) NSInteger selectedHour;

@property (nonatomic, assign) NSInteger selectedMinute;

@property (nonatomic, assign) NSInteger selectedSecond;

//取消
@property (nonatomic, strong) UIButton *cancelBtn;
//确定按钮
@property (nonatomic, strong) UIButton *sureBtn;
//顶部背景
@property (nonatomic, strong) UIView *topV;

@property (nonatomic, strong) UIPickerView *pickerView;

@property (nonatomic,strong) NSString *timeString;

@end

@implementation BDChooseDateTimeView

- (id)init:(DatePickerViewModel)pickerView
{
    self = [super init];
    
    if (self)
    {
        self.pickerViewModel = pickerView;
        [self setBackgroundColor:[UIColor whiteColor]];
        
        UIView *v = [[UIView alloc] init];
        [v setBackgroundColor:kColor(0xd6d6d6ff)];
        [self addSubview:v];
        self.topV = v;
        {
            UIButton *btn = [[UIButton alloc] init];
            [btn setBackgroundColor:[UIColor clearColor]];
            [btn.titleLabel setFont:kFont(15)];
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [btn setTitle:@"取  消" forState:UIControlStateNormal];
            [btn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
            [btn addTarget:self action:@selector(clickCancle) forControlEvents:UIControlEventTouchUpInside];
            [v addSubview:btn];
            self.cancelBtn = btn;
        }
        {
            UIButton *btn = [[UIButton alloc] init];
            [btn setBackgroundColor:[UIColor clearColor]];
            [btn.titleLabel setFont:kFont(15)];
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [btn setTitle:@"完  成" forState:UIControlStateNormal];
            [btn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
            [btn addTarget:self action:@selector(clickSure) forControlEvents:UIControlEventTouchUpInside];
            [v addSubview:btn];
            self.sureBtn = btn;
        }
        {
            UIPickerView *picker = [[UIPickerView alloc] init];
            [picker setBackgroundColor:kColor(0xE7E5E7FF)];
            [picker setDataSource:self];
            [picker setDelegate:self];
            [self addSubview:picker];
            self.pickerView = picker;
        }
        {
            NSCalendar *calendar = [NSCalendar currentCalendar];
            NSInteger unitFlage = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay |
            NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
            NSDateComponents *comps = [calendar components:unitFlage fromDate:[NSDate date]];
            NSInteger year = [comps year];
            
            self.startYear = year - 100;
            self.yearRange = 200;
        }
        {
            [self setCurrentDate:[NSDate date]];
        }
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.topV setFrame:CGRectMake(0, 0, self.bounds.size.width, kHeight(50))];
    [self.cancelBtn setFrame:CGRectMake(kHeight(20), 0, self.topV.bounds.size.width/2 - kHeight(20), self.topV.bounds.size.height)];
    [self.sureBtn setFrame:CGRectMake(self.topV.bounds.size.width/2, 0, self.topV.bounds.size.width/2 - kHeight(20), self.topV.bounds.size.height)];
    BDLog(@"你好啊:%f,%f",self.bounds.size.width,self.bounds.size.height);
    [self.pickerView setFrame:CGRectMake(0, kHeight(50), self.bounds.size.width, self.bounds.size.height - kHeight(50))];
    
}

//默认时间的处理
- (void)setCurrentDate:(NSDate *)currentDate
{
    //获取当前时间
    NSCalendar *calendar0 = [NSCalendar currentCalendar];
    NSInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay |
    NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents *comps  = [calendar0 components:unitFlags fromDate:[NSDate date]];
    
    NSInteger year=[comps year];
    NSInteger month=[comps month];
    NSInteger day=[comps day];
    NSInteger hour=[comps hour];
    NSInteger minute=[comps minute];
    NSInteger second=[comps second];
    
    self.selectedYear = year;
    self.selectedMonth = month;
    self.selectedDay = day;
    self.selectedHour = hour;
    self.selectedMinute = minute;
    self.selectedSecond = second;
    
    self.dayRange = [self isAllDay:year andMonth:month];
    
    if (self.pickerViewModel == DatePickerViewModelYearMonthDayHourMinuteMode)
    {
        [self.pickerView selectRow:year - self.startYear inComponent:0 animated:NO];
        [self.pickerView selectRow:month - 1 inComponent:1 animated:NO];
        [self.pickerView selectRow:day - 1 inComponent:2 animated:NO];
        [self.pickerView selectRow:hour inComponent:3 animated:NO];
        [self.pickerView selectRow:minute inComponent:4 animated:NO];
        
        [self pickerView:self.pickerView didSelectRow:year - self.startYear inComponent:0];
        [self pickerView:self.pickerView didSelectRow:month - 1 inComponent:1];
        [self pickerView:self.pickerView didSelectRow:day - 1 inComponent:2];
        [self pickerView:self.pickerView didSelectRow:hour inComponent:3];
        [self pickerView:self.pickerView didSelectRow:minute inComponent:4];
        
    }
    else if (self.pickerViewModel == DatePickerViewModelDayHourMinuteSecondMode)
    {
        [self.pickerView selectRow:year - self.startYear inComponent:0 animated:NO];
        [self.pickerView selectRow:month - 1 inComponent:1 animated:NO];
        [self.pickerView selectRow:day - 1 inComponent:2 animated:NO];
        [self.pickerView selectRow:hour inComponent:3 animated:NO];
        [self.pickerView selectRow:minute inComponent:4 animated:NO];
        [self.pickerView selectRow:second inComponent:5 animated:NO];
        
        [self pickerView:self.pickerView didSelectRow:year - self.startYear inComponent:0];
        [self pickerView:self.pickerView didSelectRow:month - 1 inComponent:1];
        [self pickerView:self.pickerView didSelectRow:day - 1 inComponent:2];
        [self pickerView:self.pickerView didSelectRow:hour inComponent:3];
        [self pickerView:self.pickerView didSelectRow:minute inComponent:4];
        [self pickerView:self.pickerView didSelectRow:second inComponent:5];
        
    }
    else if (self.pickerViewModel == DatePickerViewModelYearMonthDayHourMode)
    {
        [self.pickerView selectRow:year - self.startYear inComponent:0 animated:NO];
        [self.pickerView selectRow:month - 1 inComponent:1 animated:NO];
        [self.pickerView selectRow:day - 1 inComponent:2 animated:NO];
        [self.pickerView selectRow:hour inComponent:3 animated:NO];
        
        [self pickerView:self.pickerView didSelectRow:year - self.startYear inComponent:0];
        [self pickerView:self.pickerView didSelectRow:month - 1 inComponent:1];
        [self pickerView:self.pickerView didSelectRow:day - 1 inComponent:2];
        [self pickerView:self.pickerView didSelectRow:hour inComponent:3];
        
    }
    else if (self.pickerViewModel == DatePickerViewModelYearMonthDayMode)
    {
        [self.pickerView selectRow:year - self.startYear inComponent:0 animated:NO];
        [self.pickerView selectRow:month - 1 inComponent:1 animated:NO];
        [self.pickerView selectRow:day - 1 inComponent:2 animated:NO];
        
        
        [self pickerView:self.pickerView didSelectRow:year - self.startYear inComponent:0];
        [self pickerView:self.pickerView didSelectRow:month - 1 inComponent:1];
        [self pickerView:self.pickerView didSelectRow:day - 1 inComponent:2];
        
    }
    else if (self.pickerViewModel == DatePickerViewModelHourMinuteMode)
    {
        [self.pickerView selectRow:hour inComponent:0 animated:NO];
        [self.pickerView selectRow:minute inComponent:1 animated:NO];
        
        [self pickerView:self.pickerView didSelectRow:hour inComponent:0];
        [self pickerView:self.pickerView didSelectRow:minute inComponent:1];
    }
    else if (self.pickerViewModel == DatePickerViewModelYearMonthMode)
    {
        [self.pickerView selectRow:year - self.startYear inComponent:0 animated:NO];
        [self.pickerView selectRow:month - 1 inComponent:1 animated:NO];
        
        [self pickerView:self.pickerView didSelectRow:year - self.startYear inComponent:0];
        [self pickerView:self.pickerView didSelectRow:month - 1 inComponent:1];
        
    }
    else if (self.pickerViewModel == DatePickerViewModelYearMode)
    {
        [self.pickerView selectRow:year - self.startYear inComponent:0 animated:NO];
        
        [self pickerView:self.pickerView didSelectRow:year - self.startYear inComponent:0];
        
    }
    [self.pickerView reloadAllComponents];
}

#pragma mark - 选择对应月份的天数
-(NSInteger)isAllDay:(NSInteger)year andMonth:(NSInteger)month
{
    int day=0;
    switch(month)
    {
        case 1:
        case 3:
        case 5:
        case 7:
        case 8:
        case 10:
        case 12:
            day=31;
            break;
        case 4:
        case 6:
        case 9:
        case 11:
            day=30;
            break;
        case 2:
        {
            if(((year%4==0)&&(year%100!=0))||(year%400==0))
            {
                day=29;
                break;
            }
            else
            {
                day=28;
                break;
            }
        }
        default:
            break;
    }
    return day;
}

#pragma mark -- UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    if (self.pickerViewModel == DatePickerViewModelYearMonthDayHourMinuteMode)
    {
        return 5;
    }
    else if (self.pickerViewModel == DatePickerViewModelDayHourMinuteSecondMode)
    {
        return 6;
    }
    else if (self.pickerViewModel == DatePickerViewModelYearMonthDayHourMode)
    {
        return 4;
    }
    else if (self.pickerViewModel == DatePickerViewModelYearMonthDayMode)
    {
        return 3;
    }
    else if (self.pickerViewModel == DatePickerViewModelHourMinuteMode)
    {
        return 2;
    }
    else if (self.pickerViewModel == DatePickerViewModelYearMonthMode)
    {
        return 2;
    }
    else if (self.pickerViewModel == DatePickerViewModelYearMode)
    {
        return 1;
    }
    return 0;
}

//确定每一列返回的东西
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (self.pickerViewModel == DatePickerViewModelYearMonthDayHourMinuteMode)
    {
        switch (component)
        {
            case 0:
            {
                return self.yearRange;
            }
                break;
            case 1:
            {
                return 12;
            }
                break;
            case 2:
            {
                return self.dayRange;
            }
                break;
            case 3:
            {
                return 24;
            }
                break;
            case 4:
            {
                return 60;
            }
                break;
                
            default:
                break;
        }
    }
    else if (self.pickerViewModel == DatePickerViewModelDayHourMinuteSecondMode)
    {
        switch (component)
        {
            case 0:
            {
                return self.yearRange;
            }
                break;
            case 1:
            {
                return 12;
            }
                break;
            case 2:
            {
                return self.dayRange;
            }
                break;
            case 3:
            {
                return 24;
            }
                break;
            case 4:
            {
                return 60;
            }
                break;
                
            case 5:
            {
                return 60;
            }
                break;
                
            default:
                break;
        }
    }
    else if (self.pickerViewModel == DatePickerViewModelYearMonthDayHourMode)
    {
        switch (component)
        {
            case 0:
            {
                return self.yearRange;
            }
                break;
            case 1:
            {
                return 12;
            }
                break;
            case 2:
            {
                return self.dayRange;
            }
                break;
            case 3:
            {
                return 24;
            }
                break;
            default:
                break;
        }
    }
    else if (self.pickerViewModel == DatePickerViewModelYearMonthDayMode)
    {
        switch (component)
        {
            case 0:
            {
                return self.yearRange;
            }
                break;
            case 1:
            {
                return 12;
            }
                break;
            case 2:
            {
                return self.dayRange;
            }
                break;
            default:
                break;
        }
    }
    else if (self.pickerViewModel == DatePickerViewModelHourMinuteMode)
    {
        switch (component)
        {
            case 0:
            {
                return 24;
            }
                break;
            case 1:
            {
                return 60;
            }
                break;
                
            default:
                break;
        }
    }
    else if (self.pickerViewModel == DatePickerViewModelYearMonthMode)
    {
        switch (component)
        {
            case 0:
            {
                return self.yearRange;
            }
                break;
            case 1:
            {
                return 12;
            }
                break;
                
            default:
                break;
        }
    }
    else if (self.pickerViewModel == DatePickerViewModelYearMode)
    {
        switch (component)
        {
            case 0:
            {
                return self.yearRange;
            }
                break;
                
            default:
                break;
        }
    }
    return 0;
}

#pragma mark -- UIPickerViewDelegate

- (UIView*)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *lab = [[UILabel alloc] init];
    [lab setBackgroundColor:[UIColor clearColor]];
    [lab setFont:kFont(14)];
    [lab setTextColor:[UIColor blackColor]];
    [lab setTextAlignment:NSTextAlignmentCenter];
    
    if (self.pickerViewModel == DatePickerViewModelYearMonthDayHourMinuteMode)
    {
        switch (component)
        {
            case 0:
            {
                [lab setText:[NSString stringWithFormat:@"%ld年",(long)(self.startYear + row)]];
            }
                break;
            case 1:
            {
                [lab setText:[NSString stringWithFormat:@"%ld月",(long)row+1]];
            }
                break;
            case 2:
            {
                [lab setText:[NSString stringWithFormat:@"%ld日",(long)row+1]];
            }
                break;
            case 3:
            {
                [lab setTextAlignment:NSTextAlignmentRight];
                [lab setText:[NSString stringWithFormat:@"%ld时",(long)row]];
            }
                break;
            case 4:
            {
                [lab setTextAlignment:NSTextAlignmentRight];
                [lab setText:[NSString stringWithFormat:@"%ld分",(long)row]];
            }
                break;
                
            default:
                break;
        }
    }
    else if (self.pickerViewModel == DatePickerViewModelDayHourMinuteSecondMode)
    {
        switch (component)
        {
            case 0:
            {
                [lab setText:[NSString stringWithFormat:@"%ld年",(long)(self.startYear + row)]];
            }
                break;
            case 1:
            {
                [lab setText:[NSString stringWithFormat:@"%ld月",(long)row+1]];
            }
                break;
            case 2:
            {
                [lab setText:[NSString stringWithFormat:@"%ld日",(long)row+1]];
            }
                break;
            case 3:
            {
                [lab setTextAlignment:NSTextAlignmentRight];
                [lab setText:[NSString stringWithFormat:@"%ld时",(long)row]];
            }
                break;
            case 4:
            {
                [lab setTextAlignment:NSTextAlignmentRight];
                [lab setText:[NSString stringWithFormat:@"%ld分",(long)row]];
            }
                break;
            case 5:
            {
                [lab setTextAlignment:NSTextAlignmentRight];
                [lab setText:[NSString stringWithFormat:@"%ld秒",(long)row]];
            }
                break;
                
            default:
                break;
        }
    }
    else if (self.pickerViewModel == DatePickerViewModelYearMonthDayHourMode)
    {
        switch (component)
        {
            case 0:
            {
                [lab setText:[NSString stringWithFormat:@"%ld年",(long)(self.startYear + row)]];
            }
                break;
            case 1:
            {
                [lab setText:[NSString stringWithFormat:@"%ld月",(long)row+1]];
            }
                break;
            case 2:
            {
                [lab setText:[NSString stringWithFormat:@"%ld日",(long)row+1]];
            }
                break;
            case 3:
            {
                [lab setTextAlignment:NSTextAlignmentRight];
                [lab setText:[NSString stringWithFormat:@"%ld时",(long)row]];
            }
                break;
            default:
                break;
        }
    }
    else if (self.pickerViewModel == DatePickerViewModelYearMonthDayMode)
    {
        switch (component)
        {
            case 0:
            {
                [lab setText:[NSString stringWithFormat:@"%ld年",(long)(self.startYear + row)]];
            }
                break;
            case 1:
            {
                [lab setText:[NSString stringWithFormat:@"%ld月",(long)row+1]];
            }
                break;
            case 2:
            {
                [lab setText:[NSString stringWithFormat:@"%ld日",(long)row+1]];
            }
                break;
                
            default:
                break;
        }
    }
    else if (self.pickerViewModel == DatePickerViewModelHourMinuteMode)
    {
        switch (component)
        {
            case 0:
            {
                [lab setText:[NSString stringWithFormat:@"%ld时",(long)row]];
            }
                break;
            case 1:
            {
                [lab setText:[NSString stringWithFormat:@"%ld分",(long)row]];
            }
                break;
            default:
                break;
        }
    }
    else if (self.pickerViewModel == DatePickerViewModelYearMonthMode)
    {
        switch (component)
        {
            case 0:
            {
                [lab setText:[NSString stringWithFormat:@"%ld年",(long)(self.startYear + row)]];
            }
                break;
            case 1:
            {
                [lab setText:[NSString stringWithFormat:@"%ld月",(long)row+1]];
            }
                break;
            default:
                break;
        }
    }
    else if (self.pickerViewModel == DatePickerViewModelYearMode)
    {
        
        switch (component)
        {
            case 0:
            {
                [lab setText:[NSString stringWithFormat:@"%ld年",(long)(self.startYear + row)]];
            }
                break;
            case 1:
            {
                [lab setText:[NSString stringWithFormat:@"%ld月",(long)row+1]];
            }
                break;
            default:
                break;
        }
    }
    return lab;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    if (self.pickerViewModel == DatePickerViewModelYearMonthDayHourMinuteMode)
    {
        return ([UIScreen mainScreen].bounds.size.width-40)/5;
    }
    else if (self.pickerViewModel == DatePickerViewModelDayHourMinuteSecondMode)
    {
        return ([UIScreen mainScreen].bounds.size.width-40)/6;
    }
    else if (self.pickerViewModel == DatePickerViewModelYearMonthDayHourMode)
    {
        return ([UIScreen mainScreen].bounds.size.width-40)/4;
    }
    else if (self.pickerViewModel == DatePickerViewModelYearMonthDayMode)
    {
        return ([UIScreen mainScreen].bounds.size.width-40)/3;
    }
    else if (self.pickerViewModel == DatePickerViewModelHourMinuteMode)
    {
        return ([UIScreen mainScreen].bounds.size.width-40)/2;
    }
    else if (self.pickerViewModel == DatePickerViewModelYearMonthMode)
    {
        return ([UIScreen mainScreen].bounds.size.width-40)/2;
    }
    else if (self.pickerViewModel == DatePickerViewModelYearMode)
    {
        return ([UIScreen mainScreen].bounds.size.width-40)/1;
    }
    
    return 0;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return kHeight(30);
}

// 监听picker的滑动
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (self.pickerViewModel == DatePickerViewModelYearMonthDayHourMinuteMode)
    {
        switch (component)
        {
            case 0:
            {
                self.selectedYear = self.startYear + row;
                self.dayRange=[self isAllDay:self.selectedYear andMonth:self.selectedMonth];
                [self.pickerView reloadComponent:2];
            }
                break;
            case 1:
            {
                self.selectedMonth = row + 1;
                self.dayRange=[self isAllDay:self.selectedYear andMonth:self.selectedMonth];
                [self.pickerView reloadComponent:2];
            }
                break;
            case 2:
            {
                self.selectedDay = row + 1;
            }
                break;
            case 3:
            {
                self.selectedHour = row;
            }
                break;
            case 4:
            {
                self.selectedMinute = row;
            }
                break;
                
            default:
                break;
        }
        
        self.timeString =[NSString stringWithFormat:@"%ld-%.2ld-%.2ld %.2ld:%.2ld:%.2ld",self.selectedYear,self.selectedMonth,self.selectedDay,self.selectedHour,self.selectedMinute,self.selectedSecond];
    }
    else if (self.pickerViewModel == DatePickerViewModelDayHourMinuteSecondMode)
    {
        switch (component)
        {
            case 0:
            {
                self.selectedYear = self.startYear + row;
                self.dayRange=[self isAllDay:self.selectedYear andMonth:self.selectedMonth];
                [self.pickerView reloadComponent:2];
            }
                break;
            case 1:
            {
                self.selectedMonth = row + 1;
                self.dayRange=[self isAllDay:self.selectedYear andMonth:self.selectedMonth];
                [self.pickerView reloadComponent:2];
            }
                break;
            case 2:
            {
                self.selectedDay = row + 1;
            }
                break;
            case 3:
            {
                self.selectedHour = row;
            }
                break;
            case 4:
            {
                self.selectedMinute = row;
            }
                break;
            case 5:
            {
                self.selectedSecond = row;
            }
                break;
            default:
                break;
        }
        
        self.timeString =[NSString stringWithFormat:@"%ld-%.2ld-%.2ld %.2ld:%.2ld:%.2ld",self.selectedYear,self.selectedMonth,self.selectedDay,self.selectedHour,self.selectedMinute,self.selectedSecond];
    }
    else if (self.pickerViewModel == DatePickerViewModelYearMonthDayHourMode)
    {
        switch (component)
        {
            case 0:
            {
                self.selectedYear = self.startYear + row;
                self.dayRange=[self isAllDay:self.selectedYear andMonth:self.selectedMonth];
                [self.pickerView reloadComponent:2];
            }
                break;
            case 1:
            {
                self.selectedMonth = row + 1;
                self.dayRange=[self isAllDay:self.selectedYear andMonth:self.selectedMonth];
                [self.pickerView reloadComponent:2];
            }
                break;
            case 2:
            {
                self.selectedDay = row + 1;
            }
                break;
            case 3:
            {
                self.selectedHour = row;
            }
                break;
                
            default:
                break;
        }
        
        self.timeString =[NSString stringWithFormat:@"%ld-%.2ld-%.2ld %.2ld:%.2ld:%.2ld",self.selectedYear,self.selectedMonth,self.selectedDay,self.selectedHour,self.selectedMinute,self.selectedSecond];
    }
    else if (self.pickerViewModel == DatePickerViewModelYearMonthDayMode)
    {
        switch (component)
        {
            case 0:
            {
                self.selectedYear = self.startYear + row;
                self.dayRange=[self isAllDay:self.selectedYear andMonth:self.selectedMonth];
                [self.pickerView reloadComponent:2];
            }
                break;
            case 1:
            {
                self.selectedMonth = row + 1;
                self.dayRange=[self isAllDay:self.selectedYear andMonth:self.selectedMonth];
                [self.pickerView reloadComponent:2];
            }
                break;
            case 2:
            {
                self.selectedDay = row + 1;
            }
                break;
                
            default:
                break;
        }
        
        self.timeString =[NSString stringWithFormat:@"%ld-%.2ld-%.2ld %.2ld:%.2ld:%.2ld",self.selectedYear,self.selectedMonth,self.selectedDay,self.selectedHour,self.selectedMinute,self.selectedSecond];
    }
    else if (self.pickerViewModel == DatePickerViewModelHourMinuteMode)
    {
        switch (component) {
            case 0:
            {
                self.selectedHour = row;
            }
                break;
            case 1:
            {
                self.selectedMinute = row;
            }
                break;
                
            default:
                break;
        }
        
        self.timeString =[NSString stringWithFormat:@"%ld-%.2ld-%.2ld %.2ld:%.2ld:%.2ld",self.selectedYear,self.selectedMonth,self.selectedDay,self.selectedHour,self.selectedMinute,self.selectedSecond];
    }
    else if (self.pickerViewModel == DatePickerViewModelYearMonthMode)
    {
        switch (component) {
            case 0:
            {
                self.selectedYear = self.startYear + row;
                
            }
                break;
            case 1:
            {
                self.selectedMonth = row + 1;
                
            }
                break;
                
            default:
                break;
        }
        
        self.timeString =[NSString stringWithFormat:@"%ld-%.2ld-%.2ld %.2ld:%.2ld:%.2ld",self.selectedYear,self.selectedMonth,self.selectedDay,self.selectedHour,self.selectedMinute,self.selectedSecond];
    }
    else if (self.pickerViewModel == DatePickerViewModelYearMode)
    {
        switch (component)
        {
            case 0:
            {
                self.selectedYear = self.startYear + row;
                
            }
                break;
                
            default:
                break;
        }
        self.timeString =[NSString stringWithFormat:@"%ld-%.2ld-%.2ld %.2ld:%.2ld:%.2ld",self.selectedYear,self.selectedMonth,self.selectedDay,self.selectedHour,self.selectedMinute,self.selectedSecond];
    }
}

- (void)clickCancle
{
    if(self.chooseDateTimeViewClickCancel)
    {
        self.chooseDateTimeViewClickCancel();
    }
}

- (void)clickSure
{
    if (self.pickerViewModel == DatePickerViewModelDayHourMinuteSecondMode)
    {
        if(self.chooseDateTimeViewClickSure)
        {
            self.chooseDateTimeViewClickSure([[BDMethod shareMethod] bd_safeDateFromString:self.timeString Format:@"yyyy-MM-dd HH:mm:ss"]);
        }
    }
    else if (self.pickerViewModel == DatePickerViewModelYearMonthDayHourMinuteMode)
    {
        if(self.chooseDateTimeViewClickSure)
        {
            self.chooseDateTimeViewClickSure([[BDMethod shareMethod] bd_safeDateFromString:self.timeString Format:@"yyyy-MM-dd HH:mm:ss"]);
        }
    }
    else if (self.pickerViewModel == DatePickerViewModelYearMonthDayHourMode)
    {
        if(self.chooseDateTimeViewClickSure)
        {
            self.chooseDateTimeViewClickSure([[BDMethod shareMethod] bd_safeDateFromString:self.timeString Format:@"yyyy-MM-dd HH:mm:ss"]);
        }
    }
    else if (self.pickerViewModel == DatePickerViewModelYearMonthDayMode)
    {
        if(self.chooseDateTimeViewClickSure)
        {
            self.chooseDateTimeViewClickSure([[BDMethod shareMethod] bd_safeDateFromString:self.timeString Format:@"yyyy-MM-dd HH:mm:ss"]);
        }
    }
    else if (self.pickerViewModel == DatePickerViewModelHourMinuteMode)
    {
        if(self.chooseDateTimeViewClickSure)
        {
            self.chooseDateTimeViewClickSure([[BDMethod shareMethod] bd_safeDateFromString:self.timeString Format:@"yyyy-MM-dd HH:mm:ss"]);
        }
    }
    else if (self.pickerViewModel == DatePickerViewModelYearMonthMode)
    {
        if(self.chooseDateTimeViewClickSure)
        {
            self.chooseDateTimeViewClickSure([[BDMethod shareMethod] bd_safeDateFromString:self.timeString Format:@"yyyy-MM-dd HH:mm:ss"]);
        }
    }
    else if (self.pickerViewModel == DatePickerViewModelYearMode)
    {
        if(self.chooseDateTimeViewClickSure)
        {
            self.chooseDateTimeViewClickSure([[BDMethod shareMethod] bd_safeDateFromString:self.timeString Format:@"yyyy-MM-dd HH:mm:ss"]);
        }
    }
}

@end
