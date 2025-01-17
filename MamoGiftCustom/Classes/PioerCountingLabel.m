////
////  PioerCountingLabel.m
////  Pioer
////
////  Created by Pioer on 31/12/24.
////
//#import "PioerCountingLabel.h"
//#import "UIColor+CustomColor.h"
//
//@interface DPAnimationAttribute : NSObject
//
//@property (nonatomic, assign) NSInteger     repeatCount;
//@property (nonatomic, assign) CGFloat       startDuration;
//@property (nonatomic, assign) CGFloat       cycleDuration;
//@property (nonatomic, assign) CGFloat       endDuration;
//@property (nonatomic, assign) NSInteger     targetNumber;
//@property (nonatomic, assign) CGFloat       startDelay;
//@property (nonatomic, assign) NSInteger     sign;
//
//@end
//
//@implementation DPAnimationAttribute
//
//@end
//
//
//@interface DPAnimationTask : NSObject
//
//@property (nonatomic, assign) NSInteger     targetNumber;
//@property (nonatomic, assign) NSInteger     changeValue;
//@property (nonatomic, assign) CGFloat       interval;
//
//@end
//
//@implementation DPAnimationTask
//
//@end
//
//typedef NS_ENUM(NSUInteger, ScrollAnimationDirection) {
//    ScrollAnimationDirectionIncrease,
//    ScrollAnimationDirectionDecrease,
//    ScrollAnimationDirectionCount
//};
//
//typedef NS_ENUM(NSUInteger, Sign) {
//    SignNegative = 0,
//    SignZero = 1, // when the display number is zero, there is no sign
//    SignPositive = 2
//};
//
//static const CGFloat normalModulus = 0.3f;
//static const CGFloat bufferModulus = 0.7f;
//
//static const NSUInteger numberCellLineCount = 21;
//static const NSUInteger signCellLineCount = 3;
//
//static NSString * const numberCellText = @"0\n9\n8\n7\n6\n5\n4\n3\n2\n1\n0\n1\n2\n3\n4\n5\n6\n7\n8\n9\n0";
//
//@interface PioerCountingLabel()
//
//@property (nonatomic, strong, readwrite) NSNumber           *currentNumber;
//@property (nonatomic, strong) NSNumber                      *targetNumber;
//@property (nonatomic, strong) NSMutableArray<UILabel *>     *cellArray;
//@property (nonatomic, strong) UILabel                       *signCell;
//@property (nonatomic, assign) CGFloat                       fontSize;
//@property (nonatomic, assign) NSUInteger                    rowNumber;
//@property (nonatomic, strong) NSMutableArray                *taskQueue;
//@property (nonatomic, assign) BOOL                          isAnimating;
//@property (nonatomic, assign) CGFloat                       cellWidth;
//@property (nonatomic, assign) CGFloat                       numberCellHeight;
//@property (nonatomic, assign) CGFloat                       signCellHeight;
//@property (nonatomic, assign) NSInteger                     finishedAnimationCount;
//@property (nonatomic, assign) NSUInteger                    maxRowNumber;
//@property (nonatomic, strong) UIColor                       *textColor;
//@property (nonatomic, strong) UIFont                        *font;
//@property (nonatomic, assign) SignSetting                   signSetting;
//@property (nonatomic, assign) NSUInteger                    signRow;
//
//@end
//
//@implementation PioerCountingLabel
//
//#pragma mark - Init
//
//- (instancetype)initWithNumber:(NSNumber *)number fontSize:(CGFloat)fontSize {
//    return [self initWithNumber:number fontSize:fontSize textColor:[UIColor grayColor] rowNumber:0];
//}
//
//- (instancetype)initWithNumber:(NSNumber *)number fontSize:(CGFloat)fontSize textColor:(UIColor *)textColor {
//    return [self initWithNumber:number fontSize:fontSize textColor:textColor rowNumber:0];
//}
//
//- (instancetype)initWithNumber:(NSNumber *)number fontSize:(CGFloat)fontSize show_style:(NSInteger)show_style signSetting:(SignSetting)signSetting {
//    return [self initWithNumber:number fontSize:fontSize textColor:[UIColor clearColor] show_style:show_style signSetting:signSetting];
//}
//
//- (instancetype)initWithNumber:(NSNumber *)number fontSize:(CGFloat)fontSize rowNumber:(NSUInteger)rowNumber {
//    return [self initWithNumber:number fontSize:fontSize textColor:[UIColor grayColor] rowNumber:rowNumber];
//}
//
//- (instancetype)initWithNumber:(NSNumber *)number fontSize:(CGFloat)fontSize textColor:(UIColor *)textColor show_style:(NSInteger)show_style signSetting:(SignSetting)signSetting {
//    return [self initWithNumber:number fontSize:fontSize textColor:textColor show_style:show_style signSetting:signSetting rowNumber:0];
//}
//
////- (instancetype)initWithNumber:(NSNumber *)number fontSize:(CGFloat)fontSize textColor:(UIColor *)textColor rowNumber:(NSUInteger)rowNumber {
////    return [self initWithNumber:number fontSize:fontSize textColor:textColor signSetting:SignSettingUnsigned rowNumber:rowNumber];
////}
////
////- (instancetype)initWithNumber:(NSNumber *)number fontSize:(CGFloat)fontSize signSetting:(SignSetting)signSetting rowNumber:(NSUInteger)rowNumber {
////    return [self initWithNumber:number fontSize:fontSize textColor:[UIColor grayColor] signSetting:signSetting rowNumber:rowNumber];
////}
//
//- (instancetype)initWithNumber:(NSNumber *)number fontSize:(CGFloat)fontSize textColor:(UIColor *)textColor show_style:(NSInteger)show_style signSetting:(SignSetting)signSetting rowNumber:(NSUInteger)rowNumber {
//    self = [super init];
//    if (self) {
//        self.show_style = show_style;
//        self.targetNumber = number;
//        self.currentNumber = number;
//        self.font = [UIFont boldSystemFontOfSize: fontSize];//[UIFont systemFontOfSize: fontSize];
//        self.textColor = textColor;
//        self.isAnimating = NO;
//        self.finishedAnimationCount = 0;
//        self.rowNumber = (rowNumber > 0 && rowNumber <= 8) ? rowNumber : 0;
//        self.maxRowNumber = (self.rowNumber == 0) ? 8 : rowNumber;
//        self.signSetting = signSetting;
//        self.minRowNumber = 0;
//        [self commonInit];
//    }
//    return self;
//}
//
//- (instancetype)initWithNumber:(NSNumber *)number font:(UIFont *)font {
//    return [self initWithNumber:number font:font textColor:[UIColor grayColor] rowNumber:0];
//}
//
//- (instancetype)initWithNumber:(NSNumber *)number font:(UIFont *)font textColor:(UIColor *)textColor {
//    return [self initWithNumber:number font:font textColor:textColor rowNumber:0];
//}
//
//- (instancetype)initWithNumber:(NSNumber *)number font:(UIFont *)font signSetting:(SignSetting)signSetting {
//    return [self initWithNumber:number font:font textColor:[UIColor grayColor] signSetting:signSetting rowNumber:0];
//}
//
//- (instancetype)initWithNumber:(NSNumber *)number font:(UIFont *)font textColor:(UIColor *)textColor signSetting:(SignSetting)signSetting {
//    return [self initWithNumber:number font:font textColor:textColor signSetting:signSetting rowNumber:0];
//}
//
//- (instancetype)initWithNumber:(NSNumber *)number font:(UIFont *)font textColor:(UIColor *)textColor rowNumber:(NSUInteger)rowNumber {
//    return [self initWithNumber:number font:font textColor:textColor signSetting:SignSettingUnsigned rowNumber:rowNumber];
//}
//
//- (instancetype)initWithNumber:(NSNumber *)number font:(UIFont *)font signSetting:(SignSetting)signSetting rowNumber:(NSUInteger)rowNumber {
//    return [self initWithNumber:number font:font textColor:[UIColor grayColor] signSetting:signSetting rowNumber:rowNumber];
//}
//
//- (instancetype)initWithNumber:(NSNumber *)number font:(UIFont *)font textColor:(UIColor *)textColor signSetting:(SignSetting)signSetting rowNumber:(NSUInteger)rowNumber {
//    self = [super init];
//    if (self) {
//        self.targetNumber = number;
//        self.currentNumber = number;
//        self.font = font;
//        self.textColor = textColor;
//        self.isAnimating = NO;
//        self.finishedAnimationCount = 0;
//        self.rowNumber = (rowNumber > 0 && rowNumber <= 8) ? rowNumber : 0;
//        self.maxRowNumber = (self.rowNumber == 0) ? 8 : rowNumber;
//        self.signSetting = signSetting;
//        [self commonInit];
//    }
//    return self;
//}
//
//- (void)commonInit {
//    [self initSign];
//    [self initCells];
//    [self initParent];
//}
//
//- (void)initSign {
//    switch (self.signSetting) {
//        case SignSettingUnsigned:
//            self.signRow = 0;
//            int displayedNumber = self.targetNumber.intValue;
//            if (displayedNumber < 0) {
//                self.targetNumber = @(abs(displayedNumber));
//            }
//            break;
//        case SignSettingSigned:
//        case SignSettingNormal:
//            self.signRow = 1;
//            break;
//        default:
//            break;
//    }
//}
//
//#pragma mark - ConfigViews
//
//- (void)initParent{
//    
//    self.bounds = CGRectMake(0, 0, (self.rowNumber + self.signRow) * self.cellWidth, self.numberCellHeight / numberCellLineCount);
//    self.backgroundColor = [UIColor clearColor];
//    self.layer.masksToBounds = YES;
//}
//
//- (void)initCells {
//    int originNumber = self.targetNumber.intValue;
//    int sign = originNumber >= 0 ? 1 : -1;
//    if (self.rowNumber == 0) {
//        self.rowNumber = [self calculateNumberRow:originNumber];
//    }
//    self.cellArray = [[NSMutableArray alloc] init];
//    
//    CGRect rect = [numberCellText boundingRectWithSize:CGSizeZero
//                                     options:NSStringDrawingUsesLineFragmentOrigin
//                                  attributes:@{NSFontAttributeName:self.font}
//                                     context:nil];
//    self.cellWidth = rect.size.width;
//    self.numberCellHeight = rect.size.height;
//    self.signCellHeight = rect.size.height * signCellLineCount / numberCellLineCount;
//    
//    NSArray *displayNumberArray = [self getEachCellValueArrayWithTargetNumber:self.targetNumber.integerValue];
//    
//    for (NSInteger i = 0; i < self.rowNumber; i++) {
//        UILabel *numberCell = [self makeNumberCell];
//        numberCell.frame = CGRectMake((self.rowNumber + self.signRow - 1 - i) * self.cellWidth, 0, self.cellWidth, self.numberCellHeight);
//        NSNumber *displayNum = [displayNumberArray objectAtIndex:i];
//        [self moveNumberCell:numberCell toNumber:displayNum.integerValue sign:sign];
//        [self addSubview:numberCell];
//        [self.cellArray addObject:numberCell];
//    }
//    
//    self.signCell.frame = CGRectMake(0, 0, self.cellWidth, self.signCellHeight);
//    [self addSubview:self.signCell];
//    int displayedNumber = self.targetNumber.intValue;
//    if (displayedNumber > 0) {
//        [self moveSignCellToSign:SignPositive];
//    } else if (displayedNumber < 0) {
//        [self moveSignCellToSign:SignNegative];
//    } else {
//        [self moveSignCellToSign:SignZero];
//    }
//    
//}
//
//- (void)updateToRowNumber:(NSInteger)rowNumber {
//    if (rowNumber == self.rowNumber) {
//        return;
//    }
//    if (rowNumber < self.minRowNumber) {
//        return;
//    }
//    [self removeAllCellFromSuperview];
//    [self updateCellModelToFitRowNumber:rowNumber];
//    [self updateCellLayoutToFitRowNumber:rowNumber withAnimation:YES];
//    self.rowNumber = rowNumber;
//}
//
//- (void)removeAllCellFromSuperview {
//    
//    [self.cellArray makeObjectsPerformSelector:@selector(removeFromSuperview)];
//}
//
//- (void)updateCellModelToFitRowNumber:(NSInteger)rowNumber {
//    
//    if (rowNumber > self.rowNumber) {
//        for (NSInteger i = self.rowNumber; i < rowNumber; i++) {
//            UILabel *scrollCell = [self makeNumberCell];
//            scrollCell.frame = CGRectMake((self.rowNumber + self.signRow - 1 - i) * self.cellWidth, -self.numberCellHeight * 10 / numberCellLineCount, self.cellWidth, self.numberCellHeight);
//            [self.cellArray addObject:scrollCell];
//        }
//    }else {
//        for (NSInteger i = rowNumber; i < self.rowNumber; i++) {
//            [self.cellArray removeLastObject];
//        }
//    }
//}
//
//- (void)updateCellLayoutToFitRowNumber:(NSUInteger)rowNumber withAnimation:(BOOL)animated{
//    
//    for (UILabel *cell in self.cellArray) {
//        [self addSubview:cell];
//    }
//    __weak typeof(self) weakSelf = self;
//    NSUInteger interval = 0;
//    if (rowNumber > self.rowNumber) {
//        interval = rowNumber - self.rowNumber;
//    } else {
//        interval = self.rowNumber - rowNumber;
//    }
//    [UIView animateWithDuration:0.2 * interval animations:^{
//        for (int i = 0; i < rowNumber; i++) {
//            UILabel *cell = [weakSelf.cellArray objectAtIndex:i];
//            cell.frame = CGRectMake((rowNumber + self.signRow - 1 - i) * weakSelf.cellWidth,
//                                    cell.frame.origin.y,
//                                    weakSelf.cellWidth,
//                                    weakSelf.numberCellHeight);
//        }
//        self.frame = CGRectMake(self.frame.origin.x,
//                                self.frame.origin.y,
//                                (rowNumber + self.signRow) * self.cellWidth,
//                                self.numberCellHeight/numberCellLineCount);
//    } completion:nil];
//}
//
//#pragma mark - Animation
//
//- (void)playAnimationWithChange:(NSInteger)changeValue previousNumber:(NSNumber *)previousNumber interval:(CGFloat)interval{
//    
//    BOOL signChanged = NO;
//    if ((previousNumber.integerValue < 0 && self.targetNumber.integerValue > 0) ||
//        (previousNumber.integerValue > 0 && self.targetNumber.integerValue < 0)) {
//        signChanged = YES;
//    }
//    int sign = self.targetNumber.intValue >= 0 ? 1 : -1;
//    if (signChanged) {
//        sign = previousNumber.intValue >= 0 ? 1 : -1;
//        CGFloat interval2 = (CGFloat)fabs(self.targetNumber.integerValue * interval / (CGFloat)changeValue);
//        NSInteger changeValue2 = self.targetNumber.integerValue;
//        DPAnimationTask *task = [[DPAnimationTask alloc] init];
//        task.targetNumber = self.targetNumber.integerValue;
//        task.interval = interval2;
//        task.changeValue = changeValue2;
//        @synchronized (self.taskQueue) {
//            [self.taskQueue addObject:task];
//        }
//        changeValue = - previousNumber.integerValue;
//        interval = interval - interval2;
//        self.targetNumber = @0;
//    } else if (previousNumber.intValue == 0) {
//        [self makeSignChangeAnimation];
//    } else if (self.targetNumber.intValue == 0) {
//        sign = previousNumber.intValue >= 0 ? 1 : -1;
//        [self makeSignChangeAnimation];
//    }
//    
//    NSInteger targetRowNumber = [self calculateNumberRow:self.targetNumber.intValue];
//    
//    if (targetRowNumber > self.rowNumber) {
//        [self updateToRowNumber:targetRowNumber];
//    }
//    
//    NSArray *repeatCountArray = [self getRepeatTimesWithChangeNumber:changeValue targetNumber:self.targetNumber.integerValue];
//    NSArray *targetDisplayNums = [self getEachCellValueArrayWithTargetNumber:self.targetNumber.integerValue];
//    
//    if (interval == 0) {
//        interval = [self getIntervalWithPreviousNumber:previousNumber.integerValue targetNumber:self.targetNumber.integerValue];
//    }
//    
//    ScrollAnimationDirection direction = ((changeValue * sign) > 0)? ScrollAnimationDirectionIncrease : ScrollAnimationDirectionDecrease;
//    
//    CGFloat delay = 0.0f;
//    
//    if (repeatCountArray.count != 0) {
//        for (NSInteger i = 0; i < repeatCountArray.count; i++) {
//            NSNumber *repeat = [repeatCountArray objectAtIndex:i];
//            NSInteger repeatCount = repeat.integerValue;
//            NSNumber *willDisplayNum = [targetDisplayNums objectAtIndex:i];
//            UILabel *cell = [self.cellArray objectAtIndex:i];
//            CGFloat startDuration = 0;
//            
//            if (repeatCount == 0) {
//                [self makeSingleAnimationWithCell:cell duration:interval delay:delay animationCount:repeatCountArray.count displayNumber:willDisplayNum.integerValue];
//            }else {
//                if (direction == ScrollAnimationDirectionIncrease) {
//                    
//                    startDuration = interval * (10 - [self getValueOfCell:cell]) / ceilf(fabs(changeValue / pow(10, i)));
//                    CGFloat cycleDuration = interval * 10 / fabs(changeValue / pow(10, i));
//                    if (repeatCount == 1) {
//                        cycleDuration = 0;
//                    }
//                    CGFloat endDuration = bufferModulus * pow(willDisplayNum.integerValue, 0.3) / (i + 1);
//                    DPAnimationAttribute *attribute = [[DPAnimationAttribute alloc] init];
//                    attribute.startDuration = startDuration;
//                    attribute.startDelay = delay;
//                    attribute.cycleDuration = cycleDuration;
//                    attribute.endDuration = endDuration;
//                    attribute.repeatCount = repeatCount - 1;
//                    attribute.targetNumber = willDisplayNum.integerValue;
//                    attribute.sign = sign;
//                    [self makeMultiAnimationWithCell:cell direction:direction animationCount:repeatCountArray.count attribute:attribute];
//                }else if (direction == ScrollAnimationDirectionDecrease) {
//                    startDuration = interval * ([self getValueOfCell:cell] - 0) / ceilf(fabs(changeValue / pow(10, i)));
//                    CGFloat cycleDuration = interval * 10 / fabs(changeValue / pow(10, i));
//                    if (repeatCount == 1) {
//                        cycleDuration = 0;
//                    }
//                    CGFloat endDuration = bufferModulus * pow(10 - willDisplayNum.integerValue, 0.3) / (i + 1);
//                    DPAnimationAttribute *attribute = [[DPAnimationAttribute alloc] init];
//                    attribute.startDuration = startDuration;
//                    attribute.startDelay = delay;
//                    attribute.cycleDuration = cycleDuration;
//                    attribute.endDuration = endDuration;
//                    attribute.repeatCount = repeatCount - 1;
//                    attribute.targetNumber = willDisplayNum.integerValue;
//                    attribute.sign = sign;
//                    [self makeMultiAnimationWithCell:cell direction:direction animationCount:repeatCountArray.count attribute:attribute];
//                }
//            }
//            delay = delay + startDuration;
//        }
//        
//    }
//}
//
//- (void)makeMultiAnimationWithCell:(UILabel *)cell
//                         direction:(ScrollAnimationDirection)direction
//                    animationCount:(NSInteger)count
//                         attribute:(DPAnimationAttribute *)attribute{
//    
//    [UIView animateWithDuration:attribute.startDuration delay:attribute.startDelay options:UIViewAnimationOptionCurveEaseIn animations:^{
//        [self moveNumberCell:cell toNumber:(direction == ScrollAnimationDirectionIncrease)? 10 : 0 sign:attribute.sign];
//    } completion:^(BOOL finished) {
//        NSLog(@"start animation finish!");
//        [self moveNumberCell:cell toNumber:(direction == ScrollAnimationDirectionIncrease)? 0 : 10 sign:attribute.sign];
//        if (attribute.cycleDuration == 0) {
//            [UIView animateWithDuration:attribute.endDuration delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
//                [self moveNumberCell:cell toNumber:attribute.targetNumber sign:attribute.sign];
//            } completion:^(BOOL finished) {
//                [self oneAnimationDidFinishedWithTotalCount:count];
//                NSLog(@"end animation finish!");
//            }];
//        }else {
//            [UIView animateWithDuration:attribute.cycleDuration delay:0 options:UIViewAnimationOptionCurveLinear | UIViewAnimationOptionRepeat animations:^{
//                [UIView setAnimationRepeatCount:attribute.repeatCount];
//                [self moveNumberCell:cell toNumber:(direction == ScrollAnimationDirectionIncrease) ? 10 : 0 sign:attribute.sign];
//            } completion:^(BOOL finished) {
//                NSLog(@"cycle animation finish!");
//                [self moveNumberCell:cell toNumber:(direction == ScrollAnimationDirectionIncrease)?0 : 10 sign:attribute.sign];
//                [UIView animateWithDuration:attribute.endDuration delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
//                    [self moveNumberCell:cell toNumber:attribute.targetNumber sign:attribute.sign];
//                } completion:^(BOOL finished) {
//                    [self oneAnimationDidFinishedWithTotalCount:count];
//                    NSLog(@"end animation finish!");
//                }];
//            }];
//        }
//    }];
//}
//
//- (void)makeSingleAnimationWithCell:(UILabel *)cell duration:(CGFloat)duration delay:(CGFloat)delay animationCount:(NSInteger)count displayNumber:(NSInteger)displayNumber{
//    int sign = displayNumber >= 0 ? 1 : -1;
//    
//    [UIView animateWithDuration:duration delay:delay options:UIViewAnimationOptionCurveEaseOut animations:^{
//        [self moveNumberCell:cell toNumber:displayNumber sign:sign];
//    } completion:^(BOOL finished) {
//        [self oneAnimationDidFinishedWithTotalCount:count];
//        NSLog(@"single animation finish!");
//    }];
//}
//
//- (void)makeSignChangeAnimation {
//    Sign sign;
//    if (self.targetNumber.intValue > 0) {
//        sign = SignPositive;
//    } else if (self.targetNumber.intValue < 0) {
//        sign = SignNegative;
//    } else {
//        sign = SignZero;
//    }
//    [UIView animateWithDuration:0.5 animations:^{
//        [self moveSignCellToSign:sign];
//    }];
//}
//
//- (void)oneAnimationDidFinishedWithTotalCount:(NSInteger)totalCount {
//    self.finishedAnimationCount++;
//    if (self.finishedAnimationCount == totalCount) {
//        self.finishedAnimationCount = 0;
//        [self checkTaskArray];
//    }
//}
//
//- (void)checkTaskArray {
//    @synchronized (self.taskQueue) {
//        if (self.taskQueue.count != 0) {
//            DPAnimationTask *task = [self.taskQueue firstObject];
//            [self.taskQueue removeObject:task];
//            NSNumber *previousNumber = self.targetNumber;
//            self.targetNumber = @(task.targetNumber);
//            [self playAnimationWithChange:task.changeValue previousNumber:previousNumber interval:task.interval];
//        } else {
//            self.isAnimating = NO;
//            NSInteger needNumberRow = [self calculateNumberRow:self.currentNumber.intValue];
//            if (needNumberRow < self.rowNumber) {
//                [self updateToRowNumber:needNumberRow];
//            }
//        }
//    }
//}
//
//#pragma mark - Public Method
//
//- (void)changeToNumber:(NSNumber *)number animated:(BOOL)animated {
//    
//    [self changeToNumber:number interval:0 animated:animated];
//}
//
//- (void)changeToNumber:(NSNumber *)number interval:(CGFloat)interval animated:(BOOL)animated {
//    
//    if (self.signSetting == SignSettingUnsigned && number.intValue < 0) {
//        return ;
//    }
//    if ([self calculateNumberRow:number.integerValue] > self.maxRowNumber) {
//        return ;
//    }
//    if (number.integerValue == self.currentNumber.integerValue) {
//        return ;
//    }
//    if (self.isAnimating) {
//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//            DPAnimationTask *task = [[DPAnimationTask alloc] init];
//            task.targetNumber = number.integerValue;
//            task.changeValue = number.integerValue - self.targetNumber.integerValue;
//            task.interval = interval;
//            @synchronized (self.taskQueue) {
//                [self.taskQueue removeAllObjects];
//                [self.taskQueue addObject:task];
//            }
//        });
//    } else {
//        NSNumber *previousNumber = self.targetNumber;
//        self.targetNumber = number;
//        if (animated) {
//            [self playAnimationWithChange:number.integerValue - previousNumber.integerValue previousNumber:previousNumber interval:interval];
//            self.isAnimating = YES;
//        } else {
//            int sign = number.integerValue >= 0 ? 1 : -1;
//            NSArray<NSNumber *> *displayNumbers = [self getEachCellValueArrayWithTargetNumber:number.integerValue];
//            for (int i = 0; i < displayNumbers.count; i++) {
//                [self moveNumberCell:self.cellArray[i] toNumber:displayNumbers[i].integerValue sign:sign];
//            }
//        }
//    }
//    self.currentNumber = number;
//}
//
//#pragma mark - Privite Method
//
//- (NSInteger)calculateNumberRow:(NSInteger)number {
//    NSInteger numberRow = 1;
//    while ((number = number / 10) != 0) {
//        numberRow++;
//    }
//    return numberRow;
//}
//
//- (void)moveNumberCell:(UILabel *)cell toNumber:(NSInteger)number sign:(NSInteger)sign{
//    CGFloat x = cell.frame.origin.x;
//    CGFloat floatNumber = abs((int)number);
//    CGFloat y = - self.numberCellHeight / numberCellLineCount * 10 - sign * ((CGFloat)floatNumber / numberCellLineCount) * self.numberCellHeight;
//    cell.frame = CGRectMake(x, y, self.cellWidth, self.numberCellHeight);
//    // 添加文字描边效果
//    [self applyTextStrokeToLabel:cell withStrokeColor:[UIColor colorWithHexString:@"#FFFFFF"]];
//    [self applyGradientTextToLabel:cell];
//    
//}
//
//- (void)moveSignCellToSign:(Sign)sign {
//    CGFloat x = self.signCell.frame.origin.x;
//    CGFloat y = - ((CGFloat)sign / signCellLineCount) * self.signCellHeight;
//    self.signCell.frame = CGRectMake(x, y, self.cellWidth, self.signCellHeight);
//    // 添加文字描边效果
//    [self applyTextStrokeToLabel:self.signCell withStrokeColor:[UIColor colorWithHexString:@"#FFFFFF"]];
//    [self applyGradientTextToLabel:self.signCell];
//    
//}
//
//- (NSArray<NSNumber *> *)getRepeatTimesWithChangeNumber:(NSInteger)change targetNumber:(NSInteger)targetNumber{
//    NSMutableArray *repeatTimesArray = [[NSMutableArray alloc] init];
//    NSInteger originNumber = targetNumber - change;
//    if (change > 0) {
//        do {
//            targetNumber = (targetNumber / 10) * 10;
//            originNumber = (originNumber / 10) * 10;
//            NSNumber *repeat = @((targetNumber - originNumber) / 10);
//            [repeatTimesArray addObject:repeat];
//            targetNumber = targetNumber / 10;
//            originNumber = originNumber / 10;
//        } while ((targetNumber - originNumber) != 0);
//    }else {
//        do {
//            targetNumber = (targetNumber / 10) * 10;
//            originNumber = (originNumber / 10) * 10;
//            NSNumber *repeat = @((originNumber - targetNumber) / 10);
//            [repeatTimesArray addObject:repeat];
//            targetNumber = targetNumber / 10;
//            originNumber = originNumber / 10;
//        } while ((originNumber - targetNumber) != 0);
//    }
//    return repeatTimesArray;
//}
//
//- (NSArray<NSNumber *> *)getEachCellValueArrayWithTargetNumber:(NSInteger)targetNumber {
//    
//    NSMutableArray *cellValueArray = [[NSMutableArray alloc] init];
//    NSInteger tmp;
//    for (NSInteger i = 0; i < self.rowNumber; i++) {
//        tmp = targetNumber % 10;
//        NSNumber *number = @(tmp);
//        [cellValueArray addObject:number];
//        targetNumber = targetNumber / 10;
//    }
//    
//    return cellValueArray;
//}
//
//- (NSInteger)getValueOfCell:(UILabel *)cell {
//    CGFloat y = cell.frame.origin.y;
//    CGFloat tmpNumber = (- (y * numberCellLineCount / self.numberCellHeight)) - 10;
//    NSInteger displayNumber = (NSInteger)roundf(tmpNumber);
//    displayNumber = abs((int)displayNumber);
//    return displayNumber;
//}
//
//- (CGFloat)getIntervalWithPreviousNumber:(NSInteger)previousNumber targetNumber:(NSInteger)targetNumber {
//    
//    NSArray *repeatTimesArray = [self getRepeatTimesWithChangeNumber:targetNumber - previousNumber targetNumber:targetNumber];
//    NSUInteger count = repeatTimesArray.count;
//    NSInteger tmp1 = targetNumber / (NSInteger)pow(10, count - 1);
//    NSInteger tmp2 = previousNumber / (NSInteger)pow(10, count - 1);
//    
//    NSInteger maxChangeNum = labs(tmp1 % 10 - tmp2 % 10);
//    
//    return normalModulus * count * maxChangeNum;
//    
//}
//
//- (void)startAnimWithDuration:(NSTimeInterval)duration show_style:(NSInteger)show_style completion:(void (^)(void))completion {
//    self.show_style = show_style;
//    // 保存原始锚点和中心点
//    CGPoint originalAnchorPoint = self.layer.anchorPoint;
//    CGPoint originalCenter = self.center;
//
//    CGRect labelBounds = self.bounds;
//    self.layer.anchorPoint = CGPointMake(0.5, 0.2);
//    self.center = CGPointMake(self.center.x, self.center.y + (self.layer.anchorPoint.y - originalAnchorPoint.y) * labelBounds.size.height);
//
//    [UIView animateKeyframesWithDuration:duration delay:0 options:0 animations:^{
//        // 放大动画到 3 倍
//        [UIView addKeyframeWithRelativeStartTime:0 relativeDuration:0 animations:^{
//            self.transform = CGAffineTransformMakeScale(3, 3);
//        }];
//        // 缩小动画到 0.8 倍
//        [UIView addKeyframeWithRelativeStartTime:0.1 relativeDuration:0.8 animations:^{
//            self.transform = CGAffineTransformMakeScale(0.8, 0.8);
//        }];
//    } completion:^(BOOL finished) {
//        // 恢复到原始大小并复位锚点
//        [UIView animateWithDuration:0.06 delay:0 usingSpringWithDamping:0.1 initialSpringVelocity:120 options:UIViewAnimationOptionCurveEaseInOut animations:^{
//            // 恢复锚点和中心点
//            self.layer.anchorPoint = originalAnchorPoint;
//            self.center = originalCenter;
//            self.transform = CGAffineTransformIdentity;
//        } completion:^(BOOL restoreFinished) {
//            // 执行传入的完成回调
//            if (completion) {
//                completion();
//            }
//        }];
//    }];
//}
//
//#pragma mark - Setters
//
//- (void)setMinRowNumber:(NSUInteger)minRowNumber {
//    [self updateToRowNumber:minRowNumber];
//    _minRowNumber = minRowNumber;
//}
//
//#pragma mark - Getters
//
//- (UILabel *)makeNumberCell {
//    UILabel *cell = [[UILabel alloc] init];
//    cell.font = [self boldItalicizedFont:self.font];
//    cell.numberOfLines = numberCellLineCount;
//    NSLog(@"当前self.rowNumber =\(%zd)",_rowNumber);
//    cell.textColor = self.textColor;//[UIColor clearColor];
//    cell.textAlignment = NSTextAlignmentCenter;
//    cell.text = numberCellText;
//    return  cell;
//}
//
//- (UILabel *)signCell {
//    if (!_signCell) {
//        _signCell = [[UILabel alloc] init];
//        _signCell.font = [self boldItalicizedFont:self.font];
//        _signCell.numberOfLines = signCellLineCount;
//        switch (self.signSetting) {
//            case SignSettingNormal:
//                _signCell.text = @"-\n \nx ";
//                break;
//            case SignSettingUnsigned:
//                _signCell.text = @" \n \nx ";
//                break;
//            case SignSettingSigned:
//                _signCell.text = @"-\n \nx ";
//                break;
//            default:
//                break;
//        }
//        _signCell.textColor = self.textColor;//[UIColor clearColor];
//    }
//    return _signCell;
//}
//
//- (void)applyGradientTextToLabel:(UILabel *)label {
//    if (label.text == nil || label.bounds.size.width == 0 || label.bounds.size.height == 0) return;
//    
//    // 创建渐变图层
//    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
//    gradientLayer.frame = label.bounds;
//
//
//    // 设置渐变颜色
//    if (self.show_style == 1) {
//        gradientLayer.colors = @[
//            (__bridge id)[UIColor colorWithHexString:@"#D56BFF"].CGColor,
//            (__bridge id)[UIColor colorWithHexString:@"#8E24FF"].CGColor,
//            (__bridge id)[UIColor colorWithHexString:@"#D56BFF"].CGColor
//        ];
//    } else if (self.show_style == 2) {
//        gradientLayer.colors = @[
//            (__bridge id)[UIColor colorWithHexString:@"#FF757C"].CGColor,
//            (__bridge id)[UIColor colorWithHexString:@"#FF333E"].CGColor,
//            (__bridge id)[UIColor colorWithHexString:@"#FF757C"].CGColor
//        ];
//    }  else if (self.show_style == 3) {
//        gradientLayer.colors = @[
//            (__bridge id)[UIColor colorWithHexString:@"#FFBB00"].CGColor,
//            (__bridge id)[UIColor colorWithHexString:@"#FF620D"].CGColor,
//            (__bridge id)[UIColor colorWithHexString:@"#FF5159"].CGColor
//        ];
//    }  else if (self.show_style == 4) {
//        gradientLayer.colors = @[
//            (__bridge id)[UIColor colorWithHexString:@"#FFE926"].CGColor,
//            (__bridge id)[UIColor colorWithHexString:@"#FF6302"].CGColor,
//            (__bridge id)[UIColor colorWithHexString:@"#FFE926"].CGColor
//        ];
//    }  else if (self.show_style == 5) {
//        gradientLayer.colors = @[
//            (__bridge id)[UIColor colorWithHexString:@"#FFEA00"].CGColor,
//            (__bridge id)[UIColor colorWithHexString:@"#FFA600"].CGColor,
//            (__bridge id)[UIColor colorWithHexString:@"#FFEA00"].CGColor
//        ];
//    }
//    
//    // 设置渐变分布
//    gradientLayer.startPoint = CGPointMake(0, 0);
//    gradientLayer.endPoint = CGPointMake(1, 1);
//
//    // 创建文本遮罩
//    UIGraphicsBeginImageContextWithOptions(label.bounds.size, NO, 0.0);
//    [label.text drawInRect:label.bounds withAttributes:@{
//        NSFontAttributeName: label.font,
//        NSForegroundColorAttributeName: UIColor.redColor // 必须有颜色
//    }];
//    UIImage *maskImage = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//
//    if (!maskImage) {
//        NSLog(@"Error: Failed to create mask image.");
//        return;
//    }
//
//    CALayer *maskLayer = [CALayer layer];
//    maskLayer.contents = (__bridge id)maskImage.CGImage;
//    maskLayer.frame = label.bounds;
//    gradientLayer.mask = maskLayer;
//
//    // 移除已有的渐变层，避免重复添加
//    NSArray<CALayer *> *sublayers = [label.layer.sublayers copy];
//    for (CALayer *layer in sublayers) {
//        if ([layer isKindOfClass:[CAGradientLayer class]]) {
//            [layer removeFromSuperlayer];
//        }
//    }
//
//    // 添加渐变图层
//    [label.layer addSublayer:gradientLayer];
//}
//
//
////粗体
//- (UIFont *)boldItalicizedFont:(UIFont *)font {
//    if (!font) return nil;
//    UIFontDescriptor *originalDescriptor = font.fontDescriptor;
//    UIFontDescriptorSymbolicTraits traits = (originalDescriptor.symbolicTraits | UIFontDescriptorTraitBold) & ~UIFontDescriptorTraitItalic;
//    UIFontDescriptor *boldDescriptor = [originalDescriptor fontDescriptorWithSymbolicTraits:traits];
//
//    if (boldDescriptor) {
//        return [UIFont fontWithDescriptor:boldDescriptor size:font.pointSize];
//    }
//    return font;
//}
//
//
//
//// 添加文字描边效果的通用方法
//- (void)applyTextStrokeToLabel:(UILabel *)label withStrokeColor:(UIColor *)strokeColor {
//    if (label.text == nil) return;
//
//    // 创建带描边的富文本
//    NSAttributedString *attributedText = [[NSAttributedString alloc] initWithString:label.text attributes:@{
//        NSFontAttributeName: label.font,
//        NSForegroundColorAttributeName: label.textColor,
//        NSStrokeColorAttributeName: strokeColor,
//        NSStrokeWidthAttributeName: @(-2.0) // 描边宽度，负值表示描边
//    }];
//    
//    label.attributedText = attributedText;
//}
//
//- (NSMutableArray *)taskQueue {
//    if (!_taskQueue) {
//        _taskQueue = [NSMutableArray arrayWithCapacity:1];
//    }
//    return _taskQueue;
//}
//
//@end


