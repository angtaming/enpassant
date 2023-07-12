event_inherited();

active = true;
visible = true;

time_random_adj = random(999999);

x_vel = 0;
y_vel = 0;

vibratecount = 0;

start_time_dmg = 0;

if(global.level == 5)
{
	start_hp = 50;
}
else
{
	start_hp = 18;
}

hp = start_hp;
rage = 1-(hp/start_hp);

instance_create_layer(x, y, "Instances", obj_bigsword, {master: id});

function move()
{
	apply_force(0.2 + (0.2 * rage), point_direction(x, y, obj_player.x, obj_player.y))
	
	x += x_vel;
	y += y_vel;
	
	image_angle = sin(get_timer()/250000 + time_random_adj) * sqrt(power(x_vel, 2) + power(y_vel, 2)) * 2;	

	x_vel = lerp(x_vel, 0, 0.2);
	y_vel = lerp(y_vel, 0, 0.2);

	bounds();
	//exclude();
}

//functions
function apply_force(mag, dir)
{
	x_vel += lengthdir_x(mag, dir);
	y_vel += lengthdir_y(mag, dir);
}

function bounds()
{
	if(bbox_right > room_width) apply_force(5, 180);
	if(bbox_left < 0) apply_force(5, 0);	
	if(bbox_bottom > room_height) apply_force(5, 90);	
	if(bbox_top < 0) apply_force(5, 270);	
}

function exclude()
{
	if(instance_number(par_enemy) > 1)
	{
		var excluder = instance_nth_nearest(x, y, par_enemy, 2);
		if(distance_to_point(excluder.x, excluder.y) < 16 && excluder.active)
		{;
			var mag = 1/distance_to_point(excluder.x, excluder.y);
			mag = clamp(mag, 0, 1);
			apply_force(mag, point_direction(excluder.x, excluder.y, x, y));
		}
	}
}

function damage(dmg)
{
	//check immunity
	if(get_timer() - start_time_dmg > 0.25 * power(10, 6))
	{
		start_time_dmg = get_timer();
		audio_play_sound(sfx_slap, 1, false);
		hp -= dmg;
		if(hp <= 0)
		{
			active = false;
			anchor_x = x;
			image_index++;
		}
	}
}

