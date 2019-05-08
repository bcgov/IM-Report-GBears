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

# Read in TSA file from BC data catalogue
TSA_file <- file.path("tmp/TSA")
if (!file.exists(TSA_file)) {
  # TSA boundary download gdb and put in GISdir directory from:
  # https://catalogue.data.gov.bc.ca/dataset/fadm-timber-supply-area-tsa
  TSA_gdb <- list.files(file.path(GISdir), pattern = ".gdb", full.names = TRUE)[1] #  FADM_TSA.gdb
  TSA_list <- st_layers(TSA_gdb)
  TSAs <- read_sf(TSA_gdb, layer = "WHSE_ADMIN_BOUNDARIES_FADM_TSA")
  saveRDS(TSAs, file = TSA_file)
} else {    TSAs <- readRDS(file = TSA_file)
    }
  
# Identify TSA and pull out boundary
unique(TSAs$TSA_NUMBER_DESCRIPTION)
AOI<-"Lakes TSA"      #could pull several TSAs  e.g. c("Morice TSA","Lakes TSA") 

#Identify AOI and GBPUs to compare and % overlap
#Load_TSA will return  AOI.spatial with selected TSA(s)
source('01_load_TSA.R')

#see 01_load_TSA for checking which GBPUs to use
GBPU.context<-c('Tweedsmuir','Nation','Francois','Bulkley-Lakes','Blackwater-West Chilcotin','Babine')

Overlap<-0.20

#Indiators selected for summarzing
Indicators<-c('Mort_Flag', 'rdDens_Flag','Core_Flag', 'Front_Country_Flag','LU_hunterDayDens_Flag', 'Q_Food','BEC_midSeral_Conifer_gt30_Flag','Protected_Flag','WHA_Flag')
IndicatorNames<-c('Mortality','RoadDensity','CoreSercurityAreas','FrontCountry','HunterDensity','QaulityFood','MidSeral','HabitatProtection','WHA')
num_indicators<-length(Indicators)
IndicatorList<-c(0,0,0,0,0,0,0,0,0) #set indicator to 0
AOIIndicatorList<-c(0,0,0,0,0,0,0,0,0) #set indicator to 0 for AOI

#Clean data, select indicators set up fields for analysis
source("02_clean.R")

source("03_analysis_Maps.R", print.eval=TRUE)
source("03_analysis_BoxPlots.R")
source("03_analysis_GBPU_Rank.R")

#source("04_output.R")
