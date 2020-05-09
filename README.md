# Photonic-Radiative-Cooler
<p float="left">
<a href = "https://github.com/zaman13/Photonic-Radiative-Cooler"> <img src="https://img.shields.io/badge/Language-MATLAB-blue" alt="alt text"> </a>
<a href = "https://github.com/zaman13/Photonic-Radiative-Cooler/blob/master/LICENSE"> <img src="https://img.shields.io/badge/license-MIT-green" alt="alt text"></a>
<a href = "https://github.com/zaman13/Photonic-Radiative-Cooler"> <img src="https://img.shields.io/badge/version-1.1-red" alt="alt text"> </a>
</p>


<p>
<img align = "right" src="https://github.com/zaman13/Photonic-Radiative-Cooler/blob/master/Output%20figures/Emissivity_contour.png" alt="alt text" width="320">
<img align = "right" src="https://github.com/zaman13/Photonic-Radiative-Cooler/blob/master/Output%20figures/Fig_structure.png" alt="alt text" width="240">  
Data files and Matlab codes for analyzing a multilayer thin-film photonic radiative cooler. The repository contains codes for calculating the reflectance of a planar multilayer dielectric structure as a function of wavelength (for any arbitrary incident angles), plotting solar spectrm and atmospheric transmission, and evaluating the cooling power of a multilayer photonic structures. The refractive index data of several optical thin-film dielectric materials, solar spectrum data, atomospheric absorption data is also included in the repository. The source of the data files are cited in Ref. [1]. 
</p>


## Reflectivity Calculation (reflectance_TE.m and reflectance_TM.m file)

These are Matlab functions to calculate the reflectance of a planar multilayer structure. The functions have the form: 

R_TE = reflectance_TE(n0,nsubs,n_layers,d_layers,theta_in,lambda)

The arguments are listed below. The geometry of the layers is also show.

```                                                            

  n0 = refractive index of the input medium                 |--------------------------------|
  nsubs = refractive index of the substrate                 |                                |
  n_layers = refractive indices of the thin-film layers     |              Air               |  
  theta_in = incident angle (in radians)                    |                                |  
  lambda = wavelength                                       |--------------------------------| 
                                                            |            Layer 1             |
  R_TE = output = reflectivity                              |--------------------------------|
                                                            |            Layer 2             |
                                                            |--------------------------------|
                                                            |               .                |
                                                            |               .                |
                                                            |               .                |
                                                            |--------------------------------|
                                                            |            Layer N             |  
                                                            |--------------------------------|
                                                            |                                |
                                                            |           Substrate            |   
                                                            |                                |   
                                                            |--------------------------------|
```



## Emissivity (or Reflectivity) Spectrum Calculations (spectrum_out.m file)

Theis are Matlab function calculates the emissivity (emissivity = 1 - reflectivity) or a multilayer structure as a function of wavelength for a given incidence angle. reflectance_TE.m and reflectance_TM.m  functions are called within this function. It has the form:

yout = spectrum_out(M_mat,A_payload,theta_in,min_d,max_d)

The arguments are listed below. 
```
M_mat = Matrix containing material reflectivity data
A_payload = Matrix containing layer materials and thickness data
theta_in = Incidence angle
min_d = minimum allowed thickness of a layer
max_d = maximum allowed thickness of a layer
yout = emissivity = 1 - reflectivity
```

The min_d and max_d values are required as the layer thickness values in the input matrix A_payload is normalized with respect to those values. 



## Linking to an Optimization Algoirthm (fitness.m file)

For a given multilayer structure, the fitness.m file calculates the squared error between the desired emissivity and the emissivity of the structure. The function arguments are:

```
M_mat = Matrix containing material reflectivity data
A_payload = Matrix containing layer materials and thickness data
flag_fig = boolean variable indicating whether the output should be plotted or not
yout = -(sum of squared error)
```
The desired emissivity is defined withing the fitness.m file. The structure emissivity is calculated by calling the reflectance_TE and reflectance_TM files. The errors for TE and TM excitations are summed in yout. 

This function can be used as the cost function of an optimization algorithm.


## Sample output
For an example structure, some of the output plots are shown below:

<p float="left">
<img src="https://github.com/zaman13/Photonic-Radiative-Cooler/blob/master/Output%20figures/ref_index.svg" alt="alt text" width="800">
</p>

<p float="left">
<img src="https://github.com/zaman13/Photonic-Radiative-Cooler/blob/master/Output%20figures/Emissivity.svg" alt="alt text" width="400">
<img src="https://github.com/zaman13/Photonic-Radiative-Cooler/blob/master/Output%20figures/Emissivity_contour.png" alt="alt text" width="400">

</p>

## Reference
Please cite the following paper if you use this repository for your research.

**1.** Mohammad Asif Zaman, "Photonic radiative cooler optimization using Taguchi's method." International Journal of Thermal Sciences 144 (2019): 21-26. https://doi.org/10.1016/j.ijthermalsci.2019.05.019
