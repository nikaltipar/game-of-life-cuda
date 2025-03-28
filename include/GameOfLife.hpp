#pragma once

#include <cstdint>
#include <span>
#include <vector>

using Tile = uint8_t;

class GameOfLife
{
  public:
    GameOfLife(uint32_t width, uint32_t height, uint32_t seed);
    GameOfLife() = delete;
    GameOfLife(const GameOfLife&) = delete;
    GameOfLife& operator=(const GameOfLife&) = delete;
    GameOfLife(GameOfLife&&) = delete;
    GameOfLife& operator=(GameOfLife&&) = delete;

    virtual ~GameOfLife() = default;
    virtual void initialize() = 0;
    virtual void print() = 0;
    virtual void play(uint32_t steps) = 0;
    virtual std::vector<Tile> get_grid() const = 0;

    bool operator==(const GameOfLife& other) const;

  protected:
    uint32_t width;
    uint32_t height;
    uint32_t seed;
};
