//
// Created by Vansh Dhar on 4/18/22.
//

#ifndef RAY_MARCHING_CUDA_MATERIAL_H
#define RAY_MARCHING_CUDA_MATERIAL_H


#include <vector>

#include "common.cuh"
#include "light.cuh"
#include "surface1.cuh"

class material {
public:
    /***
     * r - intersecting ray
     * t - point along r of intersection
     * N - surface normal at intersection
     * lights - vector of directional lights
     */
    __device__ material() {};
    __device__ virtual vec3 color(const ray &r, vec3 p, vec3 N, light lights[20]) const = 0;//virtual
};
// Flat shading
class flat : public material {
public:
    __device__ flat(): albedo(vec3::random()) {};
    __device__ explicit flat(const vec3& alb): albedo(alb) {};
    __device__ vec3 flat::color(const ray& r, vec3 p, vec3 N, light lights[20]) const {
    // Flat color
        return albedo;
    }

public:
    vec3 albedo;
};

// Normals visualization
class normals : public material {
public:
    __device__ normals() {};
    __device__ vec3 color(const ray& r, vec3 p, vec3 N, light lights[20]) const {
    // Color as a function of surface normal
        return 0.5*vec3(N.x()+1, N.y()+1, N.z()+1);
    }
};

// Diffuse material
class diffuse : public material{
public:
    __device__ diffuse() :
            Ka(vec3::random()), Kd(vec3::random()), Ks(vec3::random()),
            la({0.2, 0.2, 0.2}), spec(16) {};
    __device__ diffuse(vec3 mat_ka, vec3 mat_kd, vec3 mat_ks, vec3 l_amb, int spower) :
            Ka(mat_ka), Kd(mat_kd), Ks(mat_ks),
            la(l_amb), spec(spower) {};

    __device__ vec3 color(const ray& r, vec3 p, vec3 N, light lights[20]) const {
        // Simple diffuse approximation
        vec3 C;

        vec3 E = -r.direction();
        double NE = dot(N, E);

        for ( int i=0;i<2;i++) {//const light &l : lights,
            const light &l = lights[i];
            double NL = dot(N, l.L);
            if (NL * NE < 0) {
                continue;
            }
            if (NL < 0 && NE < 0) {
                N = -N;
                NL = dot(N, l.L);
                NE = dot(N, E);
            }
            vec3 R = 2*NL*N - l.L;
            double RE = dot(R, E);
            RE = clamp(RE);

            C += Ks*l.le*pow(RE,spec) + Kd*l.le*NL;
        }

        C += Ka*la;
        vclamp(C);

        return C;
    }

public:
    vec3 Ka;
    vec3 Kd;
    vec3 Ks;
    int spec;
    vec3 la;
};


#endif //RAY_MARCHING_CUDA_MATERIAL_H
