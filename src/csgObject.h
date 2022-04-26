#ifndef CSG_H
#define CSG_H

#include <utility>

#include "common.h"
#include "surface.h"

using std::max;
using std::min;

class csgObject : public surface {
public:
    csgObject(const shared_ptr<surface>& obj1, const shared_ptr<surface>& obj2, int mode, shared_ptr<material> m) : surface(std::move(m)), object1(obj1), object2(obj2), mode(mode) {};

    double distance(const vec3& p) const override {
        double d1 = object1->distance(p);
        double d2 = object2->distance(p);
        if(mode == UNION){
            return min(d1, d2);
        }
        else if(mode == SUBTRACT){
            return max(-d1, d2);
        }
        else{
            return max(d1, d2);
        }

    };

public:
    const shared_ptr<surface> object1;
    const shared_ptr<surface> object2;
    const int mode;
};



#endif
