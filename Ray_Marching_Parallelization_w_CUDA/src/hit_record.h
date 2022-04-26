#ifndef HIT_RECORD_H
#define HIT_RECORD_H

#include "common.h"
#include "material.h"

// Stores intersection information
struct hit_record {
    vec3 p;
    vec3 N;
    shared_ptr<material> mat_ptr;
};

#endif //HIT_RECORD_H
