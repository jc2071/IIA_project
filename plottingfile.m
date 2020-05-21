% We want to plot AOA agaisnt, Cl, Cd and L/D. Also want to see presusre
% distrubution

clear; close all; clc

load('Data/trial/1e8_5.mat', 'cp', 'xs');

plot(xs,cp)