#include <string>
#include <math.h>

#include "circleRenderer.h"
#include "cycleTimer.h"
#include "image.h"
#include "ppm.h"


static void compare_images(const Image* ref_image, const Image* cuda_image) {
    int i;

    int mismatch_count = 0;
    
    if (ref_image->width != cuda_image->width || ref_image->height != cuda_image->height) {
        printf ("Error : width or height of reference and cuda not matching\n");
        printf ("Cuda : width = %d, height = %d\n", cuda_image->width, cuda_image->height);
        printf ("Ref : width = %d, height = %d\n", ref_image->width, ref_image->height);
        exit (1);
    }
    
    for (i = 0 ; i < 4 * ref_image->width * ref_image->height; i++) {
        // Compare with floating point error tolerance of 0.1f and ignore alpha
        if (fabs(ref_image->data[i] - cuda_image->data[i]) > 0.1f && i%4 != 3) {
            mismatch_count++;
            // Get pixel number and print values
            int j = i/4;
            printf ("Mismatch detected at pixel [%d][%d], value = %f, expected %f ", 
                    j/cuda_image->width, j%cuda_image->width, 
                    cuda_image->data[i], ref_image->data[i]);

            printf ("for color ");
            switch (i%4) {
                case 0 : printf ("Red\n"); break;
                case 1 : printf ("Green\n"); break;
                case 2 : printf ("Blue\n"); break;
            }


        }

        // Ignore 5 errors - may come up because of rounding in distance calculation
        if (mismatch_count > 5) {
            printf ("ERROR : Mismatch detected between reference and actual\n");
            exit (1);
        }

    }

    printf ("***************** Correctness check passed **************************\n");
}

void
startBenchmark(
    CircleRenderer* renderer,
    int startFrame,
    int totalFrames,
    const std::string& frameFilename)
{

    double totalClearTime = 0.f;
    double totalAdvanceTime = 0.f;
    double totalRenderTime = 0.f;
    double totalFileSaveTime = 0.f;
    double totalTime = 0.f;
    double startTime= 0.f;

    bool dumpFrames = frameFilename.length() > 0;

    printf("\nRunning benchmark, %d frames, beginning at frame %d ...\n", totalFrames, startFrame);
    if (dumpFrames)
        printf("Dumping frames to %s_xxx.ppm\n", frameFilename.c_str());

    for (int frame=0; frame<startFrame + totalFrames; frame++) {

        if (frame == startFrame)
            startTime = CycleTimer::currentSeconds();

        double startClearTime = CycleTimer::currentSeconds();

        renderer->clearImage();

        double endClearTime = CycleTimer::currentSeconds();

        renderer->advanceAnimation();

        double endAdvanceTime = CycleTimer::currentSeconds();

        renderer->render();

        double endRenderTime = CycleTimer::currentSeconds();

        if (frame >= startFrame) {
            if (dumpFrames) {
                char filename[1024];
                sprintf(filename, "%s_%04d.ppm", frameFilename.c_str(), frame);
                writePPMImage(renderer->getImage(), filename);
                //renderer->dumpParticles("snow.par");
            }

            double endFileSaveTime = CycleTimer::currentSeconds();

            totalClearTime += endClearTime - startClearTime;
            totalAdvanceTime += endAdvanceTime - endClearTime;
            totalRenderTime += endRenderTime - endAdvanceTime;
            totalFileSaveTime += endFileSaveTime - endRenderTime;
        }
    }

    double endTime = CycleTimer::currentSeconds();
    totalTime = endTime - startTime;

    printf("Clear:    %.4f ms\n", 1000.f * totalClearTime / totalFrames);
    printf("Advance:  %.4f ms\n", 1000.f * totalAdvanceTime / totalFrames);
    printf("Render:   %.4f ms\n", 1000.f * totalRenderTime / totalFrames);
    printf("Total:    %.4f ms\n", 1000.f * (totalClearTime + totalAdvanceTime + totalRenderTime) / totalFrames);
    if (dumpFrames)
        printf("File IO:  %.4f ms\n", 1000.f * totalFileSaveTime / totalFrames);
    printf("\n");
    printf("Overall:  %.4f sec (note units are seconds)\n", totalTime);

}


void
CheckBenchmark(
    CircleRenderer* ref_renderer,
    CircleRenderer* cuda_renderer,
    int startFrame,
    int totalFrames,
    const std::string& frameFilename)
{

    double totalClearTime = 0.f;
    double totalAdvanceTime = 0.f;
    double totalRenderTime = 0.f;
    double totalFileSaveTime = 0.f;
    double totalTime = 0.f;
    double startTime= 0.f;

    bool dumpFrames = frameFilename.length() > 0;

    printf("\nRunning benchmark, %d frames, beginning at frame %d ...\n", totalFrames, startFrame);
    if (dumpFrames)
        printf("Dumping frames to %s_xxx.ppm\n", frameFilename.c_str());

    for (int frame=0; frame<startFrame + totalFrames; frame++) {

        if (frame == startFrame)
            startTime = CycleTimer::currentSeconds();

        ref_renderer->clearImage();
        double startClearTime = CycleTimer::currentSeconds();
        cuda_renderer->clearImage();
        double endClearTime = CycleTimer::currentSeconds();

        ref_renderer->advanceAnimation();
        double startAdvanceTime = CycleTimer::currentSeconds();
        cuda_renderer->advanceAnimation();
        double endAdvanceTime = CycleTimer::currentSeconds(); 

        ref_renderer->render();
        double startRenderTime = CycleTimer::currentSeconds();
        cuda_renderer->render();
        double endRenderTime = CycleTimer::currentSeconds();

        if (frame >= startFrame) {
            double startFileSaveTime = CycleTimer::currentSeconds();
            if (dumpFrames) {
                char filename[1024];
                sprintf(filename, "%s_%04d.ppm", frameFilename.c_str(), frame);
                writePPMImage(cuda_renderer->getImage(), filename);
                //renderer->dumpParticles("snow.par");
            }

            double endFileSaveTime = CycleTimer::currentSeconds();

            totalClearTime += endClearTime - startClearTime;
            totalAdvanceTime += endAdvanceTime - startAdvanceTime;
            totalRenderTime += endRenderTime - startRenderTime;
            totalFileSaveTime += endFileSaveTime - startFileSaveTime;
        }
    }


    compare_images(ref_renderer->getImage(), cuda_renderer->getImage());

    double endTime = CycleTimer::currentSeconds();
    totalTime = endTime - startTime; 

    printf("Clear:    %.4f ms\n", 1000.f * totalClearTime / totalFrames);
    printf("Advance:  %.4f ms\n", 1000.f * totalAdvanceTime / totalFrames);
    printf("Render:   %.4f ms\n", 1000.f * totalRenderTime / totalFrames);
    printf("Total:    %.4f ms\n", 1000.f * (totalClearTime + totalAdvanceTime + totalRenderTime) / totalFrames);
    if (dumpFrames)
        printf("File IO:  %.4f ms\n", 1000.f * totalFileSaveTime / totalFrames);
    printf("\n");
    printf("Overall:  %.4f sec (note units are seconds)\n", totalTime);

}
