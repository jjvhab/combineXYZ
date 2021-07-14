# combineXYZ v1.0.1 by V.Haburaj
#
# Merge multiple XYZ files from  a given folder.
#
# folderString = character; folder containing multiple XYZ files
# crsString = character; coordinate reference system to be used, 
#              see PROJ.4 documentation; (example: "+init=epsg:25833")


combineXYZ <- function(folderString, crsString, save=TRUE, filename='merge.tif') {
  
  # ------------------------
  # Load Packages ----------
  # ------------------------
  
  if (!require("raster")) {
    message('package raster not found!')
  } else library(raster)
  
  # ------------------------
  # Process data -----------
  # ------------------------
  
  # list XYZ files in folder:
  fileList <- list.files(path=folderString, pattern = '.xyz', full.names = T)
  
  # create first raster from XYZ:
  df <- read.table(fileList[[1]])
  df_rast <- raster::rasterFromXYZ(df)
  
  # set CRS:
  crs(df_rast) <- CRS(crsString)
  
  # status report:
  message(paste('Finished raster', 1, 'of', length(fileList), sep=' '))
  
  # merge all raster files:
  for (i in 2:length(fileList)) {
    
    # create raster:
    tmp_df <- read.table(fileList[[i]])
    tmp_rast <- raster::rasterFromXYZ(tmp_df)
    
    # set CRS:
    crs(tmp_rast) <- CRS(crsString)
    
    # merge with df_rast:
    df_rast <- raster::merge(df_rast, tmp_rast)
    
    # status report:
    message(paste('Finished raster', i, 'of', length(fileList), sep=' '))
    
  }
  
  # ------------------------
  # Export data   ----------
  # ------------------------
  
  if (save==TRUE) {
    
    writeRaster(df_rast, filename = filename, overwrite=T)
    
  }
  
}

# citation('raster')
# Robert J. Hijmans (2019). raster: Geographic Data Analysis and
# Modeling. R package version 2.9-23.
# https://CRAN.R-project.org/package=raster









