music=[];
music = add_note(true, 'C', music); 
music = add_note(true, 'C', music); 
music = add_note(true, 'G', music); 
music = add_note(true, 'G', music); 
music = add_note(true, 'A', music);
music = add_note(true, 'A', music);
music = add_note(false, 'G', music);

music = add_note(true, 'F', music);
music = add_note(true, 'F', music);
music = add_note(true, 'E', music);
music = add_note(true, 'E', music);
music = add_note(true, 'D', music);
music = add_note(true, 'D', music);
music = add_note(false, 'C', music);

music = add_note(true, 'C', music);
music = add_note(true, 'C', music);
music = add_note(true, 'G', music);
music = add_note(true, 'G', music);
music = add_note(true, 'A', music);
music = add_note(true, 'A', music);
music = add_note(false, 'G', music);

music = add_note(true, 'F', music);
music = add_note(true, 'F', music);
music = add_note(true, 'E', music);
music = add_note(true, 'E', music);
music = add_note(true, 'D', music);
music = add_note(true, 'D', music);
music = add_note(false, 'C', music);

fs=8000;
sound(music,fs);
audiowrite('mysong.wav',music,fs);