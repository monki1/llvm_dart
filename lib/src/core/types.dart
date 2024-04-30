import 'dart:ffi';

import '../../bindings.dart';
import '../llvm.dart';
import 'context.dart';

abstract class LlvmType extends LlvmWrappedObject<LLVMType> {
  LlvmType.raw(super.handle, [super.llvm]) : super.raw();

  factory LlvmType.of(Pointer<LLVMType> handle, [Llvm? llvm]) {
    throw UnsupportedError('Not yet implemented');
  }

  bool get isSized => ownLlvm.bindings.LLVMTypeIsSized(handle) == 1;

  @override
  String toString() {
    return bindings.LLVMPrintTypeToString(handle).readUtf8();
  }
}

class IntType extends LlvmType {
  IntType.raw(super.handle, [super.llvm]) : super.raw();

  factory IntType(int numBits, [Context? context]) {
    context ??= llvm.globalContext;
    return IntType.raw(
        llvm.bindings.LLVMIntTypeInContext(context.handle, numBits));
  }

  int get bitWidth => bindings.LLVMGetIntTypeWidth(handle);
}

class FunctionType extends LlvmType {
  FunctionType.raw(super.handle, [super.llvm]) : super.raw();

  factory FunctionType(LlvmType returnType, List<LlvmType> parameters,
      {bool isVarArg = false}) {
    final argPtr =
        llvm.allocator.allocate<Pointer<LLVMType>>(count: parameters.length);
    for (var i = 0; i < parameters.length; i++) {
      argPtr[i] = parameters[i].handle;
    }

    final handle = llvm.bindings.LLVMFunctionType(
      returnType.handle,
      argPtr,
      parameters.length,
      isVarArg ? 1 : 0,
    );

    return FunctionType.raw(handle);
  }

  bool get isVarArg => bindings.LLVMIsFunctionVarArg(handle) != 0;

  LlvmType get returnType {
    return LlvmType.of(bindings.LLVMGetReturnType(handle), ownLlvm);
  }

  List<LlvmType> get parameters {
    final numArgs = bindings.LLVMCountParamTypes(handle);
    final tmpOut = allocator.tmpOut.cast<Pointer<LLVMType>>();
    bindings.LLVMGetParamTypes(handle, tmpOut);

    return [for (var i = 0; i < numArgs; i++) LlvmType.of(tmpOut[i])];
  }
}
