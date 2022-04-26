//
// Created by Vansh Dhar on 4/18/22.
//

#ifndef RAY_MARCHING_CUDA_RAY_H
#define RAY_MARCHING_CUDA_RAY_H


#include "vec3.cuh"

class ray {
public:
    __device__ ray() {};
    __device__ ray(const vec3& origin, const vec3& direction)
            : orig(origin), dir(normalize(direction))
    {};

    __device__ vec3 origin() const  { return orig; }
    __device__ vec3 direction() const { return dir; }

    __device__ vec3 at(double t) const {
        return orig + t*dir;
    }

public:
    vec3 orig;
    vec3 dir;
};



#endif //RAY_MARCHING_CUDA_RAY_H
