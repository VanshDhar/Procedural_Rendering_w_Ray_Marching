
#ifndef CYLINDER_H
#define CYLINDER_H

#include <utility>

#include "common.h"
#include "surface.h"

using std::max;
using std::min;

class cylinder : public surface {
public:
    cylinder(const vec3& cen, const float& he, const float& rad, shared_ptr<material> m) : surface(std::move(m)), center(cen), height(he), radius(rad) {};

    double distance(const vec3& p) const override {
        //vec2 xzVec = {p.x()-center.x(), p.z()-center.z()};
        float xzVecX = p.x()-center.x();
        float xzVecY = p.y()-center.y();
        float xzVecZ = p.z()-center.z();
        float xzVecLength = vec3 (xzVecX, xzVecZ,0).length();

        //vec2 d = vec2(xzVec.length(), p.y()-center.y()).abs() - vec2(radius, height);
        double dX = std::abs(xzVecLength) - radius;
        double dY = std::abs( xzVecY) - height;
        vec3 newD = {std::max(dX, 0.0), std::max(dY, 0.0), 0.0};
        return std::min(std::max(dX, dY), 0.0) + newD.length();
    };

public:
    vec3 center;
    float height;
    float radius;
};



#endif

