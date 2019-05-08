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

# Consolidate AOI into a single geometry
AOI.geom <- TSAs[TSAs$TSA_NUMBER_DESCRIPTION %in% AOI ,] %>% 
  split(.$TSA_NUMBER_DESCRIPTION) %>% 
  lapply(st_union) %>% 
  do.call(c, .) %>% 
  st_cast()
AOI.spatial <- st_sf(data.frame(TSA_NUMBER_DESCRIPTION=AOI, geom=AOI.geom))

#GB CE data from geodatabase - available from Provincial CE program - Rob Oostlander
GB_gdb <- list.files(file.path(BearsCEDir), pattern = ".gdb", full.names = TRUE)[1]
gb_list <- st_layers(GB_gdb)

ProvLUs.spatial <- 
  read_sf(GB_gdb, layer = "LU_SUMMARY_poly_v5_20160210")

GBPU.spatial <- read_sf(GB_gdb, layer = "GBPU_BC_edits_v2_20150601")
GBPU<-GBPU.spatial
st_geometry(GBPU) <- NULL

#NatureSerce ranking data
GBRe_Rank <- data.frame(read_excel(path=file.path(RankDir,paste('Threat_Calc.xls',sep=''))))

