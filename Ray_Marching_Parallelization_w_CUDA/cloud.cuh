//
// Created by Vansh Dhar on 4/18/22.
//

#ifndef RAY_MARCHING_CUDA_CLOUD_H
#define RAY_MARCHING_CUDA_CLOUD_H

#include "material.cuh"
#include "PerlinNoise.cuh"
#include "scene.cuh"

class gardner_cloud_2d : public material {
public:
    __device__ gardner_cloud_2d(scene* world, double depth) : w(world), d(depth) {};
    __device__ vec3 color(const ray& r, vec3 p, vec3 N, std::vector<light> lights) const override;

public:
    scene* w;
    double d;
};

class perlin_cloud_2d : public material {
public:
    __device__ perlin_cloud_2d(scene* world, double depth, double perlin_scale, PerlinNoise* perlin) :
            w(world), d(depth), nscale(perlin_scale), pn(perlin) {};
    __device__ vec3 color(const ray& r, vec3 p, vec3 N, std::vector<light> lights) const override;

public:
    scene* w;
    double d;
    double nscale;
    PerlinNoise* pn;
};

class gardner_cloud_3d : public gardner_cloud_2d {
    using gardner_cloud_2d::gardner_cloud_2d;
    __device__ vec3 color(const ray& r, vec3 p, vec3 N, std::vector<light> lights) const override;
};

class perlin_cloud_3d : public perlin_cloud_2d {
    using perlin_cloud_2d::perlin_cloud_2d;
    __device__ vec3 color(const ray& r, vec3 p, vec3 N, std::vector<light> lights) const override;
};

#endif //RAY_MARCHING_CUDA_CLOUD_H
