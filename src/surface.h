#ifndef HITTABLE_H
#define HITTABLE_H

#include "common.h"
#include "material.h"

class material;

class surface {
public:
    /***
     * m - surface's material
     * p - point of intersection
     */
    explicit surface(shared_ptr<material> m): mat_ptr(std::move(m)) {}
    virtual double distance(const vec3& p) const = 0;

public:
    shared_ptr<material> mat_ptr;
};

#endif