#import <QuartzCore/QuartzCore.h>
#import "PioerCountingLabel.h"
#import "UIColor+CustomColor.h"

#if !__has_feature(objc_arc)
#error PioerCountingLabel is ARC only. Either turn on ARC for the project or use -fobjc-arc flag
#endif

#pragma mark - UILabelCounter

#ifndef kUILabelCounterRate
#define kUILabelCounterRate 3.0
#endif

@protocol UILabelCounter<NSObject>

-(CGFloat)update:(CGFloat)t;

@end

@interface UILabelCounterLinear : NSObject<UILabelCounter>

@end

@interface UILabelCounterEaseIn : NSObject<UILabelCounter>

@end

@interface UILabelCounterEaseOut : NSObject<UILabelCounter>

@end

@interface UILabelCounterEaseInOut : NSObject<UILabelCounter>

@end

@interface UILabelCounterEaseInBounce : NSObject<UILabelCounter>

@end

@interface UILabelCounterEaseOutBounce : NSObject<UILabelCounter>

@end

@implementation UILabelCounterLinear

-(CGFloat)update:(CGFloat)t
{
    return t;
}

@end

@implementation UILabelCounterEaseIn

-(CGFloat)update:(CGFloat)t
{
    return powf(t, kUILabelCounterRate);
}

