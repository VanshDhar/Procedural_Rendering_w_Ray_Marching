#ifndef SCENE_H
#define SCENE_H

#include <vector>
#include <limits>

#include "common.h"
#include "hit_record.h"
#include "light.h"
#include "surface.h"

class scene {
public:
    scene() = default;
    void add_surface(const shared_ptr<surface>& s) { surface_list.push_back(s); }
    void add_light(const light& l) { lights.push_back(l); }

    double distance_estimator(vec3 p);
    bool march(const ray& r, hit_record& rec);
    vec3 normal(const vec3& p);
    vec3 ray_color(const ray& r);
    static vec3 background_color(const ray& r);

public:
    std::vector<shared_ptr<surface>> surface_list{};
    shared_ptr<surface> nearest;
    std::vector<light> lights{};
};

#endif //SCENE_H
