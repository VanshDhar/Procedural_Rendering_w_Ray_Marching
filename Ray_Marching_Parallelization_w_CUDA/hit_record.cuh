//
// Created by Vansh Dhar on 4/18/22.
//

#ifndef RAY_MARCHING_CUDA_HIT_RECORD_H
#define RAY_MARCHING_CUDA_HIT_RECORD_H

#include "common.cuh"
#include "material.cuh"

// Stores intersection information
struct hit_record {
    vec3 p;
    vec3 N;
    material *mat_ptr;
};

#endif //RAY_MARCHING_CUDA_HIT_RECORD_H
