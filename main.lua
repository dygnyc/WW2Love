
local timeSinceFrameChange


function love.load()

    love.graphics.setDefaultFilter("nearest")

    --set up character
    character={}
    character.walk = {}
    character.idle={}

    character.state = "IDLE" --default state

    --walk animation
    character.WalkSheet = love.graphics.newImage("player_run-v2-Sheet.png")
    character.walkAnimationQuads = love.graphics.newQuad(0,0,32,32,character.WalkSheet:getDimensions())
    character.walk.frame_number = 11
    character.walk.frame = 1 --current frame
    character.walk.fps = 18
    character.walk.frame_duration = 1/character.walk.fps
    character.walk.xUpdate = 0

    --idle animation
    character.IdleSheet = love.graphics.newImage("player_idle-Sheet.png")
    character.idleAnimationQuads = love.graphics.newQuad(0,0,32,32,character.IdleSheet:getDimensions())  
    character.idle.frame_number = 4
    character.idle.frame = 1 --current frame 
    character.idle.fps = 10
    character.idle.frame_duration = 1/character.idle.fps
    character.idle.xUpdate = 0
    

    sprite = {} --for location
    sprite.x=200
    sprite.y = 200
    sprite.xScale = 1
    sprite.scaleFactor = 2
    sprite.flipOffset = 0
    sprite.moveSpeed = 100

    timeSinceFrameChange = 0

end


function love.update(dt)
    --IDLE state
   if  character.state == "IDLE" then
    idleAnimation(dt)
   end
    --WALK state
    if love.keyboard.isDown('right') or love.keyboard.isDown('left') then
        
        if love.keyboard.isDown('right') then
            sprite.x = sprite.x + sprite.moveSpeed *dt
            sprite.xScale = 1
            sprite.flipOffset = 0
            character.state="WALK"
        elseif  love.keyboard.isDown('left') then
            sprite.x = sprite.x - sprite.moveSpeed *dt
            sprite.xScale = -1
            sprite.flipOffset = 32
            character.state="WALK"
        end
            
        timeSinceFrameChange = timeSinceFrameChange + dt

        --update frame
        if timeSinceFrameChange> character.walk.frame_duration then
            character.walk.frame = character.walk.frame+1
            timeSinceFrameChange = 0

            if character.walk.frame > character.walk.frame_number then
                character.walk.frame = 1
            end
            
            character.walk.xUpdate = 32 * (character.walk.frame -1)
            character.walkAnimationQuads:setViewport(character.walk.xUpdate,0,32,32)
        end
    else --if not moving, then idle
        character.state ="IDLE"
    
    end
end

function love.draw()

    if character.state=="WALK" then

        love.graphics.draw(character.WalkSheet,character.walkAnimationQuads,
        sprite.x+(sprite.flipOffset*sprite.scaleFactor) ,
        sprite.y,
        0, --rotation
        sprite.scaleFactor*sprite.xScale,sprite.scaleFactor)
    elseif character.state =="IDLE" then
        love.graphics.draw(character.IdleSheet,character.idleAnimationQuads,
        sprite.x+(sprite.flipOffset*sprite.scaleFactor) ,
        sprite.y,
        0, --rotation
        sprite.scaleFactor*sprite.xScale,sprite.scaleFactor)

    end

end

function idleAnimation(dt)
    timeSinceFrameChange = timeSinceFrameChange + dt

    --update frame
    if timeSinceFrameChange>character.idle.frame_duration then
        character.idle.frame = character.idle.frame+1
        timeSinceFrameChange = 0

        if character.idle.frame > character.idle.frame_number then
            character.idle.frame = 1
        end
        
        character.idle.xUpdate = 32 * (character.idle.frame -1)
        character.idleAnimationQuads:setViewport(character.idle.xUpdate,0,32,32)
    end
end