@end

@implementation UILabelCounterEaseOut

-(CGFloat)update:(CGFloat)t{
    return 1.0-powf((1.0-t), kUILabelCounterRate);
}

@end

@implementation UILabelCounterEaseInOut

-(CGFloat) update: (CGFloat) t
{
    t *= 2;
    if (t < 1)
        return 0.5f * powf (t, kUILabelCounterRate);
    else
        return 0.5f * (2.0f - powf(2.0 - t, kUILabelCounterRate));
}

@end

@implementation UILabelCounterEaseInBounce

-(CGFloat) update: (CGFloat) t {
    
    if (t < 4.0 / 11.0) {
        return 1.0 - (powf(11.0 / 4.0, 2) * powf(t, 2)) - t;
    }
    
    if (t < 8.0 / 11.0) {
        return 1.0 - (3.0 / 4.0 + powf(11.0 / 4.0, 2) * powf(t - 6.0 / 11.0, 2)) - t;
    }
    
    if (t < 10.0 / 11.0) {
        return 1.0 - (15.0 /16.0 + powf(11.0 / 4.0, 2) * powf(t - 9.0 / 11.0, 2)) - t;
    }
    
    return 1.0 - (63.0 / 64.0 + powf(11.0 / 4.0, 2) * powf(t - 21.0 / 22.0, 2)) - t;
    
}

