% We want to plot AOA agaisnt, Cl, Cd and L/D. Also want to see presusre
% distrubution

clear; close all; clc

load('Data/naca0012/3e6_-15:1:15_summary.mat', 'clswp', 'cdswp');

plot(clswp,cdswp, 'LineWidth', 1.5, 'color','r')
xlabel('C_L')
ylabel('C_D')

