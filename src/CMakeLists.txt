add_library(GameOfLifeLib
    "GameOfLife.cpp"
    "GameOfLifeDefault.cpp"
    "GameOfLifeThrust.cu"
)

add_executable(GameOfLife
    "main.cu"
)

set_property(TARGET GameOfLifeLib PROPERTY CUDA_SEPARABLE_COMPILATION ON)
set_property(TARGET GameOfLife PROPERTY CUDA_SEPARABLE_COMPILATION ON)

set_property(TARGET GameOfLifeLib PROPERTY CUDA_ARCHITECTURES native)
set_property(TARGET GameOfLife PROPERTY CUDA_ARCHITECTURES native)

target_link_libraries(GameOfLife PRIVATE GameOfLifeLib CLI11::CLI11)

target_compile_options(GameOfLifeLib PRIVATE $<$<COMPILE_LANGUAGE:CUDA>:--extended-lambda>)
target_compile_options(GameOfLife PRIVATE $<$<COMPILE_LANGUAGE:CUDA>:--extended-lambda>)