@end

@implementation UILabelCounterEaseOutBounce

-(CGFloat) update: (CGFloat) t {
    
    if (t < 4.0 / 11.0) {
        return powf(11.0 / 4.0, 2) * powf(t, 2);
    }
    
    if (t < 8.0 / 11.0) {
        return 3.0 / 4.0 + powf(11.0 / 4.0, 2) * powf(t - 6.0 / 11.0, 2);
    }
    
    if (t < 10.0 / 11.0) {
        return 15.0 /16.0 + powf(11.0 / 4.0, 2) * powf(t - 9.0 / 11.0, 2);
    }
    
    return 63.0 / 64.0 + powf(11.0 / 4.0, 2) * powf(t - 21.0 / 22.0, 2);
    
}

@end

#pragma mark - PioerCountingLabel

@interface PioerCountingLabel ()

@property CGFloat startingValue;
@property CGFloat destinationValue;
@property NSTimeInterval progress;
@property NSTimeInterval lastUpdate;
@property NSTimeInterval totalTime;
@property CGFloat easingRate;

@property (nonatomic, strong) CADisplayLink *timer;
@property (nonatomic, strong) id<UILabelCounter> counter;

@end

@implementation PioerCountingLabel

-(void)countFrom:(CGFloat)value to:(CGFloat)endValue alpha:(BOOL)alpha {
//    self.nowAlpha = alpha;
    if (self.animationDuration == 0.0f) {
        self.animationDuration = 2.0f;
    }
    
    [self countFrom:value to:endValue withDuration:self.animationDuration alpha: alpha];
}

