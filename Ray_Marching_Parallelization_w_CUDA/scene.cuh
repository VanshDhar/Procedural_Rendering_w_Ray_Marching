//
// Created by Vansh Dhar on 4/18/22.
//

#ifndef RAY_MARCHING_CUDA_SCENE_H
#define RAY_MARCHING_CUDA_SCENE_H

#include <vector>
#include <limits>

#include "common.cuh"
#include "hit_record.cuh"
#include "light.cuh"
#include "surface1.cuh"
#include "sphere.cuh"

class scene {//changed
public:
    __device__ scene() {k=0;t=0;};
    __device__ void add_surface(sphere& s) { surface_list[t++]=&s; }
    __device__ void add_light(light& l) { lights[k++]=l; }

    __device__ double distance_estimator(vec3 p);
    __device__ bool march(const ray& r, hit_record& rec);
    __device__ vec3 normal(const vec3& p);
    __device__ vec3 ray_color(const ray& r);
    __device__ static vec3 background_color(const ray& r);

public:
    sphere* surface_list[20];
    sphere* nearest;
    light lights[20];
    int k;
    int t;
};

#endif //RAY_MARCHING_CUDA_SCENE_H
