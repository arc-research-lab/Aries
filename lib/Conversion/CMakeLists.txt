get_property(conversion_libs GLOBAL PROPERTY MLIR_CONVERSION_LIBS)

add_mlir_library(MLIRAriesConversion
  Passes.cpp
  AriesLowerToADF.cpp
  ADFConvertToAIE.cpp

  ADDITIONAL_HEADER_DIRS
  ${PROJECT_SOURCE_DIR}/include/aries/Conversion
  
  DEPENDS
  MLIRAriesPassesIncGen
  MLIRAriesConversionPassesIncGen

  LINK_LIBS PUBLIC
  ${conversion_libs}
  MLIRADF
  MLIRIR
  MLIRPass
  MLIRTransforms
  MLIRAriesPasses
  )