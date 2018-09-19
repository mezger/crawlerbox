platz=2.5;
laenge=37+2*platz;
breite=26+2*platz;
hoehe=26+platz;
wand=1.2;
radius=2;

module ecke(x,y)
{
    difference()
    {
        translate([x,y,wand])
            cylinder(h=hoehe,r1=radius,r2=radius,$fn=40);
        translate([x,y,hoehe+wand-3])
            cylinder(h=3,r1=0.5,r2=0.5,$fn=40);
    }
}

module eckausschnitt(x,y)
{
    union()
    {
        translate([x,y,wand])
            cylinder(h=wand,r1=radius+0.5,r2=radius+0.5,$fn=40);
        translate([x,y,0])
            cylinder(h=2*wand,r1=0.75,r2=0.75,$fn=40);
    }
}

difference()
{
    cube(size=[laenge+2*wand,breite+2*wand,hoehe+wand]);
    translate([wand,wand,wand]) cube(size=[laenge,breite,hoehe+1]);
}

//Ecken
ecke(radius,radius);
ecke(laenge+2*wand-radius,radius);
ecke(radius,breite+2*wand-radius);
ecke(laenge+2*wand-radius,breite+2*wand-radius);

//Deckel
abstand=laenge+2*wand+5;
difference()
{
    union()
    {
        translate([abstand,0,0])
            cube(size=[laenge+2*wand,breite+2*wand,wand]);
        translate([abstand+wand,wand,wand])
            cube(size=[laenge,breite,wand]);
    }
    union()
    {
        eckausschnitt(abstand+radius,radius);
        eckausschnitt(abstand+laenge+2*wand-radius,radius);
        eckausschnitt(abstand+radius,breite+2*wand-radius);
        eckausschnitt(abstand+laenge+2*wand-radius,breite+2*wand-radius);
    }
}