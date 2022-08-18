# ECEC

Title: Is early formal childcare a potential equalizer?
How attending childcare and education centres affects children’s cognitive and socio-emotional skills in Germany

Authors: Gaia Ghirardi, Tina Baier, Corinna Kleinert, Moris Triventi

## Data 

We draw on the new-born sample (SC1 - https://www.neps-data.de/Data-Center/Data-and-Documentation/Start-Cohort-Newborns/105157-NEPSSC1600) of the National Educational Panel Study (NEPS - https://https://www.neps-data.de/Mainpage/)

## Replication Folder and Files description

## Variable description (main analysis)

After running dofiles: 0_master, 1_preparation, 2_weights and 3_sample_standardization

| Variable name:     |  Description                                                                      |  
|--------------------|-----------------------------------------------------------------------------------|            
| ID_t               | Child's unique id                                                                 | 
| c_healthDD2        | Child's health at wave 2                                                          |
| place_residence1   | Place of residence                                                                |
| n_siblings1        | Number of siblings at wave 1                                                      |
| n_siblings3        | Number of siblings at wave 3                                                      |
| n_sib_d            | Change in number of siblings                                                      |
| single_parent1     | Cohabitation family wave 1                                                        |
| single_parent2     | Cohabitation family wave 2                                                        |  
| single_parent3     | Cohabitation family wave 2                                                        |
| benefit_ecec       | Benefit expectation Daycare: enrichment                                           |
| att3               | ECEC attendance                                                                   |
| c_weight1          | Child's weight at birth                                                           |
| c_migr_n1          | Child's migration background                                                      |
| p_goals            | Parenting goals                                                                   |
| sensori1_sd        | Cognitive-sensorimotor development                                                |          
| stratum            | Sample: stratification variable                                                   |
| psu                | Sample: Primary Sampling Unit (Point number)                                      |
| weight_ipw_simple  | IPW weight for selection in the sample                                            |
| weight_ipw_at      | IPW weight for controlling for attrition                                          |
| weight_ipw_atW3    | IPW weight for controlling selection in the sample (w3) , and for attrition       |
| weight_ipw_atW45   | IPW weight for controlling selection in the sample (w45) , and for attrition      |
| weight_ipw_atW6    | IPW weight for controlling selection in the sample (w6) , and for attrition       |
| SDQ_ppb4_sd        | Peer problems: Standardized (w4)                                                  |
| SDQ_ppb6_sd        | Peer problems: Standardized (w6)                                                  |
| SDQ_pb4_sd         | Problems Behaviour: Standardized (w4)                                             |    
| SDQ_pb6_sd         |  Prosocial behavior: Standardized (w6)                                            | 
| SDQ_h6_sd          | Hyperactivity: Standardized (w6)                                                  |
| SDQ_bp6_sd         | Behavioral problems: Standardized (w6)                                            |
| voc6_sd            |  Vocabulary: WLE Standardized (w6)                                                |
| cat4_sd            |  Categorization: WLE Standardized (w4)                                            |
| math5_sd           |  Mathematical: WLE Standardized (w5)                                              |

| Data file to open   | Description                                                       |  
|---------------------|-------------------------------------------------------------------|
| xDataset_models.dta | Main dataset containing all variables described above             |


