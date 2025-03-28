#pragma once

#include "GameOfLife.hpp"
#include <array>
#include <utility>
#include <vector>

class GameOfLifeDefault final : public GameOfLife
{
  public:
    GameOfLifeDefault(uint32_t width, uint32_t height, uint32_t seed);
    GameOfLifeDefault() = delete;
    ~GameOfLifeDefault() override = default;
    GameOfLifeDefault(const GameOfLifeDefault&) = delete;
    GameOfLifeDefault& operator=(const GameOfLifeDefault&) = delete;
    GameOfLifeDefault(GameOfLifeDefault&&) = delete;
    GameOfLifeDefault& operator=(GameOfLifeDefault&&) = delete;

    void print() override;
    void initialize() override;
    void play(uint32_t steps) override;
    std::vector<Tile> get_grid() const override;

  private:
    std::vector<Tile> grid;
    std::vector<Tile> next_grid;

    const std::array<std::pair<int8_t, int8_t>, 8> neighbor_cells =
        std::to_array<std::pair<int8_t, int8_t>>({{-1, -1}, {0, -1}, {1, -1}, {-1, 0}, {1, 0}, {-1, 1}, {0, 1}, {1, 1}}
        );
};
