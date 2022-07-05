# MarineHeatwaveDataCode

Data and R code are provided for "Temperature amplification and marine heatwave alternation in shallow coastal bays" by Patricia L. WIberg

The following .csv files have the average SST grids for the 12-25 June 2015 marine heatwave in the study area as plotted in Figure 1.
<br>  OISSTV2_June2015MHW.csv - from OISST-V2: https://psl.noaa.gov/data/gridded/data.noaa.oisst.v2.html; 0.25°-resolution
<br>  SSTCCI_June2015MHW.csv - from SST-CCI: https://climate.esa.int/en/projects/sea-surface-temperature/; 0.05°-resolution
<br>  RUAVHRR_June2015MHW.csv - from Rutgers Center for Ocean Observing Leadership remote sensing data products: https://rucool.marine.rutgers.edu/integrated-ocean-technology/remote-sensing/
  

The following .html (with embedded graphics) and .Rmd (R notebook with code) files run simulations of SST from 1982-2100, including calculation of AR1 model parameters (see Figure 5; Tables 1 & 2). These use the included datafile: SST_COC_CBW_Jul2022.csv.
<br>  SSTMHWAnalysisCBWMWT_Jul2022.html, SSTMHWAnalysisCBWMWT_Jul2022.Rmd - for CBWMWT (measured water temperature at coastal bay site at Wachapreague, VA)
<br>  SSTMHWAnalysisCOCMWT_Jul2022.html, SSTMHWAnalysisCOCMWT_Jul2022.Rmd - for COCMWT (measured SST at coastal ocean location of NOAA NDBC CHLV2)
<br>  SSTMHWAnalysisCOCOI_Jul2022.html, SSTMHWAnalysisCOCOI_Jul2022.Rmd - for COCOI (OISST-V2 SST at coastal ocean location of NOAA NDBC CHLV2)
