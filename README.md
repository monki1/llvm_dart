## LLVM Dart Bindings

Revived from [samber/llvm_dart_binding](https://github.com/samber/llvm_dart_binding)

- Dart 3 compatible ✅

__For platform specific implementation, check [platforms.dart](./lib/src/platforms.dart)__

### Supported Platforms
  - Tested: Mac 💻
  - __ALL__ platforms are supported with some configuration, including iOS and Android. Theoretically, not tested.
  ### __To run on your specific platform__
  - compiled c file of LLVM
    - .so for Linux and Android
    - .dylib for Mac and iOS (included in /lib/c/)
  - set the file path in [platforms.dart](./lib/src/platforms.dart)
  - extra steps for mobile builds, need to include the c file in Assets

#### - Contributions are Welcome


### Introduction
The Dart LLVM bindings provide a direct interface to the LLVM C-API, enabling Dart developers to construct and manipulate LLVM IR (Intermediate Representation) efficiently. This library is useful for building compilers, static analyzers, or other tools that need to generate or manipulate low-level code.

### Get Started
- clone `git@github.com:monki1/llvm_dart.git
`

```yaml
   dependencies:
     llvm: 
        path: /path/to/llvm_dart/
   ```
   

### Usage

Below are some examples of how to use the Dart LLVM bindings:

#### Creating a Module

```dart
import 'package:llvm/llvm.dart';

void main() {
  final module = Module('my_module');
  print('Created module: ${module.identifier}');
}
```

#### Adding a Function to a Module

```dart
import 'package:llvm/llvm.dart';

void main() {
  final module = Module('my_module');
  final int64 = IntType(64);
  final functionType = FunctionType(int64, [int64, int64]);
  final sumFunction = module.addFunction('sum', functionType);

  print('Added function: ${sumFunction}');
}
```

#### Compiling and Running Code JIT

```dart
import 'package:llvm/llvm.dart';

void main() {
  final module = Module('my_module');
  final int64 = IntType(64);
  final functionType = FunctionType(int64, [int64, int64]);

  final function = module.addFunction('sum', functionType);
  final bb = function.appendBasicBlock('entry');
  final builder = InstructionBuilder()..atEndOf(bb);
  final addResult = builder.add(function.getParam(0), function.getParam(1), 'tmp');
  builder.returnValue(addResult);

  llvm.linkInMcJit();
  final engine = ExecutionEngine.forModule(module);
  final result = engine.run(function, [
    GenericValue.ofInt(int64, 3),
    GenericValue.ofInt(int64, 4),
  ]);

  print('Result from JIT function: ${result.toInt}');

  llvm.dispose();
}
```

### API Overview

This library exposes several classes that correspond to LLVM's core concepts:
- `Context`: Management of the global compilation context.
- `Module`: Container for functions and global variables.
- `FunctionType`, `IntType`: LLVM type representations.
- `Function`, `BasicBlock`, `Value`: Components of functions.
- `MemoryBuffer`: Handling of raw memory for modules.
- `InstructionBuilder`: Tool for constructing instructions within basic blocks.
- `ExecutionEngine`: Execution of compiled code.
- `Allocator`: Memory management for FFI operations.

### Contributing

Contributions to the `llvm` package are welcome. Please read the contributing guide on the GitHub repository for guidelines on pull requests, coding standards, and more.

### License

This library is distributed under the MIT license. Full license text is available in the LICENSE file in the GitHub repository.