use <bezier.scad>

gap = 0.25;

module belt_clip_knob(){
    fn = $preview?32:64;
    r = 22;
    
    points = [
        [0, -2],
        [5, -2],
        [5, 0],
        [5.5-gap/2, 0.5],
        [5.5-gap/2, 1.5],
        [4, 3],
		[4, 5],
		[6, 6],
		[6, 7],
		[5, 8],
        [4, 8],
		[2, 6],
        [0, 6]
    ];
    
    rotate_extrude(angle=360, $fn=fn)
        polygon(points);
    
}

//belt clip will be in multiple pieces
module belt_clip_face(){
    fn = $preview?32:64;
    
    //draw shell
    shell_points = [
        [[-10, 26], [-10, 30], [-6, 30]],
        [[6, 30], [10, 30], [10, 26]],
        [[10, 8], [10, 0], [2, 0]],
        [[-2, 0], [-10, 0], [-10, 8]]
    ];
    shell_path = B_path(shell_points, fn=fn);
    slot_path = [
        [5+gap, 0],
        [5+gap, 2],
        [4+gap/2, 3+gap],
		[4+gap/2, 5],
		[6+gap/2, 6],
		[6+gap/2, 10],
        [-6-gap/2, 10],
        [-6-gap/2, 6],
        [-4-gap/2, 5],
        [-4-gap/2, 3+gap],
        [-5-gap, 2],
        [-5-gap, 0]
    ];
    slot_bottom_path = [
        [0, 0],
        [5+gap, 0],
        [5+gap, 2],
        [4+gap/2, 3+gap],
		[4+gap/2, 5],
		[6+gap/2, 6],
		[6+gap/2, 10],
        [0, 10]
    ];
    slot_top_points = [
        [[4, 24], [4, 30], [6, 30]],
        [[6, 32]],
        [[-6, 32]],
        [[-6, 30], [-4, 30], [-4, 24]]
    ];
    slot_top_path = B_path(slot_top_points);
    
    difference(){
        //shell
        hull(){
            translate([0, 0, 1])
            linear_extrude(4)
                polygon(shell_path);
            
            translate([0, 1, 0])
            resize([18, 28, 6])
            linear_extrude(6)
                polygon(shell_path);
        }
        
        //main slot
        translate([0, 31, -2])
        rotate([90, 0, 0])
        linear_extrude(21)
            polygon(slot_path);
        
        //slot bottom
        translate([0, 10, -2])
        rotate_extrude(angle=360, $fn=fn)
            polygon(slot_bottom_path);
        
        //slot top
        translate([0, 0, -1])
        linear_extrude(8)
            polygon(slot_top_path);
        
        //pin holes
        translate([8, 8, 1])
            cylinder(r=1, h=6, $fn=16);
        translate([-8, 8, 1])
            cylinder(r=1, h=6, $fn=16);
        translate([8, 26, 1])
            cylinder(r=1, h=6, $fn=16);
        translate([-8, 26, 1])
            cylinder(r=1, h=6, $fn=16);
    }
}

//retains belt clip knob
module belt_clip_spring(){
    fn = $preview?32:64;
    bump_height = 3;
    
    difference(){
        union(){
            translate([0, 10, 0])
                cylinder(r=4-gap/2, h=5, $fn=fn);
            translate([-4+gap/2, 10, 0])
                cube([2*(4-gap/2), 40-gap, 5]);
        }
        
        translate([-11, 46, 3])
        rotate([0, 90, 0])
            cylinder(r=1, h=22, $fn=16);
        translate([-11, 36, 3])
        rotate([0, 90, 0])
            cylinder(r=1, h=22, $fn=16);
        
        cutout_path = [
            [12, 0],
            [15, 3],
            [31, 3],
            [34, 0],
            [34, -1],
            [12, -1]
        ];
        
        translate([-5, 0, 0])
        rotate([90, 0, 90])
        linear_extrude(10)
            polygon(cutout_path);
    }
    
    //bump to catch knob for retension
    translate([0, 10, (bump_height+5)/2])
    resize([2*(4-gap/2), 2*(4-gap/2), bump_height+5])
        sphere(r=4-gap/2, $fn=fn);
}

//central belt clip part
module belt_clip_body(){
    fn = $preview?32:64;
    //draw shell
    shell_points = [
        [[-10, 66], [-10, 70], [-6, 70]],
        [[6, 70], [10, 70], [10, 66]],
        [[10, 8], [10, 0], [2, 0]],
        [[-2, 0], [-10, 0], [-10, 8]]
    ];
    shell_path = B_path(shell_points, fn=fn);
    
