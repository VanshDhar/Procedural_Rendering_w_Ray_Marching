//
// Created by Vansh Dhar on 4/18/22.
//

#ifndef RAY_MARCHING_CUDA_SURFACE_H
#define RAY_MARCHING_CUDA_SURFACE_H


#include "common.cuh"
#include "material.cuh"

class material;
class surface1 {//changed
public:
    /***
     * m - surface's material
     * p - point of intersection
     */
    __device__ surface1() {};
    __device__ explicit surface1(material *m): mat_ptr(m) {};
    __device__ virtual double distance(const vec3& p) const = 0;

public:
    material *mat_ptr;
};


#endif //RAY_MARCHING_CUDA_SURFACE_H
