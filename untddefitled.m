% We want to plot AOA agaisnt, Cl, Cd and L?D

clear; close all; clc

load('Data/naca4412/3e6_0:0.5:30_summary.mat', 'cdswp', 'alpha');

plot(alpha,cdswp)