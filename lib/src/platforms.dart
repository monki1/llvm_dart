import 'dart:io';

String getPathOfLLVMFileOfPlatform() {
  String path;
  switch (Platform.operatingSystem) {
    case 'macos':
      path = '${Directory.current.path}/lib/c/libLLVM.dylib';
      break;
    case 'linux':
      throw UnimplementedError('Linux platform is not supported yet');
    case 'windows':
      throw UnimplementedError('Windows platform is not supported yet');
    case 'ios':
      throw UnimplementedError('iOS platform is not supported yet');
    case 'android':
      throw UnimplementedError('Android platform is not supported yet');
    default:
      throw UnsupportedError('Unsupported platform');
  }
  return path;
}
