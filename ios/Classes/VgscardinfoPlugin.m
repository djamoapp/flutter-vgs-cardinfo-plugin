#import "VgscardinfoPlugin.h"
#if __has_include(<vgscardinfo/vgscardinfo-Swift.h>)
#import <vgscardinfo/vgscardinfo-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "vgscardinfo-Swift.h"
#endif

@implementation VgscardinfoPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftVgscardinfoPlugin registerWithRegistrar:registrar];
}
@end
