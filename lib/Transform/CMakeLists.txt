add_mlir_library(MLIRAriesPasses
    AriesTiling.cpp
    AriesFuncExtract.cpp
    AriesLoopSimplify.cpp
    AriesMemSubview.cpp
    AriesMemHoist.cpp
    AriesMemCopy.cpp
    AriesDependencyExtract.cpp
    AriesFuncUnroll.cpp
    AriesLocalDataForward.cpp
    AriesL2BufferCreate.cpp
    AriesKernelInterfaceCreate.cpp
    AriesBroadcastDetect.cpp
    AriesDMAToIO.cpp
    AriesADFCellCreate.cpp
    AriesCorePlacement.cpp
    AriesIOPlacement.cpp
    AriesGMIOMaterialize.cpp
    AriesPLIOMaterialize.cpp
    AriesAXIPacking.cpp
    AriesPLDataflow.cpp
    AriesBurstDetection.cpp
    AriesFuncEliminate.cpp
    AriesPLDoubleBuffer.cpp
    AriesFileSplit.cpp
    AriesKernelSplit.cpp
    Passes.cpp
    Utils.cpp

    aries/AriesPreprocess.cpp
    aries/AriesAffineUnroll.cpp
    aries/AriesParallelReduction.cpp
    aries/AriesLowerDMAToIO.cpp
    aries/AriesPLFuncExtract.cpp
    aries/AriesPLBufferExtract.cpp
    aries/AriesPLDMAToAffine.cpp
    aries/AriesIOPacking.cpp
    aries/AriesPLSerialize.cpp

    ADDITIONAL_HEADER_DIRS
    ${PROJECT_SOURCE_DIR}/include/aries

    DEPENDS
    MLIRAriesPassesIncGen

    LINK_LIBS PUBLIC
)