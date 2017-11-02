function [ out ]  = scale_irradiance(hdr, min, max)

out = (hdr - min)/(max - min);


