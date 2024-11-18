 % Write cubit commands to a .jou file

 data_matrix = slab_mat(1:10:end,:);


    fileID = fopen('Check_Slab_Tomo.jou', 'w');
   fprintf(fileID, 'journal off\n echo off\n info off\n');

    % Create vertices
    for i = 1:size(data_matrix, 1)
        fprintf(fileID, 'create vertex location %.7e %.7e %.7e\n', data_matrix(i, 1), data_matrix(i, 2), data_matrix(i, 3));
    end

    fclose(fileID);