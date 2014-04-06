
--*********************************
--функция которая создает взрыв
--*********************************
 function Explosion(who, i, takeornot)
	print ("NUMBER OF EXPLOSION IS" .. i)
local sheetData = { width=25, height=28, numFrames=9, sheetContentWidth=228, sheetContentHeight=28 }
 
  local mySheet = graphics.newImageSheet( "explosion.png", sheetData )
 
  local sequenceData = {
    { name = "normalRun", start=1, count=9, time=800, loopCount = 1 },
  }
 
local animation = display.newSprite( mySheet, sequenceData )

if (who == "human") then
animation.x = ships[i].x  --center the sprite horizontally
animation.y = ships[i].y  --center the sprite vertically


if (takeornot == "takescrap") then
	makeScrap (animation.x, animation.y)
end
end
if (who == "alien") then 
	animation.x = alienships[i].x  --center the sprite horizontally
	animation.y = alienships[i].y  --center the sprite vertically
end
 animation:play()

end

--*****************************************
--функция, создающая инопланетные корабли
--*****************************************
function makeAlienShip ()
	--aliencount = aliencount + 1
	local previousSpawnSum = math.cos ((system.getTimer()-100)/1000) + ((system.getTimer ()-100) /1000)
	local spanwSum = 2 * math.cos (system.getTimer()/1000) + system.getTimer () / 1000
	print ("spawnsum is " .. spanwSum - previousSpawnSum)
		if (spanwSum - previousSpawnSum >= 0.5 ) then
	
		aliencount = aliencount + 1

		if (aliencount % 5 == 0) then
		local i = aliencount / 5
	print ("make " .. i .. "alienship")
	alienships[i] = display.newImage( "ship3.png", alienbaseX, alienbaseY + math.random(-103, 103) )
	alienships[i].rotation = 180
	physics.addBody( alienships[i], { density=3.0, friction=0.5, bounce=0.3, filter = alienshipsCollide } )
	alienships[i].timeStart = system.getTimer()
	alienships[i].number = i
	alienships[i].name = "tentacles"



	--а эта функция выполняется при столкновении корабля с чем-либо (он взрывается)
	alienships[i].collision = function ( self, event ) 
							if (event.other.name ~= "tentacles") then
								Explosion ("alien", i)
								alienships[self.number] = 0 
								self:removeSelf()
							end
						end
	--обработчик на столкновения
	alienships[i]:addEventListener( "collision", alienships[i])
end
end
end


--*********************************************************************************
--функция создающая корабли игрока
--*********************************************************************************
function makeShip (i)
	print ("make " .. i .. "ship")
	ships[i] = display.newImage( "ship3.png", earthX , earthY+ math.random(-104, 104) )
	physics.addBody( ships[i], { density=3.0, friction=0.5, bounce=0.3, filter = humanShipsCollide} )
	ships[i].timeStart = system.getTimer()
	ships[i].number = i
	ships[i].name = "human"



	--а эта функция выполняется при столкновении корабля с чем-либо (он взрывается)
	ships[i].collision = function ( self, event ) 
							if (event.other.name == "tentacles") then
								Explosion ("human", i, "takescrap")
								
								ships[self.number] = 0 
								
								self:removeSelf()
							end

							if (event.other.name == "alienbase") then
								Explosion ("human", i)
								ships[self.number] = 0 
								self:removeSelf()
							end
						end
	--обработчик на столкновения
	ships[i]:addEventListener( "collision", ships[i])
end




--********************************************************************************
--данные функции должны вызывать просчет движения у каждой ракеты в массиве ships и alienships
--*********************************************************************************
function rocketVelocity ()
	for k, v in ipairs (ships) do 
		if (v ~= 0) then
			print ("take " .. k) 
			local delta = system.getTimer () - ships[k].timeStart
	    	
	    	print (ships[k].x .. " , " .. ships[k].y)

				ships[k]:setLinearVelocity((alienbaseX - ships[k].x) / 15000 * (delta * 7) , (alienbaseY - ships[k].y) / 15000 * (delta * 7))
				
				--local angle = math.atan2 (alienbaseY - ships[k].y, alienbaseX - ships[k].x)
				--local angle = ships[k].rotation - math.atan2 (ships[k].x - alienbaseX, ships[k].y - alienbaseY)

				--if (angle <= 0) then angle = angle + 180 end
				--print ("angle is " .. angle)
				--ships[k]:applyTorque (angle)
	     end 
	 end
end

function tentaclesVelocity ()
	for k, v in ipairs (alienships) do 
		if (v ~= 0) then
			print ("take " .. k) 
			local delta = system.getTimer () - alienships[k].timeStart
	    	
	    	--print (ships[k].x .. " , " .. ships[k].y)

				alienships[k]:setLinearVelocity((earthX - alienships[k].x) / 15000 * (delta * 7) , (earthY - alienships[k].y) / 15000 * (delta * 7))
				--alienships[k]:setLinearVelocity(-80, 0)
				--local angle = math.atan2 (alienbaseY - ships[k].y, alienbaseX - ships[k].x)
				--local angle = ships[k].rotation - math.atan2 (ships[k].x - alienbaseX, ships[k].y - alienbaseY)

				--if (angle <= 0) then angle = angle + 180 end
				--print ("angle is " .. angle)
				--ships[k]:applyTorque (angle)
	     end 
	 end
