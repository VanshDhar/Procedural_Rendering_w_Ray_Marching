#include <iostream>
#include <fstream>
#include <time.h>
#include <float.h>
#include <curand_kernel.h>
#include "camera.cuh"
//#include "cloud.cuh"
#include "common.cuh"
//#include "diffuse.cuh"
#include "scene.cuh"
#include "sphere.cuh"
#include "scene.cu"
//#include "cloud.cu"
//#include "diffuse.cu"
//#include "PerlinNoise.cu"

using namespace std;
#define checkCudaErrors(val) CUDA_check_error((val), #val, __FILE__, __LINE__)

void CUDA_check_error(cudaError_t res, char const *const func, const char *const file, int const line) {
    if (res) {
        std::cerr << "CUDA error = " << static_cast<unsigned int>(res) << " at " << file << ":" << line << " : " << func << "\n";
        cudaDeviceReset();
        exit(90);

    }
}

void write_color(std::ostream& out, vec3 pixel_color) {
    // Clamp color to (0.0, 1.0)
    //vclamp(pixel_color);
    //if(pixel_color[0])

    // Write the translated [0,255] value of each color component.
    out << static_cast<int>(255.999 * pixel_color.x()) << ' '
        << static_cast<int>(255.999 * pixel_color.y()) << ' '
        << static_cast<int>(255.999 * pixel_color.z()) << '\n';
}


__global__ void diffuse_scene_full(scene **d_world) {
    // 3 spheres with flat, normals, and diffuse shading
    if(threadIdx.x==0 && blockIdx.x==0){
        (*d_world) = new scene();
        light l = light(
                vec3(1, 1, 1),
                vec3(0.3, 0.3, 0.3));
        light l2 = light(
                vec3(-1, 1, 1),
                vec3(0.4, 0.4, 0.4));
        (**d_world).add_light(l);
        (**d_world).add_light(l2);

        //auto d1 = new diffuse(
        //        vec3(0.3, 0.1, 0.1),
        //        vec3(0.9, 0.2, 0.2),
        //        vec3(0.4, 0.4, 0.4),
        //        vec3(0.2, 0.2, 0.2),
        //        16);

        sphere *s1 = new sphere(
                vec3(-1.1, 0, -2), 0.5, new diffuse());
        sphere *s2 = new sphere(
                vec3(0, 0, -2), 0.5, new diffuse());
        sphere *s3 = new sphere(
                vec3(1.1, 0, -2), 0.5, new diffuse());
        sphere *s4 = new sphere(
                vec3(0, 1.1, -2), 0.5, new diffuse());
        sphere *s5 = new sphere(
                vec3(0, -1.1, -2), 0.5, new diffuse());
        //auto s2 = make_shared<sphere>(
        //       vec3(0, 0, -2), 0.5,
        //        make_shared<normals>());
        //auto s3 = make_shared<perturbed_sphere>(
        //       vec3(1.1, 0, -2), 0.5, 9.0, 0.11, d1);
        //auto box1 = make_shared<box>(
        //        vec3(0, 0, -2), vec3(0.20, 0.20, 0.80), make_shared<normals>());
        //auto csg1 = make_shared<csgObject>(
        //        box1, s2, SUBTRACT, d1);

        //(**d_world).add_surface(*s1);
        (**d_world).add_surface(*s1);
        (**d_world).add_surface(*s2);
        (**d_world).add_surface(*s3);
        (**d_world).add_surface(*s4);
        (**d_world).add_surface(*s5);
        //(**d_world).add_surface(s3);
        //(**d_world).add_surface(csg1);
    }

}

__global__ void diffuse_scene_partial(scene **d_world) {
    // 3 spheres with flat, normals, and diffuse shading
    if(threadIdx.x==0 && blockIdx.x==0){
        (*d_world) = new scene();
        light l = light(
                vec3(1, 1, 1),
                vec3(0.3, 0.3, 0.3));
        light l2 = light(
                vec3(-1, 1, 1),
                vec3(0.4, 0.4, 0.4));
        (**d_world).add_light(l);
        (**d_world).add_light(l2);

        //auto d1 = new diffuse(
        //        vec3(0.3, 0.1, 0.1),
        //        vec3(0.9, 0.2, 0.2),
        //        vec3(0.4, 0.4, 0.4),
        //        vec3(0.2, 0.2, 0.2),
        //        16);

        sphere *s1 = new sphere(
                vec3(0, 0, -2), 0.5, new diffuse());
        //auto s2 = make_shared<sphere>(
        //       vec3(0, 0, -2), 0.5,
        //        make_shared<normals>());
        //auto s3 = make_shared<perturbed_sphere>(
        //       vec3(1.1, 0, -2), 0.5, 9.0, 0.11, d1);
        //auto box1 = make_shared<box>(
        //        vec3(0, 0, -2), vec3(0.20, 0.20, 0.80), make_shared<normals>());
        //auto csg1 = make_shared<csgObject>(
        //        box1, s2, SUBTRACT, d1);

        //(**d_world).add_surface(*s1);
        (**d_world).add_surface(*s1);
        //(**d_world).add_surface(s3);
        //(**d_world).add_surface(csg1);
    }

}

