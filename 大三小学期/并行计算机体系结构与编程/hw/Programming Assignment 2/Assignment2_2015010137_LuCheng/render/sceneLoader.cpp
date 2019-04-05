
#include <math.h>
#include <stdlib.h>
#include <stdio.h>
#include <vector>
#include <functional>

#include "sceneLoader.h"
#include "util.h"

// randomFloat --
// //
// // return a random floating point value between 0 and 1
static float
randomFloat() {
    return static_cast<float>(rand()) / RAND_MAX;
}

static void
makeCircleGrid(
    int startIndex,
    int circleCount,
    float circleRadius,
    float circleColor[3],
    float startOffsetX,
    float startOffsetY,
    float* position,
    float* color,
    float* radius)
{

    int index = startIndex;
    for (int j=0; j<circleCount; j++) {
        for (int i=0; i<circleCount; i++) {
            int index3 = 3 * index;
            float x = startOffsetX + (2.f * circleRadius * i);
            float y = startOffsetY + (2.f * circleRadius * j);
            position[index3] = x;
            position[index3+1] = y;
            position[index3+2] = randomFloat();
            color[index3] = circleColor[0];
            color[index3+1] = circleColor[1];
            color[index3+2] = circleColor[2];
            radius[index] =  circleRadius;
            index++;
        }
    }
}

static void
generateRandomCircles(
    int numCircles,
    float* position,
    float* velocity,
    float* color,
    float* radius) {

    srand(0);
    std::vector<float> depths(numCircles);
    for (int i=0; i<numCircles; i++) {
        depths[i] = randomFloat();
    }

    std::sort(depths.begin(), depths.end(),  std::greater<float>());

    for (int i=0; i<numCircles; i++) {

        float depth = depths[i];

        radius[i] = .02f + .06f * randomFloat();

        int index3 = 3 * i;

        position[index3] = randomFloat();
        position[index3+1] = randomFloat();
        position[index3+2] = depth;

        if (numCircles <= 10000) {
            color[index3] = .1f + .9f * randomFloat();
            color[index3+1] = .2f + .5f * randomFloat();
            color[index3+2] = .5f + .5f * randomFloat();
        } else {
            color[index3] = .3f + .9f * randomFloat();
            color[index3+1] = .1f + .9f * randomFloat();
            color[index3+2] = .1f + .4f * randomFloat();
        }
    }
}

static void
generateSizeCircles(
    int numCircles,
    float* position,
    float* velocity,
    float* color,
    float* radius,
    float targetR) {

    srand(0);
    std::vector<float> depths(numCircles);
    for (int i=0; i<numCircles; i++) {
        depths[i] = randomFloat();
    }

    std::sort(depths.begin(), depths.end(),  std::greater<float>());

    for (int i=0; i<numCircles; i++) {

        float depth = depths[i];

        radius[i] = targetR;

        int index3 = 3 * i;

        position[index3] = randomFloat(); //targetR + (1.f - targetR) * randomFloat();
        position[index3+1] = randomFloat(); //targetR + (1.f - targetR) * randomFloat();
        position[index3+2] = depth;

        if (numCircles <= 10000) {
            color[index3] = .1f + .9f * randomFloat();
            color[index3+1] = .2f + .5f * randomFloat();
            color[index3+2] = .5f + .5f * randomFloat();
        } else {
            color[index3] = .3f + .9f * randomFloat();
            color[index3+1] = .1f + .9f * randomFloat();
            color[index3+2] = .1f + .4f * randomFloat();
        }
    }
}

static void
changeCircles(
    int numCircles,
    float* position,
    float* radius,
    float targetR,
    float center,
    float div
    ) {

    for (int i=0; i<numCircles; i++) {

        radius[i] = targetR;

        int index3 = 3 * i;

        position[index3] = .9f - center + div * randomFloat();
        position[index3+1] = center + div * randomFloat();
    }
}

