add_mlir_library(MLIRAriesPasses
    Passes.cpp
    Utils.cpp
    
    aries/AriesPreprocess.cpp
    aries/AriesTiling.cpp
    aries/AriesFuncUnroll.cpp
    aries/AriesAffineUnroll.cpp
    aries/AriesBroadcastDetect.cpp
    aries/AriesMergeDetect.cpp
    aries/AriesParallelReduction.cpp
    aries/AriesKernelInterfaceCreate.cpp
    aries/AriesLowerDMAToIO.cpp
    aries/AriesDMAToIO.cpp
    aries/AriesIOPacking.cpp
    aries/AriesADFCellCreate.cpp
    aries/AriesCorePlacement.cpp
    aries/AriesIOPlacement.cpp
    aries/AriesPLFuncExtract.cpp
    aries/AriesPLBufferExtract.cpp
    aries/AriesL2BufferCreate.cpp
    aries/AriesPLDMAToAffine.cpp
    aries/AriesAXIPacking.cpp
    aries/AriesPLDataflow.cpp
    aries/AriesBurstDetection.cpp
    aries/AriesFuncEliminate.cpp
    aries/AriesPLDoubleBuffer.cpp
    aries/AriesPLSerialize.cpp
    aries/AriesFileSplit.cpp
    aries/AriesKernelSplit.cpp

    archive/AriesFuncExtract.cpp
    archive/AriesLoopSimplify.cpp
    archive/AriesMemSubview.cpp
    archive/AriesMemHoist.cpp
    archive/AriesMemCopy.cpp
    archive/AriesDependencyExtract.cpp
    archive/AriesLocalDataForward.cpp
    archive/AriesGMIOMaterialize.cpp
    archive/AriesPLIOMaterialize.cpp

    ADDITIONAL_HEADER_DIRS
    ${PROJECT_SOURCE_DIR}/include/aries

    DEPENDS
    MLIRAriesPassesIncGen

    LINK_LIBS PUBLIC
)