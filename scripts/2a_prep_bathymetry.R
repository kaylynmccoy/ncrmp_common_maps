###################################################################
### Prep island bathymetry data using in-house island GIS files ###
###################################################################

rm(list = ls())

library(dplyr)
library(ggplot2)
library(raster)
library(tidyr)
library(marmap)
library(lattice)

# need to connect to pifsc VPN if you are not at IRC

# South Mariana Islands
islands = c(
  "gua",
  # "rot", # in-house bathymetry file cannot represent eastern side of the island. Use Mariana Trench 6 arc-second Bathymetric Digital Elevation Model. Run 2c_prep_bathymetry_by_region.
  "sai", 
  "tin"
  # "agu" # in-house bathymetry file cannot represent the island. Use Mariana Trench 6 arc-second Bathymetric Digital Elevation Model. Run 2c_prep_bathymetry_by_region.
)

# North Mariana Islands
islands = c("agr", "ala", "asc", "gug", "fdp", "mau", "sar", "pag")

# American Samoa
islands = c("ofu", "ros", "swa", "tau", "tut") # none of in-house bahytmetry files worked. Run 2b_prep_bathymetry.R

# Pacific Remote Island Areas
islands = c("bak", "how", "jar", "joh", "kin", "pal", "wak")

# Main Hawaiian Islands
islands = c("haw", "kah", "kal", "kau", "lan", "mai", "mol", "nii", "oah")

# Northern Hawaiian Islands
islands = c("ffs", "kur", "lay", "lis", "mar", "mid", "phr")

for (isl in 1:length(islands)) {
  
  # isl = 2
  
  if (islands[isl] == "gua") topo = raster("N:/GIS/Projects/CommonMaps/Bathymetry/gua_nthmp_dem_10m_mosaic.tif")
  # if (islands[isl] == "rot") topo = raster("N:/GIS/Projects/CommonMaps/Bathymetry/Rota_60m.asc")
  if (islands[isl] == "sai") topo = raster("N:/GIS/Projects/CommonMaps/Bathymetry/sai_mb_li_db.asc")
  if (islands[isl] == "tin") topo = raster("N:/GIS/Projects/CommonMaps/Bathymetry/tinmblidbmos.asc")
  # if (islands[isl] == "agu") topo = raster("FILE_NOT_AVAILAVLE") # file not available
  
  if (islands[isl] == "agr") topo = raster("N:/GIS/Projects/SeafloorCalc/Final_Products/agr_inpoo_new/w001001.adf")
  if (islands[isl] == "ala") topo = raster("N:/GIS/Projects/SeafloorCalc/Workspace/Alamagan/ala_inpo_mbik/w001001.adf")
  if (islands[isl] == "asc") topo = raster("N:/GIS/Projects/SeafloorCalc/Workspace/Asuncion/asc_inpo/w001001.adf")
  if (islands[isl] == "gug") topo = raster("N:/GIS/Projects/SeafloorCalc/Final_Products/gug_inpo/w001001.adf")
  if (islands[isl] == "fdp") topo = raster("N:/GIS/Projects/SeafloorCalc/Final_Products/fdp_inpo/w001001.adf")
  if (islands[isl] == "mau") topo = raster("N:/GIS/Projects/SeafloorCalc/Final_Products/mau_inpo/w001001.adf")
  if (islands[isl] == "sar") topo = raster("N:/GIS/Projects/SeafloorCalc/Final_Products/sar_inpo/w001001.adf")
  if (islands[isl] == "pag") topo = raster("N:/GIS/Projects/SeafloorCalc/Final_Products/pag_inpo/w001001.adf")
  
  # if (islands[isl] == "ofu") topo = raster("N:/GIS/Projects/SeafloorCalc/Final_Products/ofu_inpo/w001001.adf") # decided not to use existing shp file because it was lat lon format and resolution was off. Run 2b script instead.
  # if (islands[isl] == "ros") topo = raster("N:/GIS/Projects/SeafloorCalc/Final_Products/ros_inpo/w001001.adf")# decided not to use existing shp file because it was lat lon format and resolution was off. Run 2b script instead.
  # if (islands[isl] == "swa") topo = raster("L:/ktanaka/GIS/bathymetry/pibhmc_bathy_40m_swains_ce56_bee8_9b67.nc")# decided not to use existing shp file because it was lat lon format and resolution was off. Run 2b script instead.
  # if (islands[isl] == "tau") topo = raster("N:/GIS/Projects/SeafloorCalc/Final_Products/tau_inpo/w001001.adf")# decided not to use existing shp file because it was lat lon format and resolution was off. Run 2b script instead.
  # if (islands[isl] == "tut") topo = raster("L:/ktanaka/GIS/bathymetry/ngdc_bathy_10m_tutuila_1a99_4a20_d29e.nc") # decided not to use existing shp file because it was lat lon format and resolution was off. Run 2b script instead.
  
  if (islands[isl] == "jar") topo = raster("N:/GIS/Projects/SeafloorCalc/Final_Products/jar_inpo_land/w001001.adf") # 
  if (islands[isl] == "joh") topo = raster("N:/GIS/Projects/SeafloorCalc/Final_Products/JOH/joh_inpo/w001001.adf") # 
  if (islands[isl] == "kin") topo = raster("N:/GIS/Projects/SeafloorCalc/Final_Products/kingman3/w001001.adf") # 
  if (islands[isl] == "pal") topo = raster("N:/GIS/Projects/SeafloorCalc/Final_Products/pal_inpo/w001001.adf") # 
  
  # if depth raster files contains no below sea-level cells (e.g. Swa), don't subset them
  if(min(values(topo), na.rm = T) <= 0) {
    
    topo[topo <= -30] <- NA
    topo[topo >= 0] <- NA  
    
  }
  
  if (islands[isl] %in% c("rot", "sai", "tin")) {
    
    topo <- aggregate(topo, fact = 50/res(topo))
    res(topo)
    
  } else {
    
    topo <- aggregate(topo, fact = 100/res(topo))
    res(topo)
    
  }
  
  # topo = as.data.frame(rasterToPoints(topo)) %>% drop_na()
  # colnames(topo) = c("x", "y", "depth")
  # 
  # topo %>%
  #   subset(depth <= 0 & depth >= -6) %>%
  #   ggplot(aes(x, y, fill = depth)) +
  #   geom_raster() +
  #   scale_fill_viridis_c("") +
  #   ggdark::dark_theme_minimal() +
  #   coord_fixed() +
  #   theme(axis.title = element_blank())
  
  topo_i = readAll(topo)
  plot(topo_i)
  print( islands[isl])
  
  save(topo_i, file = paste0('data/gis_bathymetry/', islands[isl], '.RData'))
  
}

load('data/gis_bathymetry/sai.RData')

wireframe(unclass(as.bathy(topo_i)), 
          shade = T,
          aspect = c(dim(topo_i)[1]/dim(topo_i)[2], 0.001),
          par.box = c(col = "transparent"),
          scales = list(arrows = FALSE, col = "transparent"), # col="black" is required
          par.settings = list(axis.line = list(col = 'transparent')),
          light.source = c(10,0,10),
          zlab = "",
          xlab = "",
          ylab = "",
          perspective = T,
          screen = list(z = 10, x = -40, y = 10),
          zoom = 1.1)
