//
// Created by Vansh Dhar on 4/18/22.
//

#ifndef RAY_MARCHING_CUDA_LIGHT_H
#define RAY_MARCHING_CUDA_LIGHT_H
#ifndef LIGHT_H
#define LIGHT_H

#include <vector>
#include "vec3.cuh"
#include "common.cuh"

struct light {
    vec3 L; // Direction to light
    vec3 le; // Emissive intensity
    __device__ light(){};
    __device__ light(vec3 dir, vec3 emit): L(normalize(dir)), le(emit) {};
};

#endif //LIGHT_H

#endif //RAY_MARCHING_CUDA_LIGHT_H
