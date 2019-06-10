# Optimum WWTP configuration 
In the study we propose a model-based approach to identify the most favorable positions of wastewater treatment plants along a river network in order to minimize the impact on the hygienic water quality. Our model comprises a stochastic climate – flow generator coupled with the water quality analyzer which is designed to work in catchments with limited data availability. 
The sampling of water and sediments we conducted along Lockwitzbach in Germany, showed a clear impact of the WWTP effluents on the E.coli concentrations in the downstream receiving waters, the extent of which varied with the source position. The application of our model helps to understand the effects of river network structure, hydraulic variables and in-river retention processes on the spatio-temporal pattern of microbial pollution. The proposed methodology can provide dynamic maps of safe and vulnerable zones in a river network under different flow conditions. Specifically, it can assist managers and stakeholders to decide on an optimum configuration of treatment plants to be built (number/ sizes/ positions) or to identify the safest locations for water use.

## Softwares used

1. MATLAB
2. QGIS/ArcGIS

### Prerequisite data

1. Rainfall time series ( atleast 2 years of data)
2. Digital Elevation Map
3. Flow data ( atleast 2 years)
4. 

### Preprocessing (Required functions)
1. Extract the river network (File name "Catchment") from the DEM along with the properties like reach length, slope, connectivity etc. 
In the example code, this information is contained in file Lockwitz.  

2.Generate network properties from "Catchment"
Data file : "Catchment" should contain the following information: 
Reach number, to and from node, Reach length and contributing area.
Network properties include : Total upstream drainage area, Total distance to the outlet, Strahar order
This can be done using GIS using DEM or Matlab/R using data file "Catchment". This function in our code is refered as "Sum_properties"

3. Stocastic rainfall generator (Rain)
Read the rain fall time series and extract the PDFs of inter arrival time and rainfall depths. distfinder()
Based on the PDF - e.g. possion/power/etc., use distcreator () to generate data of the same distribution. 









### Usage of the code

Function Network() : Is the main model where all the functions are called based on the choosen WWTP setups.
Please refer the code for in-line comments.

Say what the step will be

```
Give the example
```

And repeat

```
until finished
```

End with an example of getting some data out of the system or using it for a little demo

## Authors

* **Sulagna Mishra**

## Acknowledgments
