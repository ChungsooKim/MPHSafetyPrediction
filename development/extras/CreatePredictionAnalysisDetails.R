# Copyright 2022 Observational Health Data Sciences and Informatics
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

#' Create the analyses details
#'
#' @details
#' This function creates files specifying the analyses that will be performed.
#'
#' @param workFolder        Name of local folder to place results; make sure to use forward slashes
#'                            (/)
#'
#' @export
#' 
#' 
#' 

createAnalysesDetails <- function(workFolder) {
   # 1) ADD MODELS you want
  modelSettingList <- list(setAdaBoost(nEstimators = c(10,50,100), learningRate = c(0.5,0.9,1)),
                           setLassoLogisticRegression(),
                           setGradientBoostingMachine()#, 
                        #    setCIReNN(), 
                        #    setCNNTorch(), 
                        #    setCovNN(), 
                        #    setCovNN2(), 
                        #    setDecisionTree(), 
                        #    setDeepNN(), 
                        #    setKNN(), 
                        # setLRTorch(), 
                        # setMLP(), 
                        # setMLPTorch(), 
                        # setNaiveBayes(), 
                        # setRandomForest(), 
                        # setRNNTorch()
                        )
  
  # 2) ADD POPULATIONS you want
  pop1 <- createStudyPopulationSettings(riskWindowStart = 1, 
                                        riskWindowEnd = 7,
                                        requireTimeAtRisk = T, 
                                        minTimeAtRisk = 6, 
                                        priorOutcomeLookback = 60,
                                        firstExposureOnly = F, 
                                        removeSubjectsWithPriorOutcome = T,
                                        includeAllOutcomes = T)
  pop2 <- createStudyPopulationSettings(riskWindowStart = 1, 
                                        riskWindowEnd = 30,
                                        requireTimeAtRisk = T, 
                                        minTimeAtRisk = 29, 
                                        priorOutcomeLookback = 60,
                                        firstExposureOnly = F, 
                                        removeSubjectsWithPriorOutcome = T,
                                        includeAllOutcomes = T)
  pop3 <- createStudyPopulationSettings(riskWindowStart = 1, 
                                        riskWindowEnd = 60,
                                        requireTimeAtRisk = T, 
                                        minTimeAtRisk = 59, 
                                        priorOutcomeLookback = 60,
                                        firstExposureOnly = F, 
                                        removeSubjectsWithPriorOutcome = T,
                                        includeAllOutcomes = T)
  pop4 <- createStudyPopulationSettings(riskWindowStart = 1, 
                                        riskWindowEnd = 7,
                                        requireTimeAtRisk = T, 
                                        minTimeAtRisk = 6, 
                                        priorOutcomeLookback = 60,
                                        firstExposureOnly = T, 
                                        removeSubjectsWithPriorOutcome = T,
                                        includeAllOutcomes = T)
  pop5 <- createStudyPopulationSettings(riskWindowStart = 1, 
                                        riskWindowEnd = 30,
                                        requireTimeAtRisk = T, 
                                        minTimeAtRisk = 29, 
                                        priorOutcomeLookback = 60,
                                        firstExposureOnly = T, 
                                        removeSubjectsWithPriorOutcome = T,
                                        includeAllOutcomes = T)
  pop6 <- createStudyPopulationSettings(riskWindowStart = 1, 
                                        riskWindowEnd = 60,
                                        requireTimeAtRisk = T, 
                                        minTimeAtRisk = 59, 
                                        priorOutcomeLookback = 60,
                                        firstExposureOnly = T, 
                                        removeSubjectsWithPriorOutcome = T,
                                        includeAllOutcomes = T)
  populationSettingList <- list(pop1, pop2, pop3, pop4, pop5, pop6)
  
  # 3) ADD COVARIATES settings you want
  covariateSettings1 <- FeatureExtraction::createCovariateSettings(useDemographicsGender = TRUE,
                                                                  useDemographicsAgeGroup = TRUE,
                                                                  useDemographicsRace = TRUE,
                                                                  useConditionOccurrenceAnyTimePrior = T,
                                                                  useConditionEraAnyTimePrior = TRUE,
                                                                  useConditionGroupEraAnyTimePrior = TRUE, #FALSE,
                                                                  useDrugExposureAnyTimePrior = T,
                                                                  useDrugEraAnyTimePrior = TRUE,
                                                                  useDrugGroupEraAnyTimePrior = TRUE, #FALSE,
                                                                  useProcedureOccurrenceAnyTimePrior = T,
                                                                  useDeviceExposureAnyTimePrior = T,
                                                                  useMeasurementAnyTimePrior =T,
                                                                  useObservationAnyTimePrior = T,
                                                                  useCharlsonIndex = TRUE,
                                                                  useDcsi = TRUE, 
                                                                  useChads2 = TRUE,
                                                                  longTermStartDays = -365,
                                                                  mediumTermStartDays = -180, 
                                                                  shortTermStartDays = -30, 
                                                                  endDays = 0)
  
  covariateSettings2 <- FeatureExtraction::createCovariateSettings(useDemographicsGender = TRUE,
                                                                   useDemographicsAgeGroup = TRUE,
                                                                   useDemographicsRace = TRUE,
                                                                   useConditionOccurrenceAnyTimePrior = T,
                                                                   useConditionEraAnyTimePrior = TRUE,
                                                                   useConditionGroupEraAnyTimePrior = TRUE, 
                                                                   longTermStartDays = -365,
                                                                   mediumTermStartDays = -180, 
                                                                   shortTermStartDays = -30, 
                                                                   endDays = 0)
  
  covariateSettingList <- list(covariateSettings1
                               # , covariateSettings2
                               ) 
  
  
  CohortsToCreate <- read.csv("./inst/settings/CohortsToCreate.csv")
  
  # ADD COHORTS
  outcomeIds <- c(1778584)   # add all your outcome cohorts here
  cohortIds <- CohortsToCreate$cohortId[!(CohortsToCreate$cohortId %in% outcomeIds)]   # add cohort IDs
  
  
  # this will then generate and save the json specification for the analysis
  savePredictionAnalysisList(workFolder= workFolder,
                                         cohortIds,
                                         outcomeIds,
                                         cohortSettingCsv =file.path(workFolder, 'CohortsToCreate.csv'), 
                              
                                         covariateSettingList,
                                         populationSettingList,
                                         modelSettingList,
                                         
                                         maxSampleSize= 100000,
                                         washoutPeriod=0,
                                         minCovariateFraction=0,
                                         normalizeData=T,
                                         testSplit='person',
                                         testFraction=0.25,
                                         splitSeed=1,
                                         nfold=5)

  }
