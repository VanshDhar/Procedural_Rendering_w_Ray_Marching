//
// Created by Vansh Dhar on 4/18/22.
//

#ifndef RAY_MARCHING_CUDA_BOX_H
#define RAY_MARCHING_CUDA_BOX_H

#include <utility>

#include "common.cuh"
#include "surface1.cuh"

using std::max;
using std::min;

class box : public surface1 {
public:
    
    __device__ box(const vec3& cen, const vec3& dim, shared_ptr<material> m) : surface1(std::move(m)), center(cen), dimensions(dim) {};//changed

    __device__ double distance(const vec3& p) const override {
        vec3 q = (p - center).abs() - dimensions;
        return min(max(q.x(), max(q.y(),q.z())), 0.0) + (vmax(q, 0.0)).length();
    };

public:
    vec3 center;
    vec3 dimensions;
};




#endif //RAY_MARCHING_CUDA_BOX_H
