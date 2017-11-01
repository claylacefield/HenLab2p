function saveH5(Y, outfile)

%% USAGE: saveH5(Y, outfile);

disp('Saving stack as H5 with sima dimensions (tzyxc)');

%Y = uint16(Y);

Ysiz2 = size(Y);

Y = reshape(Y, [1,Ysiz2(1), Ysiz2(2), 1, Ysiz2(3)]);

disp(['Writing H5 file ' outfile]); 
h5create(outfile, '/imaging', size(Y), 'ChunkSize', [1, Ysiz2(1), Ysiz2(2),1,1]);
tic;
h5write(outfile, '/imaging', Y);
toc;