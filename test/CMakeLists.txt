configure_lit_site_cfg(
    ${CMAKE_CURRENT_SOURCE_DIR}/lit.site.cfg.py.in
    ${CMAKE_CURRENT_BINARY_DIR}/lit.site.cfg.py
    MAIN_CONFIG
    ${CMAKE_CURRENT_SOURCE_DIR}/lit.cfg.py
)

set (ARIES_TEST_DEPENDS
    FileCheck count not
    aries-opt
    aries-translate
)

add_lit_testsuite(check-aries "Running the Aries regression tests"
    ${CMAKE_CURRENT_BINARY_DIR}
    DEPENDS ${ARIES_TEST_DEPENDS}
)
set_target_properties(check-aries PROPERTIES FOLDER "Tests")

add_lit_testsuites(ARIES
  ${CMAKE_CURRENT_SOURCE_DIR}
  DEPENDS ${ARIES_TEST_DEPENDS}
  )