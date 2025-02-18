local MovingLightsScene = Object:extend()
local lights = {
    { position = { 100, 10 },  diffuse = { .6, .6, 1 },  power = 20 },
    { position = { 100, 450 }, diffuse = { .5, .7, 1 },  power = 20 },
    { position = { 750, 500 }, diffuse = { .7, .7, .4 }, power = 20 }
}
local ball = {
    position = { 400, 300 }
}
function MovingLightsScene:loadScene()
end
function MovingLightsScene:update(dt)
    -- move ball
    local centerX = 400
    local amplitude = 400
    local speed = 1 --dt * 10
    local newX = centerX + math.sin(love.timer.getTime() * speed) * amplitude
    ball.position[1] = newX

    -- move light
    speed = 3
    newX = centerX + math.sin(love.timer.getTime() * speed) * amplitude
    lights[1].position[1] = newX
end
function MovingLightsScene:draw()
    local screenW, screenH = love.graphics.getWidth(), love.graphics.getHeight()
    -- configure shader
    love.graphics.setShader(Shader)
    Shader:send('screenSize', { screenW, screenH })

    Shader:send('num_lights', #lights)
    for i, light in ipairs(lights) do
        Shader:send('lights[' .. (i - 1) .. '].position', light.position)
        Shader:send('lights[' .. (i - 1) .. '].diffuse', light.diffuse)
        Shader:send('lights[' .. (i - 1) .. '].power', light.power)
    end

    love.graphics.setColor(.2, .3, .2)
    love.graphics.rectangle('fill', 0, 0, screenW, screenH)

    love.graphics.draw(Img, 336, 170, 0, 2)
    love.graphics.setColor(1, 1, 1)
    love.graphics.circle('fill', ball.position[1], ball.position[2], 50)
    love.graphics.setShader()

    -- write title
    love.graphics.print('Moving Lights', 10, 10)
end

return MovingLightsScene