#import <Cephei/HBPreferences.h>
#import "SparkColourPickerUtils.h"

HBPreferences *pref;

BOOL hideClock;
BOOL hideWeatherProvided;
BOOL alwaysExtendedWidgets;

BOOL colorizeBackground;
BOOL customBackgroundColorEnabled;
NSString *customBackgroundColorString;
UIColor *customBackgroundColor;

BOOL colorizeBorder;
BOOL customBorderColorEnabled;
NSString *customBorderColorString;
UIColor *customBorderColor;

BOOL tranparentWidgetHeader;

NSInteger widgetCorner;

@interface WGWidgetListHeaderView: UIView
@end

@interface MTMaterialView: UIView
@property(nonatomic, retain) NSString *groupNameBase;
- (void)applyColor:(UIColor*)backgroundColor borderColor: (UIColor*)borderColor;
@end

@interface WGWidgetListItemViewController: UIViewController
@end

@interface WGWidgetPlatterView: UIView
@property(nonatomic, retain) UIColor *bgColor;
@property(nonatomic, retain) UIColor *borderColor;
- (WGWidgetListItemViewController*)listItem;
- (UIView*)contentView;
- (void)colorizeWidget;
- (UIButton*)showMoreButton;
@end

@interface PLPlatterHeaderContentView: UIView
- (void)_updateTextAttributesForDateLabel;
- (UILabel*)_titleLabel;
@end

@interface WGPlatterHeaderContentView: PLPlatterHeaderContentView
- (NSArray*)iconButtons;
@property(nonatomic, copy) NSArray *icons;
@end