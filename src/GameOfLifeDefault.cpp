#include "GameOfLifeDefault.hpp"
#include <algorithm>
#include <iostream>
#include <mdspan>
#include <random>
#include <ranges>

GameOfLifeDefault::GameOfLifeDefault(uint32_t width, uint32_t height, uint32_t seed)
    : GameOfLife(width, height, seed)
    , grid(width * height)
    , next_grid(width * height)
{
}

void GameOfLifeDefault::print()
{
    std::cout << std::endl;
    for (uint32_t i = 0; i < height; i++)
    {
        for (uint32_t j = 0; j < width; j++)
        {
            std::cout << static_cast<uint32_t>(grid[i * width + j]) << " ";
        }
        std::cout << std::endl;
    }
    std::cout << std::endl;
}

void GameOfLifeDefault::initialize()
{
    std::mt19937 gen(seed);
    std::bernoulli_distribution dist(0.5f);

    for (uint32_t i = 0; i < width * height; i++)
    {
        grid[i] = dist(gen);
    }
}

void GameOfLifeDefault::play(uint32_t steps)
{
    for (uint32_t step = 0; step < steps; step++)
    {
        auto grid_span = std::mdspan(grid.data(), height, width);
        auto next_grid_span = std::mdspan(next_grid.data(), height, width);
        for (size_t cell_index = 0; cell_index < width * height; cell_index++)
        {
            auto [i, j] = std::tuple {cell_index / width, cell_index % width};
            uint8_t sum = std::ranges::fold_left(
                neighbor_cells | std::views::transform([&](auto t) {
                    auto [dx, dy] = t;
                    return std::tuple {i + dx, j + dy};
                }) | std::views::filter([&](auto t) {
                    auto [x, y] = t;
                    return x >= 0 && x < height && y >= 0 && y < width;
                }) | std::views::transform([&](auto t) {
                    auto [x, y] = t;
                    return grid_span[x, y];
                }),
                0,
                std::plus {}
            );
            next_grid_span[i, j] = (sum == 3) || (sum == 2 && grid_span[i, j]);
        }
        std::swap(grid, next_grid);
    }
}

std::vector<Tile> GameOfLifeDefault::get_grid() const
{
    return grid;
}
