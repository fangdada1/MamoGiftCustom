////
////  PioerCountingLabel.h
////  Pioer
////
////  Created by Pioer on 31/12/24.
////
//
//#import <UIKit/UIKit.h>
//
//NS_ASSUME_NONNULL_BEGIN
//
//typedef NS_ENUM(NSUInteger, SignSetting) {
//    SignSettingUnsigned,
//    SignSettingNormal,
//    SignSettingSigned
//};
//
//@interface PioerCountingLabel : UIView
//
///**
// It synchronize with the value you set by method '-changeToNumber:animated:' and '-changeToNumber:interval:animated:'
// */
//@property (nonatomic, strong, readonly)NSNumber *currentNumber;
//
///**
// This property control the minimum display row.
// if set this property to 2, and currentNumber is 1, the display is 01
// */
//@property (nonatomic, assign)NSUInteger minRowNumber;
//
///**
// Dynamic init method, the instance created by this method have a dynamic row count, it's row will change with the value you setting
// @return the instance of PioerCountingLabel
// */
//- (instancetype)initWithNumber:(NSNumber *)number fontSize:(CGFloat)fontSize;
//
///**
// Dynamic init method, the instance created by this method have a dynamic row count, it's row will change with the value you setting
// @return the instance of PioerCountingLabel
// */
//- (instancetype)initWithNumber:(NSNumber *)number fontSize:(CGFloat)fontSize textColor:(UIColor *)textColor;
//
///**
// Dynamic init method, the instance created by this method have a dynamic row count, it's row will change with the value you setting
// @return the instance of PioerCountingLabel
// */
//- (instancetype)initWithNumber:(NSNumber *)number fontSize:(CGFloat)fontSize show_style:(NSInteger)show_style signSetting:(SignSetting)signSetting;
//
///**
// Dynamic init method, the instance created by this method have a dynamic row count, it's row will change with the value you setting
// @return the instance of PioerCountingLabel
// */
//- (instancetype)initWithNumber:(NSNumber *)number fontSize:(CGFloat)fontSize textColor:(UIColor *)textColor show_style:(NSInteger)show_style signSetting:(SignSetting)signSetting;
//
///**
// Dynamic init method, the instance created by this method have a dynamic row count, it's row will change with the value you setting
// @return the instance of PioerCountingLabel
// */
//- (instancetype)initWithNumber:(NSNumber *)number font:(UIFont *)font;
//
///**
// Dynamic init method, the instance created by this method have a dynamic row count, it's row will change with the value you setting
// @return the instance of PioerCountingLabel
// */
//- (instancetype)initWithNumber:(NSNumber *)number font:(UIFont *)font textColor:(UIColor *)textColor;
//
///**
// Dynamic init method, the instance created by this method have a dynamic row count, it's row will change with the value you setting
// @return the instance of PioerCountingLabel
// */
//- (instancetype)initWithNumber:(NSNumber *)number font:(UIFont *)font signSetting:(SignSetting)signSetting;
//
///**
// Dynamic init method, the instance created by this method have a dynamic row count, it's row will change with the value you setting
// @return the instance of PioerCountingLabel
// */
//- (instancetype)initWithNumber:(NSNumber *)number font:(UIFont *)font textColor:(UIColor *)textColor signSetting:(SignSetting)signSetting;
//
//
///*-------------------------------------------- Dynamic init method end -------------------------------------------------
// 
// If you set row number, the PioerCountingLabel instance's max num will less than the row num.
// For example, you set row number to 1, then the max count of this label will be 9.
// 
// Note:rowNumber shouldn't more than 8
// 
// ---------------------------------------------- Static init method start -----------------------------------------------*/
//
//
///**
// Static init method, the instance created by this method have a comfirmed row count,
// if your value's row bigger than the comfirmed row, it won't have effect
// @return the instance of PioerCountingLabel
// */
//- (instancetype)initWithNumber:(NSNumber *)number
//                      fontSize:(CGFloat)fontSize
//                     rowNumber:(NSUInteger)rowNumber;
//
///**
// Static init method, the instance created by this method have a comfirmed row count,
// if your value's row bigger than the comfirmed row, it won't have effect
// @return the instance of PioerCountingLabel
// */
//- (instancetype)initWithNumber:(NSNumber *)number
//                      fontSize:(CGFloat)fontSize
//                     textColor:(UIColor *)textColor
//                     rowNumber:(NSUInteger)rowNumber;
//
///**
// Static init method, the instance created by this method have a comfirmed row count,
// if your value's row bigger than the comfirmed row, it won't have effect
// @return the instance of PioerCountingLabel
// */
//- (instancetype)initWithNumber:(NSNumber *)number
//                      fontSize:(CGFloat)fontSize
//                      signSetting:(SignSetting)signSetting
//                     rowNumber:(NSUInteger)rowNumber;
//
///**
// Static init method, the instance created by this method have a comfirmed row count,
// if your value's row bigger than the comfirmed row, it won't have effect
// @return the instance of PioerCountingLabel
// */
//- (instancetype)initWithNumber:(NSNumber *)number
//                      fontSize:(CGFloat)fontSize
//                     textColor:(UIColor *)textColor
//                     show_style:(NSInteger)show_style
//                      signSetting:(SignSetting)signSetting
//                     rowNumber:(NSUInteger)rowNumber;
///**
// Static init method, the instance created by this method have a comfirmed row count,
// if your value's row bigger than the comfirmed row, it won't have effect
// @return the instance of PioerCountingLabel
// */
//- (instancetype)initWithNumber:(NSNumber *)number
//                          font:(UIFont *)font
//                     textColor:(UIColor *)textColor
//                     rowNumber:(NSUInteger)rowNumber;
//
///**
// Static init method, the instance created by this method have a comfirmed row count,
// if your value's row bigger than the comfirmed row, it won't have effect
// @return the instance of PioerCountingLabel
// */
//- (instancetype)initWithNumber:(NSNumber *)number
//                          font:(UIFont *)font
//                      signSetting:(SignSetting)signSetting
//                     rowNumber:(NSUInteger)rowNumber;
//
///**
// Static init method, the instance created by this method have a comfirmed row count,
// if your value's row bigger than the comfirmed row, it won't have effect
// @return the instance of PioerCountingLabel
// */
//- (instancetype)initWithNumber:(NSNumber *)number
//                          font:(UIFont *)font
//                     textColor:(UIColor *)textColor
//                      signSetting:(SignSetting)signSetting
//                     rowNumber:(NSUInteger)rowNumber;
//
///**
// When you want to change the display value, you can use this method,
// and the interval of scroll animation will be calculated automatically
// */
//- (void)changeToNumber:(NSNumber *)number animated:(BOOL)animated;
//
///**
// When you want to change the display value and you want to calculate
// the animation interval by yourself, you should use this method
// */
//- (void)changeToNumber:(NSNumber *)number interval:(CGFloat)interval animated:(BOOL)animated;
//
//- (void)startAnimWithDuration:(NSTimeInterval)duration show_style:(NSInteger)show_style completion:(void (^)(void))completion;
//
//@property (nonatomic, assign)NSInteger show_style;
//@end
//
//NS_ASSUME_NONNULL_END


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "PioerQueueGiftData.h"

