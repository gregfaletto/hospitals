# merge all zip code data together

rm(list=ls())

## Create initial data table






zip.pops <- read.csv("2010_census_zips.csv")


hospital.pops <- cbind(hospital.zips, rep(0, length(hospitals)))
errors <- 0

for(i in 1:length(hospitals)) {
	if(is.element(hospital.zips[i, 2], zips[, 1])) {
		hospital.pops[i, 3] <- zips[zips$Zip.Code.ZCTA==hospital.zips[i,
		2], ]$X2010.Census.Population[1]
	} else {
		print(paste("Error: Missing zip code", hospital.zips[i,
			2] ,"from database"))
		errors <- errors+1
		print(paste("Total errors so far:", errors))
	}
}




# Match zipcodes with hospitals

print("Matching zip codes...")

hospital.zips <- cbind(hospitals, rep(0, length(hospitals)))

for(i in 1:length(hospitals)) {
	hospital.zips[i, 2] <- health[health$Provider.Id==hospitals[i], ]$Provider.Zip.Code[1]
}

hospital.zips[, 1] <- as.integer((hospital.zips)[, 1])
hospital.zips[, 2] <- as.integer((hospital.zips)[, 2])

print("Zip codes matched!")





health.tidy <- data.frame(cbind(hospital.zips, means))
colnames(health.tidy) <- c("Provider.Id", "Provider.Zip.Code", mean.names)
health.tidy$Provider.Id <- as.integer(health.tidy$Provider.Id)
health.tidy$Provider.Zip.Code <- as.integer(health.tidy$Provider.Zip.Code)



## Incorporate unemployment data

# zip.unemp <- read.csv("07-11_Unemployment_Unsorted.csv")


## Incorporate density data

# zip.density <- read.csv("2010_census_zips-Population-Density-And-Area-Unsorted.csv")


## Incorporate demographic data

# zip.demos <- read.csv("Demographic_Statistics_By_Zip_Code.csv")


## Save as a new .csv file