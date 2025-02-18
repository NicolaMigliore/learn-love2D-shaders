local TorchesScene = Object:extend()
local lights = {
    { position = { 100, 10 }, diffuse = { .6, .6, 1 }, power = 20 },
}

function TorchesScene:loadScene()
    self.backgroundImg = love.graphics.newImage('assets/map.png')

    local torchSprite = love.graphics.newImage('assets/torch.png')
    local treeSprite = love.graphics.newImage('assets/tree.png')
    local bushSprite = love.graphics.newImage('assets/bush.png')
    local houseSprite = love.graphics.newImage('assets/house.png')

    -- Define entities
    self.entities = {
        { type = 'torch', position = { x = 104, y = 480, s = 1 }, sprite = torchSprite },
        { type = 'torch', position = { x = 428, y = 537, s = 1 }, sprite = torchSprite },
        { type = 'torch', position = { x = 320, y = 192, s = 1 }, sprite = torchSprite },
        { type = 'torch', position = { x = 228, y = 307, s = 1 }, sprite = torchSprite },
        { type = 'torch', position = { x = 643, y = 279, s = 1 }, sprite = torchSprite },
        { type = 'tree',  position = { x = 100, y = 100, s = 1 }, sprite = treeSprite },
        { type = 'tree',  position = { x = 549, y = 498, s = 1 }, sprite = treeSprite },
        { type = 'tree',  position = { x = 637, y = 198, s = 1 }, sprite = treeSprite },
        { type = 'bush',  position = { x = 735, y = 529, s = 1 }, sprite = bushSprite },
        { type = 'bush',  position = { x = 397, y = 287, s = 1 }, sprite = bushSprite },
        { type = 'house', position = { x = 110, y = 370, s = 2 }, sprite = houseSprite },
        { type = 'house', position = { x = 206, y = 102, s = 2 }, sprite = houseSprite },
        { type = 'house', position = { x = 440, y = 300, s = 2 }, sprite = houseSprite },
    }

    -- Define light sources
    self.lights = {
        -- sun = {
        --     position = { x = 1200, y = 350 },
        --     diffuse = { .96, .78, .76 },
        --     power = 5,
        -- },
        -- moon = {
        --     position = { x = -100, y = 350 },
        --     diffuse = { .3, .3, 1 },
        --     power = 10,
        -- },
        torches = {}
    }

    for _, ent in ipairs(self.entities) do
        if ent.type == 'torch' then
            print(ent.position.x)
            table.insert(self.lights.torches, {
                position = { x = ent.position.x + 8, y = ent.position.y + 12 },
                diffuse = { .8, .5, .4 },
                power = 300
            })
        end
    end

    self.time = 0
    self.normTime = 1
    self.dayLength = 12
    self.day = 1
    self.phase = 'sun'
    self.globalDiffuse = { .01, .01, .1 }
end

function TorchesScene:update(dt)
    -- Advance time
    self.time = self.time + dt
    if self.time > self.dayLength then
        self.time = 0
        self.day = self.day + 1
    end

    -- Normalized time (0 to 1)
    self.normTime = self.time / self.dayLength

    self:advanceGlobalDiffuse()
end

function TorchesScene:draw()
    -- configure shader
    local screenW, screenH = love.graphics.getWidth(), love.graphics.getHeight()
    LightsShader:send('screenSize', { screenW, screenH })
    LightsShader:send('num_lights', #self.lights.torches)
    LightsShader:send('globalDiffuse', self.globalDiffuse)

    local keyIndex = 0
    for key, light in pairs(self.lights) do
        if key == 'torches' then
            local torches = light
            for torchIndex, torch in ipairs(torches) do
                LightsShader:send('lights[' .. (keyIndex + torchIndex - 1) .. '].position',
                    { torch.position.x, torch.position.y })
                LightsShader:send('lights[' .. (keyIndex + torchIndex - 1) .. '].diffuse', torch.diffuse)
                LightsShader:send('lights[' .. (keyIndex + torchIndex - 1) .. '].power', torch.power)
            end
        end
    end

    love.graphics.setShader(LightsShader)

    -- draw scene
    love.graphics.draw(self.backgroundImg, 0, 0)

    -- draw entities
    for _, ent in ipairs(self.entities) do
        love.graphics.draw(ent.sprite, ent.position.x, ent.position.y, 0, ent.position.s)
    end

    love.graphics.setShader()

    -- write title
    love.graphics.print('Torches', 10, 10)

    -- draw clock
    local r = 25
    local clockX, clockY = screenW - 50, 30
    local ang1 = -math.pi / 2
    local ang2 = (2 * math.pi * self.normTime) - math.pi / 2
    love.graphics.setColor(.8, .8, .2)
    love.graphics.circle('fill', clockX, clockY, r)
    love.graphics.setColor(.3, .3, 1)
    love.graphics.arc('fill', clockX, clockY, r, ang1, ang2, self.dayLength)
    love.graphics.setColor(.8, .8, .8)
    love.graphics.setLineWidth(3)
    love.graphics.circle('line', clockX, clockY, r)
    love.graphics.setLineWidth(1)
    love.graphics.setColor(.1, .1, .1)
    love.graphics.print(self.day, clockX - 5, clockY - 10)
    love.graphics.setColor(1, 1, 1)

    -- -- draw diffuse values
    -- local barW = 50
    -- local red, green, blue = unpack(self.globalDiffuse)
    -- love.graphics.setColor(.4, .4, .4)
    -- love.graphics.rectangle('fill', screenW - 75, 60, barW, 10)
    -- love.graphics.rectangle('fill', screenW - 75, 75, barW, 10)
    -- love.graphics.rectangle('fill', screenW - 75, 90, barW, 10)

    -- love.graphics.setColor(red, 0, 0)
    -- love.graphics.rectangle('fill', screenW - 75, 60, barW * red, 10)
    -- love.graphics.setColor(0, green, 0)
    -- love.graphics.rectangle('fill', screenW - 75, 75, barW * green, 10)
    -- love.graphics.setColor(0, 0, blue)
    -- love.graphics.rectangle('fill', screenW - 75, 90, barW * blue, 10)
    -- love.graphics.setColor(1, 1, 1)
end

function TorchesScene:advanceGlobalDiffuse()
    local rads = self.normTime * (math.pi * 2)
    rads = rads - math.pi / 2 -- shift rads to match time of day

    -- Calc red diffuse
    local red = math.sin(rads)
    local normRed = (red + 1) / 2
    red = .1 + (.96 - .1) * normRed -- scale and shift to range [.01,.96]

    -- Calc green diffuse
    local green = math.sin(rads)
    local normGreen = (green + 1) / 2
    green = .3 + (.78 - .3) * normGreen -- scale and shift to range [.01,.78]

    -- Calc blue diffuse
    local blue = math.sin(rads)
    local normBlue = (blue + 1) / 2
    blue = .65 + (.78 - .65) * normBlue -- scale and shift to range [.3,.78]

    self.globalDiffuse[1] = red
    self.globalDiffuse[2] = green
    self.globalDiffuse[3] = blue
end

return TorchesScene
