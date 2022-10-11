// RUN: imex-opt --convert-gpux-to-llvm %s | FileCheck %s

module attributes {gpu.container_module} {
  // CHECK-LABEL: llvm.func @main
  // CHECK-SAME: %[[size:.*]]: i64
  func.func @main(%size : index) {
    // CHECK: %[[stream:.*]] = llvm.call @GpuStreamCreate()
    %0 = gpu.wait async
    // CHECK: %[[gep:.*]] = llvm.getelementptr {{.*}}[%[[size]]]
    // CHECK: %[[size_bytes:.*]] = llvm.ptrtoint %[[gep]]
    // CHECK: llvm.call @GpuAlloc(%[[size_bytes]], %[[stream]])
    %1, %2 = gpu.alloc async [%0] (%size) : memref<?xf32>
    // CHECK: %[[float_ptr:.*]] = llvm.extractvalue {{.*}}[0]
    // CHECK: %[[void_ptr:.*]] = llvm.bitcast %[[float_ptr]]
    // CHECK: llvm.call @GpuDeAlloc(%[[void_ptr]], %[[stream]])
    %3 = gpu.dealloc async [%2] %1 : memref<?xf32>
    //  llvm.call @gpuStreamSynchronize(%[[stream]])
    //  CHECK: llvm.call @GpuStreamDestroy(%[[stream]])
    gpu.wait [%3]
    return
  }
}
