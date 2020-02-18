function numEvents = nombreEvents(fileName)

f=fopen(fileName,'r');
bof=ftell(f);
line=native2unicode(fgets(f));
tok='#!AER-DAT';
version=0;
while line(1)=='#',
    if strncmp(line,tok, length(tok))==1,
        version=sscanf(line(length(tok)+1:end),'%f');
    end
    %(Garrick Orchard) commenting out printing of header, which makes other
    %printouts from this function difficult to find
%     fprintf('%s',line); % print line using \n for newline, discarding CRLF written by java under windows
    bof=ftell(f); % save end of comment header location
    line=native2unicode(fgets(f)); % gets the line including line ending chars
end
numBytesPerEvent=6;
switch(version)
    case 1
        numBytesPerEvent=6;
        addr_Skip = 4; %how many bytes between each address
        addr_precision = 'uint16';
        T_Skip = 2; %how many bytes between each timestamp
        T_precision = 'uint32';
    case 2
        numBytesPerEvent=8;
        addr_Skip = 4; %how many bytes between each address
        addr_precision = 'uint32';
        T_Skip = 4; %how many bytes between each timestamp
        T_precision = 'uint32';
%         disp('correctly assigned bits and skips')
end

        
fseek(f,0,'eof');
numEvents=floor((ftell(f)-bof)/numBytesPerEvent); % 6 or 8 bytes/event
end

