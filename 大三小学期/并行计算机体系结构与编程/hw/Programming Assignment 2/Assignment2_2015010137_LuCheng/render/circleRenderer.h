#ifndef __CIRCLE_RENDERER_H__
#define __CIRCLE_RENDERER_H__

struct Image;

// fireworks constants
#define NUM_FIREWORKS 15
#define NUM_SPARKS 20

typedef enum {
    CIRCLE_RGB,
    CIRCLE_RGBY,
    CIRCLE_TEST_10K,
    CIRCLE_TEST_100K,
    PATTERN,
    SNOWFLAKES,
    FIREWORKS, 
    HYPNOSIS, 
    BOUNCING_BALLS, 
    SNOWFLAKES_SINGLE_FRAME,
    BIG_LITTLE,
    LITTLE_BIG
} SceneName;


class CircleRenderer {

public:

    virtual ~CircleRenderer() { };

    virtual const Image* getImage() = 0;

    virtual void setup() = 0;

    virtual void loadScene(SceneName name) = 0;

    virtual void allocOutputImage(int width, int height) = 0;

    virtual void clearImage() = 0;

    virtual void advanceAnimation() = 0;

    virtual void render() = 0;

    //virtual void dumpParticles(const char* filename) {}

};


#endif
