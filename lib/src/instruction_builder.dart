import 'dart:ffi';

import '../llvm.dart';
import '../bindings.dart';

class InstructionBuilder extends LlvmWrappedObject<LLVMBuilder>
    implements Disposable {
  InstructionBuilder.raw(super.handle, [super.llvm]) : super.raw() {
    ownLlvm.trackDisposable(this);
  }

  factory InstructionBuilder([Context? context]) {
    final ctxHandle = (context ?? llvm.globalContext).handle;
    return InstructionBuilder.raw(
        llvm.bindings.LLVMCreateBuilderInContext(ctxHandle));
  }

  void at(BasicBlock block, Value instr) {
    bindings.LLVMPositionBuilder(
        handle, block.handle, instr.handle as Pointer<LLVMValue>);
  }

  /// Positions this builder before an instruction.
  void before(Value instr) {
    bindings.LLVMPositionBuilderBefore(
        handle, instr.handle as Pointer<LLVMValue>);
  }

  /// Positions this builder at the end of a [BasicBlock].
  void atEndOf(BasicBlock block) {
    bindings.LLVMPositionBuilderAtEnd(handle, block.handle);
  }

  /// Removes the position applied to this builder.
  void clearPosition() {
    bindings.LLVMClearInsertionPosition(handle);
  }

  /// Creates a return instruction that returns nothing.
  Value returnVoid() {
    return Value.raw(bindings.LLVMBuildRetVoid(handle));
  }

  /// Creates a return instruction returning the [value].
  Value returnValue(Value value) {
    return Value.raw(
        bindings.LLVMBuildRet(handle, value.handle as Pointer<LLVMValue>));
  }

  Value _binary(
    Value lhs,
    Value rhs,
    String name,
    Pointer<LLVMValue> Function(
      Pointer<LLVMBuilder>,
      Pointer<LLVMValue>,
      Pointer<LLVMValue>,
      Pointer<char>,
    ) ffiFunction,
  ) {
    final namePtr = allocator.allocateUtf8(name);
    final result = ffiFunction(handle, lhs.handle as Pointer<LLVMValue>,
        rhs.handle as Pointer<LLVMValue>, namePtr);
    allocator.free(namePtr);

    return Value.raw(result, ownLlvm);
  }

  /// Creates an add instruction
  Value add(Value lhs, Value rhs, String name) {
    return _binary(lhs, rhs, name, bindings.LLVMBuildAdd);
  }

  /// Creates an subtraction instruction
  Value sub(Value lhs, Value rhs, String name) {
    return _binary(lhs, rhs, name, bindings.LLVMBuildSub);
  }

  @override
  void dispose() {
    bindings.LLVMDisposeBuilder(handle);
    ownLlvm.untrackDisposable(this);
  }
}
