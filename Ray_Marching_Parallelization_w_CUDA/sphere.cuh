//
// Created by Vansh Dhar on 4/18/22.
//

#ifndef RAY_MARCHING_CUDA_SPHERE_H
#define RAY_MARCHING_CUDA_SPHERE_H


#include <utility>

#include "common.cuh"
#include "PerlinNoise.cuh"
#include "surface1.cuh"
#include "material.cuh"

class sphere : public surface1 {
public:

    __device__ sphere() {};
    __device__ sphere(const vec3& cen, double r, material *m) ://changed
            surface1(m), center(cen), radius(r) {};

    __device__ double distance(const vec3& p) const override {
        return (p - center).length() - radius;
    };

public:
    vec3 center;
    double radius{};
};
/*
class perturbed_sphere : public sphere {
public:
    __device__ perturbed_sphere(const vec3& cen, double r, double phase,
                                double intensity, shared_ptr<material> m) ://changed
            sphere(cen, r, std::move(m)) {
        ph = phase;
        ints = intensity;
    };

    __device__ double distance(const vec3& p) const override {
        double displacement = sin(ph * p.x())
                              * sin(ph * p.y())
                              * sin(ph * p.z()) * ints;
        return (p - center).length() - radius + displacement;
    };

public:
    double ph;
    double ints;
};

class perlin_sphere : public sphere {
public:
    __device__ perlin_sphere(const vec3& cen, double r, PerlinNoise* perlin, double intensity, shared_ptr<material> m) ://changed
            sphere(cen, r, std::move(m)) {
        ints = intensity;
        pn = perlin;
    };

    __device__ double distance(const vec3& p) const override {
        vec3 v = ints*p;
        double displacement = 0.1*pn->noise(v.x(), v.y(), v.z());
        return (p - center).length() - radius - displacement;
    };

public:
    PerlinNoise* pn;
    double ints;
};
*/

#endif //RAY_MARCHING_CUDA_SPHERE_H
