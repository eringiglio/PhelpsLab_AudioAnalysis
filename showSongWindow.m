function[songChunk,cellStart,cellEnd] = showSongWindow(song,cell)

cellStart = 1 + (cell-1)*20000000;
cellEnd = cell*20000000;
songChunk = song(cellStart:cellEnd);
view_modified_songs(songChunk);