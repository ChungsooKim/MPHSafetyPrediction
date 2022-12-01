library(MphSafetyPrediction)

#=======================
# USER INPUTS
#=======================
# The folder where the study intermediate and result files will be written:


# Details for connecting to the server:
dbms <- "sql server"
user <- 'ted9219'
pw <- 'rddo678$'
server <- '128.1.99.58'
port <- '1433'
DATABASECONNECTOR_JAR_FOLDER <- 'C:/Users/dongy/databaseconnector_jar/'
connectionDetails <- DatabaseConnector::createConnectionDetails(dbms = dbms,
                                                                server = server,
                                                                user = user,
                                                                password = pw,
                                                                port = port,
                                                                pathToDriver = DATABASECONNECTOR_JAR_FOLDER)
cdmDatabaseName <-'HIRA'
database <- 'HIRA'
connectionDetailsReference <- "HIRA"
#outputFolder <- '/home/dongyun90/synology/MPHSafetyPrediction/development/MphSafetyPredictionResults/221111'
outputFolder <- 'C:/windowR/MPHSafetyPrediction/development/MphSafetyPredictionResults/221111'
cdmDatabaseSchema <- 'AUSOM_ADHD.dbo'
workDatabaseSchema <- "cohortDb.dbo"
cohortDatabaseSchema <- "cohortDb.dbo"
cohortTable <- "CKim_MphSafetyPredictionCohort_221104"

oracleTempSchema <- NULL
tempEmulationSchema <- 'C:/windowR/MPHSafetyPrediction/development/temp'
#tempEmulationSchema <- './temp'


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
createCohorts <- FALSE
# want to run a diagnoston on the prediction and explore results? Set below to TRUE
runDiagnostic <- FALSE
viewDiagnostic <- FALSE
# want to run the prediction study? Set below to TRUE
runAnalyses <- F
sampleSize <- NULL # edit this to the number to sample if needed
# want to create a validation package with the developed models? Set below to TRUE
createValidationPackage <- T
analysesToValidate = NULL
# want to package the results ready to share? Set below to TRUE
packageResults <- FALSE
# pick the minimum count that will be displayed if creating the shiny app, the validation package, the 
# diagnosis or packaging the results to share 
minCellCount= 5
# want to create a shiny app with the results to share online? Set below to TRUE
createShiny <- F


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

# Uncomment and run the next line to see the shiny results:
PatientLevelPrediction::viewMultiplePlp(outputFolder)


