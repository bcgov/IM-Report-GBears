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

#Bear_Load <- function(AOI, AOI.Name, AOI.ShpName, GBPU.context, Overlap) {
  
#Directory setup 
fileDir<-"out/"
AOIdir <- paste(fileDir,AOI,'/',sep='')
dir.create(file.path(AOIdir), showWarnings = FALSE)
figsOutDir<-paste(AOIdir,'figures/',sep='')
dataOutDir<-paste(AOIdir,'data/',sep='')
dir.create(file.path(figsOutDir), showWarnings = FALSE)
dir.create(file.path(dataOutDir), showWarnings = FALSE)
GISdir <- "data/GISData/"
#setwd(AOIdir)

#Read in shape files and refine for AOI
ProvLUs<-readOGR(dsn=GISdir, layer="LU_SUMMARY_poly_v5_20160210")
AOIShp<-readOGR(dsn=GISdir, layer=AOI.ShpName)
MapGBPU<-subset(ProvLUs, MAX_GBPU_P %in% GBPU.context)
GBPU<-readOGR(dsn=GISdir, layer='GBPU')
AOI_GBPUContext <- gUnaryUnion(MapGBPU, id = NULL)

#Read in LU csv 
LU_Summ_in <- data.frame(read.csv(header=TRUE, file=paste(GISdir, "GBear_LU_Summary_scores_v5_20160823.csv", sep=""), sep=",", strip.white=TRUE, ))
#Read in Ranking data - may need to generate and place in GISdir
GBRe_Rank <- read.csv(paste(GISdir, "GBPU_",AOI,"_Rank.csv",sep=""), stringsAsFactors = FALSE)

#}