__global__ void render_scene(vec3* fb, int image_x, int image_y,int n_sampling ,camera **d_cam, scene **d_world,curandState *d_rand_state) {
    // Render the scene and write to ofs
    int i = blockIdx.x*blockDim.x + threadIdx.x;
    int j = blockIdx.y*blockDim.y + threadIdx.y;
    if((i>=image_x) || (j>=image_y)) return;
    int pixel_idx = i+ j*image_x;
    curandState local_state = d_rand_state[pixel_idx];
    vec3 pixel_color;
    for (int s = 0; s < n_sampling; s++) {
        float u = float(i + curand_uniform(&local_state)) / float(image_x);
        float v = float(j + curand_uniform(&local_state)) / float(image_y);
        ray r = (**d_cam).get_ray(u, v);
        pixel_color += (**d_world).ray_color(r);
    }
    pixel_color /= n_sampling;
    vclamp(pixel_color);
    fb[pixel_idx] = pixel_color;
    //write_color(ofs, pixel_color);
    //std::cerr << "\nDone.\n";
}

__global__ void camera_init(camera **d_cam){
        if(threadIdx.x==0 && blockIdx.x==0){
                const double fov = 90;
                const double aspect_ratio = 1;
                const vec3 camera_origin(0, 0, 0);
                const vec3 camera_lookat(0, 0, -1);
                const vec3 camera_up(0, 1, 0);
                *d_cam = new camera(camera_origin, camera_lookat, camera_up,fov, aspect_ratio);
        }
}

__global__ void render_init(curandState *d_rand_state, int image_x, int image_y){
        int i = ( blockIdx.x*blockDim.x + threadIdx.x), j = ( blockIdx.y*blockDim.y + threadIdx.y);
        if((i>=image_x) || (j>=image_y)) return;
        int pixel_idx = i+ j*image_x;
        curand_init(580,pixel_idx,0,&d_rand_state[pixel_idx]);
}

__global__ void free_device_memory(camera **d_cam, scene **d_world){
        //delete((**d_world).lights[0]);
        //delete((**d_world).lights[1]);
        delete((**d_world).surface_list[0]);

}

int main() {

    std::ofstream file;
    file.open("output.ppm");
    int image_x = 256, image_y = 256, thread_x = 128, thread_y = 1, n_sampling = 8;
    //int max_num_obj = 20;
    int pixel_size = image_x * image_y;
    size_t fb_size = pixel_size * sizeof(vec3);


    std::cerr << "Rendering a " << image_x << "x" << image_y << " image with " << n_sampling << " samples per pixel ";
    std::cerr << "in " << thread_x << "x" << thread_y << " blocks.\n";

    

    vec3* FrameBuffer;
    checkCudaErrors(cudaMallocManaged((void**)&FrameBuffer, fb_size));

    //cuda random state:
    curandState* d_rand_state; 
    checkCudaErrors(cudaMalloc((void **)&d_rand_state, pixel_size * sizeof(curandState)));


    camera **d_cam;
    scene **d_world;
    checkCudaErrors(cudaMalloc((void **)&d_cam, sizeof(camera *)));
    checkCudaErrors(cudaMalloc((void **)&d_world, sizeof(scene *)));

    camera_init<<<1,1>>>(d_cam);
    checkCudaErrors(cudaGetLastError());
    checkCudaErrors(cudaDeviceSynchronize());
    diffuse_scene_partial<<<1,1>>>(d_world);
    checkCudaErrors(cudaGetLastError());
    checkCudaErrors(cudaDeviceSynchronize());


    clock_t start;
    clock_t end;
    start = clock();
    dim3 threads(thread_x,thread_y);
    dim3 blocks((image_x/thread_x)+1, (image_y/thread_y)+1);
    render_init<<<blocks, threads>>>(d_rand_state, image_x, image_y);
    checkCudaErrors(cudaGetLastError());
    checkCudaErrors(cudaDeviceSynchronize());
    render_scene<<<blocks, threads>>>(FrameBuffer,image_x, image_y, n_sampling,d_cam,d_world,d_rand_state);
    checkCudaErrors(cudaGetLastError());
    checkCudaErrors(cudaDeviceSynchronize());
    end = clock();
    double time_taken = ((double) (end-start)) / CLOCKS_PER_SEC;
    std::cerr << "Time Taken: " << time_taken << " seconds.\n";

    // Camera
    //camera cam(camera_origin, camera_lookat, camera_up,
    //           fov, aspect_ratio);

    // Scene
    //scene world = diffuse_scene();

    // Render
    //std::ofstream ofs("image.ppm");
    //ofs << "P3\n" << image_width << ' ' << image_height << "\n255\n";

    
    //render_scene(file, cam, world);
    //writing image
    file << "P3\n" << image_y << ' ' << image_x << "\n255\n";
    for (int j = image_y - 1; j >= 0; --j) {
        for (int i = 0; i < image_x; ++i) {
            int pixel_idx = j*image_x + i;
            write_color(file, FrameBuffer[pixel_idx]);
        }

    }

    file.close();
    
    //freeing memory
    free_device_memory<<<1,1>>>(d_cam,d_world);
    checkCudaErrors(cudaGetLastError());
    checkCudaErrors(cudaDeviceSynchronize());
    checkCudaErrors(cudaFree(FrameBuffer));
    checkCudaErrors(cudaFree(d_world));
    checkCudaErrors(cudaFree(d_cam));
    checkCudaErrors(cudaFree(d_rand_state));

    cudaDeviceReset();

//#if defined(_WIN32)
//   system("image.ppm");
//#elif defined(__APPLE__)
//    system("open image.ppm");
//#endif

}
