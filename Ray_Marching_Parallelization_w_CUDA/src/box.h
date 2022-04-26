#ifndef BOX_H
#define BOX_H

#include <utility>

#include "common.h"
#include "surface.h"

using std::max;
using std::min;

class box : public surface {
public:
    box(const vec3& cen, const vec3& dim, shared_ptr<material> m) : surface(std::move(m)), center(cen), dimensions(dim) {};

    double distance(const vec3& p) const override {
        vec3 q = (p - center).abs() - dimensions;
        return min(max(q.x(), max(q.y(),q.z())), 0.0) + (vmax(q, 0.0)).length();
    };

public:
    vec3 center;
    vec3 dimensions;
};



#endif
