require ("game")

local physics = require("physics")
physics.start()
physics.setGravity( 0, 0 )

scrap = 0
metal = 1000
alienmetal = 1000

 ships = {}
 alienships = {}
 explosions = {}
 tapCount = 0
 aliencount = 0

 humanShipsCollide = {categoryBits = 1, maskBits = 11}
 alienshipsCollide = {categoryBits = 2, maskBits = 7}
 earthCollide = {categoryBits = 4, maskBits = 14}
 alienBaseCollide = {categoryBits = 8, maskBits = 13}
 eathFixCollide = {categoryBits = 27, maskBits = 27}
 alienBaseFixCollide = {categoryBits = 32, maskBits = 37}

alienbaseX = 850
alienbaseY = 195

earthX = 20
earthY = 195




 game = 0





local playButton = display.newImage( "playbutton.png", 200, 195 )
playButton.collision = function ( event, self )
	startLevel (1)
	game =1
	event.target:removeSelf()
	--playbutton = 0
end
playButton:addEventListener ("touch", playButton.collision)



function screenTap ( event )
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















function everyFrame(  )
	if game == 1
		then
	rocketVelocity ()
	makeAlienShip ()
	tentaclesVelocity ()
	display.remove(earthxp)
	earthxp = display.newText( earth.xp , 40, 400, native.systemFont, 40 )
	display.remove(alienbasexp)
	alienbasexp = display.newText( alienbase.xp , 300, 400, native.systemFont, 40 )
	
	end
	print ("time is " .. system.getTimer())

	

	display.remove(metalscreen)
	metalscreen = display.newText( "metal is " .. metal , 80, 10, native.systemFont, 20 )

	
	

	if (system.getTimer() % 5 >= 0 and system.getTimer() % 5 < 1) then metal = metal + 1 end
	

	display.remove(times)
	times = display.newText( system.getTimer() , 150, 400, native.systemFont, 40 )
	--myText:setFillColor( 1, 110/255, 110/255 )

end

--обработчики
Runtime:addEventListener( "enterFrame", everyFrame)
display.currentStage:addEventListener("touch", screenTap)