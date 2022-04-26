#include "scene.h"

bool near_zero(double d) {
    // Check if a double is close to 0
    return std::abs(d) < std::numeric_limits<double>::epsilon();
}

double scene::distance_estimator(vec3 p) {
    // Approximate distance between point and nearest surface
    double mindist = INT_MAX;
    nearest = surface_list.front();
    for (const shared_ptr<surface>& s : surface_list) {
        double d = s->distance(p);
        if (d < mindist) {
            mindist = d;
            nearest = s;
        }
    }
    return mindist;
}

bool scene::march(const ray& r, hit_record& rec) {
    // March along a ray by the distance to the nearest surface
    double t = 0;
    while(t < MAXDEPTH) {
        vec3 p = r.at(t);
        double dist = distance_estimator(p);
        if (near_zero(dist) || dist < 0) {
            rec.p = p;
            rec.N = normal(p);
            rec.mat_ptr = nearest->mat_ptr;
            return true;
        }
        dist = dist < 0.001 ? 0.001 : dist;
        t += dist;
    }
    return false;
}

vec3 scene::normal(const vec3 &p) {
    const vec3 stepx(0.001, 0.0, 0.0);
    const vec3 stepy(0.0, 0.001, 0.0);
    const vec3 stepz(0.0, 0.0, 0.001);

    double gradx = distance_estimator(p + stepx) - distance_estimator(p - stepx);
    double grady = distance_estimator(p + stepy) - distance_estimator(p - stepy);
    double gradz = distance_estimator(p + stepz) - distance_estimator(p - stepz);

    vec3 normal(gradx, grady, gradz);
    return normalize(normal);
}

vec3 scene::ray_color(const ray& r) {
    // Return the color of a surface at the ray intersection if it hits,
    // otherwise return the color of the background
    hit_record rec;
    if (march(r, rec))
        return rec.mat_ptr->color(r, rec.p, rec.N, lights);
    return background_color(r);
}

vec3 scene::background_color(const ray &r) {
    auto t = 0.5*(r.direction().y() + 1.0);
    return (1.0-t)*vec3(1.0, 1.0, 1.0) + t*vec3(0.5, 0.7, 1.0);
}
