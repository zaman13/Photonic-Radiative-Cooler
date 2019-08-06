# Photonic-Radiative-Cooler
Data files and Matlab codes for analyzing a multilayer thin-film photonic radiative cooler. The repository contains codes for calculating the reflectance of a planar multilayer dielectric structure as a function of wavelength (for any arbitrary incident angles), plotting solar spectrm and atmospheric transmission, and evaluating the cooling power of a multilayer photonic structures. The refractive index data of several optical thin-film dielectric materials, solar spectrum data, atomospheric absorption data is also included in the repository. The source of the data files are cited in Ref. [1]. 



## Reflectance Calculation (reflectance_TE.m and reflectance_TM.m file)

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
```

The min_d and max_d values are required as the layer thickness values in the input matrix A_payload is normalized with respect to those values. 

## Reference
Please cite the following paper if you use this repository for your research.

**1.** Mohammad Asif Zaman, "Photonic radiative cooler optimization using Taguchi's method." International Journal of Thermal Sciences 144 (2019): 21-26. https://doi.org/10.1016/j.ijthermalsci.2019.05.019
