function [newFileID, avg, stdev] = Project_outputFile(newOutputFileName, file, statFile, username, inputFileName, oldFileID, oldOutputFileName)

    if(~exist(newOutputFileName, 'file'))
        newFileID = fopen(newOutputFileName, 'a+');
        d = date;
        prompt = sprintf('%s\n%s\n%s\n', newOutputFileName, d, username);
        fprintf(newFileID, '%s\n', prompt);
    end

    %If EVERY argument is passed in, the name and ID of an old file has
    %been passed in, which means it needs to be erased, since that means we
    %have started a new output file. If we have less, than we are just
    %writing an output file from the beginning.

    if nargin == 8
        %Don't have to error check this becuase I'm the only one passing
        %things in.
        
        fclose(oldFileID);
        delete(oldOutputFileName);
    end


    %BUG: Actully appending to a file that is already made creates an
    %encrypted mess.
    newFileID = fopen(newOutputFileName, 'a+');
    if exist('statFile', 'var')
        [avg, med, mod, va, stdev, minimum, maximum, count, msg] = mystat(statFile);
    else
        [avg, med, mod, va, stdev, minimum, maximum, count, msg] = mystat(file);
    end

    %TODO: Add clause to write xls if necessary
    prompt = sprintf('From %s: ', inputFileName);
    fprintf(newFileID, '%s\nMean\t= %8.2f\nMedian\t= %8.2f\nMode\t= %8.2f\nVar\t\t= %8.2f\nStdev\t= %8.2f\t%s\nMin\t\t= %8.2f\nMax\t\t= %8.2f\nCount\t= %8.2f', prompt, avg, med, mod, va, stdev, msg, minimum, maximum, count);
end