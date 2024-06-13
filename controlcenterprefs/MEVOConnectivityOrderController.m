#import <Preferences/Preferences.h>
#import <Preferences/PSListController.h>
@interface PSEditableListController : PSListController //editibale class
@end
@interface MEVOConnectivityOrderController : PSEditableListController 
@end 

NSMutableOrderedSet *toggles;

@implementation MEVOConnectivityOrderController

- (NSArray *)specifiers {
	if (!_specifiers) {
		NSMutableArray *mutableSpecifiers = [NSMutableArray array];
		//grab the cc modules from plist
		NSString *path = @"/var/jb/var/mobile/Library/Preferences/com.ashad.connectivitymodules.plist";
        NSMutableDictionary *settings = [NSMutableDictionary dictionaryWithContentsOfFile:path];
		toggles = [NSMutableOrderedSet orderedSetWithCapacity:6];
		//add the modules to an mutable set
		for (int i = 0; i < 6; i++) {
			NSString *val = [settings objectForKey:[NSString stringWithFormat:@"connectivityPosition%d", i]];
			if (val != nil) [toggles addObject:val];
		}
		//pass the modules to an loop that generates specifier & adds them to specifier array
		for (NSString *key in toggles) {
				PSSpecifier *specifier = [self generateSpecifier:key];
				if (specifier) [mutableSpecifiers addObject:specifier];
		}

		_specifiers = mutableSpecifiers;
	}

	return _specifiers;
}
//makes editing/reordering cells possible
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
//after each time user reorders/rearranges the cells this func gets called to make sure that the new reordered cells gets saved
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)source  toIndexPath:(NSIndexPath *)destination {

  NSObject *o = toggles[source.row];
	[toggles removeObjectAtIndex:source.row];
	[toggles insertObject:o atIndex:destination.row];

	[self saveSettings];
}
//the save func 
- (void)saveSettings {
	NSString *path = @"/var/jb/var/mobile/Library/Preferences/com.ashad.connectivitymodules.plist";
	NSMutableDictionary *settings = [NSMutableDictionary dictionaryWithContentsOfFile:path];

	for (int i = 0; i < [toggles count]; i++) {
		[settings setObject:toggles[i] forKey:[NSString stringWithFormat:@"connectivityPosition%d", i]];
	}

	[settings writeToFile:path atomically:YES];
}
//generator for specifiers 
- (PSSpecifier*)generateSpecifier:(NSString *)key {
	NSString *displayName = nil;

	if ([key isEqual:@"CCUIConnectivityAirplaneViewController"]) displayName = @"Airplane Mode";
	if ([key isEqual:@"CCUIConnectivityCellularDataViewController"]) displayName = @"Cellular Data";
	if ([key isEqual:@"CCUIConnectivityWifiViewController"]) displayName = @"WiFi";
	if ([key isEqual:@"CCUIConnectivityBluetoothViewController"]) displayName = @"Bluetooth";
	if ([key isEqual:@"CCUIConnectivityAirDropViewController"]) displayName = @"AirDrop";
	if ([key isEqual:@"CCUIConnectivityHotspotViewController"]) displayName = @"Personal Hotspot";

	if (displayName == nil) return nil;

	PSSpecifier* specifier = [PSSpecifier preferenceSpecifierNamed:displayName
									    target:self
									    set:@selector(setPreferenceValue:specifier:)
								   		get:nil
									    detail:nil
									    cell:PSStaticTextCell
									    edit:nil];

	return specifier;
}

@end
