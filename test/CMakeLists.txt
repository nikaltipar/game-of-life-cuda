add_executable(GameOfLifeTest
    "GameOfLifeTest.cu"
)

set_property(TARGET GameOfLifeTest PROPERTY CUDA_SEPARABLE_COMPILATION ON)
set_property(TARGET GameOfLifeTest PROPERTY CUDA_ARCHITECTURES native)

target_link_libraries(GameOfLifeTest PRIVATE GameOfLifeLib GTest::gtest GTest::gtest_main)
target_compile_options(GameOfLifeTest PRIVATE $<$<COMPILE_LANGUAGE:CUDA>:--extended-lambda>)

add_test(NAME unit_tests COMMAND GameOfLifeTest)