end

--*******************************************************
--создание железа остающегося после уничтожения корабля
--********************************************************
function  makeScrap( x, y )
	scrap = display.newImage( "scrapbig.png", x, y )
	scrap.collision = function ( event, self )
						if ( event.phase == "moved" ) then
							metal = metal + 5
							event.target:removeSelf()
						end
						end
	scrap:addEventListener ("touch", scrap.collision)
end


--***********************************************
--функция создающая уровень
--***********************************************
function startLevel( numlevel )
	--создаем землю
earth = display.newImage( "earth.png", earthX, earthY )
earth.xp = 100
physics.addBody ( earth,  { friction=0.5, density= 1.0, bounce=0.9, filter = earthCollide } )
earthfix1 = display.newImage( "crate.png", 0, 0 )
physics.addBody ( earthfix1,  "static", { friction=0.5, density= 1.0, bounce=0.9, filter = earthFixCollide } )
earthfix2 = display.newImage( "crate.png", 0, 400 )
physics.addBody ( earthfix2,  "static", { friction=0.5, density= 1.0, bounce=0.9, filter = earthFixCollide } )
physics.newJoint( "pulley", earthfix1, earth,  earthfix1.x, earthfix1.y, 20, 110,  0,0,  20, 140)
physics.newJoint( "pulley", earthfix2, earth,  earthfix2.x, earthfix2.y, 20, 290,    earthfix2.x, earthfix2.y,  20, 270)
local myCircle = display.newCircle( 20, 290, 10 )
myCircle:setFillColor( 0.5 )

--[[
physics.addBody ( earth,  { friction=0.5, density= 1.0, bounce=0.9, filter = earthCollide } )
earthfix1 = display.newImage( "crate.png", 0, 0 )
physics.addBody ( earthfix1,  "static", { friction=0.5, density= 1.0, bounce=0.9, filter = earthFixCollide } )
earthfix2 = display.newImage( "crate.png", 0, 400 )
physics.addBody ( earthfix2,  "static", { friction=0.5, density= 1.0, bounce=0.9, filter = earthFixCollide } )
physics.newJoint( "pulley", earth, earthfix1, earthfix1.x, earthfix1.y, 0,  0,   0,    0,  0, 0)
physics.newJoint( "pulley", earth, earthfix2, earthfix2.x, earthfix2.y, 0,400, 350,    0,  0, 0)
]]

earth.collision = function ( event, self ) 
							print ("EARTH COLLIDE")
							earth.xp = earth.xp - 1
							local x = system.getTimer()
							earth:setLinearVelocity( 500, 0 )
							--for count = x, x+4000000, 10000000 do
								--earth:setLinearVelocity( math.sin(x)/x*math.sin(x)*100000, 0)
								--earth.x = math.sin(x)/x*math.sin(x)
								--end
							earth.x = earth.x + 10
							if (earth.xp == 0 ) then
								earth = nil 
								event.target:removeSelf()
							end
						end
earth:addEventListener( "collision", earth.collision)


--создаем вражеский корабль
alienbase = display.newImage( "deathstar.png",alienbaseX, alienbaseY )
alienbase.xp = 100
physics.addBody( alienbase, { friction=0.5, bounce=0.3, filter = alienBaseCollide } )
alienbasefix1 = display.newImage( "crate.png", alienbaseX, 0 )
physics.addBody ( alienbasefix1,  "static", { friction=0.5, density= 1.0, bounce=0.9, filter = alienBaseFixCollide } )
alienbasefix2 = display.newImage( "crate.png", alienbaseX, 400 )
physics.addBody ( alienbasefix2,  "static", { friction=0.5, density= 1.0, bounce=0.9, filter = alienBaseFixCollide } )
physics.newJoint( "pulley", alienbasefix1, alienbase, alienbasefix1.x, alienbasefix1.y,  850, 110,   850,   0,  850, 140)
physics.newJoint( "pulley", alienbasefix2, alienbase, alienbasefix2.x, alienbasefix2.y,  850, 290,   850,   400,  850, 270)
local myCircle = display.newCircle( 850, 290, 10 )
myCircle:setFillColor( 0.5 )
alienbase.collision = function ( event, self ) 
							print ("ALIENBASE COLLIDE")
							alienbase.xp = alienbase.xp - 1
							alienbase:setLinearVelocity(-500, 0 )
							if (alienbase.xp == 0 ) then
								alienbase = nil
								event.target:removeSelf()
							end
						end
alienbase:addEventListener( "collision", alienbase.collision)
alienbase.name = "alienbase"
end


