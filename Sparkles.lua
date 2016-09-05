-- The majority of this code is from scoreboard.lua

Sparkle_Mouse =
{
};

registerWidget("Sparkle_Mouse");
--------------------------------------------------------------------------------
local SPARKS_MAX = 64;

local SparksEmitter =
{
	sparks = {},
	nextIn = 0,
};

-- init sparks table so we're not allocating later
for i = 0, SPARKS_MAX-1 do
	SparksEmitter.sparks[i] = {};
	SparksEmitter.sparks[i].t = 90000;
	SparksEmitter.sparks[i].x = 0;
	SparksEmitter.sparks[i].y = 0;
	SparksEmitter.sparks[i].r = 0;
	SparksEmitter.sparks[i].vx = 0;
	SparksEmitter.sparks[i].vy = 0;
	SparksEmitter.sparks[i].vr = 0;
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
function SparksEmitter:addSpark(x, y)
	-- add new spark
	self.sparks[self.nextIn].x = x;
	self.sparks[self.nextIn].y = y;
	self.sparks[self.nextIn].r = 0;
	self.sparks[self.nextIn].vx = math.random(-50, -30);
	self.sparks[self.nextIn].vy = math.random(-40, 40);
	self.sparks[self.nextIn].vr = math.random(-2, 2);
	self.sparks[self.nextIn].t = 0;
	self.nextIn = (self.nextIn + 1) % SPARKS_MAX;
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
function SparksEmitter:update(dt)
	for i = 0, SPARKS_MAX-1 do
		--self.sparks[i].vy = self.sparks[i].vy + 600 * dt; -- grav
		self.sparks[i].x = self.sparks[i].x + self.sparks[i].vx * dt;
		self.sparks[i].y = self.sparks[i].y + self.sparks[i].vy * dt;
		self.sparks[i].r = self.sparks[i].r + self.sparks[i].vr * dt;
		self.sparks[i].t = self.sparks[i].t + dt;
	end
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
function SparksEmitter:draw(dt)
	local c = {};
	local lifeTime = .7;

	for i = 0, SPARKS_MAX-1 do
		local s = self.sparks[i];
		local life = s.t / lifeTime;	-- life goes 0->1 (this it's dead)
		if life < 1 then
			c.r = lerp(238, 232, life);
			c.g = lerp(185, 23, life);
			c.b = lerp(87, 32, life);
			c.a = lerp(255, 0, life);

			local scale = math.min(c.a / 256, (255 - c.a) / 4);

			nvgSave();
			nvgTranslate(s.x, s.y);
			nvgScale(scale, scale);
			nvgRotate(s.r);
			nvgBeginPath();
			nvgRoundedRect(-2, -2, 4, 4, 1);
			nvgFillColor(c);
			nvgFill();
			nvgRestore();
		end
	end
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
local EXPLOSION_MAX = 256;

local ExplosionEmitter =
{
	Explosion = {},
	nextIn = 0,
};

-- init Explosion table so we're not allocating later
for i = 0, EXPLOSION_MAX-1 do
	ExplosionEmitter.Explosion[i] = {};
	ExplosionEmitter.Explosion[i].t = 90000;
	ExplosionEmitter.Explosion[i].x = 0;
	ExplosionEmitter.Explosion[i].y = 0;
	ExplosionEmitter.Explosion[i].r = 0;
	ExplosionEmitter.Explosion[i].vx = 0;
	ExplosionEmitter.Explosion[i].vy = 0;
	ExplosionEmitter.Explosion[i].vr = 0;
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
function ExplosionEmitter:addSpark(x, y)
	-- add new spark
	self.Explosion[self.nextIn].x = x;
	self.Explosion[self.nextIn].y = y;
	self.Explosion[self.nextIn].r = 0;
	self.Explosion[self.nextIn].vx = math.random(-50, 50);
	self.Explosion[self.nextIn].vy = math.random(-100, -40);
	self.Explosion[self.nextIn].vr = math.random(-2, 2);
	self.Explosion[self.nextIn].t = math.random(0, .5);
	self.nextIn = (self.nextIn + 1) % EXPLOSION_MAX;
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
function ExplosionEmitter:update(dt)
	for i = 0, EXPLOSION_MAX-1 do
		self.Explosion[i].vy = self.Explosion[i].vy + 100 * dt; -- grav
		self.Explosion[i].x = self.Explosion[i].x + self.Explosion[i].vx * dt;
		self.Explosion[i].y = self.Explosion[i].y + self.Explosion[i].vy * dt;
		self.Explosion[i].r = self.Explosion[i].r + self.Explosion[i].vr * dt;
		self.Explosion[i].t = self.Explosion[i].t + dt;
	end
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
function ExplosionEmitter:draw(dt)
	local c = {};
	local lifeTime = 3;

	for i = 0, EXPLOSION_MAX-1 do
		local s = self.Explosion[i];
		local life = s.t / lifeTime;	-- life goes 0->1 (this it's dead)
		if life < 1 then
			c.h = lerp(255, 0, life/32);
			c.s = lerp(1, 0.25, life/2);
			c.v = lerp(1, 0.25, life/2);
			c = hsvToRgb(c)
			c.a = round(lerp(255, 0, life*4));
			local scale = math.min(lerp(1, 0, life));

			table.insert(c, c.a)
			nvgSave();
			nvgTranslate(s.x, s.y);
			nvgScale(scale, scale);
			nvgRotate(s.r);
			nvgBeginPath();
			nvgRect(-2, -2, 4, 4);
			nvgFillColor(c);
			nvgFill();
			nvgRestore();
		end
	end
end


function Sparkle_Mouse:draw()
	if not isInMenu() then return end;

	local m = mouseRegion(viewport.width, viewport.height, viewport.width, viewport.height);

	local ix = m.mousex;
	local iy = m.mousey;
	for i = 1, 5 do
		ExplosionEmitter:addSpark(
		math.random(ix - 5, ix + 5),
		math.random(iy - 5, iy + 5)+5);
	end

	-- spark timer
	if self.sparkTimer == nil then
		self.sparkTimer = 0;
	end
	self.sparkTimer = self.sparkTimer + deltaTimeRaw;
	self.sparkTimer = math.min(self.sparkTimer, .5);
	self.sparkFrame = false;
	if self.sparkTimer > .05 then
		self.sparkFrame = true;
		self.sparkTimer = 0;
	end

	-- draw sparks on top
	SparksEmitter:update(deltaTimeRaw);
	SparksEmitter:draw();

	-- draw explosions on top
	ExplosionEmitter:update(deltaTimeRaw);
	ExplosionEmitter:draw();
end