void
loadCircleScene(
    SceneName sceneName,
    int& numCircles,
    float*& position,
    float*& velocity,
    float*& color,
    float*& radius)
{

    if (sceneName == SNOWFLAKES) {

        // 100K circles
        //
        // Circles are sorted in reverse depth order (farthest first).
        // This order must be respected by the renderer for correct
        // transparency rendering.

        numCircles = 100 * 1000;

        position = new float[3 * numCircles];
        velocity = new float[3 * numCircles];
        color = new float[3 * numCircles];
        radius = new float[numCircles];

        srand(0);
        std::vector<float> depths(numCircles);

        for (int i=0; i<numCircles; i++) {
            // most of the circles are farther away from the camera
            depths[i] = CLAMP(powf((static_cast<float>(i) / numCircles), .1f) + (-.05f + .1f * randomFloat()), 0.f, 1.f);
        }

        // sort the depths, and then assign depths to particles
        std::sort(depths.begin(), depths.end(), std::greater<float>());

        const static float kMinSnowRadius = .0075f;

        for (int i=0; i<numCircles; i++) {

            float depth = depths[i];

            float closeSize = .08f;
            float actualSize = closeSize - .0075f + (.015f * randomFloat());
            radius[i] = ((1.f - depth) * actualSize) + (depth * actualSize / 15.f);
            if (depth < .02f)
                radius[i] *= 3.f;
            else if (radius[i] < kMinSnowRadius)
                radius[i] = kMinSnowRadius;

            int index3 = 3 * i;
            position[index3] = randomFloat();
            position[index3+1] = 1.f + radius[i] + 2.f * randomFloat();
            position[index3+2] = depth;

            velocity[index3] = 0.f;
            velocity[index3+1] = 0.f;
            velocity[index3+2] = 0.f;
        }

    }else if (sceneName == BOUNCING_BALLS) {
        srand(0);
        numCircles = 10;   
        position = new float[3 * numCircles]; 
        position = new float[3 * numCircles];
        velocity = new float[3 * numCircles];  
        color = new float[3 * numCircles]; 
        radius = new float[numCircles]; 

        for (int i = 0; i < numCircles; i++) { 
            int index3 = 3 * i; 
            radius[i] = .05f; 

            position[index3] = randomFloat(); 
            position[index3+1] = randomFloat();
            position[index3+2] = randomFloat(); 

            color[index3] = 0.f;
            color[index3+1] = 0.f;
            color[index3+2] = 0.f;
            if (i % 3 == 0) color[index3] = 1.f;
            if (i % 3 == 1) color[index3+1] = 1.f; 
            if (i % 3 == 2) color[index3+2] = 1.f; 

            velocity[index3] = 0.f; 
            velocity[index3+1] = randomFloat(); 
            velocity[index3+2] = 0.f;
        }
    } else if (sceneName == HYPNOSIS) {
        srand(0);  
        numCircles = 25; 
        position = new float[3 * numCircles]; 
        color = new float[3 * numCircles]; 
        radius = new float[numCircles];
        velocity = new float[3 * numCircles];
        float width = 0.02f;  

        for (int i = 0; i < numCircles; i++) { 
            int index3 = 3 * i; 
            position[index3] = position[index3+1] = .5f;
            position[index3+2] = .0f;

            // increasing radius
            radius[i] = 0.02f + (i * width);  

            color[index3] = randomFloat(); 
            color[index3+1] = randomFloat();
            color[index3+2] = randomFloat();

            velocity[index3] = 0.0f;
            velocity[index3+1] = 0.0f;
            velocity[index3+2] = 0.0f; 
        }
    } else if (sceneName == FIREWORKS) {
        srand(0); 
        const float pi = 3.14159;  
        numCircles = NUM_FIREWORKS + NUM_FIREWORKS * NUM_SPARKS;

        position = new float[3 * numCircles]; 
        color = new float[3 * numCircles]; 
        radius = new float[numCircles];
        velocity = new float[3 * numCircles];
       
        // choose positions for the fire-works
        for (int i = 0; i < NUM_FIREWORKS; i++) { 
            int index3i = 3 * i; 
            radius[i] = 0.005f; 
            
            // invisible (white)
            color[index3i] = 1.f; 
            color[index3i+1] = 1.f; 
            color[index3i+2] = 1.f;

            // random position
            position[index3i] = randomFloat(); 
            position[index3i+1] = randomFloat(); 
            position[index3i+2] = 0.0f; 

            // choose starting positions for sparks
            for (int j = 0; j < NUM_SPARKS; j++) {
                int sIdx = NUM_FIREWORKS + i * NUM_SPARKS + j;  
                int index3j = 3 * sIdx; 
                radius[sIdx] = 0.01f; 
                // cycle in colors
                color[index3j] = color[index3j+1] = color[index3j+2] = 0.0f; 
                if (i % 3 == 0) color[index3j] = 1.f;  
                if (i % 3 == 1) color[index3j+1] = 1.f;
                if (i % 3 == 2) color[index3j+2] = 1.f; 

                // random starting position on fire-work's rim
                // starting position on fire-work's rim is function of PI/spark index
                float angle = (j * 2 * pi)/NUM_SPARKS;
                
                float sinA = sin(angle); 
                float cosA = cos(angle); 
                float x = cosA * radius[i]; 
                float y = sinA * radius[i]; 

                position[index3j] = position[index3i] + x; 
                position[index3j+1] = position[index3i+1] + y; 
                position[index3j+2] = 0.0f; 

                // travel scaled unit length
                velocity[index3j] = cosA/5.0;  
                velocity[index3j+1] = sinA/5.0; 
                velocity[index3j+2] = 0.0f;
            }
        }
    } else if (sceneName == SNOWFLAKES_SINGLE_FRAME) {
        const char* filename = "snow.par";
        FILE* file = fopen(filename, "r");
        if (!file) {
            fprintf(stderr, "Error: Could not open file: %s\n", filename);
            exit(1);
        }

        fscanf(file, "%d\n", &numCircles);

        position = new float[3 * numCircles];
        velocity = new float[3 * numCircles];
        color = new float[3 * numCircles];
        radius = new float[numCircles];

        for (int i=0; i<numCircles; i++) {
            int index3 = 3 * i;
            fscanf(file, "%f %f %f   %f %f %f   %f\n",
                   &position[index3], &position[index3+1], &position[index3+2],
                   &velocity[index3], &velocity[index3+1], &velocity[index3+2],
                   &radius[i]);
        }
        fclose(file);
        printf("Loaded data for %d circles from %s\n", numCircles, filename);

    } else if (sceneName == CIRCLE_RGB) {

        // simple test scene containing 3 circles. All circles have
        // 50% opacity
        //
        // farthest circle is red.  Middle is green.  Closest is blue.

        numCircles = 3;

        position = new float[3 * numCircles];
        velocity = new float[3 * numCircles];
        color = new float[3 * numCircles];
        radius = new float[numCircles];

        for (int i=0; i<numCircles; i++)
            radius[i] = .3f;

        position[0] = .4f;
        position[1] = .5f;
        position[2] = .75f;
        color[0] = 1.f;
        color[1] = 0.f;
        color[2] = 0.f;

        position[3] = .5f;
        position[4] = .5f;
        position[5] = .5f;
        color[3] = 0.f;
        color[4] = 1.f;
        color[5] = 0.f;

        position[6] = .6f;
        position[7] = .5f;
        position[8] = .25f;
        color[6] = 0.f;
        color[7] = 0.f;
        color[8] = 1.f;

    } else if (sceneName == CIRCLE_RGBY) {

        // Another simple test scene containing 4 circles

        numCircles = 4;

        position = new float[3 * numCircles];
        velocity = new float[3 * numCircles];
        color = new float[3 * numCircles];
        radius = new float[numCircles];

        const float TINY_RADIUS = .1f;
        const float SMALL_RADIUS = .19f;
        const float BIG_RADIUS = .25f;

        radius[0] = SMALL_RADIUS;
        radius[1] = SMALL_RADIUS;
        radius[2] = BIG_RADIUS;
        radius[3] = TINY_RADIUS;

        position[0] = .25f;
        position[1] = .25f;
        position[2] = .75f;
        color[0] = 1.f;
        color[1] = 0.f;
        color[2] = 0.f;

        position[3] = .3f;
        position[4] = .3f;
        position[5] = .5f;
        color[3] = 0.f;
        color[4] = 1.f;
        color[5] = 0.f;

        position[6] = .5f;
        position[7] = .5f;
        position[8] = .25f;
        color[6] = 0.f;
        color[7] = 0.f;
        color[8] = 1.f;

        position[9] = .2f;
        position[10] = .2f;
        position[11] = .9f;
        color[9] = 1.f;
        color[10] = 1.f;
        color[11] = 0.f;

    } else if (sceneName == BIG_LITTLE) {

        const float BIG_RADIUS = .25f;
        const float MICRO_RADIUS = .05f;

        // test scene with many big circles and one tile at the bottom right having many small circles
        numCircles = 10 * 1000;

        position = new float[3 * numCircles];
        velocity = new float[3 * numCircles];
        color = new float[3 * numCircles];
        radius = new float[numCircles];

        generateSizeCircles(numCircles, position, velocity, color, radius, BIG_RADIUS);
        int startIdx = 9 * 1000;
        int changeNum = 1 * 1000;
        changeCircles(changeNum, (position+startIdx * 3), (radius+startIdx), MICRO_RADIUS, .85f, .1f);

    } else if (sceneName == LITTLE_BIG) {
       
        const float BIG_RADIUS = .25f;
        const float MICRO_RADIUS = .05f;

        // test scene with many big circles and one tile at the top left having many big circles
        numCircles = 10 * 1000;

        position = new float[3 * numCircles];
        velocity = new float[3 * numCircles];
        color = new float[3 * numCircles];
        radius = new float[numCircles];

        generateSizeCircles(numCircles, position, velocity, color, radius, BIG_RADIUS);
        int startIdx = 9 * 1000;
        int changeNum = 1 * 1000;
        changeCircles(changeNum, (position+startIdx * 3), (radius+startIdx), MICRO_RADIUS, .05f, .1f);
    
    } else if (sceneName == CIRCLE_TEST_10K) {

        // test scene containing 10K randomily placed circles

        numCircles = 10 * 1000;

        position = new float[3 * numCircles];
        velocity = new float[3 * numCircles];
        color = new float[3 * numCircles];
        radius = new float[numCircles];

        generateRandomCircles(numCircles, position, velocity, color, radius);

    } else if (sceneName == CIRCLE_TEST_100K) {

        // test scene containing 100K randomily placed circles

        numCircles = 100 * 1000;

        position = new float[3 * numCircles];
        velocity = new float[3 * numCircles];
        color = new float[3 * numCircles];
        radius = new float[numCircles];

        generateRandomCircles(numCircles, position, velocity, color, radius);

    } else if (sceneName == PATTERN) {

        int circleCount1 = 16;
        int circleCount2 = 31;
        numCircles = circleCount1 * circleCount1;
        numCircles += circleCount2 * circleCount2;

        position = new float[3 * numCircles];
        velocity = new float[3 * numCircles];
        color = new float[3 * numCircles];
        radius = new float[numCircles];

        int startIndex = 0;
        float circleRadius = .5f * (1.f / circleCount1);
        float startOffsetX = circleRadius;
        float startOffsetY = circleRadius;
        float circleColor[3];

        circleColor[0] = 1.f; circleColor[1] = 0.f; circleColor[2] = 0.f;
        makeCircleGrid(startIndex, circleCount1, circleRadius, circleColor, startOffsetX, startOffsetY, position, color, radius);

        startIndex += circleCount1 * circleCount1;
        startOffsetX = 0.f;
        startOffsetY = 0.f;
        circleColor[0] = 1.f; circleColor[1] = 1.f; circleColor[2] = .0f;
        makeCircleGrid(startIndex, circleCount2, circleRadius, circleColor, startOffsetX, startOffsetY, position, color, radius);
    } else {
        fprintf(stderr, "Error: cann't load scene (unknown scene)\n");
        return;
    }

    printf("Loaded scene with %d circles\n", numCircles);
}
