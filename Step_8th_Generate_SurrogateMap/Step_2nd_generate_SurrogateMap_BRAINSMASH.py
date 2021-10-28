#!/usr/bin/env python
# coding: utf-8

# First, you need to create the environment required by BRAINSMASH, and import it
# Whole-Brain Volume 
from brainsmash.workbench.geo import volume

coord_file = "coordinates.txt"
output_dir = "D:/wd/ISVGeneExpression/Step_8th_generate_SurrogateMap/"

filenames = volume(coord_file, output_dir)

from brainsmash.mapgen.eval import sampled_fit

brain_map = "brain_map.txt"

# These are three of the key parameters affecting the variogram fit
kwargs = {'ns': 302,
          'knn': 120,
          'pv': 70
          }

# Running this command will generate a matplotlib figure
sampled_fit(brain_map, filenames['D'], filenames['index'], nsurr=10, **kwargs)

from brainsmash.mapgen.sampled import Sampled
#gen = Sampled(x=brain_map, D=filenames['D'], index=filenames['index'], **kwargs,resample=False)
gen = Sampled(x=brain_map, D=filenames['D'], index=filenames['index'], **kwargs,resample=True)
surrogate_maps = gen(n=10000)
import numpy
numpy.savetxt("surrogate_brain_maps.csv", surrogate_maps, delimiter=",")