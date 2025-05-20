
# Game Of Life (CUDA)

A few simple implementations of Conway's Game of Life <sup>[1]</sup>, mostly using CUDA. This repository is in progress and will be augmented/improved soon to add more implementations.

```mermaid
classDiagram
    class GameOfLife {
        <<Abstract>>
        #width : uint32_t
        #height : uint32_t
        #seed : uint32_t
        +print() void*
        +initialize() void*
        +play(uint32_t) void*
        +get_grid() std::vector~Tile~*
    }

    class GameOfLifeDefault {
        -grid : std::vector~Tile~
        -next_grid : std::vector~Tile~
        +print() void
        +initialize() void
        +play(uint32_t) void
        +get_grid() std::vector~Tile~
    }

    class GameOfLifeThrust {
        -grid : thrust::universal_vector~Tile~
        -next_grid : thrust::universal_vector~Tile~
        +print() void
        +initialize() void
        +play(uint32_t) void
        +get_grid() std::vector~Tile~
    }

    GameOfLife <|-- GameOfLifeDefault
    GameOfLife <|-- GameOfLifeThrust
```

The build has only been tested on windows using MSVC, but it shouldn't be that hard to set it up on other platforms, as well.

To build:

* set VCPKG_ROOT=...  # Your VCPKG root here
* cmake --preset configure
* cmake --build --preset build --config Release

To test:
* ctest -C Release --preset test


[1] https://en.wikipedia.org/wiki/Conway's_Game_of_Life

