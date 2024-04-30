import 'dart:ffi';

import '../llvm.dart';
import '../../bindings.dart';
import 'basic_block.dart';
import 'context.dart';

class Value extends LlvmWrappedObject {
  Value.raw(Pointer<LLVMValue> super.handle, [super.llvm]) : super.raw();
}

// ignore_for_file: invalid_use_of_protected_member
extension InterpretAsFunction on Value {
  /// Creates and appends a new [BasicBlock] to the end of the function.
  ///
  /// This should only be called on values that are functions.
  BasicBlock appendBasicBlock(String name, [Context? context]) {
    context ??= ownLlvm.globalContext;
    final namePtr = allocator.allocateUtf8(name);
    final bb = bindings.LLVMAppendBasicBlockInContext(
        context.handle, handle as Pointer<LLVMValue>, namePtr);

    allocator.free(namePtr);
    return BasicBlock.raw(bb, ownLlvm);
  }

  /// Loads a value referring to a parameter of this function.
  ///
  /// This should only be called on values that are functions.
  Value getParam(int index) {
    return Value.raw(
        bindings.LLVMGetParam(handle as Pointer<LLVMValue>, index));
  }
}
