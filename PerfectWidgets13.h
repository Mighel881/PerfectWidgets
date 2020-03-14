#import <Cephei/HBPreferences.h>

HBPreferences *_Nullable pref;

BOOL alwaysExtendedWidgets;
BOOL hideClock;
BOOL hideWeatherProvided;
BOOL colorizeWidgets;

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
- (void)colorizeWidget;
- (UIButton*)showMoreButton;
@end

@interface PLPlatterHeaderContentView: UIView
- (void)_updateTextAttributesForDateLabel;
- (UILabel*)_titleLabel;
@end

@interface WGPlatterHeaderContentView: PLPlatterHeaderContentView
@property(nonatomic, copy) NSArray *icons;
@end