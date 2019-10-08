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

#Subset out only those LUs with >overlap% of their area in AOI - % set in run_all script
# Code modified from here https://rpubs.com/rural_gis/255550
AOI.int <- as_tibble(st_intersection(AOI.spatial,ProvLUs.spatial))
#add in an area count column to the tibble - 
AOI.int$areaArable <- as.single(st_area(AOI.int$geometry))/1000000
AOI.intcomp<-AOI.int %>%
  mutate(LU=LANDSCAPE_UNIT_PROVID) %>%
  mutate(areaOverlap=round(areaArable,0)) %>%
  mutate(LUArea=round(LU_AREA_KM2,0)) %>%
  mutate(diff=round(areaOverlap/LUArea*100),0) %>%
  mutate(keepLU=diff>Overlap*100) %>%
  dplyr::select(LU,areaOverlap,LUArea,diff,keepLU)

LU_list<-subset(AOI.intcomp, keepLU==TRUE)$LU

#calc some new variables so consistent Pass/Fail 
ProvLUs.spatial <- ProvLUs.spatial %>%
  mutate(AOIOnly = ifelse(LANDSCAPE_UNIT_PROVID %in% LU_list, 1,0)) %>%
  mutate(Mort_Flag = ifelse((Pop_Mort_Flag_Hunt== 'Fail' | Pop_Mort_Flag_NoHunt== 'Fail'), 'Fail', 'Pass'))  %>%
  mutate(rdDens_Flag = ifelse(rdDens_Flag_ge_pt6=='Yes', 'Fail','Pass')) %>%
  mutate(Core_Flag = ifelse(LU_Secure_Core_PCNT <60, 'Fail', 'Pass')) %>%
  mutate(NonCore = 100-LU_Secure_Core_PCNT) %>%
  mutate(Protected_Flag = ifelse(Protected_PCNT <30, 'Fail', 'Pass')) %>%
  mutate(Q_Food = ifelse(Quality_Food_Flag=='Yes', 'Pass','Fail')) %>%
  mutate(WHA_Flag = ifelse(WHA_EBM_Flag=='Yes', 'Pass','Fail'))

#pull out the AOI Lus and strip the geometry off the sf object
AOI_LU.spatial<-ProvLUs.spatial[ProvLUs.spatial$LANDSCAPE_UNIT_PROVID %in% LU_list,]
AOI_LU <- AOI_LU.spatial
st_geometry(AOI_LU) <- NULL

#Subset all LUs in GBPU context area and strip sf geometry and write to file for box plots
GBPU_LU_Context.spatial<-subset(ProvLUs.spatial, MAX_GBPU_POPULATION_NAME %in% GBPU.context)

GBPU_LU_Context<-GBPU_LU_Context.spatial
st_geometry(GBPU_LU_Context) <- NULL
write.table(GBPU_LU_Context, file = file.path(dataOutDir,"AOIContext_LUs.csv"),append = FALSE, quote = TRUE, row.names = FALSE, col.names = TRUE, sep=",")

#Union GBPUs so one polygon for viewing
GBPU.AOI.spatial<-st_union(GBPU_LU_Context.spatial)

#GBPUs use for analysis
GBPUs.used <- subset(GBPU, POPULATION_NAME %in% GBPU.context)
nameGBPU<-data.frame(GBPU_CODE=GBPUs.used$GRIZZLY_BEAR_POP_UNIT_ID, GBPU_NAME=GBPUs.used$POPULATION_NAME)

#Check results to see if appropriate LUs have been select in AOI and in overlapping GBPUs
# mapview(GBPU.spatial)+mapview(GBPU.AOI.spatial)+mapview(GBPU_LU_Context.spatial)+mapview(AOI.spatial)+mapview(AOI_LU.spatial)

#strip out the geometry of the ProvLUs object, subset to AOI and write to file for box plots
ProvLUs <- ProvLUs.spatial
st_geometry(ProvLUs) <- NULL

AOI_LU <- subset(ProvLUs, LANDSCAPE_UNIT_PROVID %in% LU_list)

write.table(AOI_LU, file = file.path(dataOutDir, paste("AOI_LUs.csv",sep="")),
            append = FALSE, quote = TRUE, row.names = FALSE, col.names = TRUE, sep=",")

#####
#Loop through GBPUs, AOI and indicators and output analysis ready data sets

