///////////////////////////////////
// Bezier curves
///////////////////////////////////

function B_quadratic(t, p0, p1, p2) =
    pow(1-t, 2)*p0 +
    2*(1-t)*t*p1 +
    pow(t, 2)*p2;

// calculate intermediate point between endpoints (p0, p3)
//      using control points (p1, p2)
function B_cubic(t, p0, p1, p2, p3) =
    pow(1-t, 3)*p0 +
    3*pow(1-t, 2)*t*p1 +
    3*(1-t)*pow(t, 2)*p2 +
    pow(t, 3)*p3;

function B_quadratic_segment(p0, p1, p2, fn=32) =
    [for(t=[0:1/fn:1]) B_quadratic(t, p0, p1, p2)];

// calculate list of points between 2 endpoints
function B_cubic_segment(p0, p1, p2, p3, fn=32) =
    [for(t=[0:1/fn:1]) B_cubic(t, p0, p1, p2, p3)];

// this returns a point set for curves up to cubic
// first and last elements are end points, in between is control points
// handles up to 4 points for a segment
function B_segment(segment, fn=32) =
    len(segment)==4 ? B_cubic_segment(segment[0], segment[1], segment[2], segment[3], fn=fn) :
        len(segment)==3 ? B_quadratic_segment(segment[0], segment[1], segment[2], fn=fn) :
        len(segment)==2 ? [segment[0], segment[1]] :
        [segment[0]];

// this takes a path broken up into segments
function B_path(segments, fn=32) = 
    [for(i=[0:len(segments)-1])
        each B_segment(segments[i], fn)];

// draw endpoints and control points
module B_draw_debug(points, size=1){
    for(i=[0:len(points)-1]){
        p=points[i];
        //endpoint
        color("green") translate([p[0].x, p[0].y, 0]){
            square(1, center=true);
            text(str("  P", i), size=size);
        }
        //downstream control point
        color("blue") translate([p[1].x, p[1].y, 0]){
            square(1, center=true);
            text(str("  Pd", i), size=size);
        }
        //upstream control point
        color("purple") translate([p[2].x, p[2].y, 0]){
            square(1, center=true);
            text(str("  Pu", i), size=size);
        }
    }
}

module B_debug(segments, size=1){
    for(i=[0:len(segments)-1], j=[0:len(segments[i])-1]){
        p = segments[i][j];
        
        if(j==0){	//start endpoint of segment
            color("green")
            translate([p.x, p.y, 0]){
				circle(r=size, $fn=8);
				text(str("  S", i), size=size);
			}
        }else if(j==len(segments[i])-1){	//end endpoint of segment
            color("green")
            translate([p.x, p.y, 0]){
				circle(r=size, $fn=8);
				translate([0, -size-2, 0])
					text(str("  S", i), size=size);
			}
        }else{	//control point
            color("blue")
            translate([p.x, p.y, 0]){
				circle(r=size/2, $fn=8);
				text(str("  S", i, " C", j-1), size=size);
			}
        }
    }
}

module B_cubic_test() {
    echo("Testing Cubic Bezier curves");
    points = [
        [[0, 0], [-5, 5], [8, 0], [10, 5]],
        [[10, 5], [12, 0], [20, 10], [20, 0]],
        [[20, 0], [20, -10], [10, -10], [0, 0]]
    ];
    translate([0, 0, 3]) B_debug(points);
    path = B_path(points, fn=16);
    polygon(path);
}

B_cubic_test();
