#ifndef MATERIAL_H
#define MATERIAL_H

#include <vector>

#include "common.h"
#include "light.h"
#include "surface.h"

class material {
public:
    /***
     * r - intersecting ray
     * t - point along r of intersection
     * N - surface normal at intersection
     * lights - vector of directional lights
     */
    virtual vec3 color(const ray &r, vec3 p, vec3 N, std::vector<light> lights) const = 0;
};

#endif //MATERIAL_H
