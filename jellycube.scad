$fn=20; //number of polygons

//These two measurements are in mm
wd = 1; //Wirediameter
id = 2.5; //Ring Inner diameter

//Integer Division. For when you need 10/3 = 3 instead of = 3.3333 
function intDiv(x,y) = (x-x%y)/y;

//A donut
module torus(id,wd){
    rotate_extrude()
    translate([(wd+id)/2,0,0])
    circle(d=wd);
    
}
// Shorthand for the torus using the wd and id specified above without having to input them all the time.
module ring(){
    torus(id,wd);
}

//---------------
//j4in1 functions
//---------------
//Position of a ring in the j4in1 or jellycube grid
function jpPos(x,y,z=0) = [x*id,y*id,z*id];
//Rotation of a ring in j4in1
function jpRot(x,y) = abs(x)%2== abs(y)%2 ? [0,0,0] : 
    abs(x)%2==1 ? [90,0,0] : abs(y)%2==1 ? [0,90,0] : [45,0,0];
//Determines if a j4in1 ring at gridposition x,y should be shown.
function jpExists(x,y) = !(abs(x)%2 == 1 && abs(y)%2 ==1 )
;
//Colors a ring based on its orientation/position
function jpCol(x,y) = abs(x)%2==0 && abs(y)%2==0 ? "red" : 
    abs(x)%2==1 ? "green" : abs(y)%2==1 ? "blue" : "magenta";

//---------------
//jellycube functions
//---------------
//Rotation of a ring in a jellycube grid
function jcRot(x,y,z) = z%2==0 ? jpRot(x,y) : 
    jpRot(x+1,y+1);
//Determines if a jellycube ring at gridposition x,y,z should be shown.
function jcExists(x,y,z) = z%2==0 ? jpExists(x,y) : jpExists(x+1,y+1) ;

//----------------
// Jellycube Color functions
//----------------
function jcCol() = function (x,y,z) z%2==0 ? jpCol(x,y) : jpCol(x+1,y+1);
function jcUnitCol() = function (x,y,z) (intDiv(x,2)%2 + intDiv(y,2)%2 + intDiv(z,2)%2)%2==0  ? "red" : "blue";
function uniform(c) = function (x,y,z) c;

//-------------------------
// Modules for actual stuff
//-------------------------
//Jellycube grid module. 
// - x,y,z are lenght,width, and height in jellycube units. You can also input #.5 in case you need half units
// - the offset is measured in half units. It is a vector [x,y,z]
// - c is a lambda function to determine how rings get colored. 
//      c should have the form (x,y,z)-> color
module jcGrid(x,y,z,offset=[0,0,0],c=jcCol()){
    for(x = [0+offset[0]:1:2*x+offset[0]-1]){
        for(y=[0+offset[1]:1:2*y+offset[1]-1]){
            for(z=[0+offset[2]:1:2*z+offset[2]-1]){
                if(jcExists(x,y,z)){
                    color(c(x,y,z))
                    translate(jpPos(x,y,z))
                    rotate(jcRot(x,y,z))
                    ring();
                }
            }
        }
    }
}

//A stardart jelly cube
module jellycube(size=3,c=jcCol()){
    jcGrid(size,size,size,c=c);
}


//A helper module for starting jelly cubes
module jcStarterArea(starterSize = 3){
    for(i = [1:2:2*starterSize]){
        jcGrid(starterSize,0.5,0.5, [1,i,0]);
        jcGrid(0.5,starterSize,0.5, [i,1,0]);
    }
    cubeLength = 2*starterSize*id+wd;
    translate([0,0,-id])
    cube([cubeLength, cubeLength,0.9*id],center=false);
}
//A helper module for starting jelly cubes
module jcStarterRing(starterSize = 3){
    for(i = [1:2:2*starterSize]){
        jcGrid(0.5,0.5,0.5,[i+1,0,0]);
        jcGrid(0.5,0.5,0.5,[0,i+1,0]);
        jcGrid(0.5,0.5,0.5,[i+1,starterSize*2+2,0]);
        jcGrid(0.5,0.5,0.5,[starterSize*2+2,i+1,0]);
    }
    
    cubeLength = 2*(starterSize+2)*id;
    holeLength =2*(starterSize+1)*id;
    difference(){
        translate([-id,-id,-0.5*wd])
        cube([cubeLength, cubeLength,wd],center=false);
        translate([0,0,-0.6*wd])
        cube([holeLength,holeLength,wd+0.2],center=false);
    }
}

//A helper module for starting jelly cubes
module jcStarterCorner(starterSize = 3){
    for(i = [1:2:2*starterSize]){
        jcGrid(0.5,0.5,0.5,[i+1,0,0]);
        jcGrid(0.5,0.5,0.5,[0,i+1,0]);
    }
    
    cubeLength = 2*(starterSize+1)*id;
    holeLength =2*(starterSize+1)*id;
    difference(){
        translate([-id,-id,-0.5*wd])
        cube([cubeLength, cubeLength,wd],center=false);
        translate([0,0,-0.6*wd])
        cube([holeLength,holeLength,wd+0.2],center=false);
    }
}


//jcStarterArea();
//jcStarterCorner();
//jcStarterRing();

jellycube();
//jellycube(1.5,1);
//jellycube(c=jcUnitCol());
//jellycube(c=uniform("yellow"));





