    difference(){
        //main shell
        hull(){
            translate([0, 0, 1])
            linear_extrude(4)
                polygon(shell_path);
            
            translate([0, 1, 0])
            resize([18, 68, 6])
            linear_extrude(6)
                polygon(shell_path);
        }
        
        //guide slot
        translate([0, 10, 5])
            cylinder(r=6+gap/2, h=2, $fn=fn);
        translate([-6-gap/2, 10, 5])
            cube([2*(6+gap/2), 70, 2]);
        
        //slot for spring
        translate([0, 10, -0.5])
            cylinder(r=4+gap/2, h=6, $fn=fn);
        translate([-4-gap/2, 10, -0.5])
            cube([2*(4+gap/2), 40, 6]);
        
        //pin holes for face
        translate([8, 8, 1])
            cylinder(r=1, h=6, $fn=16);
        translate([-8, 8, 1])
            cylinder(r=1, h=6, $fn=16);
        translate([8, 26, 1])
            cylinder(r=1, h=6, $fn=16);
        translate([-8, 26, 1])
            cylinder(r=1, h=6, $fn=16);
            
        //pin holes for spring
        translate([-11, 46, 3])
        rotate([0, 90, 0])
            cylinder(r=1, h=22, $fn=16);
        translate([-11, 36, 3])
        rotate([0, 90, 0])
            cylinder(r=1, h=22, $fn=16);
            
        //pin holes for belt hook
        translate([7, 66, -1])
            cylinder(r=1, h=6, $fn=16);
        translate([-7, 66, -1])
            cylinder(r=1, h=6, $fn=16);
        translate([7, 58, -1])
            cylinder(r=1, h=6, $fn=16);
        translate([-7, 58, -1])
            cylinder(r=1, h=6, $fn=16);
    }
}

//part that hooks into a belt
module belt_clip_hook(){
    fn = $preview?32:64;
    //outline of hook
    outline_points = [
        [[-10, 66], [-10, 70], [-6, 70]],
        [[6, 70], [10, 70], [10, 66]],
        [[10, 8], [10, 0], [2, 0]],
        [[-2, 0], [-10, 0], [-10, 8]]
    ];
    outline_path = B_path(outline_points, fn=fn);
    profile_path = [
        [0, 0],
        [0, 2],
        [10, 5],
        [10, 2],
        [54, 2],
        [54, 8],
        [70, 8],
        [70, 0]
    ];
    
    difference(){
        intersection(){
            hull(){
                translate([0, 0, 1])
                linear_extrude(6)
                    polygon(outline_path);
                
                translate([0, 1, 0])
                resize([18, 68, 8])
                linear_extrude(8)
                    polygon(outline_path);
            }
            
            translate([-10, 0, 0])
            rotate([90, 0, 90])
            linear_extrude(20)
                polygon(profile_path);
        }
        
        //pin holes for belt hook
        translate([7, 66, 3])
            cylinder(r=1, h=6, $fn=16);
        translate([-7, 66, 3])
            cylinder(r=1, h=6, $fn=16);
        translate([7, 58, 3])
            cylinder(r=1, h=6, $fn=16);
        translate([-7, 58, 3])
            cylinder(r=1, h=6, $fn=16);
    }
}

module complete_model(){
    color("gray") translate([0, 50, 0]) belt_clip_knob();
    color("#ccc") translate([0, 0, 0]) belt_clip_face();
    color("orange") translate([30, 0, 10]) belt_clip_spring();
    color("gray") translate([30, 0, 0]) belt_clip_body();
    color("gray") translate([60, 0, 0]) belt_clip_hook();
}

//slice a model up for rendering and printing
module render_model(render_model_name){
    if(render_model_name=="belt_clip_knob"){
        belt_clip_knob();
    }else if(render_model_name=="belt_clip_face"){
        belt_clip_face();
    }else if(render_model_name=="belt_clip_spring"){
        belt_clip_spring();
    }else if(render_model_name=="belt_clip_body"){
        belt_clip_body();
    }else if(render_model_name=="belt_clip_hook"){
        belt_clip_hook();
    }
}

if(is_undef(render_model_name)){
	complete_model();
}else{
	render_model(render_model_name);
}