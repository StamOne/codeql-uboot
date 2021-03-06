import cpp 
import semmle.code.cpp.dataflow.TaintTracking
import DataFlow::PathGraph

class NetworkByteSwap extends Expr{
    NetworkByteSwap() {
        exists ( MacroInvocation m |
            m.getMacro().getName().regexpMatch("ntoh.*") and this=m.getExpr())
    }

}

class Config extends TaintTracking::Configuration {
    Config (){ this = "NetworkToMemFuncLength"}
    override predicate isSource(DataFlow::Node source) {
        exists(NetworkByteSwap n | 
            source.asExpr() = n)
      }
      override predicate isSink(DataFlow::Node sink) {
        exists(FunctionCall f | 
            f.getTarget().getName().regexpMatch("memcpy") and f.getArgument(2) = sink.asExpr())
      }
} 

from Config cfg, DataFlow::PathNode source, DataFlow::PathNode sink
where cfg.hasFlowPath(source, sink)
select sink, source, sink, "Network byte swap flows to memcpy"