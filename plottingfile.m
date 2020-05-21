% We want to plot AOA agaisnt, Cl, Cd and L/D. Also want to see presusre
% distrubution

clear; close all; clc

load('Data/naca4412/3e6_0:0.5:30_summary.mat', 'clswp', 'alpha');

plot(alpha,clswp)