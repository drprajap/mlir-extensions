#pragma once

namespace mlir
{
class RewritePatternSet;
class MLIRContext;
}

namespace plier
{
void populate_index_propagate_patterns(mlir::MLIRContext& context, mlir::RewritePatternSet& patterns);
}