# Copyright 2017 Province of British Columbia
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

source("header.R")

# Consolidate AOI into a single geometry - need to modify this section based on AOI boundary
AOI<-'LBN'
AOI.Name<-"Lake Babine Nation"
AOI.ShpName <- "Lake_Babine"

AOI.spatial<-read_sf(dsn=GISdir, layer=AOI.ShpName)
mapview()
AOI.spatial

#GB CE  data from geodatabase
GB_gdb <- list.files(file.path(BearsCEDir), pattern = ".gdb", full.names = TRUE)[1]
gb_list <- st_layers(GB_gdb)

ProvLUs <- read_sf(GB_gdb, layer = "LU_SUMMARY_poly_v5_20160210")
GBPU <- read_sf(GB_gdb, layer = "GBPU_BC_edits_v2_20150601")

#NatureSerce ranking data
GBRe_Rank <- data.frame(read_excel(path=file.path(RankDir,paste('Threat_Calc.xls',sep=''))))

#Read in LU csv 
#LU_Summ_in <- data.frame(read.csv(header=TRUE, file=paste(GISdir, "GBear_LU_Summary_scores_v5_20160823.csv", sep=""), sep=",", strip.white=TRUE, ))


