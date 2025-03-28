#include "GameOfLife.hpp"
GameOfLife::GameOfLife(uint32_t width, uint32_t height, uint32_t seed)
    : width {width}
    , height {height}
    , seed {seed}
{
}

bool GameOfLife::operator==(const GameOfLife& other) const
{
    return this->get_grid() == other.get_grid();
}