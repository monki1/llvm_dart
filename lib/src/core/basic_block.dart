// import 'dart:ffi';

import '../../bindings.dart';
import '../llvm.dart';

class BasicBlock extends LlvmWrappedObject<LLVMBasicBlock> {
  BasicBlock.raw(super.handle, [super.llvm]) : super.raw();

  void delete() {
    bindings.LLVMDeleteBasicBlock(handle);
  }
}
