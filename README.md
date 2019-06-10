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
4. Catchment properties like roughness, landuse, soil cover, soil type (optional)

### Processing (Function definations and working)
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

4. Flow generator : Reads the network properties and generates flow using the 2 bucket method for "days" provided in the function call. 
The recession constants R1 and R2 - slow and fast reserviors are predefined inside the function defination which can be changed by the user. 
The flow generator outputs flow time series in user defined resolution , Quartile flow values and Mean specific discharge at all reaches.

5. Function networkprop uses Leopolds equation to compute base width in time and space. Here we also define the other network properties like Mannings roughness n, loss constant Kd (range of values)

6.Function depth() uses mannings equation and uses the network propety "out" and "Qtx" flow time series to generate depth.
Note that to save time in solving a non linear equation for each time step and location for generating depth from flow, n and s , we use a precalculated matrix of depth which is computed for a range of flow and base width for given n and s. 
We use linear interpolation from the values of this table to calculate depth. 
The function used for this precalculation is named ymaster.mat, which needs to be ran in a separate step.

7. Hotlengh() calculates the affected downstream lengths of each reach for a range of Kd values. The output is a 3D matrix with one table of affected length in time and space for each kd.

### Usage of the code

Function Model() is the main model code where all the functions are called based on the choosen WWTP setups.
Please refer the code for in-line comments in the functions provided. (Definations in section: Processing)
For further queries regarding the model working please contact the author
## Authors


* **Sulagna Mishra**


