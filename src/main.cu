#include "GameOfLifeDefault.hpp"
#include "GameOfLifeThrust.hpp"

#include <CLI/CLI.hpp>

#include <chrono>

enum class Strategy
{
    Default = 0,
    Thrust = 1
};

int main(int argc, char** argv)
{
    CLI::App app("Game of Life Implementation mostly using CUDA.", "Game of Life - CUDA");

    uint32_t width {};
    app.add_option("--width", width, "Table Width")->required();

    uint32_t height {};
    app.add_option("--height", height, "Table Height")->required();

    uint32_t seed {};
    app.add_option("--seed", seed, "Seed")->default_val(0U);

    uint32_t rounds {};
    app.add_option("--rounds", rounds, "Number of iterations")->default_val(1U);

    uint32_t strategy_index {};
    app.add_option("--strategy", strategy_index, "Selected strategy")->default_val(0U);

    CLI11_PARSE(app, argc, argv);

    auto strat = static_cast<Strategy>(strategy_index);

    std::unique_ptr<GameOfLife> game {};
    switch (strat)
    {
    case Strategy::Default:
        game = std::make_unique<GameOfLifeDefault>(width, height, seed);
        break;
    case Strategy::Thrust:
        game = std::make_unique<GameOfLifeThrust>(width, height, seed);
        break;
    default:
        throw std::invalid_argument("Invalid strategy index!");
    }

    game->initialize();
    auto start_time = std::chrono::high_resolution_clock().now();
    game->play(rounds);
    std::cout << std::chrono::duration<float>(std::chrono::high_resolution_clock().now() - start_time).count()
              << std::endl;
    return 0;
}