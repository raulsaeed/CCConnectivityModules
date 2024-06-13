#import <Foundation/Foundation.h>
#import "CONRootListController.h"
#import <Cephei/HBRespringController.h>
@implementation CONRootListController

- (NSArray *)specifiers {
	if (!_specifiers) {
		_specifiers = [self loadSpecifiersFromPlistName:@"Root" target:self];
	}
	return _specifiers;
}

- (void)respring {
	[HBRespringController respring];
}

@end

