#include "PerfectWidgets13.h"

// --------------------------------------------------------------------------
// --------------------- METHODS FOR CHOOSING COLORS ------------------------
// --------------------------------------------------------------------------

// Taken From https://stackoverflow.com/questions/11598043/get-slightly-lighter-and-darker-color-from-uicolor

static UIColor *lighterColorForColor(UIColor *c)
{
    CGFloat r, g, b, a;
	[c getRed: &r green: &g blue: &b alpha: &a];
    return [UIColor colorWithRed: MIN(r + 0.2, 1.0) green: MIN(g + 0.2, 1.0) blue: MIN(b + 0.2, 1.0) alpha: a];
}

static UIColor *darkerColorForColor(UIColor *c)
{
    CGFloat r, g, b, a;
    [c getRed: &r green: &g blue: &b alpha: &a];
    return [UIColor colorWithRed: MAX(r - 0.2, 0.0) green: MAX(g - 0.2, 0.0) blue: MAX(b - 0.2, 0.0) alpha: a];
}

static UIColor *getContrastColorBasedOnBackgroundColor(UIColor *backgroundColor)
{
	CGFloat brightness;
	[backgroundColor getHue: nil saturation: nil brightness: &brightness alpha: nil];
	if(brightness <= 0.5) return lighterColorForColor(backgroundColor);
	else return darkerColorForColor(backgroundColor);
}

@implementation UIImage (UIImageAverageColorAddition)

// Taken from @alextrob: https://github.com/alextrob/UIImageAverageColor

- (UIColor*)mergedColor
{
	CGSize size = {1, 1};
	UIGraphicsBeginImageContext(size);
	CGContextRef ctx = UIGraphicsGetCurrentContext();
	CGContextSetInterpolationQuality(ctx, kCGInterpolationMedium);
	[self drawInRect: (CGRect){.size = size} blendMode: kCGBlendModeCopy alpha: 1];
	uint8_t *data = (uint8_t *)CGBitmapContextGetData(ctx);
	UIColor *color = [UIColor colorWithRed: data[2] / 255.0f green: data[1] / 255.0f blue: data[0] / 255.0f alpha: 1];
	UIGraphicsEndImageContext();
	return color;
}

@end

// ------------------------------ ALWAYS EXTENDED WIDGETS ------------------------------

%group alwaysExtendedWidgetsGroup

	%hook WGWidgetPlatterView

	-(void)setShowingMoreContent:(BOOL)arg1
	{
		%orig(YES);
	}

	-(BOOL)isShowingMoreContent
	{
		return YES;
	}

	%end

%end

// ------------------------------ HIDE CLOCK FROM WIDGETS ------------------------------

%group hideClockGroup

	%hook WGWidgetListHeaderView

	- (void)layoutSubviews
	{
		%orig;
		self.hidden = YES;
	}

	%end

%end

// ------------------------------ HIDE "WEATHER INFORMATION PROVIDED BY..." TEXT IN WIDGETS PAGE ------------------------------

%group hideWeatherProvidedGroup

	%hook WGWidgetAttributionView

	- (id)initWithWidgetAttributedString: (id)arg
	{
		return %orig(NULL);
	}

	%end

%end

// -------------------------- COLORIZE WIDGETS ------------------------------

%group colorizeWidgetsGroup

	%hook WGWidgetPlatterView

	%property(nonatomic, retain) UIColor *bgColor;
	%property(nonatomic, retain) UIColor *borderColor;

	- (void)layoutSubviews
	{
		%orig;

		if (![self listItem]) return;
		
		if(alwaysExtendedWidgets) [self.showMoreButton setHidden: YES];
		
		if(colorizeWidgets) [self colorizeWidget];
	}

	%new
	- (void)colorizeWidget
	{
		WGPlatterHeaderContentView *headerContentView = MSHookIvar<WGPlatterHeaderContentView*>(self, "_headerContentView");
		if(headerContentView)
		{
			UIImage *appIcon = headerContentView.icons[0];
			if(appIcon)
			{
				self.bgColor = [appIcon mergedColor];
				if(self.bgColor)
				{
					self.borderColor = getContrastColorBasedOnBackgroundColor(self.bgColor);

					if(MSHookIvar<MTMaterialView*>(self, "_headerBackgroundView"))
						MSHookIvar<MTMaterialView*>(self, "_headerBackgroundView").alpha = 0;

					MTMaterialView *backgroundView = MSHookIvar<MTMaterialView*>(self, "_backgroundView");
					if(backgroundView)
					{
						backgroundView.clipsToBounds = YES;
						backgroundView.layer.cornerRadius = 13;
						backgroundView.layer.borderWidth = 3.0f;

						backgroundView.backgroundColor = self.bgColor;
						backgroundView.layer.borderColor = self.borderColor.CGColor;
					}
				}
			}
		}
	}

	%end

%end

%ctor
{
	@autoreleasepool
	{
		pref = [[HBPreferences alloc] initWithIdentifier: @"com.johnzaro.perfectwidgets13prefs"];

		[pref registerBool: &alwaysExtendedWidgets default: NO forKey: @"alwaysExtendedWidgets"];
		[pref registerBool: &hideClock default: NO forKey: @"hideClock"];
		[pref registerBool: &hideWeatherProvided default: NO forKey: @"hideWeatherProvided"];
		[pref registerBool: &colorizeWidgets default: NO forKey: @"colorizeWidgets"];

		if(alwaysExtendedWidgets) %init(alwaysExtendedWidgetsGroup);
		if(hideClock) %init(hideClockGroup);
		if(hideWeatherProvided) %init(hideWeatherProvidedGroup);
		if(alwaysExtendedWidgets || colorizeWidgets) %init(colorizeWidgetsGroup);
	}
}