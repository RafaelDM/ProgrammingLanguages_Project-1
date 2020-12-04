# ProgrammingLanguages_Project

Daniel Atilano Casillas
Rafael Díaz Medina 
</br>

<h1> Description </h1>
Ariadne's thread is a racket program that returns an exit path for any given maze with the shape of a matrix; for eaxample:
</br>

1 1 1 1 1 </br>
1 1 1 0 0 </br>
1 0 0 0 1 </br>   
1 1 0 1 1 </br>
1 1 0 1 1 </br>

</br>
<li> The maze must be fringed by 4 outer walls with anything but '1's for the exception of two '0's ; an entrance and an exit, that can be located anywhere, but must not exceed two.</li>

<li> The method to read the maze by rows is (read-maze "filename.txt") where the filename is the input maze file. To read the maze by columns (columnMaze maze) uses the output of
  (read-maze) as input. Then (newMaze maze) returns an updated maze like so: </li>
</br>

1 1 1 1 1 </br>
1 1 1 0 2 </br>
1 0 0 0 1 </br>
1 1 0 1 1 </br>
1 1 2 1 1 </br>

<li> Along with other smaller functions, (newMaze) returns a maze with marked exits. </li>
<li> (SealEntrance maze) changes the entrance of the maze from '2' to '3' so as to avoid inetrpretation of '2' as the exit like so: </li>
</br>

1 1 1 1 1 </br>
1 1 1 0 3 </br>
1 0 0 0 1 </br>
1 1 0 1 1 </br>
1 1 2 1 1 </br>

<li> (SealEntrance) can take either of the '2's as entrances; in this case, the entrance is on the upper left. The final setup function is (findStart maze) which takes the output of (SealEntrance) to read the position, in x and y coordinates, of the adjacent '0' from which to begin creating the solution path. 
In this case the ouput would be '(3 1) </li>
<li> To find the path the recursive (dfs maze x y) method reads neighbors either on the left, right, down or upper side until it finds the '2' exit. Once done, it prints the path by substituting 0s with the respective arrows that indicate the direction to follow. </li>
<li> Finally, the (OutMaze filename list) takes the list of lists; the maze, and an output file to write down the maze with the printed path. </li>



