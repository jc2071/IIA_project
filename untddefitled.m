% We want to plot AOA agaisnt, Cl, Cd and L?D

clear; close all; clc

load('Data/naca0015/3e6_0:1:89_summary.mat', 'lovdswp', 'alpha');

plot(alpha,lovdswp)