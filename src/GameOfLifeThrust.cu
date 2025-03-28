#include "GameOfLifeThrust.hpp"
#include <algorithm>
#include <random>

#include <thrust/copy.h>
#include <thrust/device_vector.h>
#include <thrust/execution_policy.h>
#include <thrust/iterator/counting_iterator.h>
#include <thrust/iterator/discard_iterator.h>
#include <thrust/iterator/transform_iterator.h>
#include <thrust/iterator/transform_output_iterator.h>
#include <thrust/iterator/zip_iterator.h>
#include <thrust/pair.h>
#include <thrust/reduce.h>

#include <cuda/std/mdspan>
#include <cuda_runtime.h>

__constant__ thrust::pair<int8_t, int8_t> neighbor_offsets[8] = {
    {-1, -1}, {0, -1}, {1, -1}, {-1, 0}, {1, 0}, {-1, 1}, {0, 1}, {1, 1}
};

GameOfLifeThrust::GameOfLifeThrust(uint32_t width, uint32_t height, uint32_t seed)
    : GameOfLife(width, height, seed)
    , grid(width * height)
    , next_grid(width * height)
{
}

void GameOfLifeThrust::print()
{
    for (uint32_t i = 0; i < height; i++)
    {
        for (uint32_t j = 0; j < width; j++)
        {
            std::cout << static_cast<uint32_t>(grid[i * width + j]) << " ";
        }
        std::cout << std::endl;
    }
}

void GameOfLifeThrust::initialize()
{
    std::mt19937 gen(seed);
    std::bernoulli_distribution dist(0.5f);

    for (uint32_t i = 0; i < width * height; i++)
    {
        grid[i] = dist(gen);
    }
}

void GameOfLifeThrust::play(uint32_t steps)
{
    cuda::std::mdspan grid_span(thrust::raw_pointer_cast(grid.data()), height, width);

    const uint32_t width = this->width;
    const uint32_t height = this->height;

    for (uint32_t step = 0; step < steps; step++)
    {
        auto count_iterator = thrust::make_counting_iterator<uint32_t>(0);
        auto cell_neighbour_iter = thrust::make_transform_iterator(count_iterator, [=] __host__ __device__(uint32_t i) {
            uint32_t cell_index = i / 8;
            uint32_t neighbor_index = i % 8;

            uint32_t cell_x = cell_index / width;
            uint32_t cell_y = cell_index % width;

            auto neighbor = neighbor_offsets[neighbor_index];
            int64_t nx = neighbor.first + cell_x;
            int64_t ny = neighbor.second + cell_y;

            return thrust::make_tuple(cell_x, cell_y, nx, ny);
        });

        auto cell_neighbour_values_iter = thrust::make_transform_iterator(
            cell_neighbour_iter,
            [=] __host__ __device__(thrust::tuple<uint32_t, uint32_t, int64_t, int64_t> t) {
                auto [cell_x, cell_y, nx, ny] = t;
                uint32_t i = cell_x * width + cell_y;
                uint32_t neighbor_value = (nx >= 0 && nx < height && ny >= 0 && ny < width) ? grid_span(nx, ny) : 0U;
                return thrust::make_pair(i, neighbor_value);
            }
        );

        auto cell_neighbour_get_cell_index = thrust::make_transform_iterator(
            cell_neighbour_values_iter, [=] __host__ __device__(thrust::pair<uint32_t, uint32_t> t) { return t.first; }
        );

        auto cell_neighbour_get_neigh_value = thrust::make_transform_iterator(
            cell_neighbour_values_iter, [=] __host__ __device__(thrust::pair<uint32_t, uint32_t> t) { return t.second; }
        );

        thrust::reduce_by_key(
            thrust::device,
            cell_neighbour_get_cell_index,
            cell_neighbour_get_cell_index + (width * height * 8),
            cell_neighbour_get_neigh_value,
            thrust::make_discard_iterator(),
            next_grid.begin()
        );

        auto input_sum_zip_iterator = thrust::make_zip_iterator(grid.begin(), next_grid.begin());
        thrust::transform(
            thrust::device,
            input_sum_zip_iterator,
            input_sum_zip_iterator + (width * height),
            next_grid.begin(),
            [=] __host__ __device__(thrust::tuple<Tile, uint8_t> t) {
                auto [val, sum] = t;
                return static_cast<Tile>((sum == 3) || (sum == 2 && val));
            }
        );

        thrust::swap(grid, next_grid);
    }
}

std::vector<Tile> GameOfLifeThrust::get_grid() const
{
    return std::vector<Tile>(grid.begin(), grid.end());
}