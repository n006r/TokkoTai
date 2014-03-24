local physics = require("physics")
physics.start()
physics.setGravity( 0, 0 )

scrap = 0
metal = 1000
alienmetal = 1000

local ships = {}
local alienships = {}
local tapCount = 0
local aliencount = 0

local humanShipsCollide = {categoryBits = 1, maskBits = 11}
local alienshipsCollide = {categoryBits = 2, maskBits = 7}
local earthCollide = {categoryBits = 4, maskBits = 14}
local alienBaseCollide = {categoryBits = 8, maskBits = 13}

--создаем землю
earthX = 20
earthY = 195

local earth = display.newImage( "earth.png", earthX, earthY )
earth.xp = 100
physics.addBody ( earth,"static", { friction=0.5, bounce=0.3, filter = earthCollide } )
earth.collision = function ( self, event ) 
							print ("EARTH COLLIDE")
							earth.xp = earth.xp - 1
							if (earth.xp == 0 ) then
								earth = 0 
								self:removeSelf()
							end
						end
earth:addEventListener( "collision", earth)


--создаем вражеский корабль
alienbaseX = 850
alienbaseY = 195
local alienbase = display.newImage( "deathstar.png",alienbaseX, alienbaseY )
alienbase.xp = 100
physics.addBody( alienbase,"static", { friction=0.5, bounce=0.3, filter = alienBaseCollide } )
alienbase.collision = function ( self, event ) 
							print ("ALIENBASE COLLIDE")
							alienbase.xp = alienbase.xp - 1
							if (alienbase.xp == 0 ) then
								alienbase = 0 
								self:removeSelf()
							end
						end
alienbase:addEventListener( "collision", alienbase)
alienbase.name = "alienbase"





local function screenTap ( event )
	print ("SCREENTAP")
	print (event.phrase)

	if ( event.phase == "began" ) then

	--функция по-сути конструктор нового корабля. Здесь он должен создаваться, ему даются функции
	if (metal >= 10) then
		metal = metal - 10
	tapCount = tapCount + 1
	local i = tapCount
	print ("this is " .. i .. " tap")
	makeShip(i)
end

	
	end
end

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
								makeScrap (self.x, self.y)
								ships[self.number] = 0 
								self:removeSelf()
							end

							if (event.other.name == "alienbase") then
								
								ships[self.number] = 0 
								self:removeSelf()
							end
						end
	--обработчик на столкновения
	ships[i]:addEventListener( "collision", ships[i])
end

--создаем инопланетные корабли
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
								alienships[self.number] = 0 
								self:removeSelf()
							end
						end
	--обработчик на столкновения
	alienships[i]:addEventListener( "collision", alienships[i])
end
end
end


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


--данная функция должна вызывать просчет движения у каждой ракеты в массиве ships
local function rocketVelocity ()
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

local function tentaclesVelocity ()
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





function everyFrame(  )
	rocketVelocity ()
	makeAlienShip ()
	tentaclesVelocity ()
	print ("time is " .. system.getTimer())
	display.remove(earthxp)
	earthxp = display.newText( earth.xp , 40, 400, native.systemFont, 40 )

	display.remove(metalscreen)
	metalscreen = display.newText( "metal is " .. metal , 80, 10, native.systemFont, 20 )

	display.remove(alienbasexp)
	alienbasexp = display.newText( alienbase.xp , 300, 400, native.systemFont, 40 )

	if (system.getTimer() % 5 >= 0 and system.getTimer() % 5 < 1) then metal = metal + 1 end
	

	display.remove(times)
	times = display.newText( system.getTimer() , 150, 400, native.systemFont, 40 )
	--myText:setFillColor( 1, 110/255, 110/255 )

end

--обработчики
Runtime:addEventListener( "enterFrame", everyFrame)
display.currentStage:addEventListener("touch", screenTap)