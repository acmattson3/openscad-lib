// Syringe Prop Colored Insert
// And cane extension

$fn = 64;

insert_dia = 17.8;
insert_len = 96.0;

//linear_extrude(96.0)
//circle(d=insert_dia);

cane_ext = 270.0;
cane_dia = 22.0;
overlap_dist = cane_dia;
line_thick = 0.8;

cylinder(d1=cane_dia, d2=cane_dia+line_thick, h=cane_ext);
translate([0,0,cane_ext])
cylinder(d=cane_dia+line_thick, h=overlap_dist);