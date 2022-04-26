#ifndef LIGHT_H
#define LIGHT_H

#include <vector>

#include "common.h"

struct light {
    vec3 L; // Direction to light
    vec3 le; // Emissive intensity

    light(vec3 dir, vec3 emit): L(normalize(dir)), le(emit) {};
};

#endif //LIGHT_H
