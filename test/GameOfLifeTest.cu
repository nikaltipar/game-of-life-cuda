#include <gtest/gtest.h>

#include "GameOfLifeDefault.hpp"
#include "GameOfLifeThrust.hpp"
#include <vector>

TEST(GameOfLifeTest, SmallSampleEquality)
{

    GameOfLifeDefault game_of_life_test1(5, 5, 0);
    game_of_life_test1.initialize();
    game_of_life_test1.play(1);
    std::vector<Tile> expected1 {0, 1, 1, 1, 0, 1, 0, 0, 0, 1, 0, 0, 0, 0, 1, 1, 1, 0, 1, 0, 0, 0, 0, 0, 0};
    EXPECT_EQ(game_of_life_test1.get_grid(), expected1);

    GameOfLifeDefault game_of_life_test2(3, 4, 212);
    game_of_life_test2.initialize();
    game_of_life_test2.play(3);
    std::vector<Tile> expected2 {0, 1, 0, 1, 0, 0, 0, 1, 0, 0, 0, 0};
    EXPECT_EQ(game_of_life_test2.get_grid(), expected2);

    GameOfLifeDefault game_of_life_test3(1, 1, 555);
    game_of_life_test3.initialize();
    game_of_life_test3.play(3);
    std::vector<Tile> expected3 {0};
    EXPECT_EQ(game_of_life_test3.get_grid(), expected3);
}

TEST(GameOfLifeTest, StrategyCompatibility)
{
    for (uint32_t seed = 0; seed <= 10; seed++)
    {
        GameOfLifeDefault game_of_life_test_default(50, 50, seed);
        GameOfLifeThrust game_of_life_test_thrust(50, 50, seed);

        game_of_life_test_default.initialize();
        game_of_life_test_default.play(10);

        game_of_life_test_thrust.initialize();
        game_of_life_test_thrust.play(10);

        EXPECT_EQ(game_of_life_test_default, game_of_life_test_thrust);
    }
}