-(void)countFrom:(CGFloat)startValue to:(CGFloat)endValue withDuration:(NSTimeInterval)duration alpha:(BOOL)alpha {
    
    self.startingValue = startValue;
    self.destinationValue = endValue;
    
//    self.nowAlpha = alpha;
    // remove any (possible) old timers
    [self.timer invalidate];
    self.timer = nil;
    
    if(self.format == nil) {
        self.format = @"%f";
    }
    if (duration == 0.0) {
        // No animation
        [self setTextValue:endValue alpha: alpha];
        [self runCompletionBlock];
        return;
    }

    self.easingRate = 3.0f;
    self.progress = 0;
    self.totalTime = duration;
    self.lastUpdate = CACurrentMediaTime();

    switch(self.method)
    {
        case UILabelCountingMethodLinear:
            self.counter = [[UILabelCounterLinear alloc] init];
            break;
        case UILabelCountingMethodEaseIn:
            self.counter = [[UILabelCounterEaseIn alloc] init];
            break;
        case UILabelCountingMethodEaseOut:
            self.counter = [[UILabelCounterEaseOut alloc] init];
            break;
        case UILabelCountingMethodEaseInOut:
            self.counter = [[UILabelCounterEaseInOut alloc] init];
            break;
        case UILabelCountingMethodEaseOutBounce:
            self.counter = [[UILabelCounterEaseOutBounce alloc] init];
            break;
        case UILabelCountingMethodEaseInBounce:
            self.counter = [[UILabelCounterEaseInBounce alloc] init];
            break;
    }

    CADisplayLink *timer = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateValue:)];
    timer.frameInterval = 2;
    [timer addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
    [timer addToRunLoop:[NSRunLoop mainRunLoop] forMode:UITrackingRunLoopMode];
    self.timer = timer;
}

