/*
crawlerbox mit Kabeldurchführung und Dichtgummi
Innenmaße angeben
*/

$fn=50;
wand=1.2;
gummi=3;

crawlerbox(45, 22, 22);
translate([0,-50,0]) crawlerboxdeckel(45, 22, 2);

module crawlerbox(l, b, h)
{
    eckradius=2; //Radius der Eckzylinder
    kabeldicke=1;
    platz=2*eckradius-wand+0.5; //Platz für Ecke
    il=l+2*platz; //Innenlänge mit Platz
    ib=b+2*platz;
    ih=h;
    

    //Box
    difference()
    {
        //Aussenwürfel
        cube(size=[il+2*wand,ib+2*wand,ih+wand]);
        //Innenwürfel
        translate([wand,wand,wand]) cube([il,ib,ih+wand]);
        //Kabeldurchführung
        translate([0,wand+2*eckradius,ih-2*kabeldicke]) 
            cube([wand,ib-4*eckradius,2*kabeldicke+wand]);
    }
    
    //Ecken
    ecke(eckradius,eckradius, ih, eckradius);
    ecke(il+2*wand-eckradius,eckradius, ih, eckradius);
    ecke(eckradius,ib+2*wand-eckradius, ih, eckradius);
    ecke(il+2*wand-eckradius,ib+2*wand-eckradius, ih, eckradius);

    //Dichtung
    difference()
    {
        hull()
        {
            //Querbalken
            translate([wand,wand,ih-gummi]) cube([gummi+wand,ib,gummi]);
            //Anfang für Schräge
            translate([wand,wand,wand]) cube([wand, ib, ih-2*kabeldicke-gummi]);
        }
        //Kabeldurchführung
        translate([0,wand+2*eckradius,ih-2*kabeldicke]) 
            cube([2*wand+gummi,ib-4*eckradius,2*kabeldicke+wand]);
        //Rille für Dichtgummi
            translate([wand,wand+2*eckradius,ih-2*kabeldicke-wand]) 
                cube([gummi, ib-4*eckradius, gummi/2]);
    }
    
    //Befestigungslöcher
    abstand=(35-(ib+2*wand))/2;
    difference()
    {
        //2 Ohren, miteinander verbunden
        hull()
        {
            translate([il/2+wand, -abstand, 0]) cylinder(h=wand, r=3);
            translate([il/2+wand, ib+2*wand+abstand, 0]) cylinder(h=wand, r=3);
        }
        //Löcher
        translate([il/2+wand, -abstand, 0]) cylinder(h=wand, r=1);
        translate([il/2+wand, ib+2*wand+abstand, 0]) cylinder(h=wand, r=1);
    }
}

module ecke(x,y,h,radius)
{
    difference()
    {
        //Zylinder
        translate([x,y,wand])
            cylinder(h=h,r=radius);
        //Bohrung
        translate([x,y,h+wand-3])
            cylinder(h=3,r=0.75);
    }
}

module crawlerboxdeckel(l, b, radius)
{
    platz=2*radius-wand+0.5;
    laenge=l+2*platz; //Innenlänge mit Platz
    breite=b+2*platz;
    difference()
    {
        union()
        {
            cube([laenge+2*wand,breite+2*wand,wand]);
            translate([0,wand,wand]) cube(size=[laenge+wand,breite,wand]);
        }
        union()
        {
            eckausschnitt(radius,radius,radius);
            eckausschnitt(laenge+2*wand-radius,radius,radius);
            eckausschnitt(radius,breite+2*wand-radius,radius);
            eckausschnitt(laenge+2*wand-radius,breite+2*wand-radius,radius);
            //Rille für Dichtgummi
            translate([wand,wand+2*radius,wand]) 
                cube([gummi, breite-4*radius, gummi/2]);
       }
    }    
}

module eckausschnitt(x,y, radius)
{
    union()
    {
        //Ausschnitt für Ecke
        translate([x,y,wand]) cylinder(h=wand,r=radius+0.75);
        //Bohrung für Schraube
        translate([x,y,0]) cylinder(h=2*wand,r1=0.75);
    }
}
