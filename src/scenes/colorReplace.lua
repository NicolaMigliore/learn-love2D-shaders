local ColorReplaceScene = Object:extend()

function ColorReplaceScene:loadScene()
end
function ColorReplaceScene:update(dt)
end

function ColorReplaceScene:draw()
    love.graphics.draw(Img, 336, 170, 0, 2)
    DrawWithReplaceColor(Img, 400, 170, 0, 2, '#784ca6', '#bdb957')
    DrawWithReplaceColor(Img, 464, 170, 0, 2, '#3a995a', '#6a232b')

    -- write title
    love.graphics.print('Color Replace', 10, 10)
end

-- @TODO: extend to manage lists of colors
-- Draw image replacing a color
function DrawWithReplaceColor(img, x, y, rotation, scale, sourceColor, replaceColor)
    love.graphics.setShader(ColorReplaceShader)
    local sr, sg, sb = Husl.hex_to_rgb(sourceColor)
    local rr, rg, rb = Husl.hex_to_rgb(replaceColor)
    -- Send data to shader
    ColorReplaceShader:send('sColor', { sr, sg, sb })
    ColorReplaceShader:send('rColor', { rr, rg, rb })

    love.graphics.draw(img, x, y, rotation, scale)

    love.graphics.setShader()
end

return ColorReplaceScene
