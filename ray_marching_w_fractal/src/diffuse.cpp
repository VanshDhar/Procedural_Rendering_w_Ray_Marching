#include "diffuse.h"

vec3 flat::color(const ray& r, vec3 p, vec3 N, std::vector<light> lights) const {
    // Flat color
    return albedo;
}

vec3 normals::color(const ray& r, vec3 p, vec3 N, std::vector<light> lights) const {
    // Color as a function of surface normal
    return 0.5*vec3(N.x()+1, N.y()+1, N.z()+1);
}

vec3 diffuse::color(const ray& r, vec3 p, vec3 N, std::vector<light> lights) const {
    // Simple diffuse approximation
    vec3 C;

    vec3 E = -r.direction();
    double NE = dot(N, E);

    for (const light &l : lights) {
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
