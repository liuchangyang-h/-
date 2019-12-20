//
//  BDChooseDateTimeView1.h
//  Community-Service
//
//  Created by 刘长洋 on 2019/5/5.
//  Copyright © 2019 NJBD. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^BDChooseDateTimeViewClickCancel)(void);

typedef void(^BDChooseDateTimeViewClickSure)(NSDate *date);

typedef NS_ENUM(NSInteger,DatePickerViewModel) {
    
    DatePickerViewModelDayHourMinuteSecondMode = 0,//年月日,时分秒
    DatePickerViewModelYearMonthDayHourMinuteMode,//年月日,时分
    DatePickerViewModelYearMonthDayHourMode,//年月日,时
    DatePickerViewModelYearMonthDayMode,//年月日
    DatePickerViewModelHourMinuteMode,//时分
    DatePickerViewModelYearMonthMode,//年月
    DatePickerViewModelYearMode,//年
};

@interface BDChooseDateTimeView : UIView

- (id)init:(DatePickerViewModel)pickerView;

//点击取消
@property (nonatomic, copy) BDChooseDateTimeViewClickCancel chooseDateTimeViewClickCancel;
//点击确定
@property (nonatomic, copy) BDChooseDateTimeViewClickSure chooseDateTimeViewClickSure;

@property (nonatomic, assign) DatePickerViewModel pickerViewModel;

@end

NS_ASSUME_NONNULL_END
