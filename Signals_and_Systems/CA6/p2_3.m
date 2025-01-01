[music, ~]=audioread('mysong.wav');
i=1;
while ~isempty(music)
    [is_half,note,music]=extract_note(music);
    fprintf('%d: Note: %c is_half: %d\n', i,note,is_half);
    i=i+1;
end