- (void)countFromCurrentValueTo:(CGFloat)endValue alpha:(BOOL)alpha {
    [self countFrom:[self currentValue] to:endValue alpha:alpha];
}

- (void)countFromCurrentValueTo:(CGFloat)endValue withDuration:(NSTimeInterval)duration alpha:(BOOL)alpha {
    [self countFrom:[self currentValue] to:endValue withDuration:duration alpha:alpha];
}

- (void)countFromZeroTo:(CGFloat)endValue alpha:(BOOL)alpha {
    [self countFrom:0.0f to:endValue alpha: false];
}
//
//- (void)countFromZeroTo:(CGFloat)endValue withDuration:(NSTimeInterval)duration alpha:(BOOL)alpha {
//    [self countFrom:0.0f to:endValue withDuration:duration];
//}

- (void)updateValue:(NSTimer *)timer {
    
    // update progress
    NSTimeInterval now = CACurrentMediaTime();
    self.progress += now - self.lastUpdate;
    self.lastUpdate = now;
    
    if (self.progress >= self.totalTime) {
        [self.timer invalidate];
        self.timer = nil;
        self.progress = self.totalTime;
    }
//    NSLog(@"当前self.nowAlpha = %d", self.nowAlpha);
    [self setTextValue:[self currentValue] alpha: self.nowAlpha];
    
    if (self.progress == self.totalTime) {
        [self runCompletionBlock];
    }
}