gbpu<-1
num<-length(GBPU.context)+1
for (gbpu in 1:num) {
  #subset the GBPU
  GBSubset <- AOI
  
  GBPU1 <-if(gbpu<num) {
    GBSubset <- GBPU.context[gbpu] 
    subset(GBPU_LU_Context,MAX_GBPU_POPULATION_NAME == GBSubset)
  } else 
    GBPU1 <- AOI_LU
 
  #Calc the area of the GBPU - may change to area that is not rock/ice
  GBPUArea<-GBPUArea<-sum(GBPU1$Shape_Area)/10000
  #Calc the area of the AOI portion of the GBPU
  AOIOnly<-subset(GBPU1, AOIOnly==1 )
  AOIArea<-sum(AOIOnly$Shape_Area)/10000
  #Calc %of GBPU that is TSA
  pcAOIofGBPU<-AOIArea/GBPUArea*100
  
  #loop through each of the flags
  Flagno<-1
  for (Flagno in 1:num_indicators){
    
    FlagInd<-paste('GBPU1$',Indicators[Flagno],sep='')
    #round(sum(GBPU1$Mort_Flag=='Fail')/noLU*100)c
    noGBPULU<-nrow(GBPU1)
    IndicatorList[Flagno]<-round(sum(eval(parse(text = FlagInd))=='Fail')/noGBPULU*100)
    
    #do another items for AOI portion
    FlagInd<-paste('GBPU1$',Indicators[Flagno],sep='')
    noAOILU<-nrow(GBPU1)
    AOIIndicatorList[Flagno]<-round(sum(eval(parse(text = FlagInd))=='Fail')/noAOILU*100)
    
  }
  
  #Create new data frame containing the summary numbers for AOI portion and GBPU
  GBPU2<-data.frame(GBSubset,round(GBPUArea),noGBPULU,round(AOIArea),round(pcAOIofGBPU),IndicatorList[1],AOIIndicatorList[1], IndicatorList[2],AOIIndicatorList[2],IndicatorList[3],AOIIndicatorList[3],IndicatorList[4],AOIIndicatorList[4],IndicatorList[5],AOIIndicatorList[5],IndicatorList[6],AOIIndicatorList[6],IndicatorList[7],AOIIndicatorList[7],IndicatorList[8],AOIIndicatorList[8],IndicatorList[9],AOIIndicatorList[9])
  colnames(GBPU2)<-c('GBPU','GBPUArea','noLU','TSAArea','pcTSAofGBPU','Mortality','TSAMortality','RoadDensity','TSARoadDensity','CoreSercurityAreas','TSACoreSercurityAreas','FrontCountry','TSAFrontCountry','HunterDensity','TSAHunterDensity','QaulityFood','TSAQaulityFood','MidSeral','TSAMidSeral','HabitatProtection','TSAHabitatProtection','WHA','TSAWHA')
  
  #GBPU2<-data.frame(GBSubset,round(GBPUArea),round(AOIArea),round(pcAOIofGBPU),IndicatorList[1],AOIIndicatorList[1], IndicatorList[2],AOIIndicatorList[2],IndicatorList[3],AOIIndicatorList[3],IndicatorList[4],AOIIndicatorList[4],IndicatorList[5],AOIIndicatorList[5],IndicatorList[6],AOIIndicatorList[6],IndicatorList[7],AOIIndicatorList[7],IndicatorList[8],AOIIndicatorList[8],IndicatorList[9],AOIIndicatorList[9])
  #colnames(GBPU2)<-c('GBPU','GBPUArea','TSAArea','pcTSAofGBPU','Mortality','TSAMortality','RoadDensity','TSARoadDensity','CoreSercurityAreas','TSACoreSercurityAreas','FrontCountry','TSAFrontCountry','HunterDensity','TSAHunterDensity','QaulityFood','TSAQaulityFood','MidSeral','TSAMidSeral','HabitatProtection','TSAHabitatProtection','WHA','TSAWHA')
  
  #Create new data frame containing the summary numbers for GBPUs only
  GBPU3<-data.frame(GBSubset,round(GBPUArea),noGBPULU,IndicatorList[1], IndicatorList[2],IndicatorList[3],IndicatorList[4],IndicatorList[5],IndicatorList[6],IndicatorList[7],IndicatorList[8],IndicatorList[9])
  colnames(GBPU3)<-c('GBPU','GBPUArea','noLU','Mortality','RoadDensity','CoreSercurityAreas','FrontCountry','HunterDensity','QaulityFood','MidSeral','HabitatProtection','WHA')
  
  ifelse(gbpu == 1, appendcolvar<-FALSE, appendcolvar<-TRUE)
  write.table((GBPU3), file = (file.path(dataOutDir,"GBPUOut.csv")),append = appendcolvar, quote = FALSE, row.names = FALSE, col.names = !appendcolvar, sep=",")#sep="\t") ifelse(gbpu == 1, appendcolvar<-FALSE, appendcolvar<-TRUE)
  
  ifelse(gbpu == 1, appendcolvar<-FALSE, appendcolvar<-TRUE)
  write.table((GBPU2), file = (file.path(dataOutDir ,"GBPUTSAOut.csv")),append = appendcolvar, quote = FALSE, row.names = FALSE, col.names = !appendcolvar, sep=",")#sep="\t")
  
  #Create a data frame for each data set (GBPU) and write out individually
  write.table((GBPU1), file = file.path(dataOutDir, paste(GBSubset, ".csv", sep='')),append = FALSE, quote = TRUE, row.names = FALSE, col.names = TRUE, sep=",")
  
}  

