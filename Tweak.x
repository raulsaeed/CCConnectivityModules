#import "Tweak.h"

%group ConnectivityModule
%hook CCUIConnectivityModuleViewController

-(void)_setupPortraitButtons{
    %orig;
    if ([[controlCenterPrefs settings] count] > 3){
    NSArray *newOrder = [[NSArray alloc] init];
    newOrder = [self evoGetToggleOrder:self.portraitButtonViewControllers];
    
    if ([newOrder count] != 0) {
        [self setPortraitButtonViewControllers:newOrder];
    }
    } else {
        NSString *path = @"/var/jb/var/mobile/Library/Preferences/com.ashad.connectivitymodules.plist";
        NSMutableDictionary *settings = [NSMutableDictionary dictionaryWithContentsOfFile:path];

        for (int i = 0; i < [self.portraitButtonViewControllers count]; i++) {
            [settings setObject:NSStringFromClass([self.portraitButtonViewControllers[i] class]) forKey:[NSString stringWithFormat:@"connectivityPosition%d", i]];
        }

        [settings writeToFile:path atomically:YES];
    }
}
%new
-(NSArray*)evoGetToggleOrder:(NSArray *)originalOrder {

    NSMutableArray *newOrder = [NSMutableArray arrayWithCapacity: 6];
    for (int i = 0; i < 6; i++) {
        [newOrder addObject:@""];
    }

    for (id obj in originalOrder) {
        for (int i = 0; i < 6; i++) {
            NSString *val = [[controlCenterPrefs settings] valueForKey:[NSString stringWithFormat:@"connectivityPosition%d", i]];
            if ([[controlCenterPrefs settings] count] != 0 && [val isEqual:NSStringFromClass([obj class])]) {
                [newOrder replaceObjectAtIndex:i withObject:obj];
            }
        }
    }

    return newOrder;
}

%end
%end


static void notificationCallback(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo) {
	if ( [((__bridge NSDictionary *)userInfo)[NSLoadedClasses] containsObject:@"CCUIConnectivityModuleViewController"]) { // The Network Bundle is Loaded
		%init(ConnectivityModule);
	}
}
%ctor { 
    prefrences = [[NSUserDefaults standardUserDefaults]
    persistentDomainForName:@"com.yourcompany.controlcenterprefs"];
    id enabled = [prefrences valueForKey:@"Enabled"];
    controlCenterPrefs = [prefs sharedInstance];

    if ([enabled isEqual:@1]){
	CFNotificationCenterAddObserver(CFNotificationCenterGetLocalCenter(), 
	NULL,notificationCallback,(CFStringRef)NSBundleDidLoadNotification,NULL, CFNotificationSuspensionBehaviorCoalesce);
    }
    
}