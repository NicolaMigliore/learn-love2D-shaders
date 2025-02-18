require 'globals'

local colorReplace = require 'src.scenes.colorReplace'
local movingLights = require 'src.scenes.movingLights'
local torches = require 'src.scenes.torches'
local scenes = {
    colorReplace,
    movingLights,
    torches,
}
local sceneIndex = 3
CurrentScene = nil



function love.load()
    love.graphics.setDefaultFilter('nearest')
    love.graphics.setBackgroundColor(.2, .2, .3)
    Img = love.graphics.newImage('assets/target.png')
    Shader = love.graphics.newShader('shaders/simpleLighting.fs')
    ColorReplaceShader = love.graphics.newShader('shaders/colorReplace.fs')
    LightsShader = love.graphics.newShader('shaders/lights.fs')

    CurrentScene = LoadScene(sceneIndex)
end

function love.update(dt)
    scenes[sceneIndex]:update(dt)
end

function love.draw()
    scenes[sceneIndex]:draw()
end

function love.keyreleased(k)
    if k == 'r' then
        love.event.quit('restart')
    elseif k == 'escape' then
        love.event.quit()
    elseif k == 'right' then
        sceneIndex = sceneIndex + 1
        if sceneIndex > #scenes then
            sceneIndex = 1
        end
        scenes[sceneIndex]:loadScene()
    elseif k == 'left' then
        sceneIndex = sceneIndex - 1
        if sceneIndex < 1 then
            sceneIndex = #scenes
        end
        scenes[sceneIndex]:loadScene()
    end
end

function LoadScene(index)
    CurrentScene = scenes[index]
    CurrentScene:loadScene()
end