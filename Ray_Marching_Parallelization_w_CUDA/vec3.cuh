//
// Created by Vansh Dhar on 4/18/22.
//

#ifndef RAY_MARCHING_CUDA_VEC3_H
#define RAY_MARCHING_CUDA_VEC3_H


#include <algorithm>
#include <cmath>
#include <iostream>

using std::sqrt;

class vec3 {
public:
    __host__ __device__ vec3() : e{0,0,0} {};

    __host__ __device__ vec3(double e0) {
        e[0] = e0;
        e[1] = e0;
        e[2] = e0;
    }

    __host__ __device__ vec3(double e0, double e1, double e2) {
        e[0] = e0;
        e[1] = e1;
        e[2] = e2;
    }

    __host__ __device__ vec3& operator=(const vec3 &rhs) {
        if (&rhs != this) {
            //std::copy_n(rhs.e, 3, e);
            e[0]=rhs.e[0];
            e[1]=rhs.e[1];
            e[2] = rhs.e[2];
        }
        return *this;
    }

    __host__ __device__ double x() const { return e[0]; }
    __host__ __device__ double y() const { return e[1]; }
    __host__ __device__ double z() const { return e[2]; }

    __host__ __device__ void x(double d) { e[0] = d; }
    __host__ __device__ void y(double d) { e[1] = d; }
    __host__ __device__ void z(double d) { e[2] = d; }

    __host__ __device__ double r() const { return e[0]; }
    __host__ __device__ double g() const { return e[1]; }
    __host__ __device__ double b() const { return e[2]; }

    __host__ __device__ void r(double d) { e[0] = d; }
    __host__ __device__ void g(double d) { e[1] = d; }
    __host__ __device__ void b(double d) { e[2] = d; }

    __host__ __device__ double operator[](int i) const { return e[i]; }

    __host__ __device__ double &operator[](int i) { return e[i]; }

    __host__ __device__ vec3 operator-() const { return {-e[0], -e[1], -e[2]}; }

    __host__ __device__ vec3 &operator+=(const vec3 &v) {
        e[0] += v.e[0];
        e[1] += v.e[1];
        e[2] += v.e[2];
        return *this;
    }

    __host__ __device__ vec3 &operator*=(const double t) {
        e[0] *= t;
        e[1] *= t;
        e[2] *= t;
        return *this;
    }

    __host__ __device__ vec3 &operator/=(const double t) {
        return *this *= 1 / t;
    }

    __host__ __device__ double length() const {
        return sqrt(length_squared());
    }

    __host__ __device__ double length_squared() const {
        return e[0] * e[0] + e[1] * e[1] + e[2] * e[2];
    }

    __device__ inline static vec3 random() {
        return {random_double(), random_double(), random_double() };
    }

    __host__ __device__ vec3 abs() const{
        return {std::abs(e[0]), std::abs(e[1]),std:: abs(e[2])};
    }

public:
    double e[3];
};

// vec3 Utility Functions

__host__ __device__ inline std::ostream &operator<<(std::ostream &out, const vec3 &v) {
    return out << v.e[0] << ' ' << v.e[1] << ' ' << v.e[2];
}

__host__ __device__ inline vec3 operator+(const vec3 &u, const vec3 &v) {
    return {u.e[0] + v.e[0], u.e[1] + v.e[1], u.e[2] + v.e[2]};
}

__host__ __device__ inline vec3 operator-(const vec3 &u, const vec3 &v) {
    return {u.e[0] - v.e[0], u.e[1] - v.e[1], u.e[2] - v.e[2]};
}

__host__ __device__ inline vec3 operator*(const vec3 &u, const vec3 &v) {
    return {u.e[0] * v.e[0], u.e[1] * v.e[1], u.e[2] * v.e[2]};
}

__host__ __device__ inline vec3 operator*(double t, const vec3 &v) {
    return {t * v.e[0], t * v.e[1], t * v.e[2]};
}

__host__ __device__ inline vec3 operator*(const vec3 &v, double t) {
    return t * v;
}

__host__ __device__ inline vec3 operator/(vec3 v, double t) {
    return (1 / t) * v;
}

__host__ __device__ inline vec3 operator/(double t, vec3 v) {
    return { t / v.x(), t / v.y(), t / v.z() };
}

__host__ __device__ inline double dot(const vec3 &u, const vec3 &v) {
    return u.e[0] * v.e[0]
           + u.e[1] * v.e[1]
           + u.e[2] * v.e[2];
}

__host__ __device__ inline vec3 cross(const vec3 &u, const vec3 &v) {
    return {u.e[1] * v.e[2] - u.e[2] * v.e[1],
            u.e[2] * v.e[0] - u.e[0] * v.e[2],
            u.e[0] * v.e[1] - u.e[1] * v.e[0]};
}

__host__ __device__ inline vec3 normalize(vec3 v) {
    return v / v.length();
}

__device__ inline void vclamp(vec3 &v) {
    v.x(clamp(v.x()));
    v.y(clamp(v.y()));
    v.z(clamp(v.z()));
}

__device__ inline vec3 vmax(vec3 v, double t){
    return { (v.x()>t)? v.x():t,
             (v.y()>t)? v.y():t,
             (v.z()>t)? v.z():t};
}
__device__ inline vec3 vmin(vec3 v, double t){
    return { (v.x()<t)? v.x():t,
             (v.y()<t)? v.y():t,
             (v.z()<t)? v.z():t};
}


#endif //RAY_MARCHING_CUDA_VEC3_H
