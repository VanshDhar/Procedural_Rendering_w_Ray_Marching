#include <iostream>
#include <fstream>

#include "camera.h"
#include "cloud.h"
#include "common.h"
#include "diffuse.h"
#include "scene.h"
#include "sphere.h"
#include "box.h"
#include "cylinder.h"
#include "triPrism.h"
#include "pyramid.h"
#include "mandelbulb.h"
#include "csgObject.h"

void write_color(std::ostream &out, vec3 pixel_color) {
    // Clamp color to (0.0, 1.0)
    vclamp(pixel_color);

    // Write the translated [0,255] value of each color component.
    out << static_cast<int>(255.999 * pixel_color.x()) << ' '
        << static_cast<int>(255.999 * pixel_color.y()) << ' '
        << static_cast<int>(255.999 * pixel_color.z()) << '\n';
}

scene cloud2d_scene() {
    // 1 perturbed cloud sphere
    scene world;

    world.add_light(light(
            vec3(1,1,1),
            vec3(0.3,0.3,0.3)));
    world.add_light(light(
            vec3(-1,1,1),
            vec3(0.6,0.6,0.6)));

    double s1rad = 2;
    double s2rad = 2;

    auto pn = new PerlinNoise(rand());

    auto c1 = make_shared<gardner_cloud_2d>(&world, 2*s1rad);
    auto c2 = make_shared<perlin_cloud_2d>(&world, 2*s2rad, 2, pn);

    auto s1 = make_shared<sphere>(
            vec3(-2.1,0, -5), s1rad, c1);

    auto s2 = make_shared<sphere>(
            vec3(2.1,0, -5), s2rad, c2);

    world.add_surface(s1);
    world.add_surface(s2);

    return world;
}

scene cloud3d_scene() {
    // 1 perturbed cloud sphere
    scene world;

    world.add_light(light(
            vec3(1,1,1),
            vec3(0.3,0.3,0.3)));
    world.add_light(light(
            vec3(-1,1,1),
            vec3(0.6,0.6,0.6)));

    double s1rad = 2;
    double s2rad = 2;

    auto pn = new PerlinNoise(rand());

    auto c1 = make_shared<gardner_cloud_3d>(&world, 2*s1rad);
    auto c2 = make_shared<perlin_cloud_3d>(&world, 2*s2rad, 2, pn);

    auto s1 = make_shared<sphere>(
            vec3(-2.1,0, -5), s1rad, c1);

    auto s2 = make_shared<sphere>(
            vec3(2.1,0, -5), s2rad, c2);

    world.add_surface(s1);
    world.add_surface(s2);

    return world;
}

scene diffuse_scene() {
    // 3 spheres with flat, normals, and diffuse shading
    scene world;

    world.add_light(light(
            vec3(1,1,1),
            vec3(0.3,0.3,0.3)));
    world.add_light(light(
            vec3(-1,1,1),
            vec3(0.4,0.4,0.4)));

    auto d1 = make_shared<diffuse>(
            vec3(0.3,0.1,0.1),
            vec3(0.9,0.2,0.2),
            vec3(0.4, 0.4, 0.4),
            vec3(0.2,0.2,0.2),
            16);

    auto s1 = make_shared<sphere>(
            vec3(-1.1,0, -2), 0.5, make_shared<flat>());
    auto s2 = make_shared<sphere>(
            vec3(0, 0, -2), 0.5,
            make_shared<normals>());
    auto s3 = make_shared<perturbed_sphere>(
            vec3(1.1, 0, -2), 0.5, 9.0, 0.11, d1);
    auto box1 = make_shared<box>(
            vec3(0, 0, -2), vec3(0.6, 0.6,0.6), make_shared<normals>());
    auto triPrism1 = make_shared<triPrism>(
            vec3(0, 0, -2),0.4,0.80, make_shared<normals>());
    auto cylinder1 = make_shared<cylinder>(
            vec3(0, 0, -2), 0.9, 0.1, make_shared<normals>());
    auto pyramid1 = make_shared<pyramid>(
            vec3(0,0,-2), 0.9,  make_shared<normals>());
    auto mandelbulb1 = make_shared<mandelbulb> (
            vec3(0.0, 0.0, -1.7), make_shared<normals>());
    //auto csg1 = make_shared<csgObject>(
    //        mandelbulb1, box1, SUBTRACT, d1);

    world.add_surface(s1);
    world.add_surface(s3);
    //world.add_surface(box1);
    world.add_surface(mandelbulb1);
    return world;
}

void render_scene(std::ofstream& ofs, camera cam, scene world) {
    // Render the scene and write to ofs
    for (int j = image_height-1; j >= 0; --j) {
        std::cerr << "\rScanlines remaining: " << j << ' ' << std::flush;
        for (int i = 0; i < image_width; ++i) {
            vec3 pixel_color;
            for (int s = 0; s < rays_per_pixel; s++) {
                auto u = (i + random_double()) / (image_width - 1);
                auto v = (j + random_double()) / (image_height - 1);
                ray r = cam.get_ray(u, v);
                pixel_color += world.ray_color(r);
            }
            pixel_color /= rays_per_pixel;
            write_color(ofs, pixel_color);
        }
    }
    std::cerr << "\nDone.\n";
}

void render_scene_parallel(std::ofstream& ofs, camera cam, scene world) {
    render_scene(ofs, cam, std::move(world));
}

int main() {
    // Camera
    camera cam(camera_origin, camera_lookat, camera_up,
               fov, aspect_ratio);

    // Scene
    scene world = diffuse_scene();

    // Render
    std::ofstream ofs("image.ppm");
    ofs << "P3\n" << image_width << ' ' << image_height << "\n255\n";

    RENDER_PARALLEL ? render_scene_parallel(ofs, cam, world)
                    : render_scene(ofs, cam, world);

    ofs.close();

#if defined(_WIN32)
    system("image.ppm");
#elif defined(__APPLE__)
    system("open image.ppm");
#endif

}
