io.stdout:setvbuf("no")

local socket = require("socket")

-- Global variables
-- WINDOW variables --
local widthm = 800
local heightm = 600
local widthM, heightM = nil
local isFullscreen = true

-- Player
local Player = {}
Player.x = 0
Player.y = 0
Player.vy = 0
Player.img = love.graphics.newImage("imgs/Player.png")
Player.bullets = {}

local bulletLaunchSound = love.audio.newSource("snds/Bullet_launch.ogg")

-- Meteorit
local Meteorit = {}
Meteorit.x = 0
Meteorit.y = 0
Meteorit.vx = 0
Meteorit.img = love.graphics.newImage("imgs/Meteorits/Meteorit_0.png")

-- Help functions
function setFullscreen()
  
  if isFullscreen == true then
    isFullscreen = false
    love.window.setMode(widthm, heightm, {resizable=false})
  elseif isFullscreen == false then
    isFullscreen = true
  end
  
end

-- Functions
function createBullet(name, x, y)

  if name == "PlayerBullet" then
    local PlayerBullet = {}
    PlayerBullet.x = Player.x + 32
    PlayerBullet.y = Player.y + 9
    PlayerBullet.vx = 6 
    PlayerBullet.img = love.graphics.newImage("imgs/Bullets/PlayerBullet.png")
    
    table.insert(Player.bullets, PlayerBullet)
  end

end

-- Main functions
function love.load()
  
  -- Initialize the window
  love.window.setTitle("Horizontal Shooter")
  love.window.setMode(widthm, heightm, {resizable=false})
  
  -- Initialize the player
  Player.x = 100
  Player.y = heightm / 2 - Player.img:getHeight()
  
end

local keyPressed = false
local createBulletTime = 0
local currentCreateBulletTimer = 0
function love.update(dt)
  
  --* KEYBOARD *--
  keyPressed = false
  
  if love.keyboard.isDown("escape") then love.window.close() end
  --if love.keyboard.isDown("f11") then 
    --setFullscreen()
    --love.window.setFullscreen(isFullscreen)
    --love.timer.sleep(0.1)
  --end
  --* PLAYER MOVEMENTS *--
  if love.keyboard.isDown("up") then -- UP The player
    if Player.vy <= 3 then
      Player.vy = Player.vy + 0.1
      keyPressed = true
    end
  end
  if love.keyboard.isDown("down") then -- DOWN The player
    if Player.vy >= -3 then
      Player.vy = Player.vy - 0.1
      keyPressed = true
    end
  end
  
  --* PLAYER SHOOT *--
  if love.keyboard.isDown("space") then
    currentCreateBulletTime = love.timer.getTime()
    
    -- Create the bullet if it's more than 0.40 sec
    if currentCreateBulletTime - createBulletTime >= 0.40 then
      createBullet("PlayerBullet", Player.x, Player.y)
      createBulletTime = love.timer.getTime()
      love.audio.play(bulletLaunchSound)
    end
  end
  
  -- Restablish the velocity
  if keyPressed == false then
    if Player.vy > 0 then
      Player.vy = Player.vy - 0.1
    elseif Player.vy < 0 then
      Player.vy = Player.vy + 0.1
    end
  end
  
  Player.y = Player.y - Player.vy
  
  
  -- Change the Player position
  if (Player.collideUp and keySimPressed == "down") then
    Player.y = Player.y - Player.vy
  elseif (Player.collideDown and keySimPressed == "up") then
    Player.y = Player.y - Player.vy
  elseif (Player.collideDown == false and Player.collideUp == false) then
    Player.y = Player.y - Player.vy
  end
  
  --* BULLETS *--
  for i=1, #Player.bullets do
    if Player.bullets[i].vx >= 3 then
      Player.bullets[i].vx = Player.bullets[i].vx - 0.2
    end
  end
  
  for i=1, #Player.bullets do
    Player.bullets[i].x = Player.bullets[i].x + Player.bullets[i].vx
  end
  
end

function love.draw()
  
  -- Draw the player
  love.graphics.draw(Player.img, Player.x, Player.y)
  
  -- Draw the bullets
  for i=1, #Player.bullets do
    local bullet = Player.bullets[i]
    love.graphics.draw(bullet.img, bullet.x, bullet.y)
  end
  
end
