//
// Created by Vansh Dhar on 4/18/22.
//

#ifndef RAY_MARCHING_CUDA_DIFFUSE_H
#define RAY_MARCHING_CUDA_DIFFUSE_H

#include <vector>

#include "common.cuh"
#include "material.cuh"

// Flat shading
/*
class flat : public material {
public:
    __device__ flat(): albedo(vec3::random()) {};
    __device__ explicit flat(const vec3& alb): albedo(alb) {};
    __device__ vec3 color(const ray& r, vec3 p, vec3 N, light lights[20]) const override;

public:
    vec3 albedo;
};

// Normals visualization
class normals : public material {
public:
    __device__ normals() = default;
    __device__ vec3 color(const ray& r, vec3 p, vec3 N, light lights[20]) const override;
};

// Diffuse material
class diffuse : public material{
public:
    __device__ diffuse() :
            Ka(vec3::random()), Kd(vec3::random()), Ks(vec3::random()),
            la({0.2, 0.2, 0.2}), spec(16) {};
    __device__ diffuse(vec3 mat_ka, vec3 mat_kd, vec3 mat_ks, vec3 l_amb, int spower) :
            Ka(mat_ka), Kd(mat_kd), Ks(mat_ks),
            la(l_amb), spec(spower) {};

    __device__ vec3 color(const ray& r, vec3 p, vec3 N, light lights[20]) const override;

public:
    vec3 Ka;
    vec3 Kd;
    vec3 Ks;
    int spec;
    vec3 la;
};
*/
#endif //RAY_MARCHING_CUDA_DIFFUSE_H