- (void)setTextValue:(CGFloat)value alpha:(BOOL)alpha
{
    if (self.attributedFormatBlock != nil) {
        self.attributedText = self.attributedFormatBlock(value);
    }
    else if(self.formatBlock != nil)
    {
        self.text = self.formatBlock(value);
    }
    else
    {
        if([self.format rangeOfString:@"%[^fega]*[diouxc]" options:NSRegularExpressionSearch|NSCaseInsensitiveSearch].location != NSNotFound)
        {
            self.text = [NSString stringWithFormat:self.format,(int)value];
        }
        else
        {
            self.text = [NSString stringWithFormat:self.format,value];
        }
    }
    // 应用渐变颜色逻辑
    [self applyGradientToTextAlpha: alpha];
    [self layoutIfNeeded];

}

- (void)setFormat:(NSString *)format {
    _format = format;
    // update label with new format
    [self setTextValue:self.currentValue alpha: true];
}

- (void)runCompletionBlock {
    
    void (^block)(void) = self.completionBlock;
    if (block) {
        self.completionBlock = nil;
        block();
    }
}

- (CGFloat)currentValue {
    
    if (self.progress >= self.totalTime) {
        return self.destinationValue;
    }
    
    CGFloat percent = self.progress / self.totalTime;
    CGFloat updateVal = [self.counter update:percent];
    return self.startingValue + (updateVal * (self.destinationValue - self.startingValue));
}