typedef NS_ENUM(NSInteger, UILabelCountingMethod) {
    UILabelCountingMethodEaseInOut,
    UILabelCountingMethodEaseIn,
    UILabelCountingMethodEaseOut,
    UILabelCountingMethodLinear,
    UILabelCountingMethodEaseInBounce,
    UILabelCountingMethodEaseOutBounce
};

typedef NSString* (^PioerCountingLabelFormatBlock)(CGFloat value);
typedef NSAttributedString* (^PioerCountingLabelAttributedFormatBlock)(CGFloat value);

@interface PioerCountingLabel : UILabel

@property (nonatomic, strong) NSString *format;
@property (nonatomic, assign) UILabelCountingMethod method;
@property (nonatomic, strong) PioerQueueGiftData *model;
@property (nonatomic,assign)  BOOL nowAlpha; //是否有透明度 true有 没有
@property (nonatomic, assign) NSTimeInterval animationDuration;

@property (nonatomic, copy) PioerCountingLabelFormatBlock formatBlock;
@property (nonatomic, copy) PioerCountingLabelAttributedFormatBlock attributedFormatBlock;
@property (nonatomic, copy) void (^completionBlock)(void);

-(void)countFrom:(CGFloat)startValue to:(CGFloat)endValue alpha:(BOOL)alpha;
-(void)countFrom:(CGFloat)startValue to:(CGFloat)endValue withDuration:(NSTimeInterval)duration alpha:(BOOL)alpha;

-(void)countFromCurrentValueTo:(CGFloat)endValue alpha:(BOOL)alpha;
-(void)countFromCurrentValueTo:(CGFloat)endValue withDuration:(NSTimeInterval)duration alpha:(BOOL)alpha;

-(void)countFromZeroTo:(CGFloat)endValue alpha:(BOOL)alpha;
//-(void)countFromZeroTo:(CGFloat)endValue withDuration:(NSTimeInterval)duration;

- (CGFloat)currentValue;

- (void)applyGradientToTextAlpha:(BOOL)alpha;

- (CGFloat)calculateTextWidthWithContent:(NSString *)content font:(UIFont *)font maxSize:(CGSize)size;

//- (void)startAnimWithDuration:(NSTimeInterval)duration completion:(void (^)(void))completion;

@end
