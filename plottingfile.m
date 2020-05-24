% We want to plot AOA agaisnt, Cl, Cd and L/D. Also want to see presusre
% distrubution

clear; close all; clc

load('Data/design1/3e6_20.mat', 'cp', 'xs');

plot(xs,-cp, 'LineWidth', 1.5, 'color','r') 

