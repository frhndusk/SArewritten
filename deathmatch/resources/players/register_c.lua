local regwindow

local function getWindowPosition(width, height)
    local screenWidth, screenHeight = guiGetScreenSize()
    local x = (screenWidth / 2) - (width / 2)
    local y = (screenHeight / 2) - (height / 2)

    return x, y, width, height
end

local function isUsernameValid(username)
    return type(username) == 'string' and string.len(username) > 1
end

local function isPasswordValid(password)
    return type(password) == 'string' and string.len(password) > 1
end


addEvent('register-menu:open', true)
addEventHandler('register-menu:open', root, function ()
    --fadecamera part two
    --setCameraMatrix (0, 0, 100, 0, 100, 50)
    --fadeCamera(true)
    --initialize cursor and freeze binds
    showCursor(true, true)
    guiSetInputMode('no binds')

    --menu design
    local x, y, width, height = getWindowPosition(400, 250)
    regwindow = guiCreateWindow(x, y, width, height, 'Register to San Andreas Rewritten', false)
    guiWindowSetMovable(regwindow, false)
    guiWindowSetSizable(regwindow, false)

    local usernameLabel = guiCreateLabel(15, 30, width - 30, 20, 'Username:', false, regwindow)

    local usernameErrorLabel = guiCreateLabel(width - 130, 30, 140, 20, 'Username is required', false, regwindow)
    guiLabelSetColor(usernameErrorLabel, 255, 100, 100)
    guiSetVisible(usernameErrorLabel, false)

    local usernameInput = guiCreateEdit(10, 50, width - 20, 30, '', false, regwindow)

    local passwordLabel = guiCreateLabel(15, 90, width - 30, 20, 'Password:', false, regwindow)

    local passwordErrorLabel = guiCreateLabel(width - 125, 90, 140, 20, 'Password is required', false, regwindow)
    guiLabelSetColor(passwordErrorLabel, 255, 100, 100)
    guiSetVisible(passwordErrorLabel, false)

    local passwordInput = guiCreateEdit(10, 110, width - 20, 30, '', false, regwindow)
    guiEditSetMasked(passwordInput, true)

    local passwordConfirmLabel = guiCreateLabel(15, 150, width - 30, 20, 'Confirm Password:', false, regwindow)

    local passwordConfirmErrorLabel = guiCreateLabel(width - 130, 150, 140, 20, 'Password needs to match!', false, regwindow)
    guiLabelSetColor(passwordConfirmErrorLabel, 255, 100, 100)
    guiSetVisible(passwordConfirmErrorLabel, false)
    
    local passwordConfirmInput = guiCreateEdit(10, 170, width - 20, 30, '', false, regwindow)
    guiEditSetMasked(passwordConfirmInput, true)

    local registerButton = guiCreateButton(10, 190, width - 20, 30, 'Sign Up', false, regwindow)
    addEventHandler('onClientGUIClick', registerButton, function (button, state)
        if button ~= 'left' or state ~= 'up' then
            return
        end

        local username = guiGetText(usernameInput)
        local password = guiGetText(passwordInput)
        local passwordconfirm = guiGetText(passwordConfirmInput)
        local inputValid = true

        if not isUsernameValid(username) then
            guiSetVisible(usernameErrorLabel, true)
            inputValid = false
        else
            guiSetVisible(usernameErrorLabel, false)
        end

        if not isPasswordValid(password) then
            guiSetVisible(passwordErrorLabel, true)
            inputValid = false
        else
            guiSetVisible(passwordErrorLabel, false)
        end

        if not password == passwordconfirm then
            guiSetVisible(passwordConfirmErrorLabel, true)
            inputValid = false
        else
            guiSetVisible(passwordConfirmErrorLabel, false)
        end

        if not inputValid then
            return
        end

        triggerServerEvent('auth:register-attempt', localPlayer, username, password)
    end, false)

    local cancelButton = guiCreateButton(10, 210, width - 20, 30, 'Cancel', false, regwindow)
    addEventHandler('onClientGUIClick', cancelButton, function (button, state)
        if button ~= 'left' or state ~= 'up' then
            return
        end

        triggerEvent('register-menu:close', localPlayer)
        triggerEvent('login-menu:open', localPlayer)
    end, false)
end, true)

addEvent('register-menu:close', true)
addEventHandler('register-menu:close', root, function ()
    destroyElement(regwindow)
    showCursor(false)
    guiSetInputMode('allow_binds')
end) 

    










