#include "cloud.h"

double fixed_mono_diffuse(double T, const ray& r, vec3 N, std::vector<light> lights) {
    // Single channel diffuse with fixed parameters for cloud texture lighting
    double Ka = 0.2;
    double Kd = 1.0;
    double Ks = 0.4;
    double la = 0.2;
    int spec = 16;

    vec3 E = -r.direction();
    double NE = dot(N, E);

    double color = 0.0;

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

        color += T*(Ks*l.le.x()*pow(RE,spec) + Kd*l.le.x()*NL);
    }

    color += T*Ka*la;
    return color;
}

double gardner_noise(vec3 p) {
    // Visual Simulation of Clouds
    // Geoffrey Y. Gardner
    // https://dl.acm.org/doi/pdf/10.1145/325334.325248
    const int n = 7;

    double X = p.x();
    double Y = p.y();
    double Z = p.z();

    double FX[n];
    double FY[n];
    double C[n];
    double PX[n];
    double PY[n];

    FX[0] = 2;
    FY[0] = 2;
    C[0] = 3;

    double To = 1;

    for (int i = 1; i < n; i++) {
        FX[i] = 2*FX[i-1];
        FY[i] = 2*FX[i-1];
        C[i]  = 0.707*C[i-1];
        PX[i] = pi/2*sin(0.5*FY[i]*Y) + pi*sin(FX[i]*Z/2);
        PY[i] = pi/2*sin(0.5*FX[i]*X) + pi*sin(FX[i]*Z/2);
    }

    double sum1 = 0.0;
    double sum2 = 0.0;

    for (int i = 1; i < n; i++) {
        sum1 += C[i]*sin(FX[i]*X + PX[i] + To);
    }
    for (int i = 0; i < n; i++) {
        sum2 += C[i]*sin(FY[i]*Y + PY[i] + To);
    }

    auto T = (sum1*sum2 + 3) / (10);

    if (T < 0.2) T = 0;
    if (T > 1) T = 1;

    return T;
}

vec3 gardner_cloud_2d::color(const ray& r, vec3 p, vec3 N, std::vector<light> lights) const {
    // Map gardner noise to surface and apply diffuse lighting
    double T = gardner_noise(p);
    T = fixed_mono_diffuse(T, r, N, lights);
    return vec3(T) + (1-T)*scene::background_color(r);
}

vec3 perlin_cloud_2d::color(const ray& r, vec3 p, vec3 N, std::vector<light> lights) const {
    // Map perlin noise to surface and apply diffuse lighting
    p = p*nscale;
    double T = pn->noise(p.x(), p.y(), p.z());
    if (T < 0.5) T = 0;
    else T = fixed_mono_diffuse(T, r, N, lights);
    return vec3(T) + (1-T)*scene::background_color(r);
}

vec3 gardner_cloud_3d::color(const ray& r, vec3 p, vec3 N, std::vector<light> lights) const {
    // Step through surface and return gardner noise above threshold, attenuated
    // by the number of steps taken through the surface
    double step_size = d/1000;
    vec3 at = p + r.direction()*step_size;
    int steps = 1;
    double de = w->distance_estimator(at);

    double noise = gardner_noise(at);

    while (noise < 0.5 && de < 0) {
        at += r.direction()*step_size;
        de = w->distance_estimator(at);
        noise = gardner_noise(at);
        steps++;
    }
    noise *= pow(0.99, steps);
    vec3 color = vec3(noise) + (1-noise)*scene::background_color(r);
    return color;
}

vec3 perlin_cloud_3d::color(const ray& r, vec3 p, vec3 N, std::vector<light> lights) const {
    // Step through surface and return perlin noise above threshold, attenuated
    // by the number of steps taken through the surface
    double step_size = d/1000;
    vec3 at = (p + r.direction()*step_size);
    int steps = 1;
    double de = w->distance_estimator(at);

    double noise = pn->noise(at.x()*nscale, at.y()*nscale, at.z()*nscale);

    while (noise < 0.5 && de < 0) {
        at += r.direction()*step_size;
        de = w->distance_estimator(at);
        noise = pn->noise(at.x()*nscale, at.y()*nscale, at.z()*nscale);
        steps++;
    }
    if (noise < 0.5) noise = 0;
    else noise *= pow(0.99, steps);
    return vec3(noise) + (1-noise)*scene::background_color(r);
}
