import '../../bindings.dart';
import '../disposable.dart';
import '../llvm.dart';

class Context extends LlvmWrappedObject<LLVMContext> implements Disposable {
  Context.raw(super.handle, [super.llvm]) : super.raw();

  factory Context() {
    final ctx = Context.raw(llvm.bindings.LLVMContextCreate());

    // Add disposable here instead of in .raw() as that might be used to global
    // contexts that we don't need to dispose
    llvm.trackDisposable(ctx);

    return ctx;
  }

  @override
  void dispose() {
    bindings.LLVMContextDispose(handle);
    ownLlvm.untrackDisposable(this);
  }
}
