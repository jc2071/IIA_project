
clear
close all

ugrads = [-0.1, 0, 0.1];
Rels = [5e6, 10e6, 20e6];
results_matrix_location = cell(length(Rels),length(ugrads));
results_matrix_value = cell(length(Rels),length(ugrads));

for i = 1:length(ugrads)
    for j = 1:length(Rels)
        [location, value] = transition(Rels(j), ugrads(i));
        results_matrix_location{j,i} = location;
        results_matrix_value{j,i} = value;     
    end
end
