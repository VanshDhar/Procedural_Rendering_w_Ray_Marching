//
// Created by Vansh Dhar on 4/18/22.
//

#include <vector>

#ifndef RAY_MARCHING_CUDA_PERLINNOISE_H
#define RAY_MARCHING_CUDA_PERLINNOISE_H


/**
 * https://github.com/sol-prog/Perlin_Noise/blob/master/PerlinNoise.h
 */


class PerlinNoise {
    // The permutation vector
    std::vector<int> p;
public:
    // Initialize with the reference values for the permutation vector
    __device__ PerlinNoise();
    // Generate a new permutation vector based on the value of seed
    __device__ explicit PerlinNoise(unsigned int seed);
    // Get a noise value, for 2D images z can have any value
    __device__ double noise(double x, double y, double z);
private:
    __device__ double fade(double t);
    __device__ double lerp(double t, double a, double b);
    __device__ double grad(int hash, double x, double y, double z);
};


#endif //RAY_MARCHING_CUDA_PERLINNOISE_H
