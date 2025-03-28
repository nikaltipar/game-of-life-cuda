#pragma once

#include "GameOfLife.hpp"

#include <thrust/device_vector.h>
#include <thrust/host_vector.h>
#include <thrust/universal_vector.h>

class GameOfLifeThrust final : public GameOfLife
{
  public:
    GameOfLifeThrust(uint32_t width, uint32_t height, uint32_t seed);
    ~GameOfLifeThrust() override = default;
    GameOfLifeThrust(const GameOfLifeThrust&) = delete;
    GameOfLifeThrust& operator=(const GameOfLifeThrust&) = delete;
    GameOfLifeThrust(GameOfLifeThrust&&) = delete;
    GameOfLifeThrust& operator=(GameOfLifeThrust&&) = delete;

    void print() override;
    void initialize() override;
    void play(uint32_t steps) override;
    std::vector<Tile> get_grid() const override;

  private:
    thrust::universal_vector<Tile> grid;
    thrust::universal_vector<Tile> next_grid;
};
