# ImageMosaicTool
This is a fast processing tool to connect multiple small images into one big image. It fixes translations only.

# How to use it
* First you need to add images inside data folder. Remember that all your input images should be PNG images. The program will automatically reads all PNG images inside the folder as inputs.
* Second run MATLAB in the root directory. The script is shown below.

  `program(path/to/data/folder,enableContrastAdjustment,enableGPU,debugMode);`

# Runing time
The first run is expected to take a longer time in GPU mode. Start from the second run, the processing time will be pretty short for normal images.

Those are the runing times for examples in data folder:

`program('data/cell_mosaic_images_1','histmatch');`
Elapsed time is 2.842919 seconds.

`program('data/cell_mosaic_images_2','histmatch');`
Elapsed time is 2.916291 seconds.

`program('data/wallimage');`
Elapsed time is 25.647229 seconds.

`program('data/example');`
Elapsed time is 2.880759 seconds.

`program('data/elevation');`
Elapsed time is 394.857136 seconds.

`program('data/ospTachyon');`
Elapsed time is 4.981369 seconds.

`program('data/ospParticle');`
Elapsed time is 4.905201 seconds.

`program('data/ospParticle_various_size');`
Elapsed time is 11.231870 seconds.

`program('data/universe_milky');`
Elapsed time is 6.812352 seconds.

`program('data/maxresdefault');`
Elapsed time is 8.286695 seconds.
