# Copyright 2018 Province of British Columbia
# 
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# 
# http://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and limitations under the License.

library(dplyr)
library(plyr)
library(readr)
#library(raster)
library(bcmaps)
#library(fasterize)
library(tidyr)
#library(rio)
#library(WriteXLS)
library(readxl)
#library(rgdal)
library(RColorBrewer)
library(mapview)
library(ggplot2)
library(GISTools)
library(sf)
library(ggspatial)

options(sf_max.plot=1)
options(scipen=999) #dont show scientific notation unless of a certain size

#Directory setup
OutDir <- 'out'
DataDir <- 'data'
dataOutDir <- file.path(OutDir,'data')
spatialOutDir <- file.path(OutDir,'spatial')
figsOutDir <- file.path(OutDir,'figures')
GISdir <- "data/spatial"
BearsCEDir <- file.path('../GB_Data/data/BearsCE')
RankDir <- file.path('../grizzly-bear-IUCN-threats/out/data')

dir.create(file.path(OutDir), showWarnings = FALSE)
dir.create(file.path(DataDir), showWarnings = FALSE)
dir.create(file.path(dataOutDir), showWarnings = FALSE)
dir.create(file.path(figsOutDir), showWarnings = FALSE)
dir.create(file.path(spatialOutDir), showWarnings = FALSE)
dir.create(file.path(GISdir), showWarnings = FALSE)
dir.create(file.path('tmp'), showWarnings = FALSE)

