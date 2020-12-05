# Ariadne's Thread

Daniel Atilano Casillas A01020270</br>
Rafael Díaz Medina A01024592
</br>

<h2> Description </h2>
<li> Ariadne's thread is a racket program that returns an exit path for any given maze with the shape of a matrix; for eaxample: </li>
</br>

                        1 1 1 1 1 
                        1 1 1 0 0
                        1 0 0 0 1    
                        1 1 0 1 1 
                        1 1 0 1 1

<li> The maze must be fringed by 4 outer walls with anything but '1's for the exception of two '0's ; an entrance and an exit, that can be located anywhere, but must not exceed two.</li>

<li> The method to read the maze by rows is (read-maze "filename.txt") where the filename is the input maze file. To read the maze by columns (columnMaze maze) uses the output of (read-maze) as input. Then (newMaze maze) returns an updated maze like so: </li>
</br>

                        1 1 1 1 1
                        1 1 1 0 2 
                        1 0 0 0 1 
                        1 1 0 1 1
                        1 1 2 1 1

<li> Along with other smaller functions, (newMaze) returns a maze with marked exits. </li>
<li> (SealEntrance maze) changes the entrance of the maze from '2' to '3' so as to avoid inetrpretation of '2' as the exit like so: </li>
</br>

                        1 1 1 1 1
                        1 1 1 0 3
                        1 0 0 0 1
                        1 1 0 1 1 
                        1 1 2 1 1 

<li> (SealEntrance) can take either of the '2's as entrances; in this case, the entrance is on the upper left. The final setup function is (findStart maze) which takes the output of (SealEntrance) to read the position, in x and y coordinates, of the adjacent '0' from which to begin creating the solution path. 
In this case the ouput would be '(3 1) </li>
<li> To find the path the recursive (dfs maze x y) method reads neighbors either on the left, right, down, or upper side until it finds the '2' exit. Once done, it prints the path by substituting 0s with the respective arrows to indicate the direction to follow. </li>
<li> Finally, the (OutMaze filename list) takes the list of lists; the maze, and an output file to write down the maze with the printed path. </li>
<li> The (main "filename.txt") method runs the whole program and is the function the user will ultimately type on the console. </li>


## Instructions to compile
* First of all download Racket
        
        sudo apt-get install -y racket.
* Clone this repository
        
        git clone https://github.com/dans088/ProgrammingLanguages_Project.git

* On the directory "ProgrammingLanguages" run Racket
        
        racket
* When racket starts write the next command

        (enter! "Ariadne_thread.rkt")
    ![](https://cdn.discordapp.com/attachments/778436643463364662/784226580049166346/unknown.png)

* Then you are ready to use the program. Now type in the main method to solve the maze that you have

        (main "{Name Of Your Maze}.txt")
    * If the maze is valid the next message will be shown

    ![](https://cdn.discordapp.com/attachments/778436643463364662/784236568058527795/unknown.png)
    
    * Otherwise the next message will appear

    ![](https://cdn.discordapp.com/attachments/778436643463364662/784236686279442472/unknown.png)

* Output maze

    ![image](https://user-images.githubusercontent.com/21222851/101233927-e2940f80-3680-11eb-8c2a-ee030bb9a1d2.png)

