#ifndef DIFFUSE_H
#define DIFFUSE_H

#include <vector>

#include "common.h"
#include "material.h"

// Flat shading
class flat : public material {
public:
    flat(): albedo(vec3::random()) {};
    explicit flat(const vec3& alb): albedo(alb) {};
    vec3 color(const ray& r, vec3 p, vec3 N, std::vector<light> lights) const override;

public:
    vec3 albedo;
};

// Normals visualization
class normals : public material {
public:
    normals() = default;
    vec3 color(const ray& r, vec3 p, vec3 N, std::vector<light> lights) const override;
};

// Diffuse material
class diffuse : public material{
public:
    diffuse() :
        Ka(vec3::random()), Kd(vec3::random()), Ks(vec3::random()),
        la({0.2, 0.2, 0.2}), spec(16) {};
    diffuse(vec3 mat_ka, vec3 mat_kd, vec3 mat_ks, vec3 l_amb, int spower) :
        Ka(mat_ka), Kd(mat_kd), Ks(mat_ks),
        la(l_amb), spec(spower) {};

    vec3 color(const ray& r, vec3 p, vec3 N, std::vector<light> lights) const override;

public:
    vec3 Ka;
    vec3 Kd;
    vec3 Ks;
    int spec;
    vec3 la;
};

#endif //DIFFUSE_H
