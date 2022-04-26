#ifndef VEC3_H
#define VEC3_H

#include <algorithm>
#include <cmath>
#include <iostream>

using std::sqrt;

class vec3 {
public:
    vec3() : e{0,0,0} {};

    vec3(double e0) {
        e[0] = e0;
        e[1] = e0;
        e[2] = e0;
    }

    vec3(double e0, double e1, double e2) {
        e[0] = e0;
        e[1] = e1;
        e[2] = e2;
    }

    vec3& operator=(const vec3 &rhs) {
        if (&rhs != this) {
            std::copy_n(rhs.e, 3, e);
        }
        return *this;
    }

    double x() const { return e[0]; }
    double y() const { return e[1]; }
    double z() const { return e[2]; }

    void x(double d) { e[0] = d; }
    void y(double d) { e[1] = d; }
    void z(double d) { e[2] = d; }

    double r() const { return e[0]; }
    double g() const { return e[1]; }
    double b() const { return e[2]; }

    void r(double d) { e[0] = d; }
    void g(double d) { e[1] = d; }
    void b(double d) { e[2] = d; }

    double operator[](int i) const { return e[i]; }

    double &operator[](int i) { return e[i]; }

    vec3 operator-() const { return {-e[0], -e[1], -e[2]}; }

    vec3 &operator+=(const vec3 &v) {
        e[0] += v.e[0];
        e[1] += v.e[1];
        e[2] += v.e[2];
        return *this;
    }

    vec3 &operator*=(const double t) {
        e[0] *= t;
        e[1] *= t;
        e[2] *= t;
        return *this;
    }

    vec3 &operator/=(const double t) {
        return *this *= 1 / t;
    }

    double length() const {
        return sqrt(length_squared());
    }

    double length_squared() const {
        return e[0] * e[0] + e[1] * e[1] + e[2] * e[2];
    }

    inline static vec3 random() {
        return {random_double(), random_double(), random_double() };
    }

    vec3 abs() const{
        return {std::abs(e[0]), std::abs(e[1]),std:: abs(e[2])};
    }

public:
    double e[3];
};

// vec3 Utility Functions

inline std::ostream &operator<<(std::ostream &out, const vec3 &v) {
    return out << v.e[0] << ' ' << v.e[1] << ' ' << v.e[2];
}

inline vec3 operator+(const vec3 &u, const vec3 &v) {
    return {u.e[0] + v.e[0], u.e[1] + v.e[1], u.e[2] + v.e[2]};
}

inline vec3 operator-(const vec3 &u, const vec3 &v) {
    return {u.e[0] - v.e[0], u.e[1] - v.e[1], u.e[2] - v.e[2]};
}

inline vec3 operator*(const vec3 &u, const vec3 &v) {
    return {u.e[0] * v.e[0], u.e[1] * v.e[1], u.e[2] * v.e[2]};
}

inline vec3 operator*(double t, const vec3 &v) {
    return {t * v.e[0], t * v.e[1], t * v.e[2]};
}

inline vec3 operator*(const vec3 &v, double t) {
    return t * v;
}

inline vec3 operator/(vec3 v, double t) {
    return (1 / t) * v;
}

inline vec3 operator/(double t, vec3 v) {
    return { t / v.x(), t / v.y(), t / v.z() };
}

inline double dot(const vec3 &u, const vec3 &v) {
    return u.e[0] * v.e[0]
           + u.e[1] * v.e[1]
           + u.e[2] * v.e[2];
}

inline vec3 cross(const vec3 &u, const vec3 &v) {
    return {u.e[1] * v.e[2] - u.e[2] * v.e[1],
            u.e[2] * v.e[0] - u.e[0] * v.e[2],
            u.e[0] * v.e[1] - u.e[1] * v.e[0]};
}

inline vec3 normalize(vec3 v) {
    return v / v.length();
}

inline void vclamp(vec3 &v) {
    v.x(clamp(v.x()));
    v.y(clamp(v.y()));
    v.z(clamp(v.z()));
}

inline vec3 vmax(vec3 v, double t){
    return { std::max(v.x(),t),
             std::max(v.y(),t),
             std::max(v.z(),t)};
}

inline vec3 vmin(vec3 v, double t){
    return { std::min(v.x(),t),
             std::min(v.y(),t),
             std::min(v.z(),t)};
}

#endif
