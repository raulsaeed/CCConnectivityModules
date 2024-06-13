#import "Tweak.h"
static prefs *sharedInstance = nil;
static NSString *settingsFile = @"/var/jb/var/mobile/Library/Preferences/com.ashad.connectivitymodules.plist";
@implementation prefs
+(id)sharedInstance {
	if (sharedInstance == nil) {
		sharedInstance = [[self alloc] init];
	}

	return sharedInstance;
}

-(id)init {
	self = [super init];
    NSFileManager *fileManager = [NSFileManager defaultManager];
		if (![fileManager fileExistsAtPath:settingsFile]) {
            NSDictionary *data = @{
            @"name": @"John Doe",
            @"age": @30,
            @"occupation": @"Developer"
        };
            id plist = [NSPropertyListSerialization dataWithPropertyList:data format:NSPropertyListXMLFormat_v1_0 options:0 error:nil];
	        [[NSFileManager defaultManager] createFileAtPath:settingsFile contents:plist attributes:nil];
        }
    _settings = [[NSMutableDictionary alloc] initWithContentsOfFile:settingsFile];
    return self;
}

@end
