

rm(list=ls())

# library("zipcode")

print("Loading and sorting data...")

health <- read.csv("health_edit.csv")

services <- levels(health$DRG.Definition)

hospitals_factor <- as.factor(health$Provider.Id)
hospitals <- as.integer(levels(hospitals_factor))
# health$Provider.Id <- as.integer(health$Provider.Id)
rm(hospitals_factor)

print("Data loaded and sorted!")


# Match zipcodes with hospitals

print("Matching zip codes...")

hospital.zips <- cbind(hospitals, rep(0, length(hospitals)))

for(i in 1:length(hospitals)) {
	hospital.zips[i, 2] <- health[health$Provider.Id==hospitals[i], ]$Provider.Zip.Code[1]
}

hospital.zips[, 1] <- as.integer((hospital.zips)[, 1])
hospital.zips[, 2] <- as.integer((hospital.zips)[, 2])

print("Zip codes matched!")

# health$DRG.Definition <- as.factor(health$Provider.Id)
# treatments <- as.integer(levels(health$Provider.Id))
# health$Provider.Id <- as.integer(health$Provider.Id)

# health <- read.csv("health_edit.csv")

# hospital.1 <- health[health$Provider.Id == hospitals[1],]

print("Calculating average costs and discharges...")

# Find average cost of each treatment; normalize cost of each 
# treatment, # of discharges to have mean 0, variance 1

for(i in 1:length(services)) {
	health.temp <- health[health$DRG.Definition == services[i], ]
	health.temp[, "Average.Covered.Charges"] <- scale(health.temp[, "Average.Covered.Charges"])
	health.temp[, "Average.Total.Payments"] <- scale(health.temp[, "Average.Total.Payments"])
	health.temp[, "Average.Medicare.Payments"] <- scale(health.temp[, "Average.Medicare.Payments"])
	health.temp[, "Discharges"] <- scale(health.temp[, "Discharges"])
	health[health$DRG.Definition == services[i], ] <- health.temp
	# rm(health.temp)
}

print("Average costs and discharges calculated!")

print("Calculating means for individual hospitals...")

# Create new dataframe: every row is an individual hospital, columns are
# mean of average discharges for all procedures (excluding procedures not done at hospital),
# mean of average total payments for all procedures (excluding
# procedures not done at hospital), mean of average medicare payments for all procedures
# (excluding procedures not done at hospital), mean of average covered charges (same)


mean.names <- c("Discharges", "Average.Covered.Charges", "Average.Total.Payments",
	"Average.Medicare.Payments")
means <- data.frame(matrix(rep(0, length(mean.names)*length(hospitals)),
	ncol=length(mean.names)))
colnames(means) <- mean.names

health.tidy <- data.frame(cbind(hospital.zips, means))
colnames(health.tidy) <- c("Provider.Id", "Provider.Zip.Code", mean.names)
health.tidy$Provider.Id <- as.integer(health.tidy$Provider.Id)
health.tidy$Provider.Zip.Code <- as.integer(health.tidy$Provider.Zip.Code)

for(i in 1:length(hospitals)) {
	health.temp <- health[health$Provider.Id==hospitals[i], ]
	means$Average.Covered.Charges[i] <- mean(health.temp$Average.Covered.Charges)
	means$Average.Total.Payments[i] <- mean(health.temp$Average.Total.Payments)
	means$Average.Medicare.Payments[i] <- mean(health.temp$Average.Medicare.Payments)
	means$Discharges[i] <- mean(health.temp$Discharges)
}

print("Means for individual hospitals calculated!")

# Shorten health$Hospital.Referral.Region.Description to the first two characters so
# I can put them in regions.

print("Sorting regions...")

health$Hospital.Referral.Region.Description <- strtrim(health$Hospital.Referral.Region.Description, 2)

# Create two new variables called "Provider.Region" and "Hospital.Referral.Region". 
# place each hospital and referral in one of 10 regions. Regions are the 10 standard
# Federal Regions established by the US Office of Management and Budget in April '74.'

regions <- list(c("CT", "ME", "MA", "NH", "RI", "VT"), c("NJ", "NY"),
	c("DE", "DC", "MD", "PA", "VA", "WV"), c("AL", "FL", "GA", "KY", "MS", "NC", "SC",
		"TN"), c("IL", "IN", "MI", "MN", "OH", "WI"), c("AR", "LA", "NM", "OK", "TX"),
	c("IA", "KS", "MO", "NE"), c("CO", "MT", "ND", "SD", "UT", "WY"), c("AZ", "CA", "HI",
		"NV"), c("AK", "ID", "OR", "WA"))

provider.regions <- rep(0, length(hospitals))

for(i in 1:length(hospitals)){
	for(j in 1:length(regions)){
		if(is.element(health$Provider.State[i], regions[[j]])) {
			provider.regions[i] <- j
		}
	}
}

provider.regions <- as.factor(provider.regions)

hospital.referral.regions <- rep(0, length(hospitals))

for(i in 1:length(hospitals)){
	for(j in 1:length(regions)){
		if(is.element(health$Hospital.Referral.Region.Description[i],
			regions[[j]])) {
			hospital.referral.regions[i] <- j
		}
	}
}

hospital.referral.regions <- as.factor(hospital.referral.regions)

health.tidy <- data.frame(cbind(hospital.zips, means, provider.regions,
	hospital.referral.regions))
colnames(health.tidy) <- c("Provider.Id", "Provider.Zip.Code", mean.names,
	"Provider.Region", "Hospital.Referral.Region")
health.tidy <- data.frame(cbind(health.tidy, provider.regions,
	hospital.referral.regions))
colnames(health.tidy) <- c("Provider.Id", "Provider.Zip.Code",
	mean.names, "Provider.Region", "Hospital.Referral.Region")
health.tidy$Provider.Id <- as.integer(health.tidy$Provider.Id)
health.tidy$Provider.Zip.Code <- as.integer(health.tidy$Provider.Zip.Code)


print("Regions sorted!")

# Create a new variable called "Provider.Zip.Pop" containing population of provider
# zip code.

# FOR NOW: add functionality to remove rows of 165 zip codes not in database, and
# save these zip codes as a vector, so I can decide what to do later.

print("Adding zip code populations...")

zips <- read.csv("2010_census_zips.csv")

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

rm(zips)

health.tidy <- data.frame(cbind(hospital.pops, means, provider.regions,
	hospital.referral.regions))
colnames(health.tidy) <- c("Provider.Id", "Provider.Zip.Code", "Provider.Zip.Pop",
	mean.names, "Provider.Region", "Hospital.Referral.Region")
health.tidy$Provider.Id <- as.integer(health.tidy$Provider.Id)
health.tidy$Provider.Zip.Code <- as.integer(health.tidy$Provider.Zip.Code)
health.tidy$Provider.Zip.Pop <- as.integer(health.tidy$Provider.Zip.Pop)


print("Populations added!")
