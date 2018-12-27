/* 
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
crawlerbox mit Kabeldurchführung und Dichtgummi
l, b und h sind Innenmaße, die Box wird entsprechend größer
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
*/

/* =================================================== */
/* Parameter für individuelle Box, hier anpassen */

//Innenlänge, d.h Länge des Inhalts. Die Box wird wegen Dichtung und Deckelbefestigung entsprechend länger
l=35;

// Innenbreite, d.h Breite des Inhalts
b=25;

// Innenhöhe, d.h Höhe des Inhalts
h=25;

//Wandstärke einfache Wand, also Boden, Seitenwände, etc.
wand=1.2;

//Durchmesser der Moosgummidichtung
gummi=3;

//Durchmesser der Bohrung für Schraube
bohrung=1.5;

//Spalthöhe für Kabelduchführung
kabelspalt=2;


/* =================================================== */
/* allgemeine Parameter, müssen nicht angepasst werden */

eckradius=bohrung+0.5; //Radius der Eckzylinder
space=1; //Lücke zwischen Inhalt und Wand
platz=2*eckradius-wand+space; //Platz für Ecke
il=l+(gummi+wand+space)+platz; //Innenlänge mit Platz
ib=b+2*space;
ih=h+space;
$fn=50;


/* =================================================== */
/* main */
crawlerbox();
translate([0,-40,0]) 
    crawlerboxdeckel();


module crawlerbox()
{
    difference()
    {
        union()
        {
            //Box
            difference()
            {
                //Aussenwürfel
                cube(size=[il+2*wand,ib+2*wand,ih+wand]);
                //Innenwürfel
                translate([wand,wand,wand]) cube([il,ib,ih+wand]);
                //Kabeldurchführung
                translate([0,wand+2*eckradius,ih-kabelspalt]) 
                    cube([wand,ib-4*eckradius,kabelspalt+wand]);
                //Platz für Deckel
                translate([0,wand+eckradius,ih]) 
                    cube([wand,ib-2*eckradius,wand]);
            }
            
            //Dichtung
            difference()
            {
                hull()
                {
                    //Querbalken
                    translate([wand,wand,ih-gummi]) cube([gummi+wand,ib,gummi]);
                    //Anfang für Schräge
                    translate([wand,wand,wand]) cube([wand, ib, ih-kabelspalt-gummi]);
                }
                //Kabeldurchführung
                translate([0,wand+2*eckradius,ih-kabelspalt]) 
                    cube([2*wand+gummi,ib-4*eckradius,kabelspalt+wand]);
                //Rille für Dichtgummi
                    translate([wand,wand+2*eckradius,ih-kabelspalt-wand]) 
                        cube([gummi, ib-4*eckradius, gummi/2]);
            }
            
            //Ecken
            ecke(eckradius,eckradius, ih, eckradius);
            ecke(il+2*wand-eckradius,eckradius, ih, eckradius);
            ecke(eckradius,ib+2*wand-eckradius, ih, eckradius);
            ecke(il+2*wand-eckradius,ib+2*wand-eckradius, ih, eckradius);

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
        }//end union
        //Eckbohrungen abziehen
        eckbohrung(eckradius,eckradius, ih, bohrung/2, 7);
        eckbohrung(il+2*wand-eckradius,eckradius, ih, bohrung/2, 7);
        eckbohrung(eckradius,ib+2*wand-eckradius, ih, bohrung/2, 7);
        eckbohrung(il+2*wand-eckradius,ib+2*wand-eckradius, ih, bohrung/2, 7);
    }
}

module ecke(x,y,h,radius)
{
    translate([x,y,wand])
        cylinder(h=h,r=radius);
}

module eckbohrung(x,y,h,lochradius,lochtiefe)
{
    translate([x,y,h+wand-lochtiefe])
        cylinder(h=lochtiefe,r=lochradius);
}


module crawlerboxdeckel()
{
    luecke=0.5; //Lücke zwischen Innendeckel und Box
    rand=5; //Höhe des Rands
    
    x1=eckradius;
    x2=il+2*wand-eckradius;
    y1=eckradius+wand+luecke;
    y2=ib+3*wand+luecke-eckradius;
    
    difference()
    {
        union()
        {
            //Deckel mit Rand
            difference()
            {
                cube([il+3*wand+luecke,ib+4*wand+2*luecke,wand+rand]);
                translate([0,wand,wand]) cube([il+2*wand+luecke,ib+2*wand+2*luecke,rand]);
            }
            //Deckelinnenteil
            translate([0,2*wand+2*luecke,wand]) cube([il+wand-luecke,ib-2*luecke,wand]);
        }
        eckausschnitt(x1,y1,eckradius);
        eckausschnitt(x1,y2,eckradius);
        eckausschnitt(x2,y1,eckradius);
        eckausschnitt(x2,y2,eckradius);
        //Rille für Dichtgummi
        translate([wand,2*wand+2*eckradius+luecke,wand]) 
                cube([gummi, ib-4*eckradius, gummi/2]);
    }    
}

module eckausschnitt(x,y, radius)
{
    union()
    {
        //Ausschnitt für Ecke
        translate([x,y,wand]) cylinder(h=wand,r=radius+0.75);
        //Bohrung für Schraube
        translate([x,y,0]) cylinder(h=2*wand,r=0.75);
    }
}
