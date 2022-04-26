//
// Created by Vansh Dhar on 4/18/22.
//

#ifndef RAY_MARCHING_CUDA_CSGOBJECT_H
#define RAY_MARCHING_CUDA_CSGOBJECT_H

#include <utility>

#include "common.cuh"
#include "surface1.cuh"

using std::max;
using std::min;

class csgObject : public surface1 {
public:
    __device__ csgObject(const shared_ptr<surface1>& obj1, const shared_ptr<surface1>& obj2, int mode, shared_ptr<material> m) : surface1(std::move(m)), object1(obj1), object2(obj2), mode(mode) {};
    
    __device__ double distance(const vec3& p) const override {
        double d1 = object1->distance(p);
        double d2 = object2->distance(p);
        if(mode == UNION){
            return min(d1, d2);
        }
        else if(mode == SUBTRACT){
            return max(-d1, d2);
        }
        else{
            return max(d1, d2);
        }

    };

public:
    const shared_ptr<surface1> object1;
    const shared_ptr<surface1> object2;
    const int mode;
};



#endif //RAY_MARCHING_CUDA_CSGOBJECT_H
