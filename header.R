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


library(sf)
library(dplyr)
library(plyr)
library(readr)
library(raster)
library(bcmaps)
library(fasterize)
library(tidyr)
library(rio)
library(WriteXLS)
library(readxl)
library(rgdal)
library(RColorBrewer)

#AOI setup 
AOI<-'Lakes'
AOI.Name<-"Lakes TSA"

#Directory setup
fileDir<-"out/"
AOIdir <- paste(fileDir,AOI,'/',sep='')
figsOutDir<-paste(AOIdir,'figures/',sep='')
dataOutDir<-paste(AOIdir,'data/',sep='')
GISdir <- "data/spatial/"
BearsCEDir <- file.path('../GB_Data/data/BearsCE')

dir.create(file.path(fileDir), showWarnings = FALSE)
dir.create(file.path(AOIdir), showWarnings = FALSE)
dir.create(file.path(figsOutDir), showWarnings = FALSE)
dir.create(file.path(dataOutDir), showWarnings = FALSE)
dir.create(file.path(GISdir), showWarnings = FALSE)

