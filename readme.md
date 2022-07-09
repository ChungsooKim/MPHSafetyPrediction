**MPHSafetyPrediction** 
========================================================

<img src="https://img.shields.io/badge/Study%20Status-Design%20Finalized-brightgreen.svg" alt="Study Status: Design Finalized">

- Analytics use case(s): **Patient-level Prediction**
- Study type: **Clinical Application**
- Tags: **OHDSI**  

- Study lead: **Dong Yun Lee**, **Chungsoo Kim**, **Yunmi Shin**, **Rae Woong Park**
- Study lead forums tag: **[[Dong Yun Lee]](https://forums.ohdsi.org/u/dy_lee)**, **[[Chungsoo_Kim]](https://forums.ohdsi.org/u/Chungsoo_Kim)**,  **[[RWPark]](https://forums.ohdsi.org/u/rwpark)**
- Study start date: **July 1, 2022**
- Study end date: **-**
- Protocol: **[[Protocol]](https://github.com/ABMI/MphSafetyPrediction/inst/doc/LargeScaleAdePrediction_v1_release.pdf)**
- Publications: **-**
- Results explorer: **-**

Description: A Package for develop models for predicting ADEs in methylphenidate users.

Suggested Requirements
===================
- R studio (https://rstudio.com)
- Java runtime environment
- Python


Instructions To Build Package
===================

- Open the package project (file ending with '.Rproj') by double clicking it
- Install any missing dependancies for the package by running:
```r
source('./extras/packageDeps.R')
```
- Build the package by clicking the R studio 'Install and Restart' button in the build tab (top right)



Instructions To Run Package
===================
- Execute the study by running the code in (extras/CodeToRun.R) :
```r
library(MphSafetyPrediction)

#=======================
# USER INPUTS
#=======================
# The folder where the study intermediate and result files will be written:

outputFolder <- "./MphSafetyPredictionResults"

# Details for connecting to the server:
dbms <- "you dbms"
user <- 'your username'
pw <- 'your password'
server <- 'your server'
port <- 'your port'

connectionDetails <- DatabaseConnector::createConnectionDetails(dbms = dbms,
                                                                server = server,
                                                                user = user,
                                                                password = pw,
                                                                port = port)

# Add the database containing the OMOP CDM data
cdmDatabaseSchema <- 'cdm database schema'
# Add a sharebale name for the database containing the OMOP CDM data
cdmDatabaseName <- 'a friendly shareable  name for your database'
# Add a database with read/write access as this is where the cohorts will be generated
cohortDatabaseSchema <- 'work database schema'

oracleTempSchema <- NULL

# table name where the cohorts will be generated
cohortTable <- 'MphSafetyPredictionCohort'

# here we specify the databaseDetails using the 
# variables specified above
databaseDetails <- PatientLevelPrediction::createDatabaseDetails(
        connectionDetails = connectionDetails, 
        cdmDatabaseSchema = cdmDatabaseSchema, 
        cdmDatabaseName = cdmDatabaseName, 
        tempEmulationSchema = tempEmulationSchema, 
        cohortDatabaseSchema = cohortDatabaseSchema, 
        cohortTable = cohortTable, 
        outcomeDatabaseSchema = cohortDatabaseSchema,  
        outcomeTable = cohortTable, 
        cdmVersion = 5
)

# specify the level of logging 
logSettings <- PatientLevelPrediction::createLogSettings(
        verbosity = 'INFO', 
        logName = 'MphSafetyPrediction'
)
#=======================

#======================
# PICK THINGS TO EXECUTE
#=======================
# want to generate a study protocol? Set below to TRUE
createProtocol <- FALSE
# want to generate the cohorts for the study? Set below to TRUE
createCohorts <- TRUE
# want to run a diagnoston on the prediction and explore results? Set below to TRUE
runDiagnostic <- FALSE
viewDiagnostic <- FALSE
# want to run the prediction study? Set below to TRUE
runAnalyses <- TRUE
sampleSize <- NULL # edit this to the number to sample if needed
# want to create a validation package with the developed models? Set below to TRUE
createValidationPackage <- FALSE
analysesToValidate = NULL
# want to package the results ready to share? Set below to TRUE
packageResults <- FALSE
# pick the minimum count that will be displayed if creating the shiny app, the validation package, the 
# diagnosis or packaging the results to share 
minCellCount= 5
# want to create a shiny app with the results to share online? Set below to TRUE
createShiny <- FALSE


#=======================

MphSafetyPrediction::execute(
        databaseDetails = databaseDetails,
        outputFolder = outputFolder,
        createProtocol = createProtocol,
        createCohorts = createCohorts,
        runDiagnostic = runDiagnostic,
        viewDiagnostic = viewDiagnostic,
        runAnalyses = runAnalyses,
        createValidationPackage = createValidationPackage,
        analysesToValidate = analysesToValidate,
        packageResults = packageResults,
        minCellCount= minCellCount,
        logSettings = logSettings,
        sampleSize = sampleSize
)
```

The 'createCohorts' option will create the target and outcome cohorts into cohortDatabaseSchema.cohortTable if set to T.  The 'runAnalyses' option will create/extract the data for each prediction problem setting (each Analysis), develop a prediction model, internally validate it if set to T.  The results of each Analysis are saved in the 'outputFolder' directory under the subdirectories 'Analysis_1' to 'Analysis_N', where N is the total analyses specified.  After running execute with 'runAnalyses set to T, a 'Validation' subdirectory will be created in the 'outputFolder' directory where you can add the external validation results to make them viewable in the shiny app or journal document that can be automatically generated.


- You can then easily transport all the trained models into a network validation study package by running:
```r
  
  execute(connectionDetails = connectionDetails,
        cdmDatabaseSchema = cdmDatabaseSchema,
		cdmDatabaseName = cdmDatabaseName,
        cohortDatabaseSchema = cohortDatabaseSchema,
        cohortTable = cohortTable,
        outputFolder = outputFolder,
        createValidationPackage = T)
  

```

- To pick specific models (e.g., models from Analysis 1 and 3) to export to a validation study run:
```r
  
  execute(connectionDetails = connectionDetails,
        cdmDatabaseSchema = cdmDatabaseSchema,
		cdmDatabaseName = cdmDatabaseName,
        cohortDatabaseSchema = cohortDatabaseSchema,
        cohortTable = cohortTable,
        outputFolder = outputFolder,
        createValidationPackage = T, 
        analysesToValidate = c(1,3))
```  
This will create a new subdirectory in 'outputFolder' that has the name <yourPredictionStudy>Validation.  For example, if your prediction study package was named 'bestPredictionEver' and you run the execute with 'createValidationPackage' set to T with 'outputFolder'= 'C:/myResults', then you will find a new R package at the directory: 'C:/myResults/bestPredictionEverValidation'.  This package can be executed similarly but will validate the developed model/s rather than develop new model/s.  If you set the validation package outputFolder to the Validation directory of the prediction package results (e.g., 'C:/myResults/Validation'), then the results will be saved in a way that can be viewed by shiny.


- To create the shiny app and view the results, run the following after successfully developing the models:
```r
  
execute(connectionDetails = connectionDetails,
        cdmDatabaseSchema = cdmDatabaseSchema,
		cdmDatabaseName = cdmDatabaseName,
        cohortDatabaseSchema = cohortDatabaseSchema,
        cohortTable = cohortTable,
        outputFolder = outputFolder,
        createShiny = T,
        minCellCount= 5)
PatientLevelPrediction::viewMultiplePlp(outputFolder)

```

If you saved the validation results into the validation folder in the directory you called 'outputFolder' in the structure: '<outputFolder>/Validation/<newDatabaseName>/Analysis_N' then shiny and the journal document creator will automatically include any validation results.  The validation package will automatically save the validation results in this structure if you set the outputFolder for the validation results to: '<outputFolder>/Validation'.

- To create the journal document for the Analysis 1:
```r
  
execute(connectionDetails = connectionDetails,
        cdmDatabaseSchema = cdmDatabaseSchema,
		cdmDatabaseName = cdmDatabaseName,
        cohortDatabaseSchema = cohortDatabaseSchema,
        cohortTable = cohortTable,
        outputFolder = outputFolder,
        createJournalDocument = F,
        analysisIdDocument = 1
        minCellCount= 5)

```


Instructions To Share Package
===================

- Share the package by adding it to the OHDSI/StudyProtocolSandbox github repo and get people to install by:
```r
  # get the latest PatientLevelPrediction
  install.packages("devtools")
  devtools::install_github("OHDSI/PatientLevelPrediction")
  # check the package
  PatientLevelPrediction::checkPlpInstallation()
  
  # install the network package
  devtools::install_github("OHDSI/StudyProtocolSandbox/MphSafetyPredic")
```



# Development status
Under development. Do not use