- (CGFloat)calculateTextWidthWithContent:(NSString *)content font:(UIFont *)font maxSize:(CGSize)size {
    if (content == nil || font == nil) {
        return 0;
    }

    NSDictionary *attributes = @{NSFontAttributeName: font};
    CGSize textSize = [content boundingRectWithSize:size
                                             options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                          attributes:attributes
                                             context:nil].size;
    return textSize.width;
}

//- (void)setNowAlpha:(BOOL)nowAlpha {
//    _nowAlpha = nowAlpha; // 直接赋值实例变量
//    self.alpha = _nowAlpha ? 0.5 : 1.0;
//    // 实时响应 alpha_style 的变化
////    NSLog(@"实时响应打印当前值 = %d", _nowAlpha);
//}



- (void)applyGradientToTextAlpha:(BOOL)alpha {
    if (self.bounds.size.width == 0 || self.bounds.size.height == 0 || self.text == nil) return;

    //渐变图层
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
//    CGSize maxSize = CGSizeMake(200, 40);
//    CGFloat textWidth = [self calculateTextWidthWithContent:self.text font:[UIFont fontWithName:@"BakbakOne-Regular" size:35] maxSize: maxSize];
    
    gradientLayer.frame = CGRectMake(self.bounds.origin.x, self.bounds.origin.y - 5, self.bounds.size.width, self.bounds.size.height); //居中

    //渐变颜色
    if (self.model.show_style == 1) {
        gradientLayer.colors = @[
            (__bridge id)[UIColor colorWithHexString:@"#D56BFF"].CGColor,
            (__bridge id)[UIColor colorWithHexString:@"#8E24FF"].CGColor,
            (__bridge id)[UIColor colorWithHexString:@"#D56BFF"].CGColor
        ];
    } else if (self.model.show_style == 2) {
        gradientLayer.colors = @[
            (__bridge id)[UIColor colorWithHexString:@"#FF757C"].CGColor,
            (__bridge id)[UIColor colorWithHexString:@"#FF333E"].CGColor,
            (__bridge id)[UIColor colorWithHexString:@"#FF757C"].CGColor
        ];
    } else if (self.model.show_style == 3) {
        gradientLayer.colors = @[
            (__bridge id)[UIColor colorWithHexString:@"#FFBB00"].CGColor,
            (__bridge id)[UIColor colorWithHexString:@"#FF620D"].CGColor,
            (__bridge id)[UIColor colorWithHexString:@"#FF5159"].CGColor
        ];
    } else if (self.model.show_style == 4) {
        gradientLayer.colors = @[
            (__bridge id)[UIColor colorWithHexString:@"#FFE926"].CGColor,
            (__bridge id)[UIColor colorWithHexString:@"#FF6302"].CGColor,
            (__bridge id)[UIColor colorWithHexString:@"#FFE926"].CGColor
        ];
    } else if (self.model.show_style == 5) {
        gradientLayer.colors = @[
            (__bridge id)[UIColor colorWithHexString:@"#FFEA00"].CGColor,
            (__bridge id)[UIColor colorWithHexString:@"#FFA600"].CGColor,
            (__bridge id)[UIColor colorWithHexString:@"#FFEA00"].CGColor
        ];
    }
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(1, 1);

    // 创建文本遮罩
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, 0.0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    if (!context) return;

    // 设置文本绘制属性
    UIFont *customFont = [UIFont fontWithName:@"BakbakOne-Regular" size:self.font.pointSize];
    if (!customFont) {
        NSLog(@"字体加载失败，请检查字体名称或是否正确导入");
        return;
    }

    NSDictionary *attributes = @{
        NSFontAttributeName: customFont,
        NSForegroundColorAttributeName: UIColor.blackColor, // 黑色用于遮罩
        NSStrokeColorAttributeName: UIColor.whiteColor,     // 描边颜色
        NSStrokeWidthAttributeName: @(0)                 // 描边宽度（负值表示描边）
    };

    // 绘制文字
    [self.text drawInRect:self.bounds withAttributes:attributes];

    UIImage *maskImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    if (!maskImage) {
        NSLog(@"Error: Failed to create mask image.");
        return;
    }

    // 设置遮罩层
    CALayer *maskLayer = [CALayer layer];
    maskLayer.contents = (__bridge id)maskImage.CGImage;
    maskLayer.frame = self.bounds;
    gradientLayer.mask = maskLayer;

    // 清除旧的渐变层，避免重复添加
    NSArray *sublayers = [self.layer.sublayers copy];
    for (CALayer *layer in sublayers) {
        if ([layer isKindOfClass:[CAGradientLayer class]]) {
            [layer removeFromSuperlayer];
        }
    }

    // 添加渐变层到当前视图
    [self.layer addSublayer:gradientLayer];
}

//- (void)startAnimWithDuration:(NSTimeInterval)duration completion:(void (^)(void))completion {
//    [UIView animateKeyframesWithDuration:duration delay:0 options:0 animations:^{
//        [UIView addKeyframeWithRelativeStartTime:0 relativeDuration:0 animations:^{
//            self.transform = CGAffineTransformMakeScale(3, 3);
//        }];
//        [UIView addKeyframeWithRelativeStartTime:0.1 relativeDuration:0.8 animations:^{
//            self.transform = CGAffineTransformMakeScale(0.7, 0.7);
//        }];
//    } completion:^(BOOL finished) {
//        [UIView animateWithDuration:0.06 delay:0 usingSpringWithDamping:0.1 initialSpringVelocity:120 options:UIViewAnimationOptionCurveEaseInOut animations:^{
//            self.transform = CGAffineTransformIdentity;
//        } completion:^(BOOL restoreFinished) {
//            //完成回调
//            if (completion) {
//                completion();
//            }
//        }];
//    }];
//}



@end
