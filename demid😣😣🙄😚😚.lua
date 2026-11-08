local Environment = getgenv()

local GuardConfig = {
    LoadTimeout = 20,
    ScanBudget = 12,
    SliceTime = 0.006,
    SliceStep = 512,
}

local LogMask = {
    "hookmetamethod", "hookfunction", "getnamecallmethod", "setnamecallmethod",
    "newcclosure", "getrawmetatable", "setrawmetatable", "checkcaller",
    "getgenv", "getsenv", "getrenv", "getmenv", "gettenv", "getgc", "getreg",
    "getregistry", "getconnections", "getloadedmodules", "getnilinstances",
    "identifyexecutor", "setfflag", "getfflag", "gethui", "isreadonly",
    "setreadonly", "isfile", "writefile", "appendfile", "delfile", "readfile",
    "loadfile", "isfolder", "makefolder", "delfolder", "listfiles",
    "getcustomasset", "getsynasset", "cloneref", "clonefunction",
    "setclipboard", "getupvalues", "getupvalue", "setupvalue", "getconstants",
    "getconstant", "setconstant", "getprotos", "getproto", "getstack",
    "setstack", "firesignal", "firetouchinterest", "fireclickdetector",
    "fireproximityprompt", "sethiddenproperty", "gethiddenproperty",
    "setscriptable", "islclosure", "getscriptclosure", "getscripthash",
    "getcallingscript", "saveinstance", "httpget", "messagebox", "protect_gui",
    "unprotect_gui", "queue_on_teleport", "replicatesignal", "hooksignal",
    "getspecialinfo", "setthreadcontext", "dumpstring", "secure_call",
}

local function Scrub(Text)
    Text = tostring(Text)
    local Lowered = Text:lower()

    for _, Word in ipairs(LogMask) do
        local From = 1

        while true do
            local Start = string.find(Lowered, Word, From, true)
            if not Start then
                break
            end

            local Cut = Start + 2
            Text = Text:sub(1, Cut - 1) .. "." .. Text:sub(Cut)
            Lowered = Text:lower()
            From = Cut + #Word
        end
    end

    return Text
end

local function Log(Text)
    print("[demida] " .. Scrub(Text))
end

local function WaitForGame()
    if game:IsLoaded() then
        return
    end

    local Deadline = os.clock() + GuardConfig.LoadTimeout
    repeat
        task.wait(0.1)
    until game:IsLoaded() or os.clock() > Deadline
end

local Guard = {}

function Guard.IsCheckList(Item)
    return typeof(Item) == "table"
        and (rawget(Item, "indexInstance")
            or rawget(Item, "newindexInstance")
            or rawget(Item, "newIndexInstance")) ~= nil
end

function Guard.IsCheckEntry(Entry)
    return type(Entry) == "table"
        and type(Entry[1]) == "string"
        and type(Entry[2]) == "function"
end

function Guard.Run()
    local State = { Done = false, Patched = 0, Hits = { Count = 0 } }
    Environment.drain_guard = State

    if type(getgc) ~= "function" then
        Log("guard skipped: no memory access")
        return
    end

    local function Calm()
        return false
    end

    local function Park()
        State.Hits.Count += 1
        return task.wait(9e9)
    end

    local function PatchList(List)
        for _, Entry in pairs(List) do
            if Guard.IsCheckEntry(Entry) then
                Entry[2] = Calm
            end
        end

        List.hbx = { "kick", Park }
    end

    local Objects = getgc(true)
    local Total = #Objects
    local Patched = 0
    local StoppedAt = 0

    local SliceStart = os.clock()
    local Deadline = SliceStart + GuardConfig.ScanBudget

    Log("guard scanning " .. Total)

    for Index = 1, Total do
        local Item = Objects[Index]

        if Guard.IsCheckList(Item) and pcall(PatchList, Item) then
            Patched += 1
        end

        if Index % GuardConfig.SliceStep == 0 then
            local Now = os.clock()

            if Now >= Deadline then
                StoppedAt = Index
                break
            end

            if Now - SliceStart >= GuardConfig.SliceTime then
                task.wait()
                SliceStart = os.clock()
            end
        end
    end

    Objects = nil
    State.Patched = Patched
    State.Done = true

    if StoppedAt > 0 then
        Log(string.format("guard time cap at %d of %d, patched %d", StoppedAt, Total, Patched))
    else
        Log(string.format("guard patched %d of %d", Patched, Total))
    end

    if Patched > 0 then
        Environment.drain_skip_guard = true
    else
        Log("guard found nothing, avoid features that need metamethod hooks")
    end
end

WaitForGame()

local GuardOk, GuardErr = pcall(Guard.Run)
if not GuardOk then
    Log("guard failed: " .. tostring(GuardErr))
end


local DemidaBundle = {}

DemidaBundle["Library.lua"] = function(...)
local InputService = game:GetService('UserInputService');
local TextService = game:GetService('TextService');
local CoreGui = game:GetService('CoreGui');
local Teams = game:GetService('Teams');
local Players = game:GetService('Players');
local RunService = game:GetService('RunService')
local TweenService = game:GetService('TweenService');
local RenderStepped = RunService.RenderStepped;
local LocalPlayer = Players.LocalPlayer;
local Mouse = LocalPlayer:GetMouse();

local ProtectGui = protectgui or (syn and syn.protect_gui) or (function() end);

local ScreenGui = Instance.new('ScreenGui');
ProtectGui(ScreenGui);

ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global;
ScreenGui.Parent = CoreGui;

local Toggles = {};
local Options = {};

getgenv().Toggles = Toggles;
getgenv().Options = Options;

local Library = {
    Toggles = Toggles;
    Options = Options;

    Registry = {};
    RegistryMap = {};

    HudRegistry = {};

    FontColor = Color3.fromRGB(255, 255, 255);
    MainColor = Color3.fromRGB(28, 28, 28);
    BackgroundColor = Color3.fromRGB(20, 20, 20);
    AccentColor = Color3.fromRGB(0, 85, 255);
    OutlineColor = Color3.fromRGB(50, 50, 50);
    RiskColor = Color3.fromRGB(255, 50, 50),

    Black = Color3.new(0, 0, 0);
    Font = Enum.Font.Code,

    ItemHeight = 17;
    Spacing = 3;

    OpenedFrames = {};
    DependencyBoxes = {};

    Signals = {};
    ScreenGui = ScreenGui;
};

local RainbowStep = 0
local Hue = 0

table.insert(Library.Signals, RenderStepped:Connect(function(Delta)
    RainbowStep = RainbowStep + Delta

    if RainbowStep >= (1 / 60) then
        RainbowStep = 0

        Hue = Hue + (1 / 400);

        if Hue > 1 then
            Hue = 0;
        end;

        Library.CurrentRainbowHue = Hue;
        Library.CurrentRainbowColor = Color3.fromHSV(Hue, 0.8, 1);
    end
end))

local function GetPlayersString()
    local PlayerList = Players:GetPlayers();

    for i = 1, #PlayerList do
        PlayerList[i] = PlayerList[i].Name;
    end;

    table.sort(PlayerList, function(str1, str2) return str1 < str2 end);

    return PlayerList;
end;

local function GetTeamsString()
    local TeamList = Teams:GetTeams();

    for i = 1, #TeamList do
        TeamList[i] = TeamList[i].Name;
    end;

    table.sort(TeamList, function(str1, str2) return str1 < str2 end);
    
    return TeamList;
end;

function Library:SafeCallback(f, ...)
    if (not f) then
        return;
    end;

    if not Library.NotifyOnError then
        return f(...);
    end;

    local success, event = pcall(f, ...);

    if not success then
        local _, i = event:find(":%d+: ");

        if not i then
            return Library:Notify(event);
        end;

        return Library:Notify(event:sub(i + 1), 3);
    end;
end;

function Library:AttemptSave()
    if Library.SaveManager then
        Library.SaveManager:Save();
    end;
end;

function Library:Create(Class, Properties)
    local _Instance = Class;

    if type(Class) == 'string' then
        _Instance = Instance.new(Class);
    end;

    for Property, Value in next, Properties do
        _Instance[Property] = Value;
    end;

    return _Instance;
end;

function Library:ApplyTextStroke(Inst)
    Inst.TextStrokeTransparency = 1;

    Library:Create('UIStroke', {
        Color = Color3.new(0, 0, 0);
        Thickness = 1;
        LineJoinMode = Enum.LineJoinMode.Miter;
        Parent = Inst;
    });
end;

function Library:CreateLabel(Properties, IsHud)
    local _Instance = Library:Create('TextLabel', {
        BackgroundTransparency = 1;
        Font = Library.Font;
        TextColor3 = Library.FontColor;
        TextSize = 16;
        TextStrokeTransparency = 0;
    });

    Library:ApplyTextStroke(_Instance);

    Library:AddToRegistry(_Instance, {
        TextColor3 = 'FontColor';
    }, IsHud);

    return Library:Create(_Instance, Properties);
end;

function Library:MakeDraggable(Instance, Cutoff)
    Instance.Active = true;

    Instance.InputBegan:Connect(function(Input)
        if Input.UserInputType == Enum.UserInputType.MouseButton1 then
            local ObjPos = Vector2.new(
                Mouse.X - Instance.AbsolutePosition.X,
                Mouse.Y - Instance.AbsolutePosition.Y
            );

            if ObjPos.Y > (Cutoff or 40) then
                return;
            end;

            while InputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) do
                Instance.Position = UDim2.new(
                    0,
                    Mouse.X - ObjPos.X + (Instance.Size.X.Offset * Instance.AnchorPoint.X),
                    0,
                    Mouse.Y - ObjPos.Y + (Instance.Size.Y.Offset * Instance.AnchorPoint.Y)
                );

                RenderStepped:Wait();
            end;
        end;
    end)
end;

function Library:AddToolTip(InfoStr, HoverInstance)
    local X, Y = Library:GetTextBounds(InfoStr, Library.Font, 14);
    local Tooltip = Library:Create('Frame', {
        BackgroundColor3 = Library.MainColor,
        BorderColor3 = Library.OutlineColor,

        Size = UDim2.fromOffset(X + 5, Y + 4),
        ZIndex = 100,
        Parent = Library.ScreenGui,

        Visible = false,
    })

    local Label = Library:CreateLabel({
        Position = UDim2.fromOffset(3, 1),
        Size = UDim2.fromOffset(X, Y);
        TextSize = 14;
        Text = InfoStr,
        TextColor3 = Library.FontColor,
        TextXAlignment = Enum.TextXAlignment.Left;
        ZIndex = Tooltip.ZIndex + 1,

        Parent = Tooltip;
    });

    Library:AddToRegistry(Tooltip, {
        BackgroundColor3 = 'MainColor';
        BorderColor3 = 'OutlineColor';
    });

    Library:AddToRegistry(Label, {
        TextColor3 = 'FontColor',
    });

    local IsHovering = false

    HoverInstance.MouseEnter:Connect(function()
        if Library:MouseIsOverOpenedFrame() then
            return
        end

        IsHovering = true

        Tooltip.Position = UDim2.fromOffset(Mouse.X + 15, Mouse.Y + 12)
        Tooltip.Visible = true

        while IsHovering do
            RunService.Heartbeat:Wait()
            Tooltip.Position = UDim2.fromOffset(Mouse.X + 15, Mouse.Y + 12)
        end
    end)

    HoverInstance.MouseLeave:Connect(function()
        IsHovering = false
        Tooltip.Visible = false
    end)
end

function Library:OnHighlight(HighlightInstance, Instance, Properties, PropertiesDefault)
    HighlightInstance.MouseEnter:Connect(function()
        local Reg = Library.RegistryMap[Instance];

        for Property, ColorIdx in next, Properties do
            Instance[Property] = Library[ColorIdx] or ColorIdx;

            if Reg and Reg.Properties[Property] then
                Reg.Properties[Property] = ColorIdx;
            end;
        end;
    end)

    HighlightInstance.MouseLeave:Connect(function()
        local Reg = Library.RegistryMap[Instance];

        for Property, ColorIdx in next, PropertiesDefault do
            Instance[Property] = Library[ColorIdx] or ColorIdx;

            if Reg and Reg.Properties[Property] then
                Reg.Properties[Property] = ColorIdx;
            end;
        end;
    end)
end;

function Library:MouseIsOverOpenedFrame()
    for Frame, _ in next, Library.OpenedFrames do
        local AbsPos, AbsSize = Frame.AbsolutePosition, Frame.AbsoluteSize;

        if Mouse.X >= AbsPos.X and Mouse.X <= AbsPos.X + AbsSize.X
            and Mouse.Y >= AbsPos.Y and Mouse.Y <= AbsPos.Y + AbsSize.Y then

            return true;
        end;
    end;
end;

function Library:IsMouseOverFrame(Frame)
    local AbsPos, AbsSize = Frame.AbsolutePosition, Frame.AbsoluteSize;

    if Mouse.X >= AbsPos.X and Mouse.X <= AbsPos.X + AbsSize.X
        and Mouse.Y >= AbsPos.Y and Mouse.Y <= AbsPos.Y + AbsSize.Y then

        return true;
    end;
end;

function Library:UpdateDependencyBoxes()
    for _, Depbox in next, Library.DependencyBoxes do
        Depbox:Update();
    end;
end;

function Library:MapValue(Value, MinA, MaxA, MinB, MaxB)
    return (1 - ((Value - MinA) / (MaxA - MinA))) * MinB + ((Value - MinA) / (MaxA - MinA)) * MaxB;
end;

function Library:GetTextBounds(Text, Font, Size, Resolution)
    local Bounds = TextService:GetTextSize(Text, Size, Font, Resolution or Vector2.new(1920, 1080))
    return Bounds.X, Bounds.Y
end;

function Library:GetDarkerColor(Color)
    local H, S, V = Color3.toHSV(Color);
    return Color3.fromHSV(H, S, V / 1.5);
end;
Library.AccentColorDark = Library:GetDarkerColor(Library.AccentColor);

function Library:AddToRegistry(Instance, Properties, IsHud)
    local Idx = #Library.Registry + 1;
    local Data = {
        Instance = Instance;
        Properties = Properties;
        Idx = Idx;
    };

    table.insert(Library.Registry, Data);
    Library.RegistryMap[Instance] = Data;

    if IsHud then
        table.insert(Library.HudRegistry, Data);
    end;
end;

function Library:RemoveFromRegistry(Instance)
    local Data = Library.RegistryMap[Instance];

    if Data then
        for Idx = #Library.Registry, 1, -1 do
            if Library.Registry[Idx] == Data then
                table.remove(Library.Registry, Idx);
            end;
        end;

        for Idx = #Library.HudRegistry, 1, -1 do
            if Library.HudRegistry[Idx] == Data then
                table.remove(Library.HudRegistry, Idx);
            end;
        end;

        Library.RegistryMap[Instance] = nil;
    end;
end;

function Library:UpdateColorsUsingRegistry()
    -- TODO: Could have an 'active' list of objects
    -- where the active list only contains Visible objects.

    -- IMPL: Could setup .Changed events on the AddToRegistry function
    -- that listens for the 'Visible' propert being changed.
    -- Visible: true => Add to active list, and call UpdateColors function
    -- Visible: false => Remove from active list.

    -- The above would be especially efficient for a rainbow menu color or live color-changing.

    for Idx, Object in next, Library.Registry do
        for Property, ColorIdx in next, Object.Properties do
            if type(ColorIdx) == 'string' then
                Object.Instance[Property] = Library[ColorIdx];
            elseif type(ColorIdx) == 'function' then
                Object.Instance[Property] = ColorIdx()
            end
        end;
    end;
end;

function Library:GiveSignal(Signal)
    -- Only used for signals not attached to library instances, as those should be cleaned up on object destruction by Roblox
    table.insert(Library.Signals, Signal)
end

function Library:Unload()
    -- Unload all of the signals
    for Idx = #Library.Signals, 1, -1 do
        local Connection = table.remove(Library.Signals, Idx)
        Connection:Disconnect()
    end

     -- Call our unload callback, maybe to undo some hooks etc
    if Library.OnUnload then
        Library.OnUnload()
    end

    ScreenGui:Destroy()
end

function Library:OnUnload(Callback)
    Library.OnUnload = Callback
end

Library:GiveSignal(ScreenGui.DescendantRemoving:Connect(function(Instance)
    if Library.RegistryMap[Instance] then
        Library:RemoveFromRegistry(Instance);
    end;
end))

local BaseAddons = {};

do
    local Funcs = {};

    function Funcs:AddColorPicker(Idx, Info)
        local ToggleLabel = self.TextLabel;
        -- local Container = self.Container;

        assert(Info.Default, 'AddColorPicker: Missing default value.');

        local ColorPicker = {
            Value = Info.Default;
            Transparency = Info.Transparency or 0;
            Type = 'ColorPicker';
            Title = type(Info.Title) == 'string' and Info.Title or 'Color picker',
            Callback = Info.Callback or function(Color) end;
        };

        function ColorPicker:SetHSVFromRGB(Color)
            local H, S, V = Color3.toHSV(Color);

            ColorPicker.Hue = H;
            ColorPicker.Sat = S;
            ColorPicker.Vib = V;
        end;

        ColorPicker:SetHSVFromRGB(ColorPicker.Value);

        local DisplayFrame = Library:Create('Frame', {
            BackgroundColor3 = ColorPicker.Value;
            BorderColor3 = Library:GetDarkerColor(ColorPicker.Value);
            BorderMode = Enum.BorderMode.Inset;
            Size = UDim2.new(0, 28, 0, 14);
            ZIndex = 6;
            Parent = ToggleLabel;
        });

        -- Transparency image taken from https://github.com/matas3535/SplixPrivateDrawingLibrary/blob/main/Library.lua cus i'm lazy
        local CheckerFrame = Library:Create('ImageLabel', {
            BorderSizePixel = 0;
            Size = UDim2.new(0, 27, 0, 13);
            ZIndex = 5;
            Image = 'http://www.roblox.com/asset/?id=12977615774';
            Visible = not not Info.Transparency;
            Parent = DisplayFrame;
        });

        -- 1/16/23
        -- Rewrote this to be placed inside the Library ScreenGui
        -- There was some issue which caused RelativeOffset to be way off
        -- Thus the color picker would never show

        local PickerFrameOuter = Library:Create('Frame', {
            Name = 'Color';
            BackgroundColor3 = Color3.new(1, 1, 1);
            BorderColor3 = Color3.new(0, 0, 0);
            Position = UDim2.fromOffset(DisplayFrame.AbsolutePosition.X, DisplayFrame.AbsolutePosition.Y + 18),
            Size = UDim2.fromOffset(230, Info.Transparency and 271 or 253);
            Visible = false;
            ZIndex = 15;
            Parent = ScreenGui,
        });

        DisplayFrame:GetPropertyChangedSignal('AbsolutePosition'):Connect(function()
            PickerFrameOuter.Position = UDim2.fromOffset(DisplayFrame.AbsolutePosition.X, DisplayFrame.AbsolutePosition.Y + 18);
        end)

        local PickerFrameInner = Library:Create('Frame', {
            BackgroundColor3 = Library.BackgroundColor;
            BorderColor3 = Library.OutlineColor;
            BorderMode = Enum.BorderMode.Inset;
            Size = UDim2.new(1, 0, 1, 0);
            ZIndex = 16;
            Parent = PickerFrameOuter;
        });

        local Highlight = Library:Create('Frame', {
            BackgroundColor3 = Library.AccentColor;
            BorderSizePixel = 0;
            Size = UDim2.new(1, 0, 0, 2);
            ZIndex = 17;
            Parent = PickerFrameInner;
        });

        local SatVibMapOuter = Library:Create('Frame', {
            BorderColor3 = Color3.new(0, 0, 0);
            Position = UDim2.new(0, 4, 0, 25);
            Size = UDim2.new(0, 200, 0, 200);
            ZIndex = 17;
            Parent = PickerFrameInner;
        });

        local SatVibMapInner = Library:Create('Frame', {
            BackgroundColor3 = Library.BackgroundColor;
            BorderColor3 = Library.OutlineColor;
            BorderMode = Enum.BorderMode.Inset;
            Size = UDim2.new(1, 0, 1, 0);
            ZIndex = 18;
            Parent = SatVibMapOuter;
        });

        local SatVibMap = Library:Create('ImageLabel', {
            BorderSizePixel = 0;
            Size = UDim2.new(1, 0, 1, 0);
            ZIndex = 18;
            Image = 'rbxassetid://4155801252';
            Parent = SatVibMapInner;
        });

        local CursorOuter = Library:Create('ImageLabel', {
            AnchorPoint = Vector2.new(0.5, 0.5);
            Size = UDim2.new(0, 6, 0, 6);
            BackgroundTransparency = 1;
            Image = 'http://www.roblox.com/asset/?id=9619665977';
            ImageColor3 = Color3.new(0, 0, 0);
            ZIndex = 19;
            Parent = SatVibMap;
        });

        local CursorInner = Library:Create('ImageLabel', {
            Size = UDim2.new(0, CursorOuter.Size.X.Offset - 2, 0, CursorOuter.Size.Y.Offset - 2);
            Position = UDim2.new(0, 1, 0, 1);
            BackgroundTransparency = 1;
            Image = 'http://www.roblox.com/asset/?id=9619665977';
            ZIndex = 20;
            Parent = CursorOuter;
        })

        local HueSelectorOuter = Library:Create('Frame', {
            BorderColor3 = Color3.new(0, 0, 0);
            Position = UDim2.new(0, 208, 0, 25);
            Size = UDim2.new(0, 15, 0, 200);
            ZIndex = 17;
            Parent = PickerFrameInner;
        });

        local HueSelectorInner = Library:Create('Frame', {
            BackgroundColor3 = Color3.new(1, 1, 1);
            BorderSizePixel = 0;
            Size = UDim2.new(1, 0, 1, 0);
            ZIndex = 18;
            Parent = HueSelectorOuter;
        });

        local HueCursor = Library:Create('Frame', { 
            BackgroundColor3 = Color3.new(1, 1, 1);
            AnchorPoint = Vector2.new(0, 0.5);
            BorderColor3 = Color3.new(0, 0, 0);
            Size = UDim2.new(1, 0, 0, 1);
            ZIndex = 18;
            Parent = HueSelectorInner;
        });

        local HueBoxOuter = Library:Create('Frame', {
            BorderColor3 = Color3.new(0, 0, 0);
            Position = UDim2.fromOffset(4, 228),
            Size = UDim2.new(0.5, -6, 0, 20),
            ZIndex = 18,
            Parent = PickerFrameInner;
        });

        local HueBoxInner = Library:Create('Frame', {
            BackgroundColor3 = Library.MainColor;
            BorderColor3 = Library.OutlineColor;
            BorderMode = Enum.BorderMode.Inset;
            Size = UDim2.new(1, 0, 1, 0);
            ZIndex = 18,
            Parent = HueBoxOuter;
        });

        Library:Create('UIGradient', {
            Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.new(1, 1, 1)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(212, 212, 212))
            });
            Rotation = 90;
            Parent = HueBoxInner;
        });

        local HueBox = Library:Create('TextBox', {
            BackgroundTransparency = 1;
            Position = UDim2.new(0, 5, 0, 0);
            Size = UDim2.new(1, -5, 1, 0);
            Font = Library.Font;
            PlaceholderColor3 = Color3.fromRGB(190, 190, 190);
            PlaceholderText = 'Hex color',
            Text = '#FFFFFF',
            TextColor3 = Library.FontColor;
            TextSize = 14;
            TextStrokeTransparency = 0;
            TextXAlignment = Enum.TextXAlignment.Left;
            ZIndex = 20,
            Parent = HueBoxInner;
        });

        Library:ApplyTextStroke(HueBox);

        local RgbBoxBase = Library:Create(HueBoxOuter:Clone(), {
            Position = UDim2.new(0.5, 2, 0, 228),
            Size = UDim2.new(0.5, -6, 0, 20),
            Parent = PickerFrameInner
        });

        local RgbBox = Library:Create(RgbBoxBase.Frame:FindFirstChild('TextBox'), {
            Text = '255, 255, 255',
            PlaceholderText = 'RGB color',
            TextColor3 = Library.FontColor
        });

        local TransparencyBoxOuter, TransparencyBoxInner, TransparencyCursor;
        
        if Info.Transparency then 
            TransparencyBoxOuter = Library:Create('Frame', {
                BorderColor3 = Color3.new(0, 0, 0);
                Position = UDim2.fromOffset(4, 251);
                Size = UDim2.new(1, -8, 0, 15);
                ZIndex = 19;
                Parent = PickerFrameInner;
            });

            TransparencyBoxInner = Library:Create('Frame', {
                BackgroundColor3 = ColorPicker.Value;
                BorderColor3 = Library.OutlineColor;
                BorderMode = Enum.BorderMode.Inset;
                Size = UDim2.new(1, 0, 1, 0);
                ZIndex = 19;
                Parent = TransparencyBoxOuter;
            });

            Library:AddToRegistry(TransparencyBoxInner, { BorderColor3 = 'OutlineColor' });

            Library:Create('ImageLabel', {
                BackgroundTransparency = 1;
                Size = UDim2.new(1, 0, 1, 0);
                Image = 'http://www.roblox.com/asset/?id=12978095818';
                ZIndex = 20;
                Parent = TransparencyBoxInner;
            });

            TransparencyCursor = Library:Create('Frame', { 
                BackgroundColor3 = Color3.new(1, 1, 1);
                AnchorPoint = Vector2.new(0.5, 0);
                BorderColor3 = Color3.new(0, 0, 0);
                Size = UDim2.new(0, 1, 1, 0);
                ZIndex = 21;
                Parent = TransparencyBoxInner;
            });
        end;

        local DisplayLabel = Library:CreateLabel({
            Size = UDim2.new(1, 0, 0, 14);
            Position = UDim2.fromOffset(5, 5);
            TextXAlignment = Enum.TextXAlignment.Left;
            TextSize = 14;
            Text = ColorPicker.Title,--Info.Default;
            TextWrapped = false;
            ZIndex = 16;
            Parent = PickerFrameInner;
        });


        local ContextMenu = {}
        do
            ContextMenu.Options = {}
            ContextMenu.Container = Library:Create('Frame', {
                BorderColor3 = Color3.new(),
                ZIndex = 14,

                Visible = false,
                Parent = ScreenGui
            })

            ContextMenu.Inner = Library:Create('Frame', {
                BackgroundColor3 = Library.BackgroundColor;
                BorderColor3 = Library.OutlineColor;
                BorderMode = Enum.BorderMode.Inset;
                Size = UDim2.fromScale(1, 1);
                ZIndex = 15;
                Parent = ContextMenu.Container;
            });

            Library:Create('UIListLayout', {
                Name = 'Layout',
                FillDirection = Enum.FillDirection.Vertical;
                SortOrder = Enum.SortOrder.LayoutOrder;
                Parent = ContextMenu.Inner;
            });

            Library:Create('UIPadding', {
                Name = 'Padding',
                PaddingLeft = UDim.new(0, 4),
                Parent = ContextMenu.Inner,
            });

            local function updateMenuPosition()
                ContextMenu.Container.Position = UDim2.fromOffset(
                    (DisplayFrame.AbsolutePosition.X + DisplayFrame.AbsoluteSize.X) + 4,
                    DisplayFrame.AbsolutePosition.Y + 1
                )
            end

            local function updateMenuSize()
                local menuWidth = 60
                for i, label in next, ContextMenu.Inner:GetChildren() do
                    if label:IsA('TextLabel') then
                        menuWidth = math.max(menuWidth, label.TextBounds.X)
                    end
                end

                ContextMenu.Container.Size = UDim2.fromOffset(
                    menuWidth + 8,
                    ContextMenu.Inner.Layout.AbsoluteContentSize.Y + 4
                )
            end

            DisplayFrame:GetPropertyChangedSignal('AbsolutePosition'):Connect(updateMenuPosition)
            ContextMenu.Inner.Layout:GetPropertyChangedSignal('AbsoluteContentSize'):Connect(updateMenuSize)

            task.spawn(updateMenuPosition)
            task.spawn(updateMenuSize)

            Library:AddToRegistry(ContextMenu.Inner, {
                BackgroundColor3 = 'BackgroundColor';
                BorderColor3 = 'OutlineColor';
            });

            function ContextMenu:Show()
                self.Container.Visible = true
            end

            function ContextMenu:Hide()
                self.Container.Visible = false
            end

            function ContextMenu:AddOption(Str, Callback)
                if type(Callback) ~= 'function' then
                    Callback = function() end
                end

                local Button = Library:CreateLabel({
                    Active = false;
                    Size = UDim2.new(1, 0, 0, 15);
                    TextSize = 13;
                    Text = Str;
                    ZIndex = 16;
                    Parent = self.Inner;
                    TextXAlignment = Enum.TextXAlignment.Left,
                });

                Library:OnHighlight(Button, Button, 
                    { TextColor3 = 'AccentColor' },
                    { TextColor3 = 'FontColor' }
                );

                Button.InputBegan:Connect(function(Input)
                    if Input.UserInputType ~= Enum.UserInputType.MouseButton1 then
                        return
                    end

                    Callback()
                end)
            end

            ContextMenu:AddOption('Copy color', function()
                Library.ColorClipboard = ColorPicker.Value
                Library:Notify('Copied color!', 2)
            end)

            ContextMenu:AddOption('Paste color', function()
                if not Library.ColorClipboard then
                    return Library:Notify('You have not copied a color!', 2)
                end
                ColorPicker:SetValueRGB(Library.ColorClipboard)
            end)


            ContextMenu:AddOption('Copy HEX', function()
                pcall(setclipboard, ColorPicker.Value:ToHex())
                Library:Notify('Copied hex code to clipboard!', 2)
            end)

            ContextMenu:AddOption('Copy RGB', function()
                pcall(setclipboard, table.concat({ math.floor(ColorPicker.Value.R * 255), math.floor(ColorPicker.Value.G * 255), math.floor(ColorPicker.Value.B * 255) }, ', '))
                Library:Notify('Copied RGB values to clipboard!', 2)
            end)

        end

        Library:AddToRegistry(PickerFrameInner, { BackgroundColor3 = 'BackgroundColor'; BorderColor3 = 'OutlineColor'; });
        Library:AddToRegistry(Highlight, { BackgroundColor3 = 'AccentColor'; });
        Library:AddToRegistry(SatVibMapInner, { BackgroundColor3 = 'BackgroundColor'; BorderColor3 = 'OutlineColor'; });

        Library:AddToRegistry(HueBoxInner, { BackgroundColor3 = 'MainColor'; BorderColor3 = 'OutlineColor'; });
        Library:AddToRegistry(RgbBoxBase.Frame, { BackgroundColor3 = 'MainColor'; BorderColor3 = 'OutlineColor'; });
        Library:AddToRegistry(RgbBox, { TextColor3 = 'FontColor', });
        Library:AddToRegistry(HueBox, { TextColor3 = 'FontColor', });

        local SequenceTable = {};

        for Hue = 0, 1, 0.1 do
            table.insert(SequenceTable, ColorSequenceKeypoint.new(Hue, Color3.fromHSV(Hue, 1, 1)));
        end;

        local HueSelectorGradient = Library:Create('UIGradient', {
            Color = ColorSequence.new(SequenceTable);
            Rotation = 90;
            Parent = HueSelectorInner;
        });

        HueBox.FocusLost:Connect(function(enter)
            if enter then
                local success, result = pcall(Color3.fromHex, HueBox.Text)
                if success and typeof(result) == 'Color3' then
                    ColorPicker.Hue, ColorPicker.Sat, ColorPicker.Vib = Color3.toHSV(result)
                end
            end

            ColorPicker:Display()
        end)

        RgbBox.FocusLost:Connect(function(enter)
            if enter then
                local r, g, b = RgbBox.Text:match('(%d+),%s*(%d+),%s*(%d+)')
                if r and g and b then
                    ColorPicker.Hue, ColorPicker.Sat, ColorPicker.Vib = Color3.toHSV(Color3.fromRGB(r, g, b))
                end
            end

            ColorPicker:Display()
        end)

        function ColorPicker:Display()
            ColorPicker.Value = Color3.fromHSV(ColorPicker.Hue, ColorPicker.Sat, ColorPicker.Vib);
            SatVibMap.BackgroundColor3 = Color3.fromHSV(ColorPicker.Hue, 1, 1);

            Library:Create(DisplayFrame, {
                BackgroundColor3 = ColorPicker.Value;
                BackgroundTransparency = ColorPicker.Transparency;
                BorderColor3 = Library:GetDarkerColor(ColorPicker.Value);
            });

            if TransparencyBoxInner then
                TransparencyBoxInner.BackgroundColor3 = ColorPicker.Value;
                TransparencyCursor.Position = UDim2.new(1 - ColorPicker.Transparency, 0, 0, 0);
            end;

            CursorOuter.Position = UDim2.new(ColorPicker.Sat, 0, 1 - ColorPicker.Vib, 0);
            HueCursor.Position = UDim2.new(0, 0, ColorPicker.Hue, 0);

            HueBox.Text = '#' .. ColorPicker.Value:ToHex()
            RgbBox.Text = table.concat({ math.floor(ColorPicker.Value.R * 255), math.floor(ColorPicker.Value.G * 255), math.floor(ColorPicker.Value.B * 255) }, ', ')

            Library:SafeCallback(ColorPicker.Callback, ColorPicker.Value);
            Library:SafeCallback(ColorPicker.Changed, ColorPicker.Value);
        end;

        function ColorPicker:OnChanged(Func)
            ColorPicker.Changed = Func;
            Func(ColorPicker.Value)
        end;

        function ColorPicker:Show()
            for Frame, Val in next, Library.OpenedFrames do
                if Frame.Name == 'Color' then
                    Frame.Visible = false;
                    Library.OpenedFrames[Frame] = nil;
                end;
            end;

            PickerFrameOuter.Visible = true;
            Library.OpenedFrames[PickerFrameOuter] = true;
        end;

        function ColorPicker:Hide()
            PickerFrameOuter.Visible = false;
            Library.OpenedFrames[PickerFrameOuter] = nil;
        end;

        function ColorPicker:SetValue(HSV, Transparency)
            local Color = Color3.fromHSV(HSV[1], HSV[2], HSV[3]);

            ColorPicker.Transparency = Transparency or 0;
            ColorPicker:SetHSVFromRGB(Color);
            ColorPicker:Display();
        end;

        function ColorPicker:SetValueRGB(Color, Transparency)
            ColorPicker.Transparency = Transparency or 0;
            ColorPicker:SetHSVFromRGB(Color);
            ColorPicker:Display();
        end;

        SatVibMap.InputBegan:Connect(function(Input)
            if Input.UserInputType == Enum.UserInputType.MouseButton1 then
                while InputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) do
                    local MinX = SatVibMap.AbsolutePosition.X;
                    local MaxX = MinX + SatVibMap.AbsoluteSize.X;
                    local MouseX = math.clamp(Mouse.X, MinX, MaxX);

                    local MinY = SatVibMap.AbsolutePosition.Y;
                    local MaxY = MinY + SatVibMap.AbsoluteSize.Y;
                    local MouseY = math.clamp(Mouse.Y, MinY, MaxY);

                    ColorPicker.Sat = (MouseX - MinX) / (MaxX - MinX);
                    ColorPicker.Vib = 1 - ((MouseY - MinY) / (MaxY - MinY));
                    ColorPicker:Display();

                    RenderStepped:Wait();
                end;

                Library:AttemptSave();
            end;
        end);

        HueSelectorInner.InputBegan:Connect(function(Input)
            if Input.UserInputType == Enum.UserInputType.MouseButton1 then
                while InputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) do
                    local MinY = HueSelectorInner.AbsolutePosition.Y;
                    local MaxY = MinY + HueSelectorInner.AbsoluteSize.Y;
                    local MouseY = math.clamp(Mouse.Y, MinY, MaxY);

                    ColorPicker.Hue = ((MouseY - MinY) / (MaxY - MinY));
                    ColorPicker:Display();

                    RenderStepped:Wait();
                end;

                Library:AttemptSave();
            end;
        end);

        DisplayFrame.InputBegan:Connect(function(Input)
            if Input.UserInputType == Enum.UserInputType.MouseButton1 and not Library:MouseIsOverOpenedFrame() then
                if PickerFrameOuter.Visible then
                    ColorPicker:Hide()
                else
                    ContextMenu:Hide()
                    ColorPicker:Show()
                end;
            elseif Input.UserInputType == Enum.UserInputType.MouseButton2 and not Library:MouseIsOverOpenedFrame() then
                ContextMenu:Show()
                ColorPicker:Hide()
            end
        end);

        if TransparencyBoxInner then
            TransparencyBoxInner.InputBegan:Connect(function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseButton1 then
                    while InputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) do
                        local MinX = TransparencyBoxInner.AbsolutePosition.X;
                        local MaxX = MinX + TransparencyBoxInner.AbsoluteSize.X;
                        local MouseX = math.clamp(Mouse.X, MinX, MaxX);

                        ColorPicker.Transparency = 1 - ((MouseX - MinX) / (MaxX - MinX));

                        ColorPicker:Display();

                        RenderStepped:Wait();
                    end;

                    Library:AttemptSave();
                end;
            end);
        end;

        Library:GiveSignal(InputService.InputBegan:Connect(function(Input)
            if Input.UserInputType == Enum.UserInputType.MouseButton1 then
                local AbsPos, AbsSize = PickerFrameOuter.AbsolutePosition, PickerFrameOuter.AbsoluteSize;

                if Mouse.X < AbsPos.X or Mouse.X > AbsPos.X + AbsSize.X
                    or Mouse.Y < (AbsPos.Y - 20 - 1) or Mouse.Y > AbsPos.Y + AbsSize.Y then

                    ColorPicker:Hide();
                end;

                if not Library:IsMouseOverFrame(ContextMenu.Container) then
                    ContextMenu:Hide()
                end
            end;

            if Input.UserInputType == Enum.UserInputType.MouseButton2 and ContextMenu.Container.Visible then
                if not Library:IsMouseOverFrame(ContextMenu.Container) and not Library:IsMouseOverFrame(DisplayFrame) then
                    ContextMenu:Hide()
                end
            end
        end))

        ColorPicker:Display();
        ColorPicker.DisplayFrame = DisplayFrame

        Options[Idx] = ColorPicker;

        return self;
    end;

    function Funcs:AddKeyPicker(Idx, Info)
        local ParentObj = self;
        local ToggleLabel = self.TextLabel;
        local Container = self.Container;

        assert(Info.Default, 'AddKeyPicker: Missing default value.');

        local KeyPicker = {
            Value = Info.Default;
            Toggled = false;
            Mode = Info.Mode or 'Toggle'; -- Always, Toggle, Hold
            Type = 'KeyPicker';
            Callback = Info.Callback or function(Value) end;
            ChangedCallback = Info.ChangedCallback or function(New) end;

            SyncToggleState = Info.SyncToggleState or false;
        };

        if KeyPicker.SyncToggleState then
            Info.Modes = { 'Toggle' }
            Info.Mode = 'Toggle'
        end

        local PickOuter = Library:Create('Frame', {
            BackgroundColor3 = Color3.new(0, 0, 0);
            BorderColor3 = Color3.new(0, 0, 0);
            Size = UDim2.new(0, 28, 0, 15);
            ZIndex = 6;
            Parent = ToggleLabel;
        });

        local PickInner = Library:Create('Frame', {
            BackgroundColor3 = Library.BackgroundColor;
            BorderColor3 = Library.OutlineColor;
            BorderMode = Enum.BorderMode.Inset;
            Size = UDim2.new(1, 0, 1, 0);
            ZIndex = 7;
            Parent = PickOuter;
        });

        Library:AddToRegistry(PickInner, {
            BackgroundColor3 = 'BackgroundColor';
            BorderColor3 = 'OutlineColor';
        });

        local DisplayLabel = Library:CreateLabel({
            Size = UDim2.new(1, 0, 1, 0);
            TextSize = 13;
            Text = Info.Default;
            TextWrapped = true;
            ZIndex = 8;
            Parent = PickInner;
        });

        local ModeSelectOuter = Library:Create('Frame', {
            BorderColor3 = Color3.new(0, 0, 0);
            Position = UDim2.fromOffset(ToggleLabel.AbsolutePosition.X + ToggleLabel.AbsoluteSize.X + 4, ToggleLabel.AbsolutePosition.Y + 1);
            Size = UDim2.new(0, 60, 0, 45 + 2);
            Visible = false;
            ZIndex = 14;
            Parent = ScreenGui;
        });

        ToggleLabel:GetPropertyChangedSignal('AbsolutePosition'):Connect(function()
            ModeSelectOuter.Position = UDim2.fromOffset(ToggleLabel.AbsolutePosition.X + ToggleLabel.AbsoluteSize.X + 4, ToggleLabel.AbsolutePosition.Y + 1);
        end);

        local ModeSelectInner = Library:Create('Frame', {
            BackgroundColor3 = Library.BackgroundColor;
            BorderColor3 = Library.OutlineColor;
            BorderMode = Enum.BorderMode.Inset;
            Size = UDim2.new(1, 0, 1, 0);
            ZIndex = 15;
            Parent = ModeSelectOuter;
        });

        Library:AddToRegistry(ModeSelectInner, {
            BackgroundColor3 = 'BackgroundColor';
            BorderColor3 = 'OutlineColor';
        });

        Library:Create('UIListLayout', {
            FillDirection = Enum.FillDirection.Vertical;
            SortOrder = Enum.SortOrder.LayoutOrder;
            Parent = ModeSelectInner;
        });

        local ContainerLabel = Library:CreateLabel({
            TextXAlignment = Enum.TextXAlignment.Left;
            Size = UDim2.new(1, 0, 0, 18);
            TextSize = 13;
            Visible = false;
            ZIndex = 110;
            Parent = Library.KeybindContainer;
        },  true);

        local Modes = Info.Modes or { 'Always', 'Toggle', 'Hold' };
        local ModeButtons = {};

        for Idx, Mode in next, Modes do
            local ModeButton = {};

            local Label = Library:CreateLabel({
                Active = false;
                Size = UDim2.new(1, 0, 0, 15);
                TextSize = 13;
                Text = Mode;
                ZIndex = 16;
                Parent = ModeSelectInner;
            });

            function ModeButton:Select()
                for _, Button in next, ModeButtons do
                    Button:Deselect();
                end;

                KeyPicker.Mode = Mode;

                Label.TextColor3 = Library.AccentColor;
                Library.RegistryMap[Label].Properties.TextColor3 = 'AccentColor';

                ModeSelectOuter.Visible = false;
            end;

            function ModeButton:Deselect()
                KeyPicker.Mode = nil;

                Label.TextColor3 = Library.FontColor;
                Library.RegistryMap[Label].Properties.TextColor3 = 'FontColor';
            end;

            Label.InputBegan:Connect(function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseButton1 then
                    ModeButton:Select();
                    Library:AttemptSave();
                end;
            end);

            if Mode == KeyPicker.Mode then
                ModeButton:Select();
            end;

            ModeButtons[Mode] = ModeButton;
        end;

        function KeyPicker:Update()
            if Info.NoUI then
                return;
            end;

            local State = KeyPicker:GetState();

            ContainerLabel.Text = string.format('[%s] %s (%s)', KeyPicker.Value, Info.Text, KeyPicker.Mode);

            ContainerLabel.Visible = true;
            ContainerLabel.TextColor3 = State and Library.AccentColor or Library.FontColor;

            Library.RegistryMap[ContainerLabel].Properties.TextColor3 = State and 'AccentColor' or 'FontColor';

            local YSize = 0
            local XSize = 0

            for _, Label in next, Library.KeybindContainer:GetChildren() do
                if Label:IsA('TextLabel') and Label.Visible then
                    YSize = YSize + 18;
                    if (Label.TextBounds.X > XSize) then
                        XSize = Label.TextBounds.X
                    end
                end;
            end;

            Library.KeybindFrame.Size = UDim2.new(0, math.max(XSize + 10, 210), 0, YSize + 23)
        end;

        function KeyPicker:GetState()
            if KeyPicker.Mode == 'Always' then
                return true;
            elseif KeyPicker.Mode == 'Hold' then
                if KeyPicker.Value == 'None' then
                    return false;
                end

                local Key = KeyPicker.Value;

                if Key == 'MB1' or Key == 'MB2' then
                    return Key == 'MB1' and InputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1)
                        or Key == 'MB2' and InputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2);
                else
                    return InputService:IsKeyDown(Enum.KeyCode[KeyPicker.Value]);
                end;
            else
                return KeyPicker.Toggled;
            end;
        end;

        function KeyPicker:SetValue(Data)
            local Key, Mode = Data[1], Data[2];
            DisplayLabel.Text = Key;
            KeyPicker.Value = Key;
            ModeButtons[Mode]:Select();
            KeyPicker:Update();
        end;

        function KeyPicker:OnClick(Callback)
            KeyPicker.Clicked = Callback
        end

        function KeyPicker:OnChanged(Callback)
            KeyPicker.Changed = Callback
            Callback(KeyPicker.Value)
        end

        if ParentObj.Addons then
            table.insert(ParentObj.Addons, KeyPicker)
        end

        function KeyPicker:DoClick()
            if ParentObj.Type == 'Toggle' and KeyPicker.SyncToggleState then
                ParentObj:SetValue(not ParentObj.Value)
            end

            Library:SafeCallback(KeyPicker.Callback, KeyPicker.Toggled)
            Library:SafeCallback(KeyPicker.Clicked, KeyPicker.Toggled)
        end

        local Picking = false;

        PickOuter.InputBegan:Connect(function(Input)
            if Input.UserInputType == Enum.UserInputType.MouseButton1 and not Library:MouseIsOverOpenedFrame() then
                Picking = true;

                DisplayLabel.Text = '';

                local Break;
                local Text = '';

                task.spawn(function()
                    while (not Break) do
                        if Text == '...' then
                            Text = '';
                        end;

                        Text = Text .. '.';
                        DisplayLabel.Text = Text;

                        wait(0.4);
                    end;
                end);

                wait(0.2);

                local Event;
                Event = InputService.InputBegan:Connect(function(Input)
                    local Key;

                    if Input.UserInputType == Enum.UserInputType.Keyboard then
                        Key = Input.KeyCode.Name;
                    elseif Input.UserInputType == Enum.UserInputType.MouseButton1 then
                        Key = 'MB1';
                    elseif Input.UserInputType == Enum.UserInputType.MouseButton2 then
                        Key = 'MB2';
                    end;

                    Break = true;
                    Picking = false;

                    DisplayLabel.Text = Key;
                    KeyPicker.Value = Key;

                    Library:SafeCallback(KeyPicker.ChangedCallback, Input.KeyCode or Input.UserInputType)
                    Library:SafeCallback(KeyPicker.Changed, Input.KeyCode or Input.UserInputType)

                    Library:AttemptSave();

                    Event:Disconnect();
                end);
            elseif Input.UserInputType == Enum.UserInputType.MouseButton2 and not Library:MouseIsOverOpenedFrame() then
                ModeSelectOuter.Visible = true;
            end;
        end);

        Library:GiveSignal(InputService.InputBegan:Connect(function(Input)
            if (not Picking) then
                if KeyPicker.Mode == 'Toggle' then
                    local Key = KeyPicker.Value;

                    if Key == 'MB1' or Key == 'MB2' then
                        if Key == 'MB1' and Input.UserInputType == Enum.UserInputType.MouseButton1
                        or Key == 'MB2' and Input.UserInputType == Enum.UserInputType.MouseButton2 then
                            KeyPicker.Toggled = not KeyPicker.Toggled
                            KeyPicker:DoClick()
                        end;
                    elseif Input.UserInputType == Enum.UserInputType.Keyboard then
                        if Input.KeyCode.Name == Key then
                            KeyPicker.Toggled = not KeyPicker.Toggled;
                            KeyPicker:DoClick()
                        end;
                    end;
                end;

                KeyPicker:Update();
            end;

            if Input.UserInputType == Enum.UserInputType.MouseButton1 then
                local AbsPos, AbsSize = ModeSelectOuter.AbsolutePosition, ModeSelectOuter.AbsoluteSize;

                if Mouse.X < AbsPos.X or Mouse.X > AbsPos.X + AbsSize.X
                    or Mouse.Y < (AbsPos.Y - 20 - 1) or Mouse.Y > AbsPos.Y + AbsSize.Y then

                    ModeSelectOuter.Visible = false;
                end;
            end;
        end))

        Library:GiveSignal(InputService.InputEnded:Connect(function(Input)
            if (not Picking) then
                KeyPicker:Update();
            end;
        end))

        KeyPicker:Update();

        Options[Idx] = KeyPicker;

        return self;
    end;

    BaseAddons.__index = Funcs;
    BaseAddons.__namecall = function(Table, Key, ...)
        return Funcs[Key](...);
    end;
end;

local BaseGroupbox = {};

do
    local Funcs = {};

    function Funcs:AddBlank(Size)
        local Groupbox = self;
        local Container = Groupbox.Container;

        Library:Create('Frame', {
            BackgroundTransparency = 1;
            Size = UDim2.new(1, 0, 0, Size);
            ZIndex = 1;
            Parent = Container;
        });
    end;

    function Funcs:AddLabel(Text, DoesWrap)
        local Label = {};

        local Groupbox = self;
        local Container = Groupbox.Container;

        local TextLabel = Library:CreateLabel({
            Size = UDim2.new(1, -4, 0, 15);
            TextSize = 14;
            Text = Text;
            TextWrapped = DoesWrap or false,
            TextXAlignment = Enum.TextXAlignment.Left;
            ZIndex = 5;
            Parent = Container;
        });

        if DoesWrap then
            local Y = select(2, Library:GetTextBounds(Text, Library.Font, 14, Vector2.new(TextLabel.AbsoluteSize.X, math.huge)))
            TextLabel.Size = UDim2.new(1, -4, 0, Y)
        else
            Library:Create('UIListLayout', {
                Padding = UDim.new(0, 4);
                FillDirection = Enum.FillDirection.Horizontal;
                HorizontalAlignment = Enum.HorizontalAlignment.Right;
                SortOrder = Enum.SortOrder.LayoutOrder;
                Parent = TextLabel;
            });
        end

        Label.TextLabel = TextLabel;
        Label.Container = Container;

        function Label:SetText(Text)
            TextLabel.Text = Text

            if DoesWrap then
                local Y = select(2, Library:GetTextBounds(Text, Library.Font, 14, Vector2.new(TextLabel.AbsoluteSize.X, math.huge)))
                TextLabel.Size = UDim2.new(1, -4, 0, Y)
            end

            Groupbox:Resize();
        end

        if (not DoesWrap) then
            setmetatable(Label, BaseAddons);
        end

        Groupbox:AddBlank(Library.Spacing);
        Groupbox:Resize();

        return Label;
    end;

    function Funcs:AddButton(...)
        -- TODO: Eventually redo this
        local Button = {};
        local function ProcessButtonParams(Class, Obj, ...)
            local Props = select(1, ...)
            if type(Props) == 'table' then
                Obj.Text = Props.Text
                Obj.Func = Props.Func
                Obj.DoubleClick = Props.DoubleClick
                Obj.Tooltip = Props.Tooltip
            else
                Obj.Text = select(1, ...)
                Obj.Func = select(2, ...)
            end

            assert(type(Obj.Func) == 'function', 'AddButton: `Func` callback is missing.');
        end

        ProcessButtonParams('Button', Button, ...)

        local Groupbox = self;
        local Container = Groupbox.Container;

        local function CreateBaseButton(Button)
            local Outer = Library:Create('Frame', {
                BackgroundColor3 = Color3.new(0, 0, 0);
                BorderColor3 = Color3.new(0, 0, 0);
                Size = UDim2.new(1, -4, 0, Library.ItemHeight + 1);
                ZIndex = 5;
            });

            local Inner = Library:Create('Frame', {
                BackgroundColor3 = Library.MainColor;
                BorderColor3 = Library.OutlineColor;
                BorderMode = Enum.BorderMode.Inset;
                Size = UDim2.new(1, 0, 1, 0);
                ZIndex = 6;
                Parent = Outer;
            });

            local Label = Library:CreateLabel({
                Size = UDim2.new(1, 0, 1, 0);
                TextSize = 14;
                Text = Button.Text;
                ZIndex = 6;
                Parent = Inner;
            });

            Library:Create('UIGradient', {
                Color = ColorSequence.new({
                    ColorSequenceKeypoint.new(0, Color3.new(1, 1, 1)),
                    ColorSequenceKeypoint.new(1, Color3.fromRGB(212, 212, 212))
                });
                Rotation = 90;
                Parent = Inner;
            });

            Library:AddToRegistry(Outer, {
                BorderColor3 = 'Black';
            });

            Library:AddToRegistry(Inner, {
                BackgroundColor3 = 'MainColor';
                BorderColor3 = 'OutlineColor';
            });

            Library:OnHighlight(Outer, Outer,
                { BorderColor3 = 'AccentColor' },
                { BorderColor3 = 'Black' }
            );

            return Outer, Inner, Label
        end

        local function InitEvents(Button)
            local function WaitForEvent(event, timeout, validator)
                local bindable = Instance.new('BindableEvent')
                local connection = event:Once(function(...)

                    if type(validator) == 'function' and validator(...) then
                        bindable:Fire(true)
                    else
                        bindable:Fire(false)
                    end
                end)
                task.delay(timeout, function()
                    connection:disconnect()
                    bindable:Fire(false)
                end)
                return bindable.Event:Wait()
            end

            local function ValidateClick(Input)
                if Library:MouseIsOverOpenedFrame() then
                    return false
                end

                if Input.UserInputType ~= Enum.UserInputType.MouseButton1 then
                    return false
                end

                return true
            end

            Button.Outer.InputBegan:Connect(function(Input)
                if not ValidateClick(Input) then return end
                if Button.Locked then return end

                if Button.DoubleClick then
                    Library:RemoveFromRegistry(Button.Label)
                    Library:AddToRegistry(Button.Label, { TextColor3 = 'AccentColor' })

                    Button.Label.TextColor3 = Library.AccentColor
                    Button.Label.Text = 'Are you sure?'
                    Button.Locked = true

                    local clicked = WaitForEvent(Button.Outer.InputBegan, 0.5, ValidateClick)

                    Library:RemoveFromRegistry(Button.Label)
                    Library:AddToRegistry(Button.Label, { TextColor3 = 'FontColor' })

                    Button.Label.TextColor3 = Library.FontColor
                    Button.Label.Text = Button.Text
                    task.defer(rawset, Button, 'Locked', false)

                    if clicked then
                        Library:SafeCallback(Button.Func)
                    end

                    return
                end

                Library:SafeCallback(Button.Func);
            end)
        end

        Button.Outer, Button.Inner, Button.Label = CreateBaseButton(Button)
        Button.Outer.Parent = Container

        InitEvents(Button)

        function Button:AddTooltip(tooltip)
            if type(tooltip) == 'string' then
                Library:AddToolTip(tooltip, self.Outer)
            end
            return self
        end


        function Button:AddButton(...)
            local SubButton = {}

            ProcessButtonParams('SubButton', SubButton, ...)

            self.Outer.Size = UDim2.new(0.5, -2, 0, Library.ItemHeight + 1)

            SubButton.Outer, SubButton.Inner, SubButton.Label = CreateBaseButton(SubButton)

            SubButton.Outer.Position = UDim2.new(1, 3, 0, 0)
            SubButton.Outer.Size = UDim2.fromOffset(self.Outer.AbsoluteSize.X - 2, self.Outer.AbsoluteSize.Y)
            SubButton.Outer.Parent = self.Outer

            function SubButton:AddTooltip(tooltip)
                if type(tooltip) == 'string' then
                    Library:AddToolTip(tooltip, self.Outer)
                end
                return SubButton
            end

            if type(SubButton.Tooltip) == 'string' then
                SubButton:AddTooltip(SubButton.Tooltip)
            end

            InitEvents(SubButton)
            return SubButton
        end

        if type(Button.Tooltip) == 'string' then
            Button:AddTooltip(Button.Tooltip)
        end

        Groupbox:AddBlank(Library.Spacing);
        Groupbox:Resize();

        return Button;
    end;

    function Funcs:AddDivider()
        local Groupbox = self;
        local Container = self.Container

        local Divider = {
            Type = 'Divider',
        }

        Groupbox:AddBlank(2);
        local DividerOuter = Library:Create('Frame', {
            BackgroundColor3 = Color3.new(0, 0, 0);
            BorderColor3 = Color3.new(0, 0, 0);
            Size = UDim2.new(1, -4, 0, 5);
            ZIndex = 5;
            Parent = Container;
        });

        local DividerInner = Library:Create('Frame', {
            BackgroundColor3 = Library.MainColor;
            BorderColor3 = Library.OutlineColor;
            BorderMode = Enum.BorderMode.Inset;
            Size = UDim2.new(1, 0, 1, 0);
            ZIndex = 6;
            Parent = DividerOuter;
        });

        Library:AddToRegistry(DividerOuter, {
            BorderColor3 = 'Black';
        });

        Library:AddToRegistry(DividerInner, {
            BackgroundColor3 = 'MainColor';
            BorderColor3 = 'OutlineColor';
        });

        Groupbox:AddBlank(9);
        Groupbox:Resize();
    end

    function Funcs:AddInput(Idx, Info)
        assert(Info.Text, 'AddInput: Missing `Text` string.')

        local Textbox = {
            Value = Info.Default or '';
            Numeric = Info.Numeric or false;
            Finished = Info.Finished or false;
            Type = 'Input';
            Callback = Info.Callback or function(Value) end;
        };

        local Groupbox = self;
        local Container = Groupbox.Container;

        local InputLabel = Library:CreateLabel({
            Size = UDim2.new(1, 0, 0, 15);
            TextSize = 14;
            Text = Info.Text;
            TextXAlignment = Enum.TextXAlignment.Left;
            ZIndex = 5;
            Parent = Container;
        });

        Groupbox:AddBlank(1);

        local TextBoxOuter = Library:Create('Frame', {
            BackgroundColor3 = Color3.new(0, 0, 0);
            BorderColor3 = Color3.new(0, 0, 0);
            Size = UDim2.new(1, -4, 0, Library.ItemHeight + 1);
            ZIndex = 5;
            Parent = Container;
        });

        local TextBoxInner = Library:Create('Frame', {
            BackgroundColor3 = Library.MainColor;
            BorderColor3 = Library.OutlineColor;
            BorderMode = Enum.BorderMode.Inset;
            Size = UDim2.new(1, 0, 1, 0);
            ZIndex = 6;
            Parent = TextBoxOuter;
        });

        Library:AddToRegistry(TextBoxInner, {
            BackgroundColor3 = 'MainColor';
            BorderColor3 = 'OutlineColor';
        });

        Library:OnHighlight(TextBoxOuter, TextBoxOuter,
            { BorderColor3 = 'AccentColor' },
            { BorderColor3 = 'Black' }
        );

        if type(Info.Tooltip) == 'string' then
            Library:AddToolTip(Info.Tooltip, TextBoxOuter)
        end

        Library:Create('UIGradient', {
            Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.new(1, 1, 1)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(212, 212, 212))
            });
            Rotation = 90;
            Parent = TextBoxInner;
        });

        local Container = Library:Create('Frame', {
            BackgroundTransparency = 1;
            ClipsDescendants = true;

            Position = UDim2.new(0, 5, 0, 0);
            Size = UDim2.new(1, -5, 1, 0);

            ZIndex = 7;
            Parent = TextBoxInner;
        })

        local Box = Library:Create('TextBox', {
            BackgroundTransparency = 1;

            Position = UDim2.fromOffset(0, 0),
            Size = UDim2.fromScale(5, 1),

            Font = Library.Font;
            PlaceholderColor3 = Color3.fromRGB(190, 190, 190);
            PlaceholderText = Info.Placeholder or '';

            Text = Info.Default or '';
            TextColor3 = Library.FontColor;
            TextSize = 14;
            TextStrokeTransparency = 0;
            TextXAlignment = Enum.TextXAlignment.Left;

            ZIndex = 7;
            Parent = Container;
        });

        Library:ApplyTextStroke(Box);

        function Textbox:SetValue(Text)
            if Info.MaxLength and #Text > Info.MaxLength then
                Text = Text:sub(1, Info.MaxLength);
            end;

            if Textbox.Numeric then
                if (not tonumber(Text)) and Text:len() > 0 then
                    Text = Textbox.Value
                end
            end

            Textbox.Value = Text;
            Box.Text = Text;

            Library:SafeCallback(Textbox.Callback, Textbox.Value);
            Library:SafeCallback(Textbox.Changed, Textbox.Value);
        end;

        if Textbox.Finished then
            Box.FocusLost:Connect(function(enter)
                if not enter then return end

                Textbox:SetValue(Box.Text);
                Library:AttemptSave();
            end)
        else
            Box:GetPropertyChangedSignal('Text'):Connect(function()
                Textbox:SetValue(Box.Text);
                Library:AttemptSave();
            end);
        end

        -- https://devforum.roblox.com/t/how-to-make-textboxes-follow-current-cursor-position/1368429/6
        -- thank you nicemike40 :)

        local function Update()
            local PADDING = 2
            local reveal = Container.AbsoluteSize.X

            if not Box:IsFocused() or Box.TextBounds.X <= reveal - 2 * PADDING then
                -- we aren't focused, or we fit so be normal
                Box.Position = UDim2.new(0, PADDING, 0, 0)
            else
                -- we are focused and don't fit, so adjust position
                local cursor = Box.CursorPosition
                if cursor ~= -1 then
                    -- calculate pixel width of text from start to cursor
                    local subtext = string.sub(Box.Text, 1, cursor-1)
                    local width = TextService:GetTextSize(subtext, Box.TextSize, Box.Font, Vector2.new(math.huge, math.huge)).X

                    -- check if we're inside the box with the cursor
                    local currentCursorPos = Box.Position.X.Offset + width

                    -- adjust if necessary
                    if currentCursorPos < PADDING then
                        Box.Position = UDim2.fromOffset(PADDING-width, 0)
                    elseif currentCursorPos > reveal - PADDING - 1 then
                        Box.Position = UDim2.fromOffset(reveal-width-PADDING-1, 0)
                    end
                end
            end
        end

        task.spawn(Update)

        Box:GetPropertyChangedSignal('Text'):Connect(Update)
        Box:GetPropertyChangedSignal('CursorPosition'):Connect(Update)
        Box.FocusLost:Connect(Update)
        Box.Focused:Connect(Update)

        Library:AddToRegistry(Box, {
            TextColor3 = 'FontColor';
        });

        function Textbox:OnChanged(Func)
            Textbox.Changed = Func;
            Func(Textbox.Value);
        end;

        Groupbox:AddBlank(Library.Spacing);
        Groupbox:Resize();

        Options[Idx] = Textbox;

        return Textbox;
    end;

    function Funcs:AddToggle(Idx, Info)
        assert(Info.Text, 'AddInput: Missing `Text` string.')

        local Toggle = {
            Value = Info.Default or false;
            Type = 'Toggle';

            Callback = Info.Callback or function(Value) end;
            Addons = {},
            Risky = Info.Risky,
        };

        local Groupbox = self;
        local Container = Groupbox.Container;

        local ToggleOuter = Library:Create('Frame', {
            BackgroundColor3 = Color3.new(0, 0, 0);
            BorderColor3 = Color3.new(0, 0, 0);
            Size = UDim2.new(0, 13, 0, 13);
            ZIndex = 5;
            Parent = Container;
        });

        Library:AddToRegistry(ToggleOuter, {
            BorderColor3 = 'Black';
        });

        local ToggleInner = Library:Create('Frame', {
            BackgroundColor3 = Library.MainColor;
            BorderColor3 = Library.OutlineColor;
            BorderMode = Enum.BorderMode.Inset;
            Size = UDim2.new(1, 0, 1, 0);
            ZIndex = 6;
            Parent = ToggleOuter;
        });

        Library:AddToRegistry(ToggleInner, {
            BackgroundColor3 = 'MainColor';
            BorderColor3 = 'OutlineColor';
        });

        local ToggleLabel = Library:CreateLabel({
            Size = UDim2.new(0, 216, 1, 0);
            Position = UDim2.new(1, 6, 0, 0);
            TextSize = 14;
            Text = Info.Text;
            TextXAlignment = Enum.TextXAlignment.Left;
            ZIndex = 6;
            Parent = ToggleInner;
        });

        Library:Create('UIListLayout', {
            Padding = UDim.new(0, 4);
            FillDirection = Enum.FillDirection.Horizontal;
            HorizontalAlignment = Enum.HorizontalAlignment.Right;
            SortOrder = Enum.SortOrder.LayoutOrder;
            Parent = ToggleLabel;
        });

        local ToggleRegion = Library:Create('Frame', {
            BackgroundTransparency = 1;
            Size = UDim2.new(0, 170, 1, 0);
            ZIndex = 8;
            Parent = ToggleOuter;
        });

        Library:OnHighlight(ToggleRegion, ToggleOuter,
            { BorderColor3 = 'AccentColor' },
            { BorderColor3 = 'Black' }
        );

        function Toggle:UpdateColors()
            Toggle:Display();
        end;

        if type(Info.Tooltip) == 'string' then
            Library:AddToolTip(Info.Tooltip, ToggleRegion)
        end

        function Toggle:Display()
            ToggleInner.BackgroundColor3 = Toggle.Value and Library.AccentColor or Library.MainColor;
            ToggleInner.BorderColor3 = Toggle.Value and Library.AccentColorDark or Library.OutlineColor;

            Library.RegistryMap[ToggleInner].Properties.BackgroundColor3 = Toggle.Value and 'AccentColor' or 'MainColor';
            Library.RegistryMap[ToggleInner].Properties.BorderColor3 = Toggle.Value and 'AccentColorDark' or 'OutlineColor';
        end;

        function Toggle:OnChanged(Func)
            Toggle.Changed = Func;
            Func(Toggle.Value);
        end;

        function Toggle:SetValue(Bool)
            Bool = (not not Bool);

            Toggle.Value = Bool;
            Toggle:Display();

            for _, Addon in next, Toggle.Addons do
                if Addon.Type == 'KeyPicker' and Addon.SyncToggleState then
                    Addon.Toggled = Bool
                    Addon:Update()
                end
            end

            Library:SafeCallback(Toggle.Callback, Toggle.Value);
            Library:SafeCallback(Toggle.Changed, Toggle.Value);
            Library:UpdateDependencyBoxes();
        end;

        ToggleRegion.InputBegan:Connect(function(Input)
            if Input.UserInputType == Enum.UserInputType.MouseButton1 and not Library:MouseIsOverOpenedFrame() then
                Toggle:SetValue(not Toggle.Value) -- Why was it not like this from the start?
                Library:AttemptSave();
            end;
        end);

        if Toggle.Risky then
            Library:RemoveFromRegistry(ToggleLabel)
            ToggleLabel.TextColor3 = Library.RiskColor
            Library:AddToRegistry(ToggleLabel, { TextColor3 = 'RiskColor' })
        end

        Toggle:Display();
        Groupbox:AddBlank(Info.BlankSize or Library.Spacing + 1);
        Groupbox:Resize();

        Toggle.TextLabel = ToggleLabel;
        Toggle.Container = Container;
        setmetatable(Toggle, BaseAddons);

        Toggles[Idx] = Toggle;

        Library:UpdateDependencyBoxes();

        return Toggle;
    end;

    function Funcs:AddSlider(Idx, Info)
        assert(Info.Default, 'AddSlider: Missing default value.');
        assert(Info.Text, 'AddSlider: Missing slider text.');
        assert(Info.Min, 'AddSlider: Missing minimum value.');
        assert(Info.Max, 'AddSlider: Missing maximum value.');
        assert(Info.Rounding, 'AddSlider: Missing rounding value.');

        local Slider = {
            Value = Info.Default;
            Min = Info.Min;
            Max = Info.Max;
            Rounding = Info.Rounding;
            MaxSize = 232;
            Type = 'Slider';
            Callback = Info.Callback or function(Value) end;
        };

        local Groupbox = self;
        local Container = Groupbox.Container;

        if not Info.Compact then
            Library:CreateLabel({
                Size = UDim2.new(1, 0, 0, 10);
                TextSize = 14;
                Text = Info.Text;
                TextXAlignment = Enum.TextXAlignment.Left;
                TextYAlignment = Enum.TextYAlignment.Bottom;
                ZIndex = 5;
                Parent = Container;
            });

            Groupbox:AddBlank(3);
        end

        local SliderOuter = Library:Create('Frame', {
            BackgroundColor3 = Color3.new(0, 0, 0);
            BorderColor3 = Color3.new(0, 0, 0);
            Size = UDim2.new(1, -4, 0, 13);
            ZIndex = 5;
            Parent = Container;
        });

        Library:AddToRegistry(SliderOuter, {
            BorderColor3 = 'Black';
        });

        local SliderInner = Library:Create('Frame', {
            BackgroundColor3 = Library.MainColor;
            BorderColor3 = Library.OutlineColor;
            BorderMode = Enum.BorderMode.Inset;
            Size = UDim2.new(1, 0, 1, 0);
            ZIndex = 6;
            Parent = SliderOuter;
        });

        Library:AddToRegistry(SliderInner, {
            BackgroundColor3 = 'MainColor';
            BorderColor3 = 'OutlineColor';
        });

        local Fill = Library:Create('Frame', {
            BackgroundColor3 = Library.AccentColor;
            BorderColor3 = Library.AccentColorDark;
            Size = UDim2.new(0, 0, 1, 0);
            ZIndex = 7;
            Parent = SliderInner;
        });

        Library:AddToRegistry(Fill, {
            BackgroundColor3 = 'AccentColor';
            BorderColor3 = 'AccentColorDark';
        });

        local HideBorderRight = Library:Create('Frame', {
            BackgroundColor3 = Library.AccentColor;
            BorderSizePixel = 0;
            Position = UDim2.new(1, 0, 0, 0);
            Size = UDim2.new(0, 1, 1, 0);
            ZIndex = 8;
            Parent = Fill;
        });

        Library:AddToRegistry(HideBorderRight, {
            BackgroundColor3 = 'AccentColor';
        });

        local DisplayLabel = Library:CreateLabel({
            Size = UDim2.new(1, 0, 1, 0);
            TextSize = 14;
            Text = 'Infinite';
            ZIndex = 9;
            Parent = SliderInner;
        });

        Library:OnHighlight(SliderOuter, SliderOuter,
            { BorderColor3 = 'AccentColor' },
            { BorderColor3 = 'Black' }
        );

        if type(Info.Tooltip) == 'string' then
            Library:AddToolTip(Info.Tooltip, SliderOuter)
        end

        function Slider:UpdateColors()
            Fill.BackgroundColor3 = Library.AccentColor;
            Fill.BorderColor3 = Library.AccentColorDark;
        end;

        function Slider:Display()
            local Suffix = Info.Suffix or '';

            if Info.Compact then
                DisplayLabel.Text = Info.Text .. ': ' .. Slider.Value .. Suffix
            elseif Info.HideMax then
                DisplayLabel.Text = string.format('%s', Slider.Value .. Suffix)
            else
                DisplayLabel.Text = string.format('%s/%s', Slider.Value .. Suffix, Slider.Max .. Suffix);
            end

            local X = math.ceil(Library:MapValue(Slider.Value, Slider.Min, Slider.Max, 0, Slider.MaxSize));
            Fill.Size = UDim2.new(0, X, 1, 0);

            HideBorderRight.Visible = not (X == Slider.MaxSize or X == 0);
        end;

        function Slider:OnChanged(Func)
            Slider.Changed = Func;
            Func(Slider.Value);
        end;

        local function Round(Value)
            if Slider.Rounding == 0 then
                return math.floor(Value);
            end;


            return tonumber(string.format('%.' .. Slider.Rounding .. 'f', Value))
        end;

        function Slider:GetValueFromXOffset(X)
            return Round(Library:MapValue(X, 0, Slider.MaxSize, Slider.Min, Slider.Max));
        end;

        function Slider:SetValue(Str)
            local Num = tonumber(Str);

            if (not Num) then
                return;
            end;

            Num = math.clamp(Num, Slider.Min, Slider.Max);

            Slider.Value = Num;
            Slider:Display();

            Library:SafeCallback(Slider.Callback, Slider.Value);
            Library:SafeCallback(Slider.Changed, Slider.Value);
        end;

        SliderInner.InputBegan:Connect(function(Input)
            if Input.UserInputType == Enum.UserInputType.MouseButton1 and not Library:MouseIsOverOpenedFrame() then
                local mPos = Mouse.X;
                local gPos = Fill.Size.X.Offset;
                local Diff = mPos - (Fill.AbsolutePosition.X + gPos);

                while InputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) do
                    local nMPos = Mouse.X;
                    local nX = math.clamp(gPos + (nMPos - mPos) + Diff, 0, Slider.MaxSize);

                    local nValue = Slider:GetValueFromXOffset(nX);
                    local OldValue = Slider.Value;
                    Slider.Value = nValue;

                    Slider:Display();

                    if nValue ~= OldValue then
                        Library:SafeCallback(Slider.Callback, Slider.Value);
                        Library:SafeCallback(Slider.Changed, Slider.Value);
                    end;

                    RenderStepped:Wait();
                end;

                Library:AttemptSave();
            end;
        end);

        Slider:Display();
        Groupbox:AddBlank(Info.BlankSize or Library.Spacing + 1);
        Groupbox:Resize();

        Options[Idx] = Slider;

        return Slider;
    end;

    function Funcs:AddDropdown(Idx, Info)
        if Info.SpecialType == 'Player' then
            Info.Values = GetPlayersString();
            Info.AllowNull = true;
        elseif Info.SpecialType == 'Team' then
            Info.Values = GetTeamsString();
            Info.AllowNull = true;
        end;

        assert(Info.Values, 'AddDropdown: Missing dropdown value list.');
        assert(Info.AllowNull or Info.Default, 'AddDropdown: Missing default value. Pass `AllowNull` as true if this was intentional.')

        if (not Info.Text) then
            Info.Compact = true;
        end;

        local Dropdown = {
            Values = Info.Values;
            Value = Info.Multi and {};
            Multi = Info.Multi;
            Type = 'Dropdown';
            SpecialType = Info.SpecialType; -- can be either 'Player' or 'Team'
            Callback = Info.Callback or function(Value) end;
        };

        local Groupbox = self;
        local Container = Groupbox.Container;

        local RelativeOffset = 0;

        if not Info.Compact then
            local DropdownLabel = Library:CreateLabel({
                Size = UDim2.new(1, 0, 0, 10);
                TextSize = 14;
                Text = Info.Text;
                TextXAlignment = Enum.TextXAlignment.Left;
                TextYAlignment = Enum.TextYAlignment.Bottom;
                ZIndex = 5;
                Parent = Container;
            });

            Groupbox:AddBlank(3);
        end

        for _, Element in next, Container:GetChildren() do
            if not Element:IsA('UIListLayout') then
                RelativeOffset = RelativeOffset + Element.Size.Y.Offset;
            end;
        end;

        local DropdownOuter = Library:Create('Frame', {
            BackgroundColor3 = Color3.new(0, 0, 0);
            BorderColor3 = Color3.new(0, 0, 0);
            Size = UDim2.new(1, -4, 0, Library.ItemHeight + 1);
            ZIndex = 5;
            Parent = Container;
        });

        Library:AddToRegistry(DropdownOuter, {
            BorderColor3 = 'Black';
        });

        local DropdownInner = Library:Create('Frame', {
            BackgroundColor3 = Library.MainColor;
            BorderColor3 = Library.OutlineColor;
            BorderMode = Enum.BorderMode.Inset;
            Size = UDim2.new(1, 0, 1, 0);
            ZIndex = 6;
            Parent = DropdownOuter;
        });

        Library:AddToRegistry(DropdownInner, {
            BackgroundColor3 = 'MainColor';
            BorderColor3 = 'OutlineColor';
        });

        Library:Create('UIGradient', {
            Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.new(1, 1, 1)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(212, 212, 212))
            });
            Rotation = 90;
            Parent = DropdownInner;
        });

        local DropdownArrow = Library:Create('ImageLabel', {
            AnchorPoint = Vector2.new(0, 0.5);
            BackgroundTransparency = 1;
            Position = UDim2.new(1, -16, 0.5, 0);
            Size = UDim2.new(0, 12, 0, 12);
            Image = 'http://www.roblox.com/asset/?id=6282522798';
            ZIndex = 8;
            Parent = DropdownInner;
        });

        local ItemList = Library:CreateLabel({
            Position = UDim2.new(0, 5, 0, 0);
            Size = UDim2.new(1, -5, 1, 0);
            TextSize = 14;
            Text = '--';
            TextXAlignment = Enum.TextXAlignment.Left;
            TextWrapped = true;
            ZIndex = 7;
            Parent = DropdownInner;
        });

        Library:OnHighlight(DropdownOuter, DropdownOuter,
            { BorderColor3 = 'AccentColor' },
            { BorderColor3 = 'Black' }
        );

        if type(Info.Tooltip) == 'string' then
            Library:AddToolTip(Info.Tooltip, DropdownOuter)
        end

        local MAX_DROPDOWN_ITEMS = 10;
        local ITEM_HEIGHT = Library.ItemHeight;

        local ListOuter = Library:Create('Frame', {
            BackgroundColor3 = Color3.new(0, 0, 0);
            BorderColor3 = Color3.new(0, 0, 0);
            ZIndex = 20;
            Visible = false;
            Parent = ScreenGui;
        });

        local function RecalculateListPosition()
            ListOuter.Position = UDim2.fromOffset(DropdownOuter.AbsolutePosition.X, DropdownOuter.AbsolutePosition.Y + DropdownOuter.Size.Y.Offset + 1);
        end;

        local function RecalculateListSize(YSize)
            ListOuter.Size = UDim2.fromOffset(DropdownOuter.AbsoluteSize.X, YSize or (MAX_DROPDOWN_ITEMS * ITEM_HEIGHT + 2))
        end;

        RecalculateListPosition();
        RecalculateListSize();

        DropdownOuter:GetPropertyChangedSignal('AbsolutePosition'):Connect(RecalculateListPosition);

        local ListInner = Library:Create('Frame', {
            BackgroundColor3 = Library.MainColor;
            BorderColor3 = Library.OutlineColor;
            BorderMode = Enum.BorderMode.Inset;
            BorderSizePixel = 0;
            Size = UDim2.new(1, 0, 1, 0);
            ZIndex = 21;
            Parent = ListOuter;
        });

        Library:AddToRegistry(ListInner, {
            BackgroundColor3 = 'MainColor';
            BorderColor3 = 'OutlineColor';
        });

        local Scrolling = Library:Create('ScrollingFrame', {
            BackgroundTransparency = 1;
            BorderSizePixel = 0;
            CanvasSize = UDim2.new(0, 0, 0, 0);
            Size = UDim2.new(1, 0, 1, 0);
            ZIndex = 21;
            Parent = ListInner;

            TopImage = 'rbxasset://textures/ui/Scroll/scroll-middle.png',
            BottomImage = 'rbxasset://textures/ui/Scroll/scroll-middle.png',

            ScrollBarThickness = 3,
            ScrollBarImageColor3 = Library.AccentColor,
        });

        Library:AddToRegistry(Scrolling, {
            ScrollBarImageColor3 = 'AccentColor'
        })

        Library:Create('UIListLayout', {
            Padding = UDim.new(0, 0);
            FillDirection = Enum.FillDirection.Vertical;
            SortOrder = Enum.SortOrder.LayoutOrder;
            Parent = Scrolling;
        });

        function Dropdown:Display()
            local Values = Dropdown.Values;
            local Str = '';

            if Info.Multi then
                for Idx, Value in next, Values do
                    if Dropdown.Value[Value] then
                        Str = Str .. Value .. ', ';
                    end;
                end;

                Str = Str:sub(1, #Str - 2);
            else
                Str = Dropdown.Value or '';
            end;

            ItemList.Text = (Str == '' and '--' or Str);
        end;

        function Dropdown:GetActiveValues()
            if Info.Multi then
                local T = {};

                for Value, Bool in next, Dropdown.Value do
                    table.insert(T, Value);
                end;

                return T;
            else
                return Dropdown.Value and 1 or 0;
            end;
        end;

        function Dropdown:BuildDropdownList()
            local Values = Dropdown.Values;
            local Buttons = {};

            for _, Element in next, Scrolling:GetChildren() do
                if not Element:IsA('UIListLayout') then
                    Element:Destroy();
                end;
            end;

            local Count = 0;

            for Idx, Value in next, Values do
                local Table = {};

                Count = Count + 1;

                local Button = Library:Create('Frame', {
                    BackgroundColor3 = Library.MainColor;
                    BorderColor3 = Library.OutlineColor;
                    BorderMode = Enum.BorderMode.Middle;
                    Size = UDim2.new(1, -1, 0, ITEM_HEIGHT);
                    ZIndex = 23;
                    Active = true,
                    Parent = Scrolling;
                });

                Library:AddToRegistry(Button, {
                    BackgroundColor3 = 'MainColor';
                    BorderColor3 = 'OutlineColor';
                });

                local ButtonLabel = Library:CreateLabel({
                    Active = false;
                    Size = UDim2.new(1, -6, 1, 0);
                    Position = UDim2.new(0, 6, 0, 0);
                    TextSize = 14;
                    Text = Value;
                    TextXAlignment = Enum.TextXAlignment.Left;
                    ZIndex = 25;
                    Parent = Button;
                });

                Library:OnHighlight(Button, Button,
                    { BorderColor3 = 'AccentColor', ZIndex = 24 },
                    { BorderColor3 = 'OutlineColor', ZIndex = 23 }
                );

                local Selected;

                if Info.Multi then
                    Selected = Dropdown.Value[Value];
                else
                    Selected = Dropdown.Value == Value;
                end;

                function Table:UpdateButton()
                    if Info.Multi then
                        Selected = Dropdown.Value[Value];
                    else
                        Selected = Dropdown.Value == Value;
                    end;

                    ButtonLabel.TextColor3 = Selected and Library.AccentColor or Library.FontColor;
                    Library.RegistryMap[ButtonLabel].Properties.TextColor3 = Selected and 'AccentColor' or 'FontColor';
                end;

                ButtonLabel.InputBegan:Connect(function(Input)
                    if Input.UserInputType == Enum.UserInputType.MouseButton1 then
                        local Try = not Selected;

                        if Dropdown:GetActiveValues() == 1 and (not Try) and (not Info.AllowNull) then
                        else
                            if Info.Multi then
                                Selected = Try;

                                if Selected then
                                    Dropdown.Value[Value] = true;
                                else
                                    Dropdown.Value[Value] = nil;
                                end;
                            else
                                Selected = Try;

                                if Selected then
                                    Dropdown.Value = Value;
                                else
                                    Dropdown.Value = nil;
                                end;

                                for _, OtherButton in next, Buttons do
                                    OtherButton:UpdateButton();
                                end;
                            end;

                            Table:UpdateButton();
                            Dropdown:Display();

                            Library:SafeCallback(Dropdown.Callback, Dropdown.Value);
                            Library:SafeCallback(Dropdown.Changed, Dropdown.Value);

                            Library:AttemptSave();
                        end;
                    end;
                end);

                Table:UpdateButton();
                Dropdown:Display();

                Buttons[Button] = Table;
            end;

            Scrolling.CanvasSize = UDim2.fromOffset(0, (Count * ITEM_HEIGHT) + 1);

            local Y = math.clamp(Count * ITEM_HEIGHT, 0, MAX_DROPDOWN_ITEMS * ITEM_HEIGHT) + 1;
            RecalculateListSize(Y);
        end;

        function Dropdown:SetValues(NewValues)
            if NewValues then
                Dropdown.Values = NewValues;
            end;

            Dropdown:BuildDropdownList();
        end;

        function Dropdown:OpenDropdown()
            ListOuter.Visible = true;
            Library.OpenedFrames[ListOuter] = true;
            DropdownArrow.Rotation = 180;
        end;

        function Dropdown:CloseDropdown()
            ListOuter.Visible = false;
            Library.OpenedFrames[ListOuter] = nil;
            DropdownArrow.Rotation = 0;
        end;

        function Dropdown:OnChanged(Func)
            Dropdown.Changed = Func;
            Func(Dropdown.Value);
        end;

        function Dropdown:SetValue(Val)
            if Dropdown.Multi then
                local nTable = {};

                for Value, Bool in next, Val do
                    if table.find(Dropdown.Values, Value) then
                        nTable[Value] = true
                    end;
                end;

                Dropdown.Value = nTable;
            else
                if (not Val) then
                    Dropdown.Value = nil;
                elseif table.find(Dropdown.Values, Val) then
                    Dropdown.Value = Val;
                end;
            end;

            Dropdown:BuildDropdownList();

            Library:SafeCallback(Dropdown.Callback, Dropdown.Value);
            Library:SafeCallback(Dropdown.Changed, Dropdown.Value);
        end;

        DropdownOuter.InputBegan:Connect(function(Input)
            if Input.UserInputType == Enum.UserInputType.MouseButton1 and not Library:MouseIsOverOpenedFrame() then
                if ListOuter.Visible then
                    Dropdown:CloseDropdown();
                else
                    Dropdown:OpenDropdown();
                end;
            end;
        end);

        InputService.InputBegan:Connect(function(Input)
            if Input.UserInputType == Enum.UserInputType.MouseButton1 then
                local AbsPos, AbsSize = ListOuter.AbsolutePosition, ListOuter.AbsoluteSize;

                if Mouse.X < AbsPos.X or Mouse.X > AbsPos.X + AbsSize.X
                    or Mouse.Y < (AbsPos.Y - 20 - 1) or Mouse.Y > AbsPos.Y + AbsSize.Y then

                    Dropdown:CloseDropdown();
                end;
            end;
        end);

        Dropdown:BuildDropdownList();
        Dropdown:Display();

        local Defaults = {}

        if type(Info.Default) == 'string' then
            local Idx = table.find(Dropdown.Values, Info.Default)
            if Idx then
                table.insert(Defaults, Idx)
            end
        elseif type(Info.Default) == 'table' then
            for _, Value in next, Info.Default do
                local Idx = table.find(Dropdown.Values, Value)
                if Idx then
                    table.insert(Defaults, Idx)
                end
            end
        elseif type(Info.Default) == 'number' and Dropdown.Values[Info.Default] ~= nil then
            table.insert(Defaults, Info.Default)
        end

        if next(Defaults) then
            for i = 1, #Defaults do
                local Index = Defaults[i]
                if Info.Multi then
                    Dropdown.Value[Dropdown.Values[Index]] = true
                else
                    Dropdown.Value = Dropdown.Values[Index];
                end

                if (not Info.Multi) then break end
            end

            Dropdown:BuildDropdownList();
            Dropdown:Display();
        end

        Groupbox:AddBlank(Info.BlankSize or Library.Spacing);
        Groupbox:Resize();

        Options[Idx] = Dropdown;

        return Dropdown;
    end;

    function Funcs:AddPreview(Idx, Info)
        Info = Info or {};

        local Groupbox = self;
        local Container = Groupbox.Container;

        local Preview = {
            Type = 'Preview';
            Model = nil;
            Yaw = math.rad(25);
            Pitch = math.rad(-10);
            Zoom = 1;
            Distance = 4;
            AutoRotate = Info.AutoRotate ~= false;
            Speed = Info.Speed or 0.5;
            IdleUntil = 0;
        };

        local Outer = Library:Create('Frame', {
            BackgroundColor3 = Color3.new(0, 0, 0);
            BorderColor3 = Color3.new(0, 0, 0);
            Size = UDim2.new(1, -4, 0, Info.Height or 140);
            ZIndex = 5;
            Parent = Container;
        });

        local Inner = Library:Create('Frame', {
            BackgroundColor3 = Library.MainColor;
            BorderColor3 = Library.OutlineColor;
            BorderMode = Enum.BorderMode.Inset;
            Size = UDim2.new(1, 0, 1, 0);
            ZIndex = 6;
            Active = true;
            Parent = Outer;
        });

        Library:AddToRegistry(Inner, {
            BackgroundColor3 = 'MainColor';
            BorderColor3 = 'OutlineColor';
        });

        local Viewport = Library:Create('ViewportFrame', {
            BackgroundTransparency = 1;
            Position = UDim2.new(0, 1, 0, 1);
            Size = UDim2.new(1, -2, 1, -2);
            Ambient = Color3.fromRGB(165, 165, 165);
            LightColor = Color3.fromRGB(255, 255, 255);
            LightDirection = Vector3.new(-0.6, -1, -0.8);
            ZIndex = 7;
            Parent = Inner;
        });

        local Camera = Instance.new('Camera');
        Camera.FieldOfView = 40;
        Camera.Parent = Viewport;
        Viewport.CurrentCamera = Camera;

        local Caption = Library:CreateLabel({
            Position = UDim2.new(0, 5, 1, -16);
            Size = UDim2.new(1, -10, 0, 14);
            TextSize = 13;
            Text = Info.Text or '';
            TextXAlignment = Enum.TextXAlignment.Left;
            ZIndex = 8;
            Parent = Inner;
        });

        local EmptyLabel = Library:CreateLabel({
            Size = UDim2.new(1, 0, 1, 0);
            TextSize = 13;
            Text = Info.EmptyText or 'no preview';
            TextTransparency = 0.5;
            ZIndex = 8;
            Parent = Inner;
        });

        local function GetAspect()
            local Size = Viewport.AbsoluteSize;
            if Size.X <= 0 or Size.Y <= 0 then
                return 2;
            end;
            return Size.X / Size.Y;
        end;

        local function GetBounds(Model)
            local Min, Max;

            for _, Part in next, Model:GetDescendants() do
                if Part:IsA('BasePart') and Part.Transparency < 1 then
                    local Half = Part.Size / 2;

                    for X = -1, 1, 2 do
                        for Y = -1, 1, 2 do
                            for Z = -1, 1, 2 do
                                local Point = Part.CFrame * Vector3.new(Half.X * X, Half.Y * Y, Half.Z * Z);

                                if Min then
                                    Min = Vector3.new(math.min(Min.X, Point.X), math.min(Min.Y, Point.Y), math.min(Min.Z, Point.Z));
                                    Max = Vector3.new(math.max(Max.X, Point.X), math.max(Max.Y, Point.Y), math.max(Max.Z, Point.Z));
                                else
                                    Min, Max = Point, Point;
                                end;
                            end;
                        end;
                    end;
                end;
            end;

            return Min, Max;
        end;

        local function SortedAxes(Size)
            local Axes = {
                { Vector3.xAxis, Size.X };
                { Vector3.yAxis, Size.Y };
                { Vector3.zAxis, Size.Z };
            };

            table.sort(Axes, function(A, B) return A[2] > B[2] end);

            return Axes[1][1], Axes[2][1];
        end;

        local function Align(Model)
            local Min, Max = GetBounds(Model);
            if not Min then
                return;
            end;

            local Center = (Min + Max) / 2;
            local Long, Mid = SortedAxes(Max - Min);
            local Rotation = CFrame.fromMatrix(Vector3.zero, Long, Mid):Inverse();

            Model:PivotTo(Rotation * CFrame.new(-Center) * Model:GetPivot());
        end;

        local function Fit(Model)
            local Min, Max = GetBounds(Model);
            if not Min then
                return;
            end;

            local Size = Max - Min;
            local Tan = math.tan(math.rad(Camera.FieldOfView) / 2);

            Preview.Distance = math.max(
                (Size.X / 2) / (Tan * GetAspect()),
                (Size.Y / 2) / Tan
            ) * 1.2 + Size.Z / 2;
        end;

        local function UpdateCamera()
            Camera.CFrame = CFrame.Angles(0, Preview.Yaw, 0)
                * CFrame.Angles(Preview.Pitch, 0, 0)
                * CFrame.new(0, 0, Preview.Distance * Preview.Zoom);
        end;

        function Preview:Clear()
            if Preview.Model then
                Preview.Model:Destroy();
                Preview.Model = nil;
            end;

            EmptyLabel.Visible = true;
        end;

        function Preview:SetModel(Source, Owned)
            Preview:Clear();

            if not Source then
                return nil;
            end;

            local Model = Source;

            if not Owned then
                local WasArchivable = Source.Archivable;
                Source.Archivable = true;
                Model = Source:Clone();
                Source.Archivable = WasArchivable;
            end;

            if not Model then
                return nil;
            end;

            if not Model:IsA('Model') then
                local Wrapper = Instance.new('Model');
                Model.Parent = Wrapper;
                Model = Wrapper;
            end;

            for _, Desc in next, Model:GetDescendants() do
                if Desc:IsA('LuaSourceContainer') or Desc:IsA('Sound') then
                    Desc:Destroy();
                elseif Desc:IsA('BasePart') then
                    Desc.Anchored = true;
                    Desc.CanCollide = false;
                end;
            end;

            Align(Model);
            Fit(Model);
            Model.Parent = Viewport;

            Preview.Model = Model;
            EmptyLabel.Visible = false;
            UpdateCamera();

            return Model;
        end;

        function Preview:GetModel()
            return Preview.Model;
        end;

        function Preview:Refit()
            if Preview.Model then
                Fit(Preview.Model);
                UpdateCamera();
            end;
        end;

        function Preview:SetText(Text)
            Caption.Text = Text or '';
        end;

        function Preview:SetEmptyText(Text)
            EmptyLabel.Text = Text or '';
        end;

        function Preview:SetAutoRotate(Bool)
            Preview.AutoRotate = Bool;
        end;

        local function AddZoomButton(Text, Index, Step)
            local ButtonOuter = Library:Create('Frame', {
                AnchorPoint = Vector2.new(1, 0);
                BackgroundColor3 = Color3.new(0, 0, 0);
                BorderColor3 = Color3.new(0, 0, 0);
                Position = UDim2.new(1, -3 - (Index - 1) * 17, 0, 3);
                Size = UDim2.fromOffset(15, 15);
                ZIndex = 9;
                Parent = Inner;
            });

            local ButtonInner = Library:Create('TextButton', {
                AutoButtonColor = false;
                BackgroundColor3 = Library.MainColor;
                BorderColor3 = Library.OutlineColor;
                BorderMode = Enum.BorderMode.Inset;
                Size = UDim2.new(1, 0, 1, 0);
                Font = Library.Font;
                Text = Text;
                TextColor3 = Library.FontColor;
                TextSize = 14;
                ZIndex = 10;
                Parent = ButtonOuter;
            });

            Library:AddToRegistry(ButtonInner, {
                BackgroundColor3 = 'MainColor';
                BorderColor3 = 'OutlineColor';
                TextColor3 = 'FontColor';
            });

            Library:OnHighlight(ButtonInner, ButtonInner,
                { BorderColor3 = 'AccentColor' },
                { BorderColor3 = 'OutlineColor' }
            );

            ButtonInner.MouseButton1Click:Connect(function()
                Preview.Zoom = math.clamp(Preview.Zoom + Step, 0.4, 2.5);
                UpdateCamera();
            end);
        end;

        AddZoomButton('+', 1, -0.15);
        AddZoomButton('-', 2, 0.15);

        local Dragging = false;
        local LastMouse;

        Inner.InputBegan:Connect(function(Input)
            if Input.UserInputType == Enum.UserInputType.MouseButton1 and not Library:MouseIsOverOpenedFrame() then
                Dragging = true;
                LastMouse = InputService:GetMouseLocation();
            end;
        end);

        Inner.InputChanged:Connect(function(Input)
            if Input.UserInputType == Enum.UserInputType.MouseWheel then
                Preview.Zoom = math.clamp(Preview.Zoom - Input.Position.Z * 0.1, 0.4, 2.5);
                UpdateCamera();
            end;
        end);

        Library:GiveSignal(InputService.InputChanged:Connect(function(Input)
            if Dragging and Input.UserInputType == Enum.UserInputType.MouseMovement then
                local Mouse = InputService:GetMouseLocation();
                local Delta = Mouse - LastMouse;
                LastMouse = Mouse;

                Preview.Yaw = Preview.Yaw - Delta.X * 0.012;
                Preview.Pitch = math.clamp(Preview.Pitch - Delta.Y * 0.012, -1.3, 1.3);
                Preview.IdleUntil = os.clock() + 2;
                UpdateCamera();
            end;
        end));

        Library:GiveSignal(InputService.InputEnded:Connect(function(Input)
            if Input.UserInputType == Enum.UserInputType.MouseButton1 then
                Dragging = false;
            end;
        end));

        Library:GiveSignal(RenderStepped:Connect(function(Delta)
            if not Preview.Model or Dragging or not Preview.AutoRotate then
                return;
            end;

            if os.clock() < Preview.IdleUntil or Viewport.AbsoluteSize.X <= 0 then
                return;
            end;

            Preview.Yaw = Preview.Yaw + Delta * Preview.Speed;
            UpdateCamera();
        end));

        Viewport:GetPropertyChangedSignal('AbsoluteSize'):Connect(function()
            Preview:Refit();
        end);

        Groupbox:AddBlank(Library.Spacing);
        Groupbox:Resize();

        if Idx then
            Options[Idx] = Preview;
        end;

        return Preview;
    end;

    function Funcs:AddDependencyBox()
        local Depbox = {
            Dependencies = {};
        };
        
        local Groupbox = self;
        local Container = Groupbox.Container;

        local Holder = Library:Create('Frame', {
            BackgroundTransparency = 1;
            Size = UDim2.new(1, 0, 0, 0);
            Visible = false;
            Parent = Container;
        });

        local Frame = Library:Create('Frame', {
            BackgroundTransparency = 1;
            Size = UDim2.new(1, 0, 1, 0);
            Visible = true;
            Parent = Holder;
        });

        local Layout = Library:Create('UIListLayout', {
            FillDirection = Enum.FillDirection.Vertical;
            SortOrder = Enum.SortOrder.LayoutOrder;
            Parent = Frame;
        });

        function Depbox:Resize()
            Holder.Size = UDim2.new(1, 0, 0, Layout.AbsoluteContentSize.Y);
            Groupbox:Resize();
        end;

        Layout:GetPropertyChangedSignal('AbsoluteContentSize'):Connect(function()
            Depbox:Resize();
        end);

        Holder:GetPropertyChangedSignal('Visible'):Connect(function()
            Depbox:Resize();
        end);

        function Depbox:Update()
            for _, Dependency in next, Depbox.Dependencies do
                local Elem = Dependency[1];
                local Value = Dependency[2];

                if Elem.Type == 'Toggle' and Elem.Value ~= Value then
                    Holder.Visible = false;
                    Depbox:Resize();
                    return;
                end;
            end;

            Holder.Visible = true;
            Depbox:Resize();
        end;

        function Depbox:SetupDependencies(Dependencies)
            for _, Dependency in next, Dependencies do
                assert(type(Dependency) == 'table', 'SetupDependencies: Dependency is not of type `table`.');
                assert(Dependency[1], 'SetupDependencies: Dependency is missing element argument.');
                assert(Dependency[2] ~= nil, 'SetupDependencies: Dependency is missing value argument.');
            end;

            Depbox.Dependencies = Dependencies;
            Depbox:Update();
        end;

        Depbox.Container = Frame;

        setmetatable(Depbox, BaseGroupbox);

        table.insert(Library.DependencyBoxes, Depbox);

        return Depbox;
    end;

    BaseGroupbox.__index = Funcs;
    BaseGroupbox.__namecall = function(Table, Key, ...)
        return Funcs[Key](...);
    end;
end;

-- < Create other UI elements >
do
    Library.NotificationArea = Library:Create('Frame', {
        BackgroundTransparency = 1;
        Position = UDim2.new(0, 0, 0, 40);
        Size = UDim2.new(0, 300, 0, 200);
        ZIndex = 100;
        Parent = ScreenGui;
    });

    Library:Create('UIListLayout', {
        Padding = UDim.new(0, 4);
        FillDirection = Enum.FillDirection.Vertical;
        SortOrder = Enum.SortOrder.LayoutOrder;
        Parent = Library.NotificationArea;
    });

    local WatermarkOuter = Library:Create('Frame', {
        BorderColor3 = Color3.new(0, 0, 0);
        Position = UDim2.new(0, 100, 0, -25);
        Size = UDim2.new(0, 213, 0, 20);
        ZIndex = 200;
        Visible = false;
        Parent = ScreenGui;
    });

    local WatermarkInner = Library:Create('Frame', {
        BackgroundColor3 = Library.MainColor;
        BorderColor3 = Library.AccentColor;
        BorderMode = Enum.BorderMode.Inset;
        Size = UDim2.new(1, 0, 1, 0);
        ZIndex = 201;
        Parent = WatermarkOuter;
    });

    Library:AddToRegistry(WatermarkInner, {
        BorderColor3 = 'AccentColor';
    });

    local InnerFrame = Library:Create('Frame', {
        BackgroundColor3 = Color3.new(1, 1, 1);
        BorderSizePixel = 0;
        Position = UDim2.new(0, 1, 0, 1);
        Size = UDim2.new(1, -2, 1, -2);
        ZIndex = 202;
        Parent = WatermarkInner;
    });

    local Gradient = Library:Create('UIGradient', {
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Library:GetDarkerColor(Library.MainColor)),
            ColorSequenceKeypoint.new(1, Library.MainColor),
        });
        Rotation = -90;
        Parent = InnerFrame;
    });

    Library:AddToRegistry(Gradient, {
        Color = function()
            return ColorSequence.new({
                ColorSequenceKeypoint.new(0, Library:GetDarkerColor(Library.MainColor)),
                ColorSequenceKeypoint.new(1, Library.MainColor),
            });
        end
    });

    local WatermarkLabel = Library:CreateLabel({
        Position = UDim2.new(0, 5, 0, 0);
        Size = UDim2.new(1, -4, 1, 0);
        TextSize = 14;
        TextXAlignment = Enum.TextXAlignment.Left;
        ZIndex = 203;
        Parent = InnerFrame;
    });

    Library.Watermark = WatermarkOuter;
    Library.WatermarkText = WatermarkLabel;
    Library:MakeDraggable(Library.Watermark);



    local KeybindOuter = Library:Create('Frame', {
        AnchorPoint = Vector2.new(0, 0.5);
        BorderColor3 = Color3.new(0, 0, 0);
        Position = UDim2.new(0, 10, 0.5, 0);
        Size = UDim2.new(0, 210, 0, 20);
        Visible = false;
        ZIndex = 100;
        Parent = ScreenGui;
    });

    local KeybindInner = Library:Create('Frame', {
        BackgroundColor3 = Library.MainColor;
        BorderColor3 = Library.OutlineColor;
        BorderMode = Enum.BorderMode.Inset;
        Size = UDim2.new(1, 0, 1, 0);
        ZIndex = 101;
        Parent = KeybindOuter;
    });

    Library:AddToRegistry(KeybindInner, {
        BackgroundColor3 = 'MainColor';
        BorderColor3 = 'OutlineColor';
    }, true);

    local ColorFrame = Library:Create('Frame', {
        BackgroundColor3 = Library.AccentColor;
        BorderSizePixel = 0;
        Size = UDim2.new(1, 0, 0, 2);
        ZIndex = 102;
        Parent = KeybindInner;
    });

    Library:AddToRegistry(ColorFrame, {
        BackgroundColor3 = 'AccentColor';
    }, true);

    local KeybindLabel = Library:CreateLabel({
        Size = UDim2.new(1, 0, 0, 20);
        Position = UDim2.fromOffset(5, 2),
        TextXAlignment = Enum.TextXAlignment.Left,

        Text = 'Keybinds';
        ZIndex = 104;
        Parent = KeybindInner;
    });

    local KeybindContainer = Library:Create('Frame', {
        BackgroundTransparency = 1;
        Size = UDim2.new(1, 0, 1, -20);
        Position = UDim2.new(0, 0, 0, 20);
        ZIndex = 1;
        Parent = KeybindInner;
    });

    Library:Create('UIListLayout', {
        FillDirection = Enum.FillDirection.Vertical;
        SortOrder = Enum.SortOrder.LayoutOrder;
        Parent = KeybindContainer;
    });

    Library:Create('UIPadding', {
        PaddingLeft = UDim.new(0, 5),
        Parent = KeybindContainer,
    })

    Library.KeybindFrame = KeybindOuter;
    Library.KeybindContainer = KeybindContainer;
    Library:MakeDraggable(KeybindOuter);
end;

function Library:SetWatermarkVisibility(Bool)
    Library.Watermark.Visible = Bool;
end;

function Library:SetWatermark(Text)
    local X, Y = Library:GetTextBounds(Text, Library.Font, 14);
    Library.Watermark.Size = UDim2.new(0, X + 15, 0, (Y * 1.5) + 3);
    Library:SetWatermarkVisibility(true)

    Library.WatermarkText.Text = Text;
end;

function Library:Notify(Text, Time)
    local XSize, YSize = Library:GetTextBounds(Text, Library.Font, 14);

    YSize = YSize + 7

    local NotifyOuter = Library:Create('Frame', {
        BorderColor3 = Color3.new(0, 0, 0);
        Position = UDim2.new(0, 100, 0, 10);
        Size = UDim2.new(0, 0, 0, YSize);
        ClipsDescendants = true;
        ZIndex = 100;
        Parent = Library.NotificationArea;
    });

    local NotifyInner = Library:Create('Frame', {
        BackgroundColor3 = Library.MainColor;
        BorderColor3 = Library.OutlineColor;
        BorderMode = Enum.BorderMode.Inset;
        Size = UDim2.new(1, 0, 1, 0);
        ZIndex = 101;
        Parent = NotifyOuter;
    });

    Library:AddToRegistry(NotifyInner, {
        BackgroundColor3 = 'MainColor';
        BorderColor3 = 'OutlineColor';
    }, true);

    local InnerFrame = Library:Create('Frame', {
        BackgroundColor3 = Color3.new(1, 1, 1);
        BorderSizePixel = 0;
        Position = UDim2.new(0, 1, 0, 1);
        Size = UDim2.new(1, -2, 1, -2);
        ZIndex = 102;
        Parent = NotifyInner;
    });

    local Gradient = Library:Create('UIGradient', {
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Library:GetDarkerColor(Library.MainColor)),
            ColorSequenceKeypoint.new(1, Library.MainColor),
        });
        Rotation = -90;
        Parent = InnerFrame;
    });

    Library:AddToRegistry(Gradient, {
        Color = function()
            return ColorSequence.new({
                ColorSequenceKeypoint.new(0, Library:GetDarkerColor(Library.MainColor)),
                ColorSequenceKeypoint.new(1, Library.MainColor),
            });
        end
    });

    local NotifyLabel = Library:CreateLabel({
        Position = UDim2.new(0, 4, 0, 0);
        Size = UDim2.new(1, -4, 1, 0);
        Text = Text;
        TextXAlignment = Enum.TextXAlignment.Left;
        TextSize = 14;
        ZIndex = 103;
        Parent = InnerFrame;
    });

    local LeftColor = Library:Create('Frame', {
        BackgroundColor3 = Library.AccentColor;
        BorderSizePixel = 0;
        Position = UDim2.new(0, -1, 0, -1);
        Size = UDim2.new(0, 3, 1, 2);
        ZIndex = 104;
        Parent = NotifyOuter;
    });

    Library:AddToRegistry(LeftColor, {
        BackgroundColor3 = 'AccentColor';
    }, true);

    pcall(NotifyOuter.TweenSize, NotifyOuter, UDim2.new(0, XSize + 8 + 4, 0, YSize), 'Out', 'Quad', 0.4, true);

    task.spawn(function()
        wait(Time or 5);

        pcall(NotifyOuter.TweenSize, NotifyOuter, UDim2.new(0, 0, 0, YSize), 'Out', 'Quad', 0.4, true);

        wait(0.4);

        NotifyOuter:Destroy();
    end);
end;

function Library:CreateWindow(...)
    local Arguments = { ... }
    local Config = { AnchorPoint = Vector2.zero }

    if type(...) == 'table' then
        Config = ...;
    else
        Config.Title = Arguments[1]
        Config.AutoShow = Arguments[2] or false;
    end

    if type(Config.Title) ~= 'string' then Config.Title = 'No title' end
    if type(Config.TabPadding) ~= 'number' then Config.TabPadding = 0 end
    if type(Config.MenuFadeTime) ~= 'number' then Config.MenuFadeTime = 0.2 end

    if typeof(Config.Position) ~= 'UDim2' then Config.Position = UDim2.fromOffset(175, 50) end
    if typeof(Config.Size) ~= 'UDim2' then Config.Size = UDim2.fromOffset(500, 460) end

    if Config.Center then
        Config.AnchorPoint = Vector2.new(0.5, 0.5)
        Config.Position = UDim2.fromScale(0.5, 0.5)
    end

    local Window = {
        Tabs = {};
    };

    local Outer = Library:Create('Frame', {
        AnchorPoint = Config.AnchorPoint,
        BackgroundColor3 = Color3.new(0, 0, 0);
        BorderSizePixel = 0;
        Position = Config.Position,
        Size = Config.Size,
        Visible = false;
        ZIndex = 1;
        Parent = ScreenGui;
    });

    Library:MakeDraggable(Outer, 25);

    local Inner = Library:Create('Frame', {
        BackgroundColor3 = Library.MainColor;
        BorderColor3 = Library.AccentColor;
        BorderMode = Enum.BorderMode.Inset;
        Position = UDim2.new(0, 1, 0, 1);
        Size = UDim2.new(1, -2, 1, -2);
        ZIndex = 1;
        Parent = Outer;
    });

    Library:AddToRegistry(Inner, {
        BackgroundColor3 = 'MainColor';
        BorderColor3 = 'AccentColor';
    });

    local WindowLabel = Library:CreateLabel({
        Position = UDim2.new(0, 7, 0, 0);
        Size = UDim2.new(0, 0, 0, 25);
        Text = Config.Title or '';
        TextXAlignment = Enum.TextXAlignment.Left;
        ZIndex = 1;
        Parent = Inner;
    });

    local MainSectionOuter = Library:Create('Frame', {
        BackgroundColor3 = Library.BackgroundColor;
        BorderColor3 = Library.OutlineColor;
        Position = UDim2.new(0, 8, 0, 25);
        Size = UDim2.new(1, -16, 1, -33);
        ZIndex = 1;
        Parent = Inner;
    });

    Library:AddToRegistry(MainSectionOuter, {
        BackgroundColor3 = 'BackgroundColor';
        BorderColor3 = 'OutlineColor';
    });

    local MainSectionInner = Library:Create('Frame', {
        BackgroundColor3 = Library.BackgroundColor;
        BorderColor3 = Color3.new(0, 0, 0);
        BorderMode = Enum.BorderMode.Inset;
        Position = UDim2.new(0, 0, 0, 0);
        Size = UDim2.new(1, 0, 1, 0);
        ZIndex = 1;
        Parent = MainSectionOuter;
    });

    Library:AddToRegistry(MainSectionInner, {
        BackgroundColor3 = 'BackgroundColor';
    });

    local TabArea = Library:Create('Frame', {
        BackgroundTransparency = 1;
        Position = UDim2.new(0, 8, 0, 8);
        Size = UDim2.new(1, -16, 0, 21);
        ZIndex = 1;
        Parent = MainSectionInner;
    });

    local TabListLayout = Library:Create('UIListLayout', {
        Padding = UDim.new(0, Config.TabPadding);
        FillDirection = Enum.FillDirection.Horizontal;
        SortOrder = Enum.SortOrder.LayoutOrder;
        Parent = TabArea;
    });

    local TabContainer = Library:Create('Frame', {
        BackgroundColor3 = Library.MainColor;
        BorderColor3 = Library.OutlineColor;
        Position = UDim2.new(0, 8, 0, 30);
        Size = UDim2.new(1, -16, 1, -38);
        ZIndex = 2;
        Parent = MainSectionInner;
    });
    

    Library:AddToRegistry(TabContainer, {
        BackgroundColor3 = 'MainColor';
        BorderColor3 = 'OutlineColor';
    });

    function Window:SetWindowTitle(Title)
        WindowLabel.Text = Title;
    end;

    function Window:AddTab(Name)
        local Tab = {
            Groupboxes = {};
            Tabboxes = {};
        };

        local TabButtonWidth = Library:GetTextBounds(Name, Library.Font, 16);

        local TabButton = Library:Create('Frame', {
            BackgroundColor3 = Library.BackgroundColor;
            BorderColor3 = Library.OutlineColor;
            Size = UDim2.new(0, TabButtonWidth + 8 + 4, 1, 0);
            ZIndex = 1;
            Parent = TabArea;
        });

        Library:AddToRegistry(TabButton, {
            BackgroundColor3 = 'BackgroundColor';
            BorderColor3 = 'OutlineColor';
        });

        local TabButtonLabel = Library:CreateLabel({
            Position = UDim2.new(0, 0, 0, 0);
            Size = UDim2.new(1, 0, 1, -1);
            Text = Name;
            ZIndex = 1;
            Parent = TabButton;
        });

        local Blocker = Library:Create('Frame', {
            BackgroundColor3 = Library.MainColor;
            BorderSizePixel = 0;
            Position = UDim2.new(0, 0, 1, 0);
            Size = UDim2.new(1, 0, 0, 1);
            BackgroundTransparency = 1;
            ZIndex = 3;
            Parent = TabButton;
        });

        Library:AddToRegistry(Blocker, {
            BackgroundColor3 = 'MainColor';
        });

        local TabFrame = Library:Create('Frame', {
            Name = 'TabFrame',
            BackgroundTransparency = 1;
            Position = UDim2.new(0, 0, 0, 0);
            Size = UDim2.new(1, 0, 1, 0);
            Visible = false;
            ZIndex = 2;
            Parent = TabContainer;
        });

        local LeftSide = Library:Create('ScrollingFrame', {
            BackgroundTransparency = 1;
            BorderSizePixel = 0;
            Position = UDim2.new(0, 8 - 1, 0, 8 - 1);
            Size = UDim2.new(0.5, -12 + 2, 0, 507 + 2);
            CanvasSize = UDim2.new(0, 0, 0, 0);
            BottomImage = '';
            TopImage = '';
            ScrollBarThickness = 0;
            ZIndex = 2;
            Parent = TabFrame;
        });

        local RightSide = Library:Create('ScrollingFrame', {
            BackgroundTransparency = 1;
            BorderSizePixel = 0;
            Position = UDim2.new(0.5, 4 + 1, 0, 8 - 1);
            Size = UDim2.new(0.5, -12 + 2, 0, 507 + 2);
            CanvasSize = UDim2.new(0, 0, 0, 0);
            BottomImage = '';
            TopImage = '';
            ScrollBarThickness = 0;
            ZIndex = 2;
            Parent = TabFrame;
        });

        Library:Create('UIListLayout', {
            Padding = UDim.new(0, 8);
            FillDirection = Enum.FillDirection.Vertical;
            SortOrder = Enum.SortOrder.LayoutOrder;
            HorizontalAlignment = Enum.HorizontalAlignment.Center;
            Parent = LeftSide;
        });

        Library:Create('UIListLayout', {
            Padding = UDim.new(0, 8);
            FillDirection = Enum.FillDirection.Vertical;
            SortOrder = Enum.SortOrder.LayoutOrder;
            HorizontalAlignment = Enum.HorizontalAlignment.Center;
            Parent = RightSide;
        });

        for _, Side in next, { LeftSide, RightSide } do
            Side:WaitForChild('UIListLayout'):GetPropertyChangedSignal('AbsoluteContentSize'):Connect(function()
                Side.CanvasSize = UDim2.fromOffset(0, Side.UIListLayout.AbsoluteContentSize.Y);
            end);
        end;

        function Tab:ShowTab()
            for _, Tab in next, Window.Tabs do
                Tab:HideTab();
            end;

            Blocker.BackgroundTransparency = 0;
            TabButton.BackgroundColor3 = Library.MainColor;
            Library.RegistryMap[TabButton].Properties.BackgroundColor3 = 'MainColor';
            TabFrame.Visible = true;
        end;

        function Tab:HideTab()
            Blocker.BackgroundTransparency = 1;
            TabButton.BackgroundColor3 = Library.BackgroundColor;
            Library.RegistryMap[TabButton].Properties.BackgroundColor3 = 'BackgroundColor';
            TabFrame.Visible = false;
        end;

        function Tab:SetLayoutOrder(Position)
            TabButton.LayoutOrder = Position;
            TabListLayout:ApplyLayout();
        end;

        function Tab:AddGroupbox(Info)
            local Groupbox = {};

            local BoxOuter = Library:Create('Frame', {
                BackgroundColor3 = Library.BackgroundColor;
                BorderColor3 = Library.OutlineColor;
                BorderMode = Enum.BorderMode.Inset;
                Size = UDim2.new(1, 0, 0, 507 + 2);
                ZIndex = 2;
                Parent = Info.Side == 1 and LeftSide or RightSide;
            });

            Library:AddToRegistry(BoxOuter, {
                BackgroundColor3 = 'BackgroundColor';
                BorderColor3 = 'OutlineColor';
            });

            local BoxInner = Library:Create('Frame', {
                BackgroundColor3 = Library.BackgroundColor;
                BorderColor3 = Color3.new(0, 0, 0);
                -- BorderMode = Enum.BorderMode.Inset;
                Size = UDim2.new(1, -2, 1, -2);
                Position = UDim2.new(0, 1, 0, 1);
                ZIndex = 4;
                Parent = BoxOuter;
            });

            Library:AddToRegistry(BoxInner, {
                BackgroundColor3 = 'BackgroundColor';
            });

            local Highlight = Library:Create('Frame', {
                BackgroundColor3 = Library.AccentColor;
                BorderSizePixel = 0;
                Size = UDim2.new(1, 0, 0, 2);
                ZIndex = 5;
                Parent = BoxInner;
            });

            Library:AddToRegistry(Highlight, {
                BackgroundColor3 = 'AccentColor';
            });

            local GroupboxLabel = Library:CreateLabel({
                Size = UDim2.new(1, 0, 0, 18);
                Position = UDim2.new(0, 4, 0, 2);
                TextSize = 14;
                Text = Info.Name;
                TextXAlignment = Enum.TextXAlignment.Left;
                ZIndex = 5;
                Parent = BoxInner;
            });

            local Container = Library:Create('Frame', {
                BackgroundTransparency = 1;
                Position = UDim2.new(0, 4, 0, 20);
                Size = UDim2.new(1, -4, 1, -20);
                ZIndex = 1;
                Parent = BoxInner;
            });

            Library:Create('UIListLayout', {
                FillDirection = Enum.FillDirection.Vertical;
                SortOrder = Enum.SortOrder.LayoutOrder;
                Parent = Container;
            });

            function Groupbox:Resize()
                local Size = 0;

                for _, Element in next, Groupbox.Container:GetChildren() do
                    if (not Element:IsA('UIListLayout')) and Element.Visible then
                        Size = Size + Element.Size.Y.Offset;
                    end;
                end;

                BoxOuter.Size = UDim2.new(1, 0, 0, 20 + Size + 2 + 2);
            end;

            Groupbox.Container = Container;
            setmetatable(Groupbox, BaseGroupbox);

            Groupbox:AddBlank(3);
            Groupbox:Resize();

            Tab.Groupboxes[Info.Name] = Groupbox;

            return Groupbox;
        end;

        function Tab:AddLeftGroupbox(Name)
            return Tab:AddGroupbox({ Side = 1; Name = Name; });
        end;

        function Tab:AddRightGroupbox(Name)
            return Tab:AddGroupbox({ Side = 2; Name = Name; });
        end;

        function Tab:AddTabbox(Info)
            local Tabbox = {
                Tabs = {};
            };

            local BoxOuter = Library:Create('Frame', {
                BackgroundColor3 = Library.BackgroundColor;
                BorderColor3 = Library.OutlineColor;
                BorderMode = Enum.BorderMode.Inset;
                Size = UDim2.new(1, 0, 0, 0);
                ZIndex = 2;
                Parent = Info.Side == 1 and LeftSide or RightSide;
            });

            Library:AddToRegistry(BoxOuter, {
                BackgroundColor3 = 'BackgroundColor';
                BorderColor3 = 'OutlineColor';
            });

            local BoxInner = Library:Create('Frame', {
                BackgroundColor3 = Library.BackgroundColor;
                BorderColor3 = Color3.new(0, 0, 0);
                -- BorderMode = Enum.BorderMode.Inset;
                Size = UDim2.new(1, -2, 1, -2);
                Position = UDim2.new(0, 1, 0, 1);
                ZIndex = 4;
                Parent = BoxOuter;
            });

            Library:AddToRegistry(BoxInner, {
                BackgroundColor3 = 'BackgroundColor';
            });

            local Highlight = Library:Create('Frame', {
                BackgroundColor3 = Library.AccentColor;
                BorderSizePixel = 0;
                Size = UDim2.new(1, 0, 0, 2);
                ZIndex = 10;
                Parent = BoxInner;
            });

            Library:AddToRegistry(Highlight, {
                BackgroundColor3 = 'AccentColor';
            });

            local TabboxButtons = Library:Create('Frame', {
                BackgroundTransparency = 1;
                Position = UDim2.new(0, 0, 0, 1);
                Size = UDim2.new(1, 0, 0, 18);
                ZIndex = 5;
                Parent = BoxInner;
            });

            Library:Create('UIListLayout', {
                FillDirection = Enum.FillDirection.Horizontal;
                HorizontalAlignment = Enum.HorizontalAlignment.Left;
                SortOrder = Enum.SortOrder.LayoutOrder;
                Parent = TabboxButtons;
            });

            function Tabbox:AddTab(Name)
                local Tab = {};

                local Button = Library:Create('Frame', {
                    BackgroundColor3 = Library.MainColor;
                    BorderColor3 = Color3.new(0, 0, 0);
                    Size = UDim2.new(0.5, 0, 1, 0);
                    ZIndex = 6;
                    Parent = TabboxButtons;
                });

                Library:AddToRegistry(Button, {
                    BackgroundColor3 = 'MainColor';
                });

                local ButtonLabel = Library:CreateLabel({
                    Size = UDim2.new(1, 0, 1, 0);
                    TextSize = 14;
                    Text = Name;
                    TextXAlignment = Enum.TextXAlignment.Center;
                    ZIndex = 7;
                    Parent = Button;
                });

                local Block = Library:Create('Frame', {
                    BackgroundColor3 = Library.BackgroundColor;
                    BorderSizePixel = 0;
                    Position = UDim2.new(0, 0, 1, 0);
                    Size = UDim2.new(1, 0, 0, 1);
                    Visible = false;
                    ZIndex = 9;
                    Parent = Button;
                });

                Library:AddToRegistry(Block, {
                    BackgroundColor3 = 'BackgroundColor';
                });

                local Container = Library:Create('Frame', {
                    BackgroundTransparency = 1;
                    Position = UDim2.new(0, 4, 0, 20);
                    Size = UDim2.new(1, -4, 1, -20);
                    ZIndex = 1;
                    Visible = false;
                    Parent = BoxInner;
                });

                Library:Create('UIListLayout', {
                    FillDirection = Enum.FillDirection.Vertical;
                    SortOrder = Enum.SortOrder.LayoutOrder;
                    Parent = Container;
                });

                function Tab:Show()
                    for _, Tab in next, Tabbox.Tabs do
                        Tab:Hide();
                    end;

                    Container.Visible = true;
                    Block.Visible = true;

                    Button.BackgroundColor3 = Library.BackgroundColor;
                    Library.RegistryMap[Button].Properties.BackgroundColor3 = 'BackgroundColor';

                    Tab:Resize();
                end;

                function Tab:Hide()
                    Container.Visible = false;
                    Block.Visible = false;

                    Button.BackgroundColor3 = Library.MainColor;
                    Library.RegistryMap[Button].Properties.BackgroundColor3 = 'MainColor';
                end;

                function Tab:Resize()
                    local TabCount = 0;

                    for _, Tab in next, Tabbox.Tabs do
                        TabCount = TabCount + 1;
                    end;

                    for _, Button in next, TabboxButtons:GetChildren() do
                        if not Button:IsA('UIListLayout') then
                            Button.Size = UDim2.new(1 / TabCount, 0, 1, 0);
                        end;
                    end;

                    if (not Container.Visible) then
                        return;
                    end;

                    local Size = 0;

                    for _, Element in next, Tab.Container:GetChildren() do
                        if (not Element:IsA('UIListLayout')) and Element.Visible then
                            Size = Size + Element.Size.Y.Offset;
                        end;
                    end;

                    BoxOuter.Size = UDim2.new(1, 0, 0, 20 + Size + 2 + 2);
                end;

                Button.InputBegan:Connect(function(Input)
                    if Input.UserInputType == Enum.UserInputType.MouseButton1 and not Library:MouseIsOverOpenedFrame() then
                        Tab:Show();
                        Tab:Resize();
                    end;
                end);

                Tab.Container = Container;
                Tabbox.Tabs[Name] = Tab;

                setmetatable(Tab, BaseGroupbox);

                Tab:AddBlank(3);
                Tab:Resize();

                -- Show first tab (number is 2 cus of the UIListLayout that also sits in that instance)
                if #TabboxButtons:GetChildren() == 2 then
                    Tab:Show();
                end;

                return Tab;
            end;

            Tab.Tabboxes[Info.Name or ''] = Tabbox;

            return Tabbox;
        end;

        function Tab:AddLeftTabbox(Name)
            return Tab:AddTabbox({ Name = Name, Side = 1; });
        end;

        function Tab:AddRightTabbox(Name)
            return Tab:AddTabbox({ Name = Name, Side = 2; });
        end;

        TabButton.InputBegan:Connect(function(Input)
            if Input.UserInputType == Enum.UserInputType.MouseButton1 then
                Tab:ShowTab();
            end;
        end);

        -- This was the first tab added, so we show it by default.
        if #TabContainer:GetChildren() == 1 then
            Tab:ShowTab();
        end;

        Window.Tabs[Name] = Tab;
        return Tab;
    end;

    local ModalElement = Library:Create('TextButton', {
        BackgroundTransparency = 1;
        Size = UDim2.new(0, 0, 0, 0);
        Visible = true;
        Text = '';
        Modal = false;
        Parent = ScreenGui;
    });

    local TransparencyCache = {};
    local Toggled = false;
    local Fading = false;

    function Library:Toggle()
        if Fading then
            return;
        end;

        local FadeTime = Config.MenuFadeTime;
        Fading = true;
        Toggled = (not Toggled);
        ModalElement.Modal = Toggled;

        if Toggled then
            -- A bit scuffed, but if we're going from not toggled -> toggled we want to show the frame immediately so that the fade is visible.
            Outer.Visible = true;

            task.spawn(function()
                -- TODO: add cursor fade?
                local State = InputService.MouseIconEnabled;

                local Cursor = Drawing.new('Triangle');
                Cursor.Thickness = 1;
                Cursor.Filled = true;
                Cursor.Visible = true;

                local CursorOutline = Drawing.new('Triangle');
                CursorOutline.Thickness = 1;
                CursorOutline.Filled = false;
                CursorOutline.Color = Color3.new(0, 0, 0);
                CursorOutline.Visible = true;

                while Toggled and ScreenGui.Parent do
                    InputService.MouseIconEnabled = false;

                    local mPos = InputService:GetMouseLocation();

                    Cursor.Color = Library.AccentColor;

                    Cursor.PointA = Vector2.new(mPos.X, mPos.Y);
                    Cursor.PointB = Vector2.new(mPos.X + 16, mPos.Y + 6);
                    Cursor.PointC = Vector2.new(mPos.X + 6, mPos.Y + 16);

                    CursorOutline.PointA = Cursor.PointA;
                    CursorOutline.PointB = Cursor.PointB;
                    CursorOutline.PointC = Cursor.PointC;

                    RenderStepped:Wait();
                end;

                InputService.MouseIconEnabled = State;

                Cursor:Remove();
                CursorOutline:Remove();
            end);
        end;

        for _, Desc in next, Outer:GetDescendants() do
            local Properties = {};

            if Desc:IsA('ImageLabel') then
                table.insert(Properties, 'ImageTransparency');
                table.insert(Properties, 'BackgroundTransparency');
            elseif Desc:IsA('TextLabel') or Desc:IsA('TextBox') then
                table.insert(Properties, 'TextTransparency');
            elseif Desc:IsA('TextButton') then
                table.insert(Properties, 'TextTransparency');
                table.insert(Properties, 'BackgroundTransparency');
            elseif Desc:IsA('ViewportFrame') then
                table.insert(Properties, 'ImageTransparency');
                table.insert(Properties, 'BackgroundTransparency');
            elseif Desc:IsA('Frame') or Desc:IsA('ScrollingFrame') then
                table.insert(Properties, 'BackgroundTransparency');
            elseif Desc:IsA('UIStroke') then
                table.insert(Properties, 'Transparency');
            end;

            local Cache = TransparencyCache[Desc];

            if (not Cache) then
                Cache = {};
                TransparencyCache[Desc] = Cache;
            end;

            for _, Prop in next, Properties do
                if not Cache[Prop] then
                    Cache[Prop] = Desc[Prop];
                end;

                if Cache[Prop] == 1 then
                    continue;
                end;

                TweenService:Create(Desc, TweenInfo.new(FadeTime, Enum.EasingStyle.Linear), { [Prop] = Toggled and Cache[Prop] or 1 }):Play();
            end;
        end;

        task.wait(FadeTime);

        Outer.Visible = Toggled;

        Fading = false;
    end

    Library:GiveSignal(InputService.InputBegan:Connect(function(Input, Processed)
        if type(Library.ToggleKeybind) == 'table' and Library.ToggleKeybind.Type == 'KeyPicker' then
            if Input.UserInputType == Enum.UserInputType.Keyboard and Input.KeyCode.Name == Library.ToggleKeybind.Value then
                task.spawn(Library.Toggle)
            end
        elseif Input.KeyCode == Enum.KeyCode.RightControl or (Input.KeyCode == Enum.KeyCode.RightShift and (not Processed)) then
            task.spawn(Library.Toggle)
        end
    end))

    if Config.AutoShow then task.spawn(Library.Toggle) end

    Window.Holder = Outer;

    return Window;
end;

local function OnPlayerChange()
    local PlayerList = GetPlayersString();

    for _, Value in next, Options do
        if Value.Type == 'Dropdown' and Value.SpecialType == 'Player' then
            Value:SetValues(PlayerList);
        end;
    end;
end;

Players.PlayerAdded:Connect(OnPlayerChange);
Players.PlayerRemoving:Connect(OnPlayerChange);

getgenv().Library = Library
return Library
end

DemidaBundle["Skins.lua"] = function(...)
local function G17Sights(Tool, Material, Color)
    for _, Part in pairs(Tool:GetDescendants()) do
        if Part.Name == "FrontSightColorPart" or Part.Name == "RearSightColorPart" then
            Part.Transparency = 0
            if Material then Part.Material = Material end
            Part.Color = Color
        end
    end
    return true
end

local SkinsDB = {
    Armors = {
        ["HelmetA_1"] = {
            ["Redoit"] = {
                id = "rbxassetid://79684082596276",
                customApply = function(t)
                    local parts  = t:FindFirstChild("Parts")
                    local head   = parts  and parts:FindFirstChild("Head")
                    local helmet = head   and head:FindFirstChild("Helmet")
                    if helmet then
                        pcall(function() helmet.TextureID = "rbxassetid://79684082596276" end)
                    end
                end,
            },
        },
        ["VestA_1"] = {
            ["Redoit"] = {
                id = "rbxassetid://121174343685261",
                customApply = function(t)
                    local parts = t:FindFirstChild("Parts")
                    if not parts then return end
                    
                    local leftArmFolder = parts:FindFirstChild("Left Arm")
                    local leftArm = leftArmFolder and leftArmFolder:FindFirstChild("LeftArm")
                    if leftArm then
                        pcall(function() leftArm.TextureID = "rbxassetid://88820282974237" end)
                    end
                    
                    local rightArmFolder = parts:FindFirstChild("Right Arm")
                    local rightArm = rightArmFolder and rightArmFolder:FindFirstChild("RightArm")
                    if rightArm then
                        pcall(function() rightArm.TextureID = "rbxassetid://88820282974237" end)
                    end
                    
                    local torsoFolder = parts:FindFirstChild("Torso")
                    local vest = torsoFolder and torsoFolder:FindFirstChild("Vest")
                    if vest then
                        pcall(function() vest.TextureID = "rbxassetid://121174343685261" end)
                    end
                end,
            },
        },
    },
    Melees = {
        ["Balisong"] = {["Gold"]={id="rbxassetid://13715204837"},["Camo"]={id="rbxassetid://13388377781"}},
        ["Katana"] = {["Golden"]={id="rbxassetid://15012855048"},["Voidedge"]={id="rbxassetid://15653919187"},["Dragon"]={id="rbxassetid://17519365000"},["Neo-blade"]={id="rbxassetid://15653919187"}},
        ["Scythe"] = {["Bloodust"]={id="rbxassetid://16551103097"},["Golden"]={id="rbxassetid://16571711832"}},
        ["SlayerSword"] = {["Angelic"]={id="rbxassetid://16549614598"},["Overcharged"]={id="rbxassetid://8770131341"}},
        ["Shiv"] = {["Golden"]={id="rbxassetid://15421623693"}},
        ["ERADICATOR"] = {["Gold"]={id="rbxassetid://18338493787"}},
        ["Bat"] = {["Cash Cane"]={id="rbxassetid://16482015134", customApply=function(t)
            local wh = t:FindFirstChild("WeaponHandle"); if not wh then return end
            pcall(function()
                wh.Transparency = 1
                if wh:IsA("MeshPart") then
                    wh.TextureID = "rbxassetid://16482015134"
                elseif wh:IsA("SpecialMesh") or wh:FindFirstChildWhichIsA("SpecialMesh") then
                    local mesh = wh:FindFirstChildWhichIsA("SpecialMesh")
                    if mesh then mesh.TextureId = "rbxassetid://16482015134" end
                end
                local dec = wh:FindFirstChildWhichIsA("Decal") or wh:FindFirstChildWhichIsA("Texture")
                if not dec then
                    dec = Instance.new("Decal")
                    dec.Face = Enum.NormalId.Front
                    dec.Parent = wh
                end
                dec.Texture = "rbxassetid://16482015134"
            end)
            return true
        end},["Opium Cane"]={id="rbxassetid://17727652050"}},
        ["Chainsaw"] = {["Gold"]={id="rbxassetid://13715204837"}},
        ["Fire-Axe"] = {["FireAxe"]={id="rbxassetid://333816720"}},
        ["Machete"] = {["Gold"]={id="rbxassetid://13715204837"}},
        ["Rambo"] = {["Gold"]={id="rbxassetid://13715204837"}},
        ["Wrench"] = {["Gold"]={id="rbxassetid://13715204837"}},
    },
    GrenadeLaunchers = {
        ["RPG-7"] = {["Gold"]={id="rbxassetid://13715204837"},["Twotone"]={id="rbxassetid://13388377781"},["Boom"]={id="rbxassetid://10959329950"},["MATI"]={id="rbxassetid://15507994427"},["Vibrant"]={id="rbxassetid://15645944609"},["PumpkinlLauncher"]={id="rbxassetid://90439639128347"},["John Pork"]={id="rbxassetid://15336726016"},["MESSER"]={id="rbxassetid://15268970718"}},
        ["M320-1"] = {["Paintball"]={id="rbxassetid://13842613980"}},
    },
    Pistols = {
        ["M1911"] = {["Ironsight"]={id="rbxassetid://13388236414"},["Rebel"]={id="rbxassetid://13410196884"},["Stainless"]={id="rbxassetid://13842569053"},["Oldglory"]={id="rbxassetid://13948805827", customApply=function(t)
            local wh = t:FindFirstChild("WeaponHandle"); if not wh then return end
            local muzzle = wh:FindFirstChild("Muzzle"); if not muzzle then return end
            local snd = muzzle:FindFirstChild("FFireSoundTWO")
            if not snd then snd = Instance.new("Sound"); snd.Name = "FFireSoundTWO"; snd.Parent = muzzle end
            snd.SoundId = "rbxassetid://1210852193"; snd.PlaybackSpeed = 2.5; snd.Volume = 1
            local yellow = Color3.fromRGB(255, 200, 0)
            local yellowSeq = ColorSequence.new(yellow)
            if not _G._m1911OldgloryOrigColors then _G._m1911OldgloryOrigColors = {} end
            for _, child in pairs(muzzle:GetChildren()) do
                pcall(function()
                    if child:IsA("ParticleEmitter") then
                        if not _G._m1911OldgloryOrigColors[child.Name] then _G._m1911OldgloryOrigColors[child.Name] = child.Color end
                        child.Color = yellowSeq
                    elseif child:IsA("Smoke") then
                        if not _G._m1911OldgloryOrigColors[child.Name] then _G._m1911OldgloryOrigColors[child.Name] = child.Color end
                        child.Color = yellow
                    elseif child:IsA("Sparkles") then
                        if not _G._m1911OldgloryOrigColors[child.Name] then _G._m1911OldgloryOrigColors[child.Name] = child.SparkleColor end
                        child.SparkleColor = yellow
                    end
                end)
            end
            return true
        end},["Darkheart"]={id="rbxassetid://13564716720"},["White Pearl"]={id="rbxassetid://105263704974134"},["Gazaan yebaaan"]={id="rbxassetid://112475590131585"},["Sandwaves"]={id="rbxassetid://15998637813"},["Unity"]={id="rbxassetid://18149758418"},["Lunar"]={id="rbxassetid://128273297919691"},["Galaxy"]={id="rbxassetid://15646150196"},["Lazy Jester"]={id="rbxassetid://15321145643"},["Lava"]={id="rbxassetid://15264400015"}},
        ["FNP-45"] = {["Bloodshot"]={id="rbxassetid://13566118019"},["Tan"]={id="rbxassetid://15998535930"},["Pulse"]={id="rbxassetid://16355357985"},["Pulse (New)"]={id="rbxassetid://16355357614"},["G59"]={id="rbxassetid://17525744923"},["Desert Camo"]={id="rbxassetid://15320173660"},["Shattered Heart"]={id="rbxassetid://15280020776"},["Treachery"]={id="rbxassetid://15362308196"},["Sunrise"]={id="rbxassetid://15264245774"}},
        ["TEC-9"] = {["Diner"]={id="rbxassetid://13712979305"},["Gold"]={id="rbxassetid://83307928778065", customApply=function(t)
            local wh = t:FindFirstChild("WeaponHandle"); if not wh then return end
            local muzzle = wh:FindFirstChild("Muzzle"); if not muzzle then return end
            local snd = muzzle:FindFirstChild("FFireSoundTWO")
            if not snd then snd = Instance.new("Sound"); snd.Name = "FFireSoundTWO"; snd.Parent = muzzle end
            snd.SoundId = "rbxassetid://1210852193"; snd.PlaybackSpeed = 1.5; snd.Volume = 1
            local yellow = Color3.fromRGB(255,200,0); local yellowSeq = ColorSequence.new(yellow)
            if not _G._tec9GoldOrigColors then _G._tec9GoldOrigColors = {} end
            for _, child in pairs(muzzle:GetChildren()) do pcall(function()
                if child:IsA("ParticleEmitter") then if not _G._tec9GoldOrigColors[child.Name] then _G._tec9GoldOrigColors[child.Name]=child.Color end; child.Color=yellowSeq
                elseif child:IsA("Smoke") then if not _G._tec9GoldOrigColors[child.Name] then _G._tec9GoldOrigColors[child.Name]=child.Color end; child.Color=yellow
                elseif child:IsA("Sparkles") then if not _G._tec9GoldOrigColors[child.Name] then _G._tec9GoldOrigColors[child.Name]=child.SparkleColor end; child.SparkleColor=yellow end
            end) end
            return true
        end},["Dragonic"]={id="rbxassetid://111108415179208"},["Ginetonick"]={id="rbxassetid://100681165165596"},["PM"]={id="rbxassetid://93790340681172"},["Whitebone"]={id="rbxassetid://73160924638574"},["Greenout"]={id="rbxassetid://79680278943539"},["Carbon"]={id="rbxassetid://79680278943539"},["RUSSIA"]={id="rbxassetid://121521069527148"},["Requiem"]={id="rbxassetid://137017251315628"},["Cottoncloud"]={id="rbxassetid://15998727136"},["Liberty"]={id="rbxassetid://13935385791"},["Lilac"]={id="rbxassetid://13841531857"},["Import"]={id="rbxassetid://13556231753"},["Snakeskin"]={id="rbxassetid://13566186022"},["Star9"]={id="rbxassetid://13387502788"},["Iced"]={id="rbxassetid://15264655453"},["Darkmatter"]={id="rbxassetid://15282521824"}},
        ["Magnum"] = {["Inferno"]={id="rbxassetid://13565647644", customApply=function(t)
            local orange = Color3.fromRGB(160, 95, 53)
            if not _G._magnumInfernoOrig then _G._magnumInfernoOrig = {} end
            local partNames = {["BulletsRealPart"]=true,["L1"]=true,["L2"]=true,["L3"]=true,["L4"]=true}
            for _, d in pairs(t:GetDescendants()) do
                if partNames[d.Name] and (d:IsA("BasePart") or d:IsA("MeshPart")) then
                    pcall(function()
                        if not _G._magnumInfernoOrig[d] then
                            _G._magnumInfernoOrig[d] = {color=d.Color, mat=d.Material, tex=d.TextureID}
                        end
                        d.Color = orange; d.Material = Enum.Material.Neon; d.TextureID = ""
                    end)
                end
            end
            local wh = t:FindFirstChild("WeaponHandle")
            local muzzle = wh and wh:FindFirstChild("Muzzle")
            if muzzle then
                local snd = muzzle:FindFirstChild("FFireSoundTWO")
                if not snd then snd = Instance.new("Sound"); snd.Name = "FFireSoundTWO"; snd.Parent = muzzle end
                snd.SoundId = "rbxassetid://7578785210"; snd.PlaybackSpeed = 1.2; snd.Volume = 1
            end
            return true
        end},["Abstract"]={id="rbxassetid://13851638932"},["Cowboy Silvered"]={id="rbxassetid://130593263389536"},["Bronze"]={id="rbxassetid://13388529824"},["Arcticapex"]={id="rbxassetid://15710939034"},["Ironhammer"]={id="rbxassetid://18319380961"},["Bills"]={id="rbxassetid://13935343468"},["Grandpa"]={id="rbxassetid://10946557133"},["Amour"]={id="rbxassetid://16355308299"},["Limbo"]={id="rbxassetid://15370830129"},["456"]={id="rbxassetid://74041893391960"}},
        ["G-17"] = {
            ["Gleagle"]={id="rbxassetid://16911006388"},
            ["RedWood"]={id="rbxassetid://137523407857261"},
            ["Redbape"]={id="rbxassetid://122542990627224"},
            ["Hotblue"]={id="rbxassetid://109723583774820"},
            ["Gold"]={id="rbxassetid://120291964077772", customApply=function(t)
            local wh = t:FindFirstChild("WeaponHandle"); if not wh then return end
            local muzzle = wh:FindFirstChild("Muzzle"); if not muzzle then return end
            local snd = muzzle:FindFirstChild("FFireSoundTWO")
            if not snd then snd = Instance.new("Sound"); snd.Name = "FFireSoundTWO"; snd.Parent = muzzle end
            snd.SoundId = "rbxassetid://1210852193"; snd.PlaybackSpeed = 1.5; snd.Volume = 1
            local yellow = Color3.fromRGB(255,200,0); local yellowSeq = ColorSequence.new(yellow)
            if not _G._g17GoldOrigColors then _G._g17GoldOrigColors = {} end
            for _, child in pairs(muzzle:GetChildren()) do pcall(function()
                if child:IsA("ParticleEmitter") then if not _G._g17GoldOrigColors[child.Name] then _G._g17GoldOrigColors[child.Name]=child.Color end; child.Color=yellowSeq
                elseif child:IsA("Smoke") then if not _G._g17GoldOrigColors[child.Name] then _G._g17GoldOrigColors[child.Name]=child.Color end; child.Color=yellow
                elseif child:IsA("Sparkles") then if not _G._g17GoldOrigColors[child.Name] then _G._g17GoldOrigColors[child.Name]=child.SparkleColor end; child.SparkleColor=yellow end
            end) end
            return true
        end},
            ["Dragonit"]={id="rbxassetid://78392359238030"},
            ["Lightrose"]={id="rbxassetid://114687207309114"},
            ["Sjull"]={id="rbxassetid://73161208203144"},
            ["Flowers"]={id="rbxassetid://78633165502325"},
            ["Skulled"]={id="rbxassetid://72272620660994"},
            ["Gamma Doppler"]={id="rbxassetid://136980397772527"},
            ["Gradient"]={id="rbxassetid://130087883139550"},
            ["Hotpink"]={id="rbxassetid://15998559023", customApply=function(t) return G17Sights(t, Enum.Material.Neon, Color3.fromRGB(211,157,188)) end},
            ["Warhawk"]={id="rbxassetid://10898489161", customApply=function(t) return G17Sights(t, nil, Color3.fromRGB(197,189,106)) end},
            ["Amethyst"]={id="rbxassetid://9344554991", customApply=function(t) return G17Sights(t, Enum.Material.Neon, Color3.fromRGB(121,113,163)) end},
            ["Digital Green"]={id="rbxassetid://9422494421", customApply=function(t) return G17Sights(t, nil, Color3.fromRGB(161,179,98)) end},
            ["Sage"]={id="rbxassetid://10898771076", customApply=function(t) return G17Sights(t, nil, Color3.fromRGB(116,121,98)) end},
            ["Benjamin"]={id="rbxassetid://18198687338"},
            ["Oxide"]={id="rbxassetid://13556385916", customApply=function(t) return G17Sights(t, nil, Color3.fromRGB(145,190,197)) end},
            ["Tan"]={id="rbxassetid://13841571102", customApply=function(t) return G17Sights(t, nil, Color3.fromRGB(121,108,98)) end},
            ["Night"]={id="rbxassetid://10899178487", customApply=function(t) return G17Sights(t, nil, Color3.fromRGB(104,117,121)) end},
            ["Yosei"]={id="rbxassetid://15707661222"},["GRUNCH"]={id="rbxassetid://125445752675439"},["Sigma"]={id="rbxassetid://17861230617"},
            ["ELIMINATION"]={id="rbxassetid://94164067871562", customApply=function(t)
                local pink = Color3.fromRGB(165, 128, 136)
                local black = Color3.fromRGB(17, 17, 17)
                local pinkSeq = ColorSequence.new(pink)
                if not _G._g17ElimOrigColors then _G._g17ElimOrigColors = {} end
                local partSettings = {
                    ["Barrel"]       = {color=black, mat=Enum.Material.ForceField, clearTex=true},
                    ["SlidePart"]    = {color=black, mat=Enum.Material.ForceField, clearTex=true},
                    ["FrontSightColorPart"] = {color=pink, mat=Enum.Material.Neon, clearTex=true},
                    ["RearSightColorPart"]  = {color=pink, mat=Enum.Material.Neon, clearTex=true},
                    ["BulletPart"]   = {color=pink, mat=Enum.Material.Neon, clearTex=true},
                }
                for _, d in pairs(t:GetDescendants()) do
                    local settings = partSettings[d.Name]
                    if settings and (d:IsA("BasePart") or d:IsA("MeshPart")) then
                        pcall(function()
                            if not _G._g17ElimOrigColors[d] then
                                _G._g17ElimOrigColors[d] = {color=d.Color, mat=d.Material, tex=d.TextureID}
                            end
                            d.Color = settings.color
                            d.Material = settings.mat
                            if settings.clearTex then d.TextureID = "" end
                        end)
                    end
                end
                local wh = t:FindFirstChild("WeaponHandle")
                local muzzle = wh and wh:FindFirstChild("Muzzle")
                if muzzle then
                    local snd = muzzle:FindFirstChild("FFireSoundTWO")
                    if not snd then snd = Instance.new("Sound"); snd.Name = "FFireSoundTWO"; snd.Parent = muzzle end
                    snd.SoundId = "rbxassetid://3466984142"; snd.PlaybackSpeed = 2.5; snd.Volume = 1
                    if not _G._g17ElimMuzzleOrig then _G._g17ElimMuzzleOrig = {} end
                    for _, child in pairs(muzzle:GetChildren()) do
                        pcall(function()
                            if child:IsA("ParticleEmitter") then
                                if not _G._g17ElimMuzzleOrig[child.Name] then _G._g17ElimMuzzleOrig[child.Name] = child.Color end
                                child.Color = pinkSeq
                            elseif child:IsA("Smoke") then
                                if not _G._g17ElimMuzzleOrig[child.Name] then _G._g17ElimMuzzleOrig[child.Name] = child.Color end
                                child.Color = pink
                            elseif child:IsA("Sparkles") then
                                if not _G._g17ElimMuzzleOrig[child.Name] then _G._g17ElimMuzzleOrig[child.Name] = child.SparkleColor end
                                child.SparkleColor = pink
                            end
                        end)
                    end
                end
                return true
            end, customDisplayApply=function(root)
                local pink = Color3.fromRGB(165,128,136)
                local black = Color3.fromRGB(17,17,17)
                local ps = {["Barrel"]={color=black,mat=Enum.Material.ForceField},["SlidePart"]={color=black,mat=Enum.Material.ForceField},["FrontSightColorPart"]={color=pink,mat=Enum.Material.Neon},["RearSightColorPart"]={color=pink,mat=Enum.Material.Neon},["BulletPart"]={color=pink,mat=Enum.Material.Neon}}
                for _,d in pairs(root:GetDescendants()) do local s=ps[d.Name]; if s and (d:IsA("BasePart") or d:IsA("MeshPart")) then pcall(function() d.Color=s.color; d.Material=s.mat; d.TextureID="" end) end end
            end},["Photon"]={id="rbxassetid://94317587382863"},["ToyBlaster"]={id="rbxassetid://15345210370"},
            ["Tomato"]={id="rbxassetid://17861211063"},["Dragon Power"]={id="rbxassetid://15297949359"},
            ["Hells Angel"]={id="rbxassetid://15257750130"},["Fall"]={id="rbxassetid://15264245774"},["Toy"]={id="rbxassetid://15342068894"}
        },
        ["G-18"] = {
            ["Gleagle"]={id="rbxassetid://16911006388"},
            ["Sjull"]={id="rbxassetid://73161208203144"},
            ["Skulled"]={id="rbxassetid://72272620660994"},
            ["Gamma Doppler"]={id="rbxassetid://136980397772527"},
            ["Gradient"]={id="rbxassetid://130087883139550"},
            ["RedWood"]={id="rbxassetid://137523407857261"},
            ["Redbape"]={id="rbxassetid://122542990627224"},
            ["Hotblue"]={id="rbxassetid://109723583774820"},
            ["Gold"]={id="rbxassetid://120291964077772", customApply=function(t)
            local wh = t:FindFirstChild("WeaponHandle"); if not wh then return end
            local muzzle = wh:FindFirstChild("Muzzle"); if not muzzle then return end
            local snd = muzzle:FindFirstChild("FFireSoundTWO")
            if not snd then snd = Instance.new("Sound"); snd.Name = "FFireSoundTWO"; snd.Parent = muzzle end
            snd.SoundId = "rbxassetid://1210852193"; snd.PlaybackSpeed = 1.5; snd.Volume = 1
            local yellow = Color3.fromRGB(255,200,0); local yellowSeq = ColorSequence.new(yellow)
            if not _G._g18GoldOrigColors then _G._g18GoldOrigColors = {} end
            for _, child in pairs(muzzle:GetChildren()) do pcall(function()
                if child:IsA("ParticleEmitter") then if not _G._g18GoldOrigColors[child.Name] then _G._g18GoldOrigColors[child.Name]=child.Color end; child.Color=yellowSeq
                elseif child:IsA("Smoke") then if not _G._g18GoldOrigColors[child.Name] then _G._g18GoldOrigColors[child.Name]=child.Color end; child.Color=yellow
                elseif child:IsA("Sparkles") then if not _G._g18GoldOrigColors[child.Name] then _G._g18GoldOrigColors[child.Name]=child.SparkleColor end; child.SparkleColor=yellow end
            end) end
            return true
        end},
            ["Hotpink"]={id="rbxassetid://15998559023", customApply=function(t) return G17Sights(t, Enum.Material.Neon, Color3.fromRGB(211,157,188)) end},
            ["Warhawk"]={id="rbxassetid://10898489161", customApply=function(t) return G17Sights(t, nil, Color3.fromRGB(197,189,106)) end},
            ["Amethyst"]={id="rbxassetid://9344554991", customApply=function(t) return G17Sights(t, Enum.Material.Neon, Color3.fromRGB(121,113,163)) end},
            ["Digital Green"]={id="rbxassetid://9422494421", customApply=function(t) return G17Sights(t, nil, Color3.fromRGB(161,179,98)) end},
            ["Sage"]={id="rbxassetid://10898771076", customApply=function(t) return G17Sights(t, nil, Color3.fromRGB(116,121,98)) end},
            ["Benjamin"]={id="rbxassetid://18198687338"},
            ["Oxide"]={id="rbxassetid://13556385916", customApply=function(t) return G17Sights(t, nil, Color3.fromRGB(145,190,197)) end},
            ["Tan"]={id="rbxassetid://13841571102", customApply=function(t) return G17Sights(t, nil, Color3.fromRGB(121,108,98)) end},
            ["Night"]={id="rbxassetid://10899178487", customApply=function(t) return G17Sights(t, nil, Color3.fromRGB(104,117,121)) end},
            ["Yosei"]={id="rbxassetid://15707661222"},["GRUNCH"]={id="rbxassetid://125445752675439"},["Sigma"]={id="rbxassetid://17861230617"},
            ["ELIMINATION"]={id="rbxassetid://94164067871562", customApply=function(t)
                local pink = Color3.fromRGB(165,128,136)
                local black = Color3.fromRGB(17,17,17)
                local pinkSeq = ColorSequence.new(pink)
                if not _G._g18ElimOrigColors then _G._g18ElimOrigColors = {} end
                local partSettings = {
                    ["Barrel"]={color=black,mat=Enum.Material.ForceField,clearTex=true},
                    ["SlidePart"]={color=black,mat=Enum.Material.ForceField,clearTex=true},
                    ["FrontSightColorPart"]={color=pink,mat=Enum.Material.Neon,clearTex=true},
                    ["RearSightColorPart"]={color=pink,mat=Enum.Material.Neon,clearTex=true},
                    ["BulletPart"]={color=pink,mat=Enum.Material.Neon,clearTex=true},
                }
                for _, d in pairs(t:GetDescendants()) do
                    local s = partSettings[d.Name]
                    if s and (d:IsA("BasePart") or d:IsA("MeshPart")) then
                        pcall(function()
                            if not _G._g18ElimOrigColors[d] then _G._g18ElimOrigColors[d]={color=d.Color,mat=d.Material,tex=d.TextureID} end
                            d.Color=s.color; d.Material=s.mat
                            if s.clearTex then d.TextureID="" end
                        end)
                    end
                end
                local wh = t:FindFirstChild("WeaponHandle")
                local muzzle = wh and wh:FindFirstChild("Muzzle")
                if muzzle then
                    local snd = muzzle:FindFirstChild("FFireSoundTWO")
                    if not snd then snd=Instance.new("Sound"); snd.Name="FFireSoundTWO"; snd.Parent=muzzle end
                    snd.SoundId="rbxassetid://3466984142"; snd.PlaybackSpeed=2.5; snd.Volume=1
                    if not _G._g18ElimMuzzleOrig then _G._g18ElimMuzzleOrig={} end
                    for _,child in pairs(muzzle:GetChildren()) do pcall(function()
                        if child:IsA("ParticleEmitter") then if not _G._g18ElimMuzzleOrig[child.Name] then _G._g18ElimMuzzleOrig[child.Name]=child.Color end; child.Color=pinkSeq
                        elseif child:IsA("Smoke") then if not _G._g18ElimMuzzleOrig[child.Name] then _G._g18ElimMuzzleOrig[child.Name]=child.Color end; child.Color=pink
                        elseif child:IsA("Sparkles") then if not _G._g18ElimMuzzleOrig[child.Name] then _G._g18ElimMuzzleOrig[child.Name]=child.SparkleColor end; child.SparkleColor=pink end
                    end) end
                end
                return true
            end, customDisplayApply=function(root)
                local pink=Color3.fromRGB(165,128,136); local black=Color3.fromRGB(17,17,17)
                local ps={["Barrel"]={color=black,mat=Enum.Material.ForceField},["SlidePart"]={color=black,mat=Enum.Material.ForceField},["FrontSightColorPart"]={color=pink,mat=Enum.Material.Neon},["RearSightColorPart"]={color=pink,mat=Enum.Material.Neon},["BulletPart"]={color=pink,mat=Enum.Material.Neon}}
                for _,d in pairs(root:GetDescendants()) do local s=ps[d.Name]; if s and (d:IsA("BasePart") or d:IsA("MeshPart")) then pcall(function() d.Color=s.color; d.Material=s.mat; d.TextureID="" end) end end
            end},["Photon"]={id="rbxassetid://94317587382863"},["ToyBlaster"]={id="rbxassetid://15345210370"},
            ["Tomato"]={id="rbxassetid://17861211063"},["Dragon Power"]={id="rbxassetid://15297949359"},
            ["Hells Angel"]={id="rbxassetid://15257750130"},["Fall"]={id="rbxassetid://15264245774"},["Toy"]={id="rbxassetid://15342068894"}
        },
        ["G-18-X"] = {
            ["Gleagle"]={id="rbxassetid://16911006388"},
            ["Sjull"]={id="rbxassetid://73161208203144"},
            ["RedWood"]={id="rbxassetid://137523407857261"},
            ["Gamma Doppler"]={id="rbxassetid://136980397772527"},
            ["Gradient"]={id="rbxassetid://130087883139550"},
            ["Redbape"]={id="rbxassetid://122542990627224"},
            ["Hotblue"]={id="rbxassetid://109723583774820"},
            ["Skulled"]={id="rbxassetid://72272620660994"},
            ["Gold"]={id="rbxassetid://120291964077772", customApply=function(t)
            local wh = t:FindFirstChild("WeaponHandle"); if not wh then return end
            local muzzle = wh:FindFirstChild("Muzzle"); if not muzzle then return end
            local snd = muzzle:FindFirstChild("FFireSoundTWO")
            if not snd then snd = Instance.new("Sound"); snd.Name = "FFireSoundTWO"; snd.Parent = muzzle end
            snd.SoundId = "rbxassetid://1210852193"; snd.PlaybackSpeed = 1.5; snd.Volume = 1
            local yellow = Color3.fromRGB(255,200,0); local yellowSeq = ColorSequence.new(yellow)
            if not _G._g18xGoldOrigColors then _G._g18xGoldOrigColors = {} end
            for _, child in pairs(muzzle:GetChildren()) do pcall(function()
                if child:IsA("ParticleEmitter") then if not _G._g18xGoldOrigColors[child.Name] then _G._g18xGoldOrigColors[child.Name]=child.Color end; child.Color=yellowSeq
                elseif child:IsA("Smoke") then if not _G._g18xGoldOrigColors[child.Name] then _G._g18xGoldOrigColors[child.Name]=child.Color end; child.Color=yellow
                elseif child:IsA("Sparkles") then if not _G._g18xGoldOrigColors[child.Name] then _G._g18xGoldOrigColors[child.Name]=child.SparkleColor end; child.SparkleColor=yellow end
            end) end
            return true
        end},
            ["Hotpink"]={id="rbxassetid://15998559023", customApply=function(t) return G17Sights(t, Enum.Material.Neon, Color3.fromRGB(211,157,188)) end},
            ["Warhawk"]={id="rbxassetid://10898489161", customApply=function(t) return G17Sights(t, nil, Color3.fromRGB(197,189,106)) end},
            ["Amethyst"]={id="rbxassetid://9344554991", customApply=function(t) return G17Sights(t, Enum.Material.Neon, Color3.fromRGB(121,113,163)) end},
            ["Digital Green"]={id="rbxassetid://9422494421", customApply=function(t) return G17Sights(t, nil, Color3.fromRGB(161,179,98)) end},
            ["Sage"]={id="rbxassetid://10898771076", customApply=function(t) return G17Sights(t, nil, Color3.fromRGB(116,121,98)) end},
            ["Benjamin"]={id="rbxassetid://18198687338"},
            ["Oxide"]={id="rbxassetid://13556385916", customApply=function(t) return G17Sights(t, nil, Color3.fromRGB(145,190,197)) end},
            ["Tan"]={id="rbxassetid://13841571102", customApply=function(t) return G17Sights(t, nil, Color3.fromRGB(121,108,98)) end},
            ["Night"]={id="rbxassetid://10899178487", customApply=function(t) return G17Sights(t, nil, Color3.fromRGB(104,117,121)) end},
            ["Yosei"]={id="rbxassetid://15707661222"},["GRUNCH"]={id="rbxassetid://125445752675439"},["Sigma"]={id="rbxassetid://17861230617"},
            ["ELIMINATION"]={id="rbxassetid://94164067871562", customApply=function(t)
                local pink = Color3.fromRGB(165,128,136)
                local black = Color3.fromRGB(17,17,17)
                local pinkSeq = ColorSequence.new(pink)
                if not _G._g18xElimOrigColors then _G._g18xElimOrigColors = {} end
                local partSettings = {
                    ["Barrel"]={color=black,mat=Enum.Material.ForceField,clearTex=true},
                    ["SlidePart"]={color=black,mat=Enum.Material.ForceField,clearTex=true},
                    ["FrontSightColorPart"]={color=pink,mat=Enum.Material.Neon,clearTex=true},
                    ["RearSightColorPart"]={color=pink,mat=Enum.Material.Neon,clearTex=true},
                    ["BulletPart"]={color=pink,mat=Enum.Material.Neon,clearTex=true},
                }
                for _, d in pairs(t:GetDescendants()) do
                    local s = partSettings[d.Name]
                    if s and (d:IsA("BasePart") or d:IsA("MeshPart")) then
                        pcall(function()
                            if not _G._g18xElimOrigColors[d] then _G._g18xElimOrigColors[d]={color=d.Color,mat=d.Material,tex=d.TextureID} end
                            d.Color=s.color; d.Material=s.mat
                            if s.clearTex then d.TextureID="" end
                        end)
                    end
                end
                local wh = t:FindFirstChild("WeaponHandle")
                local muzzle = wh and wh:FindFirstChild("Muzzle")
                if muzzle then
                    local snd = muzzle:FindFirstChild("FFireSoundTWO")
                    if not snd then snd=Instance.new("Sound"); snd.Name="FFireSoundTWO"; snd.Parent=muzzle end
                    snd.SoundId="rbxassetid://3466984142"; snd.PlaybackSpeed=2.5; snd.Volume=1
                    if not _G._g18xElimMuzzleOrig then _G._g18xElimMuzzleOrig={} end
                    for _,child in pairs(muzzle:GetChildren()) do pcall(function()
                        if child:IsA("ParticleEmitter") then if not _G._g18xElimMuzzleOrig[child.Name] then _G._g18xElimMuzzleOrig[child.Name]=child.Color end; child.Color=pinkSeq
                        elseif child:IsA("Smoke") then if not _G._g18xElimMuzzleOrig[child.Name] then _G._g18xElimMuzzleOrig[child.Name]=child.Color end; child.Color=pink
                        elseif child:IsA("Sparkles") then if not _G._g18xElimMuzzleOrig[child.Name] then _G._g18xElimMuzzleOrig[child.Name]=child.SparkleColor end; child.SparkleColor=pink end
                    end) end
                end
                return true
            end, customDisplayApply=function(root)
                local pink=Color3.fromRGB(165,128,136); local black=Color3.fromRGB(17,17,17)
                local ps={["Barrel"]={color=black,mat=Enum.Material.ForceField},["SlidePart"]={color=black,mat=Enum.Material.ForceField},["FrontSightColorPart"]={color=pink,mat=Enum.Material.Neon},["RearSightColorPart"]={color=pink,mat=Enum.Material.Neon},["BulletPart"]={color=pink,mat=Enum.Material.Neon}}
                for _,d in pairs(root:GetDescendants()) do local s=ps[d.Name]; if s and (d:IsA("BasePart") or d:IsA("MeshPart")) then pcall(function() d.Color=s.color; d.Material=s.mat; d.TextureID="" end) end end
            end},["Photon"]={id="rbxassetid://94317587382863"},["ToyBlaster"]={id="rbxassetid://15345210370"},
            ["Tomato"]={id="rbxassetid://17861211063"},["Dragon Power"]={id="rbxassetid://15297949359"},
            ["Hells Angel"]={id="rbxassetid://15257750130"},["Fall"]={id="rbxassetid://15264245774"},["Toy"]={id="rbxassetid://15342068894"}
        },
        ["Deagle"] = {["Plasma"]={id="rbxassetid://13567908266"},["Mountain Sunset"]={id="rbxassetid://16018334320"},["Mashed"]={id="rbxassetid://15645853435"},["Hydration"]={id="rbxassetid://15311299274"},["Gingerbread"]={id="rbxassetid://15695335671"},["Federation"]={id="rbxassetid://13841710519"},["Presidential"]={id="rbxassetid://18198669148"},["Presidential (New)"]={id="rbxassetid://18198670122"},["ExoticTest"]={id="rbxassetid://15445293206"},["Golden"]={id="rbxassetid://9422465914", customApply=function(t)
            local wh = t:FindFirstChild("WeaponHandle"); if not wh then return end
            local muzzle = wh:FindFirstChild("Muzzle"); if not muzzle then return end
            local snd = muzzle:FindFirstChild("FFireSoundTWO")
            if not snd then snd = Instance.new("Sound"); snd.Name = "FFireSoundTWO"; snd.Parent = muzzle end
            snd.SoundId = "rbxassetid://1210852193"; snd.PlaybackSpeed = 1.5; snd.Volume = 1
            local yellow = Color3.fromRGB(255,200,0); local yellowSeq = ColorSequence.new(yellow)
            if not _G._deagleGoldOrigColors then _G._deagleGoldOrigColors = {} end
            for _, child in pairs(muzzle:GetChildren()) do pcall(function()
                if child:IsA("ParticleEmitter") then if not _G._deagleGoldOrigColors[child.Name] then _G._deagleGoldOrigColors[child.Name]=child.Color end; child.Color=yellowSeq
                elseif child:IsA("Smoke") then if not _G._deagleGoldOrigColors[child.Name] then _G._deagleGoldOrigColors[child.Name]=child.Color end; child.Color=yellow
                elseif child:IsA("Sparkles") then if not _G._deagleGoldOrigColors[child.Name] then _G._deagleGoldOrigColors[child.Name]=child.SparkleColor end; child.SparkleColor=yellow end
            end) end
            return true
        end},["Eagleeye"]={id="rbxassetid://13937646988"},["Nacho"]={id="rbxassetid://16942393059"},["Acrylic"]={id="rbxassetid://13714048705"},["Ember"]={id="rbxassetid://16041800350"},["Reaper"]={id="rbxassetid://88948471438774"},["OMORI"]={id="rbxassetid://136460482192003"},["Red Skull"]={id="rbxassetid://17861203454"},["Achievent"]={id="rbxassetid://11934375653"},["Illuminated"]={id="rbxassetid://16018590682"},["SKIBIDIGLE"]={id="rbxassetid://18761552696"},["Winter"]={id="rbxassetid://15293726993"},["Hydration"]={id="rbxassetid://15311368659"},["Inferno"]={id="rbxassetid://16065242678"},["Nigger"]={id="rbxassetid://60484592"}},
        ["Beretta"] = {["Wooden"]={id="rbxassetid://15695411633"},["Gingerbread"]={id="rbxassetid://93272969986535"},["Clef"]={id="rbxassetid://13387587315"},["Sektatar"]={id="rbxassetid://75279788664610"},["Makarov"]={id="rbxassetid://100642188396999"},["Indepence"]={id="rbxassetid://92454568789042"},["Fallen"]={id="rbxassetid://122109061721406"},["Mafiozo"]={id="rbxassetid://128244637306934"},["Silvered"]={id="rbxassetid://15998401350"},["Knight"]={id="rbxassetid://112424211127596"},["Urbanred"]={id="rbxassetid://13841595045"},["Moss"]={id="rbxassetid://13443011965"},["Digital"]={id="rbxassetid://9341791793"},["Walker"]={id="rbxassetid://15177179442"},["Tiger"]={id="rbxassetid://13704088639"},["Gold"]={id="rbxassetid://15039167103", customApply=function(t)
            local wh = t:FindFirstChild("WeaponHandle")
            if not wh then return end
            local muzzle = wh:FindFirstChild("Muzzle")
            if not muzzle then return end
            local snd = muzzle:FindFirstChild("FFireSoundTWO")
            if not snd then snd = Instance.new("Sound"); snd.Name = "FFireSoundTWO"; snd.Parent = muzzle end
            snd.SoundId = "rbxassetid://1210852193"; snd.PlaybackSpeed = 1.5; snd.Volume = 1
            local yellow = Color3.fromRGB(255, 200, 0)
            local yellowSeq = ColorSequence.new(yellow)
            local particleNames = {"Barrel smoke","FlashEmitter","Gas","Gas2","Lens flare","Muzzle Flash 1","SmokeEmitter","Sparkles"}
            for _, name in ipairs(particleNames) do
                local p = muzzle:FindFirstChild(name)
                if p then pcall(function()
                    if p:IsA("ParticleEmitter") then
                        if not _G._berettaOrigColors then _G._berettaOrigColors = {} end
                        if not _G._berettaOrigColors[name] then _G._berettaOrigColors[name] = p.Color end
                        p.Color = yellowSeq
                    elseif p:IsA("Smoke") then
                        if not _G._berettaOrigColors then _G._berettaOrigColors = {} end
                        if not _G._berettaOrigColors[name] then _G._berettaOrigColors[name] = p.Color end
                        p.Color = yellow
                    elseif p:IsA("Sparkles") then
                        if not _G._berettaOrigColors then _G._berettaOrigColors = {} end
                        if not _G._berettaOrigColors[name] then _G._berettaOrigColors[name] = p.SparkleColor end
                        p.SparkleColor = yellow
                    end
                end) end
            end
            return true
        end},["GoldenClouds"]={id="rbxassetid://15645965487"},["Kitten"]={id="rbxassetid://15319888022"},["Haresy"]={id="rbxassetid://15357016361"}},
        ["Hawkeye"] = {["Story Of Dragon"]={id="rbxassetid://72701714984885"},["Scroll Of Intellect"]={id="rbxassetid://113767818518860"},["Gold"]={id="rbxassetid://70692231773291"}},
    },
    Snipers = {
        ["Mare"] = {["Maritime"]={id="rbxassetid://15998688712"},["Rust"]={id="rbxassetid://16560187868"},["Frostecho"]={id="rbxassetid://15695474241"},["Stallion"]={id="rbxassetid://13556460890"},["Gold"]={id="rbxassetid://16560241772"},["TrickShot"]={id="rbxassetid://16907785827"},["BlipBlop"]={id="rbxassetid://15507973306"},["Paintball Mare"]={id="rbxassetid://15250631049"},["Azurite"]={id="rbxassetid://15264608175"}},
        ["Scout"] = {["SUnseemly Virescent"]={id="rbxassetid://15297464039"},["Relic is Present"]={id="rbxassetid://127029130055628"}},
        ["BFG-1"] = {["Savior"]={id="rbxassetid://18316883517"},["Dragonlore"]={id="rbxassetid://85587904714868"},["Federal"]={id="rbxassetid://13948416273"},["Cupid"]={id="rbxassetid://16355412948"},["Inferno"]={id="rbxassetid://16648247101"},["Nerf"]={id="rbxassetid://17861264834"},["Grapes"]={id="rbxassetid://15718105579"},["Vibrant"]={id="rbxassetid://15646150196"},["Blue Fade"]={id="rbxassetid://15322769646"},["Bloodied"]={id="rbxassetid://13948416273"},["USA"]={id="rbxassetid://941761111"}},
    },
    SMGS = {
        ["Uzi"] = {["Rust"]={id="rbxassetid://13715502850"},["BRAINROT"]={id="rbxassetid://116553702208312"},["BlueSky"]={id="rbxassetid://92753563236550"},["Damascus"]={id="rbxassetid://82490185009183"},["Premium"]={id="rbxassetid://136048473285965"},["Apex"]={id="rbxassetid://74316388718020"},["Morte"]={id="rbxassetid://105172018177784"},["BMW"]={id="rbxassetid://97244031852464"},["Grape2"]={id="rbxassetid://16952083915"},["Smiley"]={id="rbxassetid://13841666943"},["Pumpkinspice"]={id="rbxassetid://15177118472"},["Guilded"]={id="rbxassetid://15998742287"},["Grape"]={id="rbxassetid://13387917991"},["Hallowed"]={id="rbxassetid://15264802296"},["Sparkle Time"]={id="rbxassetid://15320329589"},["Rusted Highlighter"]={id="rbxassetid://15283257255"},["TZZV"]={id="rbxassetid://13387917991"}},
        ["Uzi-S"] = {["Rust"]={id="rbxassetid://13715502850"},["Grape2"]={id="rbxassetid://16952083915"},["Smiley"]={id="rbxassetid://13841666943"},["Pumpkinspice"]={id="rbxassetid://15177118472"},["Guilded"]={id="rbxassetid://15998742287"},["Grape"]={id="rbxassetid://13387917991"},["Hallowed"]={id="rbxassetid://15264802296"},["Sparkle Time"]={id="rbxassetid://15320329589"},["TZZV"]={id="rbxassetid://13387917991"}},
        ["UMP-45"] = {["Lesion"]={id="rbxassetid://15177224638"},["Quavers"]={id="rbxassetid://75562498289063"},["Burntumber"]={id="rbxassetid://13842574571"},["Dragon"]={id="rbxassetid://15264844741"}},
        ["UMP-45-S"] = {["Lesion"]={id="rbxassetid://15177224638"},["Quavers"]={id="rbxassetid://75562498289063"},["Burntumber"]={id="rbxassetid://13842574571"},["Dragon"]={id="rbxassetid://15264844741"}},
        ["MP7"] = {["Nixerious"]={id="rbxassetid://113877254258956"},["Gold"]={id="rbxassetid://15039147920", customApply=function(t)
            local wh = t:FindFirstChild("WeaponHandle")
            if not wh then return end
            local muzzle = wh:FindFirstChild("Muzzle")
            if not muzzle then return end
            local snd = muzzle:FindFirstChild("FFireSoundTWO")
            if not snd then snd = Instance.new("Sound"); snd.Name = "FFireSoundTWO"; snd.Parent = muzzle end
            snd.SoundId = "rbxassetid://1210852193"; snd.PlaybackSpeed = 1.5; snd.Volume = 1
            local yellow = Color3.fromRGB(255, 200, 0)
            local yellowSeq = ColorSequence.new(yellow)
            if not _G._mp7GoldOrigColors then _G._mp7GoldOrigColors = {} end
            for _, child in pairs(muzzle:GetChildren()) do
                pcall(function()
                    if child:IsA("ParticleEmitter") then
                        if not _G._mp7GoldOrigColors[child.Name] then _G._mp7GoldOrigColors[child.Name] = child.Color end
                        child.Color = yellowSeq
                    elseif child:IsA("Smoke") then
                        if not _G._mp7GoldOrigColors[child.Name] then _G._mp7GoldOrigColors[child.Name] = child.Color end
                        child.Color = yellow
                    elseif child:IsA("Sparkles") then
                        if not _G._mp7GoldOrigColors[child.Name] then _G._mp7GoldOrigColors[child.Name] = child.SparkleColor end
                        child.SparkleColor = yellow
                    end
                end)
            end
            return true
        end},["Navy"]={id="rbxassetid://13714362770"},["Digital"]={id="rbxassetid://13703243112"},["Hellrazor"]={id="rbxassetid://13842812065"},["Zombified"]={id="rbxassetid://15334894800"},["Olive"]={id="rbxassetid://13404159306"},["Left4Dead"]={id="rbxassetid://15334894800"},["Italiano?"]={id="rbxassetid://15334630306"}},
        ["MP7-S"] = {["Navy"]={id="rbxassetid://13714362770"},["Digital"]={id="rbxassetid://13703243112"},["Hellrazor"]={id="rbxassetid://13842812065"},["Zombified"]={id="rbxassetid://15334894800"},["Olive"]={id="rbxassetid://13404159306"},["Left4Dead"]={id="rbxassetid://15334894800"},["Italiano?"]={id="rbxassetid://15334630306"},["Gold"]={id="rbxassetid://15039147920", customApply=function(t)
            local wh = t:FindFirstChild("WeaponHandle")
            if not wh then return end
            local muzzle = wh:FindFirstChild("Muzzle")
            if not muzzle then return end
            local snd = muzzle:FindFirstChild("FFireSoundTWO")
            if not snd then snd = Instance.new("Sound"); snd.Name = "FFireSoundTWO"; snd.Parent = muzzle end
            snd.SoundId = "rbxassetid://1210852193"; snd.PlaybackSpeed = 1.5; snd.Volume = 1
            local yellow = Color3.fromRGB(255, 200, 0)
            local yellowSeq = ColorSequence.new(yellow)
            if not _G._mp7sGoldOrigColors then _G._mp7sGoldOrigColors = {} end
            for _, child in pairs(muzzle:GetChildren()) do
                pcall(function()
                    if child:IsA("ParticleEmitter") then
                        if not _G._mp7sGoldOrigColors[child.Name] then _G._mp7sGoldOrigColors[child.Name] = child.Color end
                        child.Color = yellowSeq
                    elseif child:IsA("Smoke") then
                        if not _G._mp7sGoldOrigColors[child.Name] then _G._mp7sGoldOrigColors[child.Name] = child.Color end
                        child.Color = yellow
                    elseif child:IsA("Sparkles") then
                        if not _G._mp7sGoldOrigColors[child.Name] then _G._mp7sGoldOrigColors[child.Name] = child.SparkleColor end
                        child.SparkleColor = yellow
                    end
                end)
            end
            return true
        end}},
        ["Tommy"] = {["Mafia"]={id="rbxassetid://13387532472"},["Currant"]={id="rbxassetid://13841583772"},["Gold"]={id="rbxassetid://15039147920", customApply=function(t)
            local wh = t:FindFirstChild("WeaponHandle"); if not wh then return end
            local muzzle = wh:FindFirstChild("Muzzle"); if not muzzle then return end
            local snd = muzzle:FindFirstChild("FFireSoundTWO")
            if not snd then snd = Instance.new("Sound"); snd.Name = "FFireSoundTWO"; snd.Parent = muzzle end
            snd.SoundId = "rbxassetid://1210852193"; snd.PlaybackSpeed = 1.5; snd.Volume = 1
            local yellow = Color3.fromRGB(255,200,0); local yellowSeq = ColorSequence.new(yellow)
            if not _G._tommyGoldOrigColors then _G._tommyGoldOrigColors = {} end
            for _, child in pairs(muzzle:GetChildren()) do pcall(function()
                if child:IsA("ParticleEmitter") then if not _G._tommyGoldOrigColors[child.Name] then _G._tommyGoldOrigColors[child.Name]=child.Color end; child.Color=yellowSeq
                elseif child:IsA("Smoke") then if not _G._tommyGoldOrigColors[child.Name] then _G._tommyGoldOrigColors[child.Name]=child.Color end; child.Color=yellow
                elseif child:IsA("Sparkles") then if not _G._tommyGoldOrigColors[child.Name] then _G._tommyGoldOrigColors[child.Name]=child.SparkleColor end; child.SparkleColor=yellow end
            end) end
            return true
        end},["Plum"]={id="rbxassetid://13388349585"},["Leatherworks"]={id="rbxassetid://13556313114"},["Unclesam"]={id="rbxassetid://13936670325"},["Headstone"]={id="rbxassetid://15177096261"},["Stained"]={id="rbxassetid://16037741369"},["Candy Pop"]={id="rbxassetid://15264694906"},["Doodle"]={id="rbxassetid://15297763963"},["Greed"]={id="rbxassetid://15362065880"}},
        ["Tommy-S"] = {["Mafia"]={id="rbxassetid://13387532472"},["Currant"]={id="rbxassetid://13841583772"},["Gold"]={id="rbxassetid://15039147920", customApply=function(t)
            local wh = t:FindFirstChild("WeaponHandle"); if not wh then return end
            local muzzle = wh:FindFirstChild("Muzzle"); if not muzzle then return end
            local snd = muzzle:FindFirstChild("FFireSoundTWO")
            if not snd then snd = Instance.new("Sound"); snd.Name = "FFireSoundTWO"; snd.Parent = muzzle end
            snd.SoundId = "rbxassetid://1210852193"; snd.PlaybackSpeed = 1.5; snd.Volume = 1
            local yellow = Color3.fromRGB(255,200,0); local yellowSeq = ColorSequence.new(yellow)
            if not _G._tommysGoldOrigColors then _G._tommysGoldOrigColors = {} end
            for _, child in pairs(muzzle:GetChildren()) do pcall(function()
                if child:IsA("ParticleEmitter") then if not _G._tommysGoldOrigColors[child.Name] then _G._tommysGoldOrigColors[child.Name]=child.Color end; child.Color=yellowSeq
                elseif child:IsA("Smoke") then if not _G._tommysGoldOrigColors[child.Name] then _G._tommysGoldOrigColors[child.Name]=child.Color end; child.Color=yellow
                elseif child:IsA("Sparkles") then if not _G._tommysGoldOrigColors[child.Name] then _G._tommysGoldOrigColors[child.Name]=child.SparkleColor end; child.SparkleColor=yellow end
            end) end
            return true
        end},["Plum"]={id="rbxassetid://13388349585"},["Leatherworks"]={id="rbxassetid://13556313114"},["Unclesam"]={id="rbxassetid://13936670325"},["Headstone"]={id="rbxassetid://15177096261"},["Stained"]={id="rbxassetid://16037741369"},["Candy Pop"]={id="rbxassetid://15264694906"},["Doodle"]={id="rbxassetid://15297763963"},["Greed"]={id="rbxassetid://15362065880"}},
        ["MAC-10"] = {["Sunrise"]={id="rbxassetid://13387823798"},["Bloodied"]={id="rbxassetid://109985513961603"},["USA"]={id="rbxassetid://77249135761011"},["404 Hot Found"]={id="rbxassetid://93020203120595"},["Cheese"]={id="rbxassetid://13556188816"},["Digital"]={id="rbxassetid://13388148081"},["Lostnfound"]={id="rbxassetid://13841544929"},["Freedom"]={id="rbxassetid://13935272075"},["Tropical"]={id="rbxassetid://13712964810"},["Urbandispatch"]={id="rbxassetid://15998655169"},["Gold Brick"]={id="rbxassetid://15653126777"},["Sunset"]={id="rbxassetid://15321332214"},["Luxurious"]={id="rbxassetid://15248514127"}},
        ["MAC-10-S"] = {["Sunrise"]={id="rbxassetid://13387823798"},["Bloodied"]={id="rbxassetid://109985513961603"},["USA"]={id="rbxassetid://77249135761011"},["404 Hot Found"]={id="rbxassetid://93020203120595"},["Cheese"]={id="rbxassetid://13556188816"},["Digital"]={id="rbxassetid://13388148081"},["Lostnfound"]={id="rbxassetid://13841544929"},["Bloodied"]={id="rbxassetid://109985513961603"},["USA"]={id="rbxassetid://77249135761011"},["404 Hot Found"]={id="rbxassetid://93020203120595"},["Freedom"]={id="rbxassetid://13935272075"},["Tropical"]={id="rbxassetid://13712964810"},["Urbandispatch"]={id="rbxassetid://15998655169"},["Gold Brick"]={id="rbxassetid://15653126777"},["Sunset"]={id="rbxassetid://15321332214"},["Luxurious"]={id="rbxassetid://15248514127"}},
    },
    Rifles = {
        ["AKS-74U"] = {["Draco"]={id="rbxassetid://13388090322"},["Skulled"]={id="rbxassetid://15645829822"},["Frostbite"]={id="rbxassetid://82590391241285"},["Party Rings"]={id="rbxassetid://119753542316423"},["Fire Serpent"]={id="rbxassetid://121728237779959"},["Hells"]={id="rbxassetid://122955996300385"},["Crimcola"]={id="rbxassetid://13387556541"},["Cherish"]={id="rbxassetid://16355375052"},["Formula"]={id="rbxassetid://16010501274"},["Mire"]={id="rbxassetid://15177307123"},["Battleworncamo"]={id="rbxassetid://13842104374"},["Sharkbite"]={id="rbxassetid://11684759812"},["Gravebound"]={id="rbxassetid://75395134245084"},["JadeStone"]={id="rbxassetid://13712930979"},["PLUTO"]={id="rbxassetid://119124175056081"},["OPM"]={id="rbxassetid://17517217348"},["Gold"]={id="rbxassetid://15303808080", customApply=function(t)
            local wh = t:FindFirstChild("WeaponHandle"); if not wh then return end
            local muzzle = wh:FindFirstChild("Muzzle"); if not muzzle then return end
            local snd = muzzle:FindFirstChild("FFireSoundTWO")
            if not snd then snd = Instance.new("Sound"); snd.Name = "FFireSoundTWO"; snd.Parent = muzzle end
            snd.SoundId = "rbxassetid://1210852193"; snd.PlaybackSpeed = 1.5; snd.Volume = 1
            local yellow = Color3.fromRGB(255,200,0); local yellowSeq = ColorSequence.new(yellow)
            if not _G._aks74uGoldOrigColors then _G._aks74uGoldOrigColors = {} end
            for _, child in pairs(muzzle:GetChildren()) do pcall(function()
                if child:IsA("ParticleEmitter") then if not _G._aks74uGoldOrigColors[child.Name] then _G._aks74uGoldOrigColors[child.Name]=child.Color end; child.Color=yellowSeq
                elseif child:IsA("Smoke") then if not _G._aks74uGoldOrigColors[child.Name] then _G._aks74uGoldOrigColors[child.Name]=child.Color end; child.Color=yellow
                elseif child:IsA("Sparkles") then if not _G._aks74uGoldOrigColors[child.Name] then _G._aks74uGoldOrigColors[child.Name]=child.SparkleColor end; child.SparkleColor=yellow end
            end) end
            return true
        end},["Case Hardened"]={id="rbxassetid://15646024746"},["Soda"]={id="rbxassetid://13387566361"},["Holy Crap!"]={id="rbxassetid://86193260671473"},["Achromic"]={id="rbxassetid://15296578778"},["Pixel Whiteout"]={id="rbxassetid://15290670950"},["Wrath"]={id="rbxassetid://15362065880"},["Red Lore"]={id="rbxassetid://16591533890"},["MESSER"]={id="rbxassetid://15268970718"}},
        ["AKS-74U-X"] = {["Draco"]={id="rbxassetid://13388090322"},["Skulled"]={id="rbxassetid://15645829822"},["Party Rings"]={id="rbxassetid://119753542316423"},["Frostbite"]={id="rbxassetid://82590391241285"},["Fire Serpent"]={id="rbxassetid://121728237779959"},["Hells"]={id="rbxassetid://122955996300385"},["Crimcola"]={id="rbxassetid://13387556541"},["Cherish"]={id="rbxassetid://16355375052"},["Formula"]={id="rbxassetid://16010501274"},["Mire"]={id="rbxassetid://15177307123"},["Battleworncamo"]={id="rbxassetid://13842104374"},["Sharkbite"]={id="rbxassetid://11684759812"},["Gravebound"]={id="rbxassetid://75395134245084"},["JadeStone"]={id="rbxassetid://13712930979"},["PLUTO"]={id="rbxassetid://119124175056081"},["OPM"]={id="rbxassetid://17517217348"},["Gold"]={id="rbxassetid://15303808080", customApply=function(t)
            local wh = t:FindFirstChild("WeaponHandle"); if not wh then return end
            local muzzle = wh:FindFirstChild("Muzzle"); if not muzzle then return end
            local snd = muzzle:FindFirstChild("FFireSoundTWO")
            if not snd then snd = Instance.new("Sound"); snd.Name = "FFireSoundTWO"; snd.Parent = muzzle end
            snd.SoundId = "rbxassetid://1210852193"; snd.PlaybackSpeed = 1.5; snd.Volume = 1
            local yellow = Color3.fromRGB(255,200,0); local yellowSeq = ColorSequence.new(yellow)
            if not _G._aks74uxGoldOrigColors then _G._aks74uxGoldOrigColors = {} end
            for _, child in pairs(muzzle:GetChildren()) do pcall(function()
                if child:IsA("ParticleEmitter") then if not _G._aks74uxGoldOrigColors[child.Name] then _G._aks74uxGoldOrigColors[child.Name]=child.Color end; child.Color=yellowSeq
                elseif child:IsA("Smoke") then if not _G._aks74uxGoldOrigColors[child.Name] then _G._aks74uxGoldOrigColors[child.Name]=child.Color end; child.Color=yellow
                elseif child:IsA("Sparkles") then if not _G._aks74uxGoldOrigColors[child.Name] then _G._aks74uxGoldOrigColors[child.Name]=child.SparkleColor end; child.SparkleColor=yellow end
            end) end
            return true
        end},["Case Hardened"]={id="rbxassetid://15646024746"},["Soda"]={id="rbxassetid://13387566361"},["Holy Crap!"]={id="rbxassetid://86193260671473"},["Achromic"]={id="rbxassetid://15296578778"},["Pixel Whiteout"]={id="rbxassetid://15290670950"},["Wrath"]={id="rbxassetid://15362065880"},["Red Lore"]={id="rbxassetid://16591533890"},["MESSER"]={id="rbxassetid://15268970718"}},
        ["FN-FAL"] = {["Majesty"]={id="rbxassetid://12268008265"},["Purpleheart"]={id="rbxassetid://16040566709"},["Merlot"]={id="rbxassetid://13566072355"},["Wintermaroon"]={id="rbxassetid://15710689660"},["OPM"]={id="rbxassetid://17528070377"},["Goldified"]={id="rbxassetid://15264820986"}},
        ["FN-FAL-S"] = {["Majesty"]={id="rbxassetid://12268008265"},["Purpleheart"]={id="rbxassetid://16040566709"},["Merlot"]={id="rbxassetid://13566072355"},["Wintermaroon"]={id="rbxassetid://15710689660"},["OPM"]={id="rbxassetid://17528070377"},["Goldified"]={id="rbxassetid://15264820986"}},
        ["SKS"] = {["Paragon"]={id="rbxassetid://15998710650"},["Digital"]={id="rbxassetid://9341995268"},["Jacko"]={id="rbxassetid://15177206758"},["Copper"]={id="rbxassetid://13394135741"},["Umbrella"]={id="rbxassetid://13841605579"},["Modern"]={id="rbxassetid://13388175991"},["Jester"]={id="rbxassetid://13343167267"},["Gold"]={id="rbxassetid://16300596462", customApply=function(t)
            local handle = t:FindFirstChild("Handle")
            if not handle then return end
            local muzzle = handle:FindFirstChild("Muzzle")
            if not muzzle then return end
            local snd = muzzle:FindFirstChild("FireSound1")
            if snd then snd.PlaybackSpeed = 1 end
            local ffire = muzzle:FindFirstChild("FFireSoundTWO")
            if not ffire then ffire = Instance.new("Sound"); ffire.Name = "FFireSoundTWO"; ffire.Parent = muzzle end
            ffire.SoundId = "rbxassetid://1210852193"; ffire.PlaybackSpeed = 1.3; ffire.Volume = 1
            local colorSeq = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.new(0, 1, 0.666667)),
                ColorSequenceKeypoint.new(1, Color3.new(1, 0.666667, 0)),
            })
            local teal = Color3.new(0, 1, 0.666667)
            for _, child in ipairs(muzzle:GetChildren()) do
                pcall(function()
                    if child:IsA("ParticleEmitter") then
                        child.Color = colorSeq
                    elseif child:IsA("Smoke") then
                        child.Color = teal
                    elseif child:IsA("Sparkles") then
                        child.SparkleColor = teal
                    elseif child:IsA("PointLight") then
                        child.Color = teal
                    end
                end)
            end
            return true
        end},["Second Circle"]={id="rbxassetid://15362065880"}},
        ["SCAR-H-1"] = {["Torchbearer"]={id="rbxassetid://18167599401"},["Gridlines"]={id="rbxassetid://16010528228"},["Poison"]={id="rbxassetid://15264664685"},["Yellow"]={id="rbxassetid://15250623811"},["Paintball"]={id="rbxassetid://15250631049"}},
        ["SCAR-H-X"] = {["Torchbearer"]={id="rbxassetid://18167599401"},["Gridlines"]={id="rbxassetid://16010528228"},["Poison"]={id="rbxassetid://15264664685"},["Yellow"]={id="rbxassetid://15250623811"},["Paintball"]={id="rbxassetid://15250631049"}},
        ["M4A1-1"] = {["Pumpkin Eater"]={id="rbxassetid://81794945540744"},["Karma"]={id="rbxassetid://95787108899910"},["Emeraldix"]={id="rbxassetid://112074069466259"},["Berserk"]={id="rbxassetid://122376884656792"},["Red Star"]={id="rbxassetid://87049976243824"},["Pinkezoz"]={id="rbxassetid://87467084447967"},["PvH"]={id="rbxassetid://98211871930051"},["Jogo de"]={id="rbxassetid://121996683210389"},["Miky"]={id="rbxassetid://106610484340376"},["Maromo"]={id="rbxassetid://125975827383671"},["White Hole"]={id="rbxassetid://104207186658134"},["RUSSIA"]={id="rbxassetid://126399852295247"},["KAWAII"]={id="rbxassetid://128794761291211"},["BlueSky"]={id="rbxassetid://129104085783652"},["Monster Energy"]={id="rbxassetid://116795272061031"},["Baldwin"]={id="rbxassetid://118544010684901"},["Ierasolime"]={id="rbxassetid://130117588936000"},["Crossed"]={id="rbxassetid://105573525928603"},["Immortal"]={id="rbxassetid://112684062836222"},["Binary"]={id="rbxassetid://88226103702232"},["Compound"]={id="rbxassetid://75044416753289"},["Japaniese"]={id="rbxassetid://109663166143783"},["Aldi"]={id="rbxassetid://119604828125733"},["B4444"]={id="rbxassetid://109688148863871"},["4444"]={id="rbxassetid://115898355951069"},["Knight"]={id="rbxassetid://80329197009201"},["Guardian"]={id="rbxassetid://131818248921848"},["Hyperblast"]={id="rbxassetid://77469029834734"},["Blue"]={id="rbxassetid://108153630779925"},["Prinstream2"]={id="rbxassetid://113777652634940"},["Nightmare"]={id="rbxassetid://116823760758621"},["VoidMarble"]={id="rbxassetid://82785130623530", customApply=function(t)
            local wh = t:FindFirstChild("WeaponHandle"); if not wh then return end
            local muzzle = wh:FindFirstChild("Muzzle"); if not muzzle then return end
            local snd = muzzle:FindFirstChild("FFireSoundTWO")
            if not snd then snd = Instance.new("Sound"); snd.Name = "FFireSoundTWO"; snd.Parent = muzzle end
            snd.SoundId = "rbxassetid://96028055513912"; snd.PlaybackSpeed = 1.5; snd.Volume = 1
            local purple = Color3.fromRGB(138, 43, 226); local purpleSeq = ColorSequence.new(purple)
            if not _G._m4a1VoidOrigColors then _G._m4a1VoidOrigColors = {} end
            for _, child in pairs(muzzle:GetChildren()) do pcall(function()
                if child:IsA("ParticleEmitter") then if not _G._m4a1VoidOrigColors[child.Name] then _G._m4a1VoidOrigColors[child.Name]=child.Color end; child.Color=purpleSeq
                elseif child:IsA("Smoke") then if not _G._m4a1VoidOrigColors[child.Name] then _G._m4a1VoidOrigColors[child.Name]=child.Color end; child.Color=purple
                elseif child:IsA("Sparkles") then if not _G._m4a1VoidOrigColors[child.Name] then _G._m4a1VoidOrigColors[child.Name]=child.SparkleColor end; child.SparkleColor=purple end
            end) end
            local neonParts = {["BulletPart1A"]=true,["BulletPart1B"]=true,["CasingPart1A"]=true,["CasingPart1B"]=true}
            if not _G._m4a1VoidPartOrig then _G._m4a1VoidPartOrig = {} end
            for _, d in pairs(t:GetDescendants()) do
                if neonParts[d.Name] and (d:IsA("BasePart") or d:IsA("MeshPart")) then pcall(function()
                    if not _G._m4a1VoidPartOrig[d] then _G._m4a1VoidPartOrig[d]={color=d.Color,mat=d.Material,tex=d.TextureID} end
                    d.Color=purple; d.Material=Enum.Material.Neon; d.TextureID=""
                end) end
            end
            return true
        end},["Kews"]={id="rbxassetid://128935596003077"},["PixelWaifu"]={id="rbxassetid://99219255854961"},["Watering"]={id="rbxassetid://88318143921114", customApply=function(t)
            local wh = t:FindFirstChild("WeaponHandle"); if not wh then return end
            local muzzle = wh:FindFirstChild("Muzzle"); if not muzzle then return end
            local snd = muzzle:FindFirstChild("FFireSoundTWO")
            if not snd then snd = Instance.new("Sound"); snd.Name = "FFireSoundTWO"; snd.Parent = muzzle end
            snd.SoundId = "rbxassetid://220194561"; snd.PlaybackSpeed = 1.5; snd.Volume = 1
            local blue = Color3.fromRGB(0, 180, 255); local blueSeq = ColorSequence.new(blue)
            if not _G._m4a1WateringOrigColors then _G._m4a1WateringOrigColors = {} end
            for _, child in pairs(muzzle:GetChildren()) do pcall(function()
                if child:IsA("ParticleEmitter") then if not _G._m4a1WateringOrigColors[child.Name] then _G._m4a1WateringOrigColors[child.Name]=child.Color end; child.Color=blueSeq
                elseif child:IsA("Smoke") then if not _G._m4a1WateringOrigColors[child.Name] then _G._m4a1WateringOrigColors[child.Name]=child.Color end; child.Color=blue
                elseif child:IsA("Sparkles") then if not _G._m4a1WateringOrigColors[child.Name] then _G._m4a1WateringOrigColors[child.Name]=child.SparkleColor end; child.SparkleColor=blue end
            end) end
            local neonParts = {["BulletPart1A"]=true,["BulletPart1B"]=true,["CasingPart1A"]=true,["CasingPart1B"]=true}
            if not _G._m4a1WateringPartOrig then _G._m4a1WateringPartOrig = {} end
            for _, d in pairs(t:GetDescendants()) do
                if neonParts[d.Name] and (d:IsA("BasePart") or d:IsA("MeshPart")) then pcall(function()
                    if not _G._m4a1WateringPartOrig[d] then _G._m4a1WateringPartOrig[d]={color=d.Color,mat=d.Material,tex=d.TextureID} end
                    d.Color=blue; d.Material=Enum.Material.Neon; d.TextureID=""
                end) end
            end
            return true
        end},["Skulling"]={id="rbxassetid://96515781328932"},["Hiops"]={id="rbxassetid://97928907596266"},["Millitary"]={id="rbxassetid://92209702442701"},["WhiteSakurain"]={id="rbxassetid://96760742066894"},["WhiteSakura"]={id="rbxassetid://103014723270752"},["Eroh"]={id="rbxassetid://91979056086526"},["Minuom"]={id="rbxassetid://76668617144086"},["Temukao2"]={id="rbxassetid://110667753140141"},["YEEG"]={id="rbxassetid://84687282729067"},["Cosmatic"]={id="rbxassetid://131391610673680"},["Mirage"]={id="rbxassetid://88779051864727"},["Skulled"]={id="rbxassetid://116324364500050"},["Robo"]={id="rbxassetid://100485456984949"},["Showtired"]={id="rbxassetid://111221181841521"},["Hellbanger"]={id="rbxassetid://121385474940014"},["Temukao"]={id="rbxassetid://135149857999430"},["BMW"]={id="rbxassetid://103285981397119"},["Hellbanger"]={id="rbxassetid://121385474940014"},["SHARKBITE"]={id="rbxassetid://135499741986262"},["Inverted"]={id="rbxassetid://114620580425619"},["Grassy"]={id="rbxassetid://116340038516475"},["Colacamo"]={id="rbxassetid://16910928732"},["Circuit"]={id="rbxassetid://13841654362"},["Frostbite"]={id="rbxassetid://15695458963"},["Monochrome"]={id="rbxassetid://13388682540"},["Aureus"]={id="rbxassetid://13714578814"},["Patriot"]={id="rbxassetid://13945985275"},["Tiles"]={id="rbxassetid://13387870685"},["Yellowstone"]={id="rbxassetid://15998612264"},["Gold"]={id="rbxassetid://18231287937", customApply=function(t)
            local wh = t:FindFirstChild("WeaponHandle"); if not wh then return end
            local muzzle = wh:FindFirstChild("Muzzle"); if not muzzle then return end
            local snd = muzzle:FindFirstChild("FFireSoundTWO")
            if not snd then snd = Instance.new("Sound"); snd.Name = "FFireSoundTWO"; snd.Parent = muzzle end
            snd.SoundId = "rbxassetid://1210852193"; snd.PlaybackSpeed = 1.5; snd.Volume = 1
            local yellow = Color3.fromRGB(255,200,0); local yellowSeq = ColorSequence.new(yellow)
            if not _G._m4a1GoldOrigColors then _G._m4a1GoldOrigColors = {} end
            for _, child in pairs(muzzle:GetChildren()) do pcall(function()
                if child:IsA("ParticleEmitter") then if not _G._m4a1GoldOrigColors[child.Name] then _G._m4a1GoldOrigColors[child.Name]=child.Color end; child.Color=yellowSeq
                elseif child:IsA("Smoke") then if not _G._m4a1GoldOrigColors[child.Name] then _G._m4a1GoldOrigColors[child.Name]=child.Color end; child.Color=yellow
                elseif child:IsA("Sparkles") then if not _G._m4a1GoldOrigColors[child.Name] then _G._m4a1GoldOrigColors[child.Name]=child.SparkleColor end; child.SparkleColor=yellow end
            end) end
            return true
        end},["Heritage"]={id="rbxassetid://18312055711"},["Inferno"]={id="rbxassetid://15417229857"},["X-Ray"]={customApply=function(t)
            local wh = t:FindFirstChild("WeaponHandle"); if not wh then return end
            local parts = wh:FindFirstChild("Parts"); if not parts then return end
            local partNames = {"Base","BoltCatchPart","BoltPart","ChargingHandlePart","DustCoverPart","MagPart","MagReleaseButtonPart","MagReleasePart"}
            if not _G._xrayPartOrig then _G._xrayPartOrig = {} end
            local function applyFF()
                for _, name in ipairs(partNames) do
                    local p = parts:FindFirstChild(name, true)
                    if p and (p:IsA("BasePart") or p:IsA("MeshPart")) then
                        pcall(function()
                            if not _G._xrayPartOrig[p] then _G._xrayPartOrig[p] = p.Material end
                            p.Material = Enum.Material.ForceField
                        end)
                    end
                end
            end
            applyFF()
            task.delay(0.1, applyFF)
            task.delay(0.5, applyFF)
            return true
        end, customDisplayApply=function(root)

            local partNames = {"Base","BoltCatchPart","BoltPart","ChargingHandlePart","DustCoverPart","MagPart","MagReleaseButtonPart","MagReleasePart"}
            if not _G._xrayDisplayOrig then _G._xrayDisplayOrig = {} end
            for _, name in ipairs(partNames) do
                local p = root:FindFirstChild(name, true)
                if p and (p:IsA("BasePart") or p:IsA("MeshPart")) then
                    pcall(function()
                        if not _G._xrayDisplayOrig[p] then _G._xrayDisplayOrig[p] = p.Material end
                        p.Material = Enum.Material.ForceField
                    end)
                end
            end
        end},["Meltdown"]={id="rbxassetid://105367863967017"},["HautedWoods"]={id="rbxassetid://91632633068427", customApply=function(t)
            local wh = t:FindFirstChild("WeaponHandle"); if not wh then return end
            local muzzle = wh:FindFirstChild("Muzzle"); if not muzzle then return end
            local snd = muzzle:FindFirstChild("FFireSoundTWO")
            if not snd then snd = Instance.new("Sound"); snd.Name = "FFireSoundTWO"; snd.Parent = muzzle end
            snd.SoundId = "rbxassetid://139760297086682"; snd.PlaybackSpeed = 1; snd.Volume = 1
            local darkGreen = Color3.fromRGB(0, 80, 0)
            local darkGreenSeq = ColorSequence.new(darkGreen)
            for _, child in ipairs(muzzle:GetChildren()) do
                pcall(function()
                    if child:IsA("ParticleEmitter") then child.Color = darkGreenSeq
                    elseif child:IsA("Smoke") then child.Color = darkGreen
                    elseif child:IsA("Sparkles") then child.SparkleColor = darkGreen
                    elseif child:IsA("PointLight") then child.Color = darkGreen
                    end
                end)
            end
            local reloadA = wh:FindFirstChild("ReloadA")
            if reloadA then
                local magOut = reloadA:FindFirstChild("MagOut")
                if magOut then
                    if not _G._hautedMagOutOrig then _G._hautedMagOutOrig = {} end
                    local weapName = t.Name
                    if not _G._hautedMagOutOrig[weapName] then
                        _G._hautedMagOutOrig[weapName] = {id = magOut.SoundId, vol = magOut.Volume}
                    end
                    magOut.SoundId = "rbxassetid://139822052056984"; magOut.Volume = 1
                end
            end
            local green = Color3.fromRGB(0, 200, 0)
            local neonParts = {["BulletPart1A"]=true,["BulletPart1B"]=true,["CasingPart1A"]=true,["CasingPart1B"]=true}
            if not _G._hautedWoodsPartOrig then _G._hautedWoodsPartOrig = {} end
            for _, d in pairs(t:GetDescendants()) do
                if neonParts[d.Name] and (d:IsA("BasePart") or d:IsA("MeshPart")) then pcall(function()
                    if not _G._hautedWoodsPartOrig[d] then _G._hautedWoodsPartOrig[d]={color=d.Color,mat=d.Material,tex=d.TextureID} end
                    d.Color = green; d.Material = Enum.Material.Neon; d.TextureID = ""
                end) end
            end
            return true
        end},["Subzero"]={id="rbxassetid://109664302456309"},["OPM"]={id="rbxassetid://16932839206"},["Red Star"]={id="rbxassetid://87049976243824"},["Binary"]={id="rbxassetid://88226103702232"},["Compound"]={id="rbxassetid://75044416753289"},["Japaniese"]={id="rbxassetid://109663166143783"},["Aldi"]={id="rbxassetid://119604828125733"},["B4444"]={id="rbxassetid://109688148863871"},["4444"]={id="rbxassetid://115898355951069"},["Knight"]={id="rbxassetid://80329197009201"},["Guardian"]={id="rbxassetid://131818248921848"},["Hyperblast"]={id="rbxassetid://77469029834734"},["Blue"]={id="rbxassetid://108153630779925"},["Prinstream2"]={id="rbxassetid://113777652634940"},["BlueGem"]={id="rbxassetid://15646272873"},["Case Hardened"]={id="rbxassetid://15645898166"},["PrintStream"]={id="rbxassetid://17838832952"},["SpecOps"]={id="rbxassetid://15344576855"},["Jahibiulous the Greatest"]={id="rbxassetid://15253071974"},["Sourse Missing"]={id="rbxassetid://15264453961"},["Battle Worn"]={id="rbxassetid://15320008608"},["Kitty Hawk"]={id="rbxassetid://15319237497"},["Durimane"]={id="rbxassetid://133507596932655"},["Overprice"]={id="rbxassetid://127016861780202"},["Yaga"]={id="rbxassetid://123580251586008"},["Overload"]={id="rbxassetid://107223728256464"},["Growdown"]={id="rbxassetid://116269420981187"},["PinkDown"]={id="rbxassetid://103518507606964"},["OPMW"]={id="rbxassetid://88211645734166"},["Firebite"]={id="rbxassetid://134888597234636"},["Galasia"]={id="rbxassetid://99374399268601"},["Yellowdump"]={id="rbxassetid://86026762960005"},["Penstick"]={id="rbxassetid://77467662272084"},["Dangerous"]={id="rbxassetid://73627422059849"},["Gasattack"]={id="rbxassetid://80075675951194"},["Pinkform"]={id="rbxassetid://132432316629885"},["HelloKitty"]={id="rbxassetid://81238933089769"},["Ivan Olin"]={id="rbxassetid://104337061217190"},["Steel"]={id="rbxassetid://128592228174287"},["Tugarin"]={id="rbxassetid://137901888336824"},["Dark Essence"]={id="rbxassetid://94848190129550"},["Growess"]={id="rbxassetid://84483564242316"},["Sakura"]={id="rbxassetid://103211071204546"},["Bloodrain"]={id="rbxassetid://116950613843071"},["Iced"]={id="rbxassetid://87976754296141"},["Iron breaker"]={id="rbxassetid://125406237941852"},["GPTprompt"]={id="rbxassetid://89878321896846"},["Memory"]={id="rbxassetid://138602414261870"},["Miamoree"]={id="rbxassetid://89179425357864"},["Minions"]={id="rbxassetid://87686543174255"},["Arabian"]={id="rbxassetid://78086707910549"},["RidenGI"]={id="rbxassetid://105686184306746"},["Sakurain"]={id="rbxassetid://84441518736003"},["Hellaida"]={id="rbxassetid://123113137075758"},["PIXELMAIN"]={id="rbxassetid://103895362425333"},["Azimov"]={id="rbxassetid://87797063560328"},["Neo noir"]={id="rbxassetid://114859231452954"},["Marvelous"]={id="rbxassetid://16502823677"}},
        ["M4A1-S"] = {["Colacamo"]={id="rbxassetid://16910928732"},["Red Star"]={id="rbxassetid://87049976243824"},["Binary"]={id="rbxassetid://88226103702232"},["Compound"]={id="rbxassetid://75044416753289"},["Japaniese"]={id="rbxassetid://109663166143783"},["Aldi"]={id="rbxassetid://119604828125733"},["B4444"]={id="rbxassetid://109688148863871"},["4444"]={id="rbxassetid://115898355951069"},["Knight"]={id="rbxassetid://80329197009201"},["Guardian"]={id="rbxassetid://131818248921848"},["Hyperblast"]={id="rbxassetid://77469029834734"},["Blue"]={id="rbxassetid://108153630779925"},["Prinstream2"]={id="rbxassetid://113777652634940"},["HautedWoods"]={id="rbxassetid://91632633068427", customApply=function(t)
            local wh = t:FindFirstChild("WeaponHandle"); if not wh then return end
            local muzzle = wh:FindFirstChild("Muzzle"); if not muzzle then return end
            local snd = muzzle:FindFirstChild("FFireSoundTWO")
            if not snd then snd = Instance.new("Sound"); snd.Name = "FFireSoundTWO"; snd.Parent = muzzle end
            snd.SoundId = "rbxassetid://139760297086682"; snd.PlaybackSpeed = 1; snd.Volume = 1
            local darkGreen = Color3.fromRGB(0, 80, 0); local darkGreenSeq = ColorSequence.new(darkGreen)
            for _, child in ipairs(muzzle:GetChildren()) do pcall(function()
                if child:IsA("ParticleEmitter") then child.Color = darkGreenSeq
                elseif child:IsA("Smoke") then child.Color = darkGreen
                elseif child:IsA("Sparkles") then child.SparkleColor = darkGreen
                elseif child:IsA("PointLight") then child.Color = darkGreen end
            end) end
            local reloadA = wh:FindFirstChild("ReloadA")
            if reloadA then
                local magOut = reloadA:FindFirstChild("MagOut")
                if magOut then
                    if not _G._hautedMagOutOrig then _G._hautedMagOutOrig = {} end
                    local weapName = t.Name
                    if not _G._hautedMagOutOrig[weapName] then
                        _G._hautedMagOutOrig[weapName] = {id = magOut.SoundId, vol = magOut.Volume}
                    end
                    magOut.SoundId = "rbxassetid://139822052056984"; magOut.Volume = 1
                end
            end
            local green = Color3.fromRGB(0, 200, 0)
            local neonParts = {["BulletPart1A"]=true,["BulletPart1B"]=true,["CasingPart1A"]=true,["CasingPart1B"]=true}
            if not _G._m4a1sHautedPartOrig then _G._m4a1sHautedPartOrig = {} end
            for _, d in pairs(t:GetDescendants()) do
                if neonParts[d.Name] and (d:IsA("BasePart") or d:IsA("MeshPart")) then pcall(function()
                    if not _G._m4a1sHautedPartOrig[d] then _G._m4a1sHautedPartOrig[d]={color=d.Color,mat=d.Material,tex=d.TextureID} end
                    d.Color = green; d.Material = Enum.Material.Neon; d.TextureID = ""
                end) end
            end
            return true
        end},["VoidMarble"]={id="rbxassetid://82785130623530", customApply=function(t)
            local wh = t:FindFirstChild("WeaponHandle"); if not wh then return end
            local muzzle = wh:FindFirstChild("Muzzle"); if not muzzle then return end
            local snd = muzzle:FindFirstChild("FFireSoundTWO")
            if not snd then snd = Instance.new("Sound"); snd.Name = "FFireSoundTWO"; snd.Parent = muzzle end
            snd.SoundId = "rbxassetid://96028055513912"; snd.PlaybackSpeed = 1.5; snd.Volume = 1
            local purple = Color3.fromRGB(138, 43, 226); local purpleSeq = ColorSequence.new(purple)
            if not _G._m4a1sVoidOrigColors then _G._m4a1sVoidOrigColors = {} end
            for _, child in pairs(muzzle:GetChildren()) do pcall(function()
                if child:IsA("ParticleEmitter") then if not _G._m4a1sVoidOrigColors[child.Name] then _G._m4a1sVoidOrigColors[child.Name]=child.Color end; child.Color=purpleSeq
                elseif child:IsA("Smoke") then if not _G._m4a1sVoidOrigColors[child.Name] then _G._m4a1sVoidOrigColors[child.Name]=child.Color end; child.Color=purple
                elseif child:IsA("Sparkles") then if not _G._m4a1sVoidOrigColors[child.Name] then _G._m4a1sVoidOrigColors[child.Name]=child.SparkleColor end; child.SparkleColor=purple end
            end) end
            local neonParts = {["BulletPart1A"]=true,["BulletPart1B"]=true,["CasingPart1A"]=true,["CasingPart1B"]=true}
            if not _G._m4a1sVoidPartOrig then _G._m4a1sVoidPartOrig = {} end
            for _, d in pairs(t:GetDescendants()) do
                if neonParts[d.Name] and (d:IsA("BasePart") or d:IsA("MeshPart")) then pcall(function()
                    if not _G._m4a1sVoidPartOrig[d] then _G._m4a1sVoidPartOrig[d]={color=d.Color,mat=d.Material,tex=d.TextureID} end
                    d.Color=purple; d.Material=Enum.Material.Neon; d.TextureID=""
                end) end
            end
            return true
        end},["Watering"]={customApply=function(t)
            local wh = t:FindFirstChild("WeaponHandle"); if not wh then return end
            local muzzle = wh:FindFirstChild("Muzzle"); if not muzzle then return end
            local snd = muzzle:FindFirstChild("FFireSoundTWO")
            if not snd then snd = Instance.new("Sound"); snd.Name = "FFireSoundTWO"; snd.Parent = muzzle end
            snd.SoundId = "rbxassetid://220194561"; snd.PlaybackSpeed = 1.5; snd.Volume = 1
            local blue = Color3.fromRGB(0, 180, 255); local blueSeq = ColorSequence.new(blue)
            if not _G._m4a1sWateringOrigColors then _G._m4a1sWateringOrigColors = {} end
            for _, child in pairs(muzzle:GetChildren()) do pcall(function()
                if child:IsA("ParticleEmitter") then if not _G._m4a1sWateringOrigColors[child.Name] then _G._m4a1sWateringOrigColors[child.Name]=child.Color end; child.Color=blueSeq
                elseif child:IsA("Smoke") then if not _G._m4a1sWateringOrigColors[child.Name] then _G._m4a1sWateringOrigColors[child.Name]=child.Color end; child.Color=blue
                elseif child:IsA("Sparkles") then if not _G._m4a1sWateringOrigColors[child.Name] then _G._m4a1sWateringOrigColors[child.Name]=child.SparkleColor end; child.SparkleColor=blue end
            end) end
            local neonParts = {["BulletPart1A"]=true,["BulletPart1B"]=true,["CasingPart1A"]=true,["CasingPart1B"]=true}
            if not _G._m4a1sWateringPartOrig then _G._m4a1sWateringPartOrig = {} end
            for _, d in pairs(t:GetDescendants()) do
                if neonParts[d.Name] and (d:IsA("BasePart") or d:IsA("MeshPart")) then pcall(function()
                    if not _G._m4a1sWateringPartOrig[d] then _G._m4a1sWateringPartOrig[d]={color=d.Color,mat=d.Material,tex=d.TextureID} end
                    d.Color=blue; d.Material=Enum.Material.Neon; d.TextureID=""
                end) end
            end
            return true
        end},["Eroh"]={id="rbxassetid://91979056086526"},["Minuom"]={id="rbxassetid://76668617144086"},["Temukao2"]={id="rbxassetid://110667753140141"},["YEEG"]={id="rbxassetid://84687282729067"},["Cosmatic"]={id="rbxassetid://131391610673680"},["Mirage"]={id="rbxassetid://88779051864727"},["Skulled"]={id="rbxassetid://116324364500050"},["Robo"]={id="rbxassetid://100485456984949"},["Showtired"]={id="rbxassetid://111221181841521"},["Hellbanger"]={id="rbxassetid://121385474940014"},["Temukao"]={id="rbxassetid://135149857999430"},["BMW"]={id="rbxassetid://103285981397119"},["Circuit"]={id="rbxassetid://13841654362"},["Frostbite"]={id="rbxassetid://15695458963"},["Monochrome"]={id="rbxassetid://13388682540"},["Aureus"]={id="rbxassetid://13714578814"},["Patriot"]={id="rbxassetid://13945985275"},["Tiles"]={id="rbxassetid://13387870685"},["Yellowstone"]={id="rbxassetid://15998612264"},["Gold"]={id="rbxassetid://18231287937", customApply=function(t)
            local wh = t:FindFirstChild("WeaponHandle"); if not wh then return end
            local muzzle = wh:FindFirstChild("Muzzle"); if not muzzle then return end
            local snd = muzzle:FindFirstChild("FFireSoundTWO")
            if not snd then snd = Instance.new("Sound"); snd.Name = "FFireSoundTWO"; snd.Parent = muzzle end
            snd.SoundId = "rbxassetid://1210852193"; snd.PlaybackSpeed = 1.5; snd.Volume = 1
            local yellow = Color3.fromRGB(255,200,0); local yellowSeq = ColorSequence.new(yellow)
            if not _G._m4a1GoldOrigColors then _G._m4a1GoldOrigColors = {} end
            for _, child in pairs(muzzle:GetChildren()) do pcall(function()
                if child:IsA("ParticleEmitter") then if not _G._m4a1GoldOrigColors[child.Name] then _G._m4a1GoldOrigColors[child.Name]=child.Color end; child.Color=yellowSeq
                elseif child:IsA("Smoke") then if not _G._m4a1GoldOrigColors[child.Name] then _G._m4a1GoldOrigColors[child.Name]=child.Color end; child.Color=yellow
                elseif child:IsA("Sparkles") then if not _G._m4a1GoldOrigColors[child.Name] then _G._m4a1GoldOrigColors[child.Name]=child.SparkleColor end; child.SparkleColor=yellow end
            end) end
            return true
        end},["Heritage"]={id="rbxassetid://18312055711"},["Inferno"]={id="rbxassetid://15417229857"},["Meltdown"]={id="rbxassetid://105367863967017"},["Subzero"]={id="rbxassetid://109664302456309"},["OPM"]={id="rbxassetid://16932839206"},["BlueGem"]={id="rbxassetid://15646272873"},["Case Hardened"]={id="rbxassetid://15645898166"},["PrintStream"]={id="rbxassetid://17838832952"},["SpecOps"]={id="rbxassetid://15344576855"},["Jahibiulous the Greatest"]={id="rbxassetid://15253071974"},["Sourse Missing"]={id="rbxassetid://15264453961"},["Battle Worn"]={id="rbxassetid://15320008608"},["Kitty Hawk"]={id="rbxassetid://15319237497"},["Durimane"]={id="rbxassetid://133507596932655"},["Overprice"]={id="rbxassetid://127016861780202"},["Yaga"]={id="rbxassetid://123580251586008"},["Overload"]={id="rbxassetid://107223728256464"},["Growdown"]={id="rbxassetid://116269420981187"},["PinkDown"]={id="rbxassetid://103518507606964"},["OPMW"]={id="rbxassetid://88211645734166"},["Firebite"]={id="rbxassetid://134888597234636"},["Galasia"]={id="rbxassetid://99374399268601"},["Yellowdump"]={id="rbxassetid://86026762960005"},["Penstick"]={id="rbxassetid://77467662272084"},["Dangerous"]={id="rbxassetid://73627422059849"},["Gasattack"]={id="rbxassetid://80075675951194"},["Ivan Olin"]={id="rbxassetid://104337061217190"},["Steel"]={id="rbxassetid://128592228174287"},["Tugarin"]={id="rbxassetid://137901888336824"},["Dark Essence"]={id="rbxassetid://94848190129550"},["Growess"]={id="rbxassetid://84483564242316"},["Sakura"]={id="rbxassetid://103211071204546"},["Bloodrain"]={id="rbxassetid://116950613843071"},["Iced"]={id="rbxassetid://87976754296141"},["Iron breaker"]={id="rbxassetid://125406237941852"},["GPTprompt"]={id="rbxassetid://89878321896846"},["Memory"]={id="rbxassetid://138602414261870"},["Miamoree"]={id="rbxassetid://89179425357864"},["Minions"]={id="rbxassetid://87686543174255"},["Arabian"]={id="rbxassetid://78086707910549"},["RidenGI"]={id="rbxassetid://105686184306746"},["Sakurain"]={id="rbxassetid://84441518736003"},["Hellaida"]={id="rbxassetid://123113137075758"},["PIXELMAIN"]={id="rbxassetid://103895362425333"},["Azimov"]={id="rbxassetid://87797063560328"},["Neo noir"]={id="rbxassetid://114859231452954"}},
        ["AKM"] = {["Whitestring"]={id="rbxassetid://15282661456"},["Gildedfury"]={id="rbxassetid://15282807876"},["Stars"]={id="rbxassetid://16090684967"},["Insurgent"]={id="rbxassetid://15282115851"},["Lab Grown"]={id="rbxassetid://16591522484"}},
    },
    Shotguns = {
        ["Sawn-Off"] = {["Multicam"]={id="rbxassetid://15998421683"},["Webs"]={id="rbxassetid://15177076142"},["Banana"]={id="rbxassetid://13387455222"},["Glacial"]={id="rbxassetid://13030805318"},["Grandprix"]={id="rbxassetid://13841748041"},["Caution"]={id="rbxassetid://10959371093"},["Logs"]={id="rbxassetid://13556252494"},["Gold"]={id="rbxassetid://13714495559", customApply=function(t)
            local wh = t:FindFirstChild("WeaponHandle")
            if not wh then return end
            local muzzle = wh:FindFirstChild("Muzzle")
            if not muzzle then return end
            local snd = muzzle:FindFirstChild("FFireSoundTWO")
            if not snd then snd = Instance.new("Sound"); snd.Name = "FFireSoundTWO"; snd.Parent = muzzle end
            snd.SoundId = "rbxassetid://1210852193"; snd.PlaybackSpeed = 1.5; snd.Volume = 1
            local yellow = Color3.fromRGB(255, 200, 0)
            local yellowSeq = ColorSequence.new(yellow)
            if not _G._sawnoffGoldOrigColors then _G._sawnoffGoldOrigColors = {} end
            for _, child in pairs(muzzle:GetChildren()) do
                pcall(function()
                    if child:IsA("ParticleEmitter") then
                        if not _G._sawnoffGoldOrigColors[child.Name] then _G._sawnoffGoldOrigColors[child.Name] = child.Color end
                        child.Color = yellowSeq
                    elseif child:IsA("Smoke") then
                        if not _G._sawnoffGoldOrigColors[child.Name] then _G._sawnoffGoldOrigColors[child.Name] = child.Color end
                        child.Color = yellow
                    elseif child:IsA("Sparkles") then
                        if not _G._sawnoffGoldOrigColors[child.Name] then _G._sawnoffGoldOrigColors[child.Name] = child.SparkleColor end
                        child.SparkleColor = yellow
                    end
                end)
            end
            return true
        end},["Eros"]={id="rbxassetid://124136583812651"},["Grapey"]={id="rbxassetid://15303443830"}},
        ["Ithaca-37"] = {["Homedefense"]={id="rbxassetid://13935302367"},["Sightings"]={id="rbxassetid://15183702458"},["Reserve"]={id="rbxassetid://13841781874"},["Darkmatter"]={id="rbxassetid://15998588320"},["Blaze"]={id="rbxassetid://13703922904"},["Ithcuh"]={id="rbxassetid://16910987164"},["Engraved"]={id="rbxassetid://13388409062"},["Hellfire"]={id="rbxassetid://88337624827127"},["Platinum"]={id="rbxassetid://15344307680"}},
        ["Super-Shorty"] = {["Firecracker"]={id="rbxassetid://18149800264"},["Checkmate"]={id="rbxassetid://13713146952"},["Steel"]={id="rbxassetid://13394161570"},["Loveletter"]={id="rbxassetid://16355340290"},["Fade"]={id="rbxassetid://15645983643"},["Hell Burner"]={id="rbxassetid://15093033212"}},
    }
}

return SkinsDB

end

DemidaBundle["Models.lua"] = function(...)
local M4 = { "M4A1-1", "M4A1-S" }

local Red = Color3.fromRGB(255, 50, 50)
local Blue = Color3.fromRGB(0, 150, 255)
local Yellow = Color3.fromRGB(255, 255, 0)
local Pink = Color3.fromRGB(255, 105, 180)
local Green = Color3.fromRGB(0, 255, 0)
local White = Color3.fromRGB(255, 255, 255)
local GhostGrey = Color3.fromRGB(163, 162, 165)

return {
    {
        Name = "Subzero",
        Weapons = M4,
        Variant = "Guns/m4a1_subzero",
        Muzzle = { Color = Blue, Sound = "rbxassetid://747238556" },
    },
    {
        Name = "Dragon",
        Weapons = M4,
        Variant = "Guns/m4a1_c_sm",
        PlasticTint = Red,
        Muzzle = { Color = Red, Sound = "rbxassetid://4547663256" },
    },
    {
        Name = "Heritage",
        Weapons = M4,
        Variant = "Guns/m4a1_heritage",
        Texture = "rbxassetid://18312058779",
        Muzzle = { Color = Yellow },
    },
    {
        Name = "Heritage FullBlood",
        Weapons = M4,
        Variant = "Guns/m4a1_heritage",
        Texture = "rbxassetid://18447364551",
        Muzzle = { Color = Color3.fromRGB(255, 0, 0) },
    },
    {
        Name = "OPM",
        Weapons = M4,
        Variant = "Guns/m4a1_opm",
        Addon = true,
        Texture = "rbxassetid://17517217348",
        AddonTexture = "rbxassetid://16932839206",
    },
    {
        Name = "Drum",
        Weapons = M4,
        Meshes = {
            MagPart = { Mesh = "rbxassetid://140272930523977", Texture = "rbxassetid://107837016820812" },
        },
    },
    {
        Name = "Ray",
        Weapons = M4,
        Meshes = {
            MagPart = { Mesh = "rbxassetid://140272930523977", Texture = "rbxassetid://126890730405677" },
            Base = { Mesh = "rbxassetid://101952962740417", Texture = "rbxassetid://11586103571" },
        },
    },
    {
        Name = "Reaver",
        Weapons = M4,
        Meshes = {
            MagPart = { Mesh = "rbxassetid://71385868054373", Texture = "rbxassetid://104132908111866" },
            Base = { Mesh = "rbxassetid://93419126206300", Texture = "rbxassetid://104132908111866" },
        },
    },
    {
        Name = "NoSight",
        Weapons = M4,
        Meshes = {
            Base = { Mesh = "rbxassetid://119024334602457" },
        },
    },
    {
        Name = "DZM",
        Weapons = M4,
        Meshes = {
            Base = { Mesh = "rbxassetid://82993336911710", Texture = "rbxassetid://120182440246568" },
        },
    },
    {
        Name = "MFM",
        Weapons = M4,
        Meshes = {
            Base = { Mesh = "rbxassetid://103712118948489" },
        },
    },
    {
        Name = "Cryogen",
        Weapons = { "MP7", "MP7-S" },
        Variant = "Guns/mp7_cryogen",
    },
    {
        Name = "Showdown",
        Weapons = { "Magnum" },
        Variant = "Guns/magnum_ind",
        Texture = "rbxassetid://92440380770170",
        Glow = { Names = { "OverlayPart", "L1" }, Color = GhostGrey },
    },
    {
        Name = "Steeldown",
        Weapons = { "Magnum" },
        Variant = "Guns/magnum_ind",
        Texture = "rbxassetid://84378650452943",
        Glow = { Names = { "OverlayPart", "L1" }, Color = GhostGrey },
    },
    {
        Name = "Eros",
        Weapons = { "Sawn-Off" },
        Variant = "Guns/sawnoff_eros",
        Muzzle = { Color = Pink },
    },
    {
        Name = "TrickShot",
        Weapons = { "Mare" },
        Variant = "Guns/mare_trickshot",
        Texture = "rbxassetid://16907785827",
        Muzzle = { Color = Green, Sound = "rbxassetid://5033272182" },
    },
    {
        Name = "White",
        Weapons = { "Mare" },
        Variant = "Guns/mare_trickshot",
        Texture = "rbxassetid://16907786165",
        Muzzle = { Color = White, Sound = "rbxassetid://5033272182" },
    },
    {
        Name = "Valentine",
        Weapons = { "Bayonet" },
        Variant = "Melees/bayonet_val",
        Hide = { "Glow Overlay", "Glow outline", "glow_overlay", "glow_outline", "DefaultFXPart", "CharmHitboxPart", "FXPart" },
    },
    {
        Name = "Cash Cane",
        Weapons = { "Bat" },
        Variant = "Melees/bat_cashcane",
        Texture = "rbxassetid://16299762278",
    },
}

end

local Config = {
    LibRoot = "demida/lib/",
    SaveFile = "demida_skins.json",
    SweepInterval = 0.5,
    SettleTime = 0.5,
    MaxRepairs = 5,
    RepairCooldown = 2,
}

local function Import(Name)
    if DemidaBundle and DemidaBundle[Name] then
        return DemidaBundle[Name]()
    end

    local Path = Config.LibRoot .. Name
    assert(isfile and isfile(Path), "missing " .. Path)

    local Chunk, Err = loadstring(readfile(Path), "@" .. Name)
    assert(Chunk, Err)

    return Chunk()
end

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")
local AssetService = game:GetService("AssetService")

local LocalPlayer = Players.LocalPlayer
local Storage = ReplicatedStorage:WaitForChild("Storage")
local DisplayModels = Storage:WaitForChild("DisplayWepModels")
local SkinVariants = Storage:WaitForChild("SkinVariants")

local Library = Import("Library.lua")
local Toggles = Library.Toggles
local Options = Library.Options
local SkinsDB = Import("Skins.lua")
local ModelDefs = Import("Models.lua")

local NoneSkin = "None"

local ClassOrder = { "Pistols", "SMGS", "Rifles", "Shotguns", "Snipers", "GrenadeLaunchers", "Melees", "Armors", "Other" }

local GlockWeapons = { ["G-17"] = true, ["G-18"] = true, ["G-18-X"] = true }

local GlockColors = {
    ["Amethyst"]      = Color3.fromRGB(138, 43, 226),
    ["Benjamin"]      = Color3.fromRGB(0, 180, 80),
    ["Digital Green"] = Color3.fromRGB(0, 100, 40),
    ["Dragon Power"]  = Color3.fromRGB(0, 100, 40),
    ["Fall"]          = Color3.fromRGB(255, 120, 0),
    ["Flowers"]       = Color3.fromRGB(180, 0, 255),
    ["GRUNCH"]        = Color3.fromRGB(120, 80, 40),
    ["Gleagle"]       = Color3.fromRGB(255, 255, 255),
    ["Hells Angel"]   = Color3.fromRGB(255, 255, 255),
    ["Hotpink"]       = Color3.fromRGB(255, 105, 180),
    ["Hot Blue"]      = Color3.fromRGB(0, 180, 255),
    ["Night"]         = Color3.fromRGB(60, 80, 100),
    ["Oxide"]         = Color3.fromRGB(0, 180, 220),
    ["Photon"]        = Color3.fromRGB(140, 0, 60),
    ["Redwood"]       = Color3.fromRGB(200, 0, 0),
    ["Redbape"]       = Color3.fromRGB(200, 0, 0),
    ["Sage"]          = Color3.fromRGB(160, 170, 150),
    ["Sigma"]         = Color3.fromRGB(255, 180, 200),
    ["Sjull"]         = Color3.fromRGB(150, 150, 150),
    ["Skulled"]       = Color3.fromRGB(150, 150, 150),
    ["Tan"]           = Color3.fromRGB(180, 150, 100),
    ["Tomato"]        = Color3.fromRGB(220, 40, 0),
    ["Toy"]           = Color3.fromRGB(255, 220, 0),
    ["ToyBlaster"]    = Color3.fromRGB(0, 80, 220),
    ["Warhawk"]       = Color3.fromRGB(0, 80, 40),
    ["Yosei"]         = Color3.fromRGB(100, 220, 255),
    ["Dragonit"]      = Color3.fromRGB(200, 0, 80),
    ["Lightrose"]     = Color3.fromRGB(100, 220, 255),
    ["Gold"]          = Color3.fromRGB(255, 200, 0),
}

local GlockSightParts = { FrontSightColorPart = true, RearSightColorPart = true, BulletPart = true }

local VariantWeapons = {
    m4a1 = "M4A1-1", mp7 = "MP7", m320 = "M320-1", sks = "SKS", aks = "AKS-74U",
    mare = "Mare", magnum = "Magnum", bfg = "BFG-1", ithaca = "Ithaca-37", sawnoff = "Sawn-Off",
    machete = "Machete", wrench = "Wrench", katana = "Katana", fireaxe = "Fire-Axe", bat = "Bat",
    rambo = "Rambo", balisong = "Balisong", chainsaw = "Chainsaw", metalbat = "Metal-Bat",
    shiv = "Shiv", bayonet = "Bayonet",
}

local MeshAliases = {
    MagPart = { "MagPart", "MagazinePart" },
    Base = { "Base" },
}

local MuzzleClasses = {
    ParticleEmitter = true, Beam = true, PointLight = true, SpotLight = true,
    Smoke = true, Fire = true, Sparkles = true,
}

local function AssetId(Id)
    Id = tostring(Id)
    return Id:find("rbxasset") and Id or ("rbxassetid://" .. Id)
end

local function Normalize(Name)
    return Name:lower():gsub("[%s_%-]", "")
end

local function TitleCase(Text)
    return (Text:gsub("_", " "):gsub("(%a)([%w]*)", function(First, Rest)
        return First:upper() .. Rest
    end))
end

local function CloneOf(Source)
    local WasArchivable = Source.Archivable
    Source.Archivable = true
    local Copy = Source:Clone()
    Source.Archivable = WasArchivable
    return Copy
end

local Registry = { Weapons = {}, Models = {}, CrossCache = {}, CrossEnabled = true, Flips = {} }

function Registry.Bucket(Weapon, Class)
    local Bucket = Registry.Weapons[Weapon]

    if not Bucket then
        Bucket = { Class = Class or "Other", Skins = {}, Models = {} }
        Registry.Weapons[Weapon] = Bucket
    end

    return Bucket
end

function Registry.ClassOf(Weapon)
    for Class, Weapons in pairs(SkinsDB) do
        if Weapons[Weapon] then
            return Class
        end
    end
end

function Registry.Add(Weapon, Name, Entry, Class)
    Registry.Bucket(Weapon, Class or Registry.ClassOf(Weapon)).Skins[Name] = Entry
end

function Registry.AddNativeModel(Weapon, Name, Entry, Class)
    Registry.Bucket(Weapon, Class or Registry.ClassOf(Weapon)).Models[Name] = Entry
end

function Registry.IsMelee(Weapon)
    local Bucket = Registry.Weapons[Weapon]
    return Bucket and Bucket.Class == "Melees"
end

function Registry.AddModel(Name, Entry, Natives, Group)
    local NativeSet = {}
    for _, Weapon in ipairs(Natives) do
        NativeSet[Weapon] = true
    end

    table.insert(Registry.Models, {
        Name = Name,
        Entry = Entry,
        Natives = NativeSet,
        Label = Natives[1],
        Group = Group,
    })
end

function Registry.Cross(Weapon)
    local Cached = Registry.CrossCache[Weapon]
    if Cached then
        return Cached
    end

    local Bucket = Registry.Weapons[Weapon]
    local Group = Registry.IsMelee(Weapon) and "Melees" or "Guns"
    Cached = {}

    if Bucket and Bucket.Class ~= "Armors" then
        for _, Model in ipairs(Registry.Models) do
            if Model.Group == Group and not Model.Natives[Weapon] then
                Cached[Model.Name .. " · " .. Model.Label] = setmetatable({ Fit = true }, { __index = Model.Entry })
            end
        end
    end

    Registry.CrossCache[Weapon] = Cached
    return Cached
end

function Registry.Get(Weapon, Name)
    local Bucket = Registry.Weapons[Weapon]
    if not (Bucket and Name) then
        return nil
    end

    return Bucket.Skins[Name]
end

function Registry.GetModel(Weapon, Name)
    local Bucket = Registry.Weapons[Weapon]
    if not (Bucket and Name) then
        return nil
    end

    return Bucket.Models[Name] or (Registry.CrossEnabled and Registry.Cross(Weapon)[Name]) or nil
end

function Registry.GetVariant(Path)
    local Class, Name = Path:match("^(%w+)/(.+)$")
    local Folder = Class and SkinVariants:FindFirstChild(Class)
    return Folder and Folder:FindFirstChild(Name)
end

function Registry.LoadLegacy()
    for Class, Weapons in pairs(SkinsDB) do
        for Weapon, Skins in pairs(Weapons) do
            for Name, Data in pairs(Skins) do
                Registry.Add(Weapon, Name, {
                    Source = "astral",
                    Texture = Data.id,
                    Apply = Data.customApply,
                    DisplayApply = Data.customDisplayApply,
                    Legacy = true,
                }, Class)
            end
        end
    end
end

function Registry.LoadCatalog()
    local Env = getrenv and getrenv()._G
    local Data = Env and Env.COSMETIC_STORE_DATA
    if not (Data and Data.Cases) then
        Log("catalog unavailable")
        return {}
    end

    local Used = {}
    local Seen = {}

    for _, Case in pairs(Data.Cases) do
        for _, Group in pairs(Case.CaseContents or {}) do
            if type(Group) == "table" then
                for Id, Item in pairs(Group) do
                    if type(Item) == "table" and Item.ItemName and Item.TextureID and not Seen[Id] then
                        Seen[Id] = true

                        local Name = Item.DisplayName or Id
                        if Item.MeshVariant and Item.CustomName then
                            Name = Item.CustomName .. " " .. Name
                        end

                        local Bucket = Registry.Bucket(Item.ItemName,
                            Registry.ClassOf(Item.ItemName) or (Item.SkinClass == "Melees" and "Melees" or "Other"))

                        for Existing, Entry in pairs(Bucket.Skins) do
                            if Entry.Legacy and Normalize(Existing) == Normalize(Name) then
                                Bucket.Skins[Existing] = nil
                            end
                        end

                        Bucket.Skins[Name] = {
                            Source = "game",
                            Texture = AssetId(Item.TextureID),
                            Variant = Item.MeshVariant and (Item.SkinClass .. "/" .. Item.MeshVariant),
                            Addon = Item.MeshVariantIsAddon,
                            FixedMag = Item._FixedMagThing,
                        }

                        if Item.MeshVariant then
                            Used[Item.MeshVariant] = true
                        end
                    end
                end
            end
        end
    end

    return Used
end

function Registry.LoadModels(Used)
    for _, Def in ipairs(ModelDefs) do
        local Entry = setmetatable({ Source = "model" }, { __index = Def })

        if not Def.Variant or Registry.GetVariant(Def.Variant) then
            for _, Weapon in ipairs(Def.Weapons) do
                Registry.AddNativeModel(Weapon, Def.Name, Entry)
            end

            if Def.Variant then
                Used[Def.Variant:match("/(.+)$")] = true
                Registry.AddModel(Def.Name, Entry, Def.Weapons, Def.Variant:match("^(%w+)/"))
            end
        else
            Log("model missing: " .. Def.Variant)
        end
    end

    for _, Folder in ipairs(SkinVariants:GetChildren()) do
        if Folder.Name == "Guns" or Folder.Name == "Melees" then
            for _, Variant in ipairs(Folder:GetChildren()) do
                local Prefix, Rest = Variant.Name:match("^([%w]+)_(.+)$")
                local Weapon = Prefix and VariantWeapons[Prefix:lower()]

                if Weapon and not Used[Variant.Name] then
                    local Entry = {
                        Source = "model",
                        Variant = Folder.Name .. "/" .. Variant.Name,
                    }

                    Registry.AddNativeModel(Weapon, TitleCase(Rest), Entry, Folder.Name == "Melees" and "Melees" or nil)
                    Registry.AddModel(TitleCase(Rest), Entry, { Weapon }, Folder.Name)
                end
            end
        end
    end
end

function Registry.PruneDead(OnDone)
    local ContentProvider = game:GetService("ContentProvider")
    local Users = {}
    local Ids = {}

    for _, Bucket in pairs(Registry.Weapons) do
        for Name, Entry in pairs(Bucket.Skins) do
            if Entry.Legacy and Entry.Texture then
                if not Users[Entry.Texture] then
                    Users[Entry.Texture] = {}
                    table.insert(Ids, Entry.Texture)
                end
                table.insert(Users[Entry.Texture], { Bucket, Name, Entry })
            end
        end
    end

    local Dead = 0

    for Index = 1, #Ids, 40 do
        local Batch = { table.unpack(Ids, Index, math.min(Index + 39, #Ids)) }

        pcall(ContentProvider.PreloadAsync, ContentProvider, Batch, function(Id, Status)
            if Status == Enum.AssetFetchStatus.Success then
                return
            end

            for _, User in ipairs(Users[Id] or {}) do
                local Bucket, Name, Entry = User[1], User[2], User[3]
                Dead += 1

                if Entry.Apply or Entry.DisplayApply then
                    Entry.Texture = nil
                else
                    Bucket.Skins[Name] = nil
                end
            end
        end)
    end

    Log("pruned " .. Dead .. " dead skins")

    if OnDone then
        OnDone()
    end
end

function Registry.GetWeapons(Class)
    local Weapons = {}

    for Weapon, Bucket in pairs(Registry.Weapons) do
        if Bucket.Class == Class and (next(Bucket.Skins) or next(Bucket.Models)) then
            table.insert(Weapons, Weapon)
        end
    end

    table.sort(Weapons)
    return Weapons
end

function Registry.SortedNames(Map, Extra)
    local Names = {}

    for Name in pairs(Map or {}) do
        table.insert(Names, Name)
    end
    table.sort(Names)

    if Extra then
        local ExtraNames = {}
        for Name in pairs(Extra) do
            table.insert(ExtraNames, Name)
        end
        table.sort(ExtraNames)

        for _, Name in ipairs(ExtraNames) do
            table.insert(Names, Name)
        end
    end

    table.insert(Names, 1, NoneSkin)
    return Names
end

function Registry.GetSkins(Weapon)
    local Bucket = Registry.Weapons[Weapon]
    return Registry.SortedNames(Bucket and Bucket.Skins)
end

function Registry.GetModels(Weapon)
    local Bucket = Registry.Weapons[Weapon]
    return Registry.SortedNames(Bucket and Bucket.Models, Bucket and Registry.CrossEnabled and Registry.Cross(Weapon) or nil)
end

local Meshes = { Parts = {}, Loading = {} }

function Meshes.Get(Id)
    Id = AssetId(Id)

    while Meshes.Loading[Id] do
        task.wait()
    end

    if Meshes.Parts[Id] == nil then
        Meshes.Loading[Id] = true

        local Ok, Part = pcall(function()
            return AssetService:CreateMeshPartAsync(Id)
        end)

        Meshes.Parts[Id] = Ok and Part or false
        Meshes.Loading[Id] = nil

        if not Ok then
            Log("mesh failed " .. Id .. ": " .. tostring(Part))
        end
    end

    return Meshes.Parts[Id] or nil
end

function Meshes.Preload()
    for _, Def in ipairs(ModelDefs) do
        for _, Spec in pairs(Def.Meshes or {}) do
            task.spawn(Meshes.Get, Spec.Mesh)
        end
    end
end

local Painter = { States = {}, Painted = {}, Defaults = {} }

function Painter.DefaultTexture(Weapon)
    local Cached = Painter.Defaults[Weapon]
    if Cached ~= nil then
        return Cached or nil
    end

    local Source = DisplayModels:FindFirstChild(Weapon)
    local Texture = false

    for _, Part in ipairs(Source and Source:GetDescendants() or {}) do
        if Part:IsA("MeshPart") and Part:GetAttribute("SATP") and Part.TextureID ~= "" then
            Texture = Part.TextureID
            break
        end
    end

    Painter.Defaults[Weapon] = Texture
    return Texture or nil
end

function Painter.NewState()
    return {
        Layers = {},
        Saved = {},
        Parked = {},
        Created = {},
        Hidden = {},
        Connections = {},
        Meshes = {},
        Checks = {},
        Appearances = {},
        Sounds = {},
        Mirrors = {},
        BaseCount = 0,
    }
end

function Painter.CountBases(Root, State)
    local Count = 0

    for _, Part in ipairs(Root:GetDescendants()) do
        if Part:IsA("BasePart") then
            local Owned = false

            for _, Instance in ipairs(State.Created) do
                if Part:IsDescendantOf(Instance) then
                    Owned = true
                    break
                end
            end

            if not Owned then
                Count += 1
            end
        end
    end

    return Count
end

function Painter.Snapshot(State, Root, Weapon, Mode)
    local Default = Painter.DefaultTexture(Weapon)
    local Pbr = Storage:FindFirstChild("PBRTextures") and Storage.PBRTextures:FindFirstChild(Weapon)

    for _, Desc in ipairs(Root:GetDescendants()) do
        if Desc:IsA("BasePart") then
            if Desc:IsA("MeshPart") then
                if Default and Painter.Painted[Desc.TextureID] then
                    State.Saved[Desc] = State.Saved[Desc] or {}
                    State.Saved[Desc].TextureID = Default

                    if Mode == "Tool" and Pbr and not Desc:FindFirstChildOfClass("SurfaceAppearance") then
                        table.insert(State.Appearances, { nil, Desc, CloneOf(Pbr) })
                    end
                else
                    Painter.Save(State, Desc, "TextureID")
                end
            end
            Painter.Save(State, Desc, "Color")
            Painter.Save(State, Desc, "Material")
        elseif Desc:IsA("SurfaceAppearance") then
            local Ok, Copy = pcall(CloneOf, Desc)
            table.insert(State.Appearances, { Desc, Desc.Parent, Ok and Copy or nil })
        elseif Desc:IsA("Sparkles") then
            Painter.Save(State, Desc, "SparkleColor")
        elseif MuzzleClasses[Desc.ClassName] then
            pcall(Painter.Save, State, Desc, "Color")
        elseif Desc:IsA("Sound") then
            State.Sounds[Desc] = true
            Painter.Save(State, Desc, "SoundId")
            Painter.Save(State, Desc, "PlaybackSpeed")
        end
    end

    State.BaseCount = Painter.CountBases(Root, State)
end

function Painter.IsIntact(Root)
    local State = Painter.States[Root]
    if not State then
        return false
    end

    for _, Instance in ipairs(State.Created) do
        if Instance:IsA("Model") and not Instance:IsDescendantOf(Root) then
            return false
        end
    end

    for _, Check in ipairs(State.Checks) do
        local Part, Texture = Check[1], Check[2]
        if not Part:IsDescendantOf(Root) or Part.TextureID ~= Texture then
            return false
        end
    end

    return Painter.CountBases(Root, State) == State.BaseCount
end

function Painter.Save(State, Instance, Property)
    local Saved = State.Saved[Instance]
    if not Saved then
        Saved = {}
        State.Saved[Instance] = Saved
    end

    if Saved[Property] == nil then
        Saved[Property] = Instance[Property]
    end
end

function Painter.Set(State, Instance, Property, Value)
    Painter.Save(State, Instance, Property)
    Instance[Property] = Value
end

function Painter.Park(State, Appearance)
    State.Parked[Appearance] = Appearance.Parent
    Appearance.Parent = nil
end

function Painter.IsRigged(Root, Part)
    for _, Joint in ipairs(Part:GetJoints()) do
        local Other = Joint.Part0 == Part and Joint.Part1 or Joint.Part0
        if Other and not Other:IsDescendantOf(Root) then
            return true
        end
    end
    return false
end

function Painter.FindHandle(Root)
    local Candidates = {}

    for _, Child in ipairs(Root:GetChildren()) do
        if Child:IsA("BasePart") and (Child.Name == "WeaponHandle" or Child.Name == "Handle") then
            table.insert(Candidates, Child)
        end
    end

    if #Candidates > 1 then
        for _, Candidate in ipairs(Candidates) do
            if Painter.IsRigged(Root, Candidate) then
                return Candidate
            end
        end
    end

    if Candidates[1] then
        return Candidates[1]
    end

    for _, Desc in ipairs(Root:GetDescendants()) do
        if Desc:IsA("BasePart") and (Desc.Name == "Handle" or Desc.Name == "WeaponHandle") then
            return Desc
        end
    end
end

function Painter.MeshParts(Root, Exclude)
    local All, Tagged = {}, {}

    for _, Part in ipairs(Root:GetDescendants()) do
        if Part:IsA("MeshPart") and not (Exclude and Part:IsDescendantOf(Exclude)) then
            table.insert(All, Part)
            if Part:GetAttribute("SATP") then
                table.insert(Tagged, Part)
            end
        end
    end

    return All, Tagged
end

function Painter.Texture(State, Root, Texture, Exclude, AllParts)
    local All, Tagged = Painter.MeshParts(Root, Exclude)
    local Targets = (AllParts or #Tagged == 0) and All or Tagged

    for _, Part in ipairs(Targets) do
        Painter.Set(State, Part, "TextureID", Texture)
        Painter.Painted[Texture] = true
        table.insert(State.Checks, { Part, Texture })

        local Appearance = Part:FindFirstChildOfClass("SurfaceAppearance")
        if Appearance then
            Painter.Park(State, Appearance)
        end
    end
end

function Painter.Sights(State, Root, SkinName)
    local Color = GlockColors[SkinName]

    for _, Part in ipairs(Root:GetDescendants()) do
        if Part:IsA("BasePart") and GlockSightParts[Part.Name] then
            Painter.Set(State, Part, "Material", Enum.Material.Neon)
            if Part:IsA("MeshPart") then
                Painter.Set(State, Part, "TextureID", "")
            end
            if Color then
                Painter.Set(State, Part, "Color", Color)
            end
        end
    end
end

function Painter.Hide(State, Part, Live)
    if State.Hidden[Part] ~= nil then
        return
    end

    State.Hidden[Part] = Part.Transparency
    Part.Transparency = 1

    if Live then
        table.insert(State.Connections, Part:GetPropertyChangedSignal("Transparency"):Connect(function()
            if Part.Transparency ~= 1 then
                State.Hidden[Part] = Part.Transparency
                Part.Transparency = 1
            end
        end))
    end
end

function Painter.AddMirror(State, Root, Overlay)
    local Reference

    for _, Part in ipairs(Root:GetDescendants()) do
        if Part:IsA("MeshPart") and not Part:IsDescendantOf(Overlay) then
            Reference = Part
            break
        end
    end

    if not Reference then
        return
    end

    local Parts = {}
    for _, Part in ipairs(Overlay:GetDescendants()) do
        if Part:IsA("BasePart") then
            table.insert(Parts, Part)
        end
    end

    table.insert(State.Mirrors, { Reference = Reference, Parts = Parts, Last = -1 })
end

function Painter.SyncMirrors()
    for _, State in pairs(Painter.States) do
        for _, Mirror in ipairs(State.Mirrors) do
            local Modifier = Mirror.Reference.LocalTransparencyModifier

            if Modifier ~= Mirror.Last then
                Mirror.Last = Modifier

                for _, Part in ipairs(Mirror.Parts) do
                    Part.LocalTransparencyModifier = Modifier
                end
            end
        end
    end
end

function Painter.HideOriginals(State, Root, Overlay, Live)
    for _, Part in ipairs(Root:GetDescendants()) do
        if Part:IsA("BasePart") and not Part:IsDescendantOf(Overlay) then
            Painter.Hide(State, Part, Live)
        end
    end
end

function Painter.DrivenParts(Root, Handle)
    local Driven = {}

    for _, Joint in ipairs(Root:GetDescendants()) do
        if Joint:IsA("Motor6D") and Joint.Part1 and Joint.Part1 ~= Handle then
            Driven[Joint.Part1.Name] = Joint.Part1
        end
    end

    return Driven
end

function Painter.AssignDrivers(Clone, VariantHandle, Driven)
    local Links = {}

    local function Link(A, B)
        if A and B and A ~= VariantHandle and B ~= VariantHandle then
            Links[A] = Links[A] or {}
            Links[B] = Links[B] or {}
            table.insert(Links[A], B)
            table.insert(Links[B], A)
        end
    end

    for _, Joint in ipairs(Clone:GetDescendants()) do
        if Joint:IsA("JointInstance") or Joint:IsA("WeldConstraint") then
            Link(Joint.Part0, Joint.Part1)
        end
    end

    local Drivers = {}
    local Queue = {}

    for _, Part in ipairs(Clone:GetDescendants()) do
        if Part:IsA("BasePart") and Part ~= VariantHandle and Driven[Part.Name] then
            Drivers[Part] = Part
            table.insert(Queue, Part)
        end
    end

    local Index = 1
    while Queue[Index] do
        local Part = Queue[Index]
        Index += 1

        for _, Next in ipairs(Links[Part] or {}) do
            if not Drivers[Next] then
                Drivers[Next] = Drivers[Part]
                table.insert(Queue, Next)
            end
        end
    end

    return Drivers
end

function Painter.Bounds(Root, Handle, Exclude, IncludeHidden)
    local Min, Max

    for _, Part in ipairs(Root:GetDescendants()) do
        local Visible = Part:IsA("BasePart") and (Part.Transparency < 1 or (IncludeHidden and Part:IsA("MeshPart")))

        if Visible and Part ~= Handle and not (Exclude and Part:IsDescendantOf(Exclude)) then
            local Half = Part.Size / 2

            for X = -1, 1, 2 do
                for Y = -1, 1, 2 do
                    for Z = -1, 1, 2 do
                        local Point = Handle.CFrame:PointToObjectSpace(Part.CFrame * Vector3.new(Half.X * X, Half.Y * Y, Half.Z * Z))
                        Min = Min and Min:Min(Point) or Point
                        Max = Max and Max:Max(Point) or Point
                    end
                end
            end
        end
    end

    if not Min and not IncludeHidden then
        return Painter.Bounds(Root, Handle, Exclude, true)
    end

    return Min, Max
end

function Painter.Axes(Min, Max)
    local Size = Max - Min
    local Center = (Min + Max) / 2
    local Axes = {
        { Vector3.xAxis, Size.X, Center.X },
        { Vector3.yAxis, Size.Y, Center.Y },
        { Vector3.zAxis, Size.Z, Center.Z },
    }

    table.sort(Axes, function(A, B) return A[2] > B[2] end)

    return Axes, Center
end

function Painter.AxisSign(Axis)
    if math.abs(Axis[3]) > Axis[2] * 0.05 then
        return Axis[3] < 0 and -1 or 1
    end
    return 1
end

function Painter.MatchAxis(From, To)
    if From[1] == To[1] then
        return From[1], To[1]
    end
    return From[1] * Painter.AxisSign(From), To[1] * Painter.AxisSign(To)
end

function Painter.FitTransform(VariantMin, VariantMax, TargetMin, TargetMax, Flip)
    local VariantAxes, VariantCenter = Painter.Axes(VariantMin, VariantMax)
    local TargetAxes, TargetCenter = Painter.Axes(TargetMin, TargetMax)

    local FromLong, ToLong = Painter.MatchAxis(VariantAxes[1], TargetAxes[1])
    local FromMid, ToMid = Painter.MatchAxis(VariantAxes[2], TargetAxes[2])

    local From = CFrame.fromMatrix(Vector3.zero, FromLong, FromMid)
    local To = CFrame.fromMatrix(Vector3.zero, ToLong, ToMid)
    local Rotation = To * From:Inverse()
    if Flip then
        Rotation = CFrame.fromAxisAngle(ToMid, math.pi) * Rotation
    end

    local Scale = math.clamp(TargetAxes[1][2] / math.max(VariantAxes[1][2], 1e-3), 0.5, 2)

    return function(Relative)
        local Position = TargetCenter + Rotation:VectorToWorldSpace((Relative.Position - VariantCenter) * Scale)
        return CFrame.new(Position) * Rotation * Relative.Rotation
    end, Scale
end

function Painter.ScalePart(Part, Scale)
    Part.Size *= Scale

    local Mesh = Part:FindFirstChildOfClass("SpecialMesh")
    if Mesh then
        Mesh.Scale *= Scale
    end
end

function Painter.Attach(State, Root, Path, Mode, Fit, Flip)
    local Source = Registry.GetVariant(Path)
    local Handle = Painter.FindHandle(Root)
    if not (Source and Handle) then
        return nil
    end

    local Clone = CloneOf(Source)
    local VariantHandle = Painter.FindHandle(Clone)
    if not VariantHandle then
        Clone:Destroy()
        return nil
    end

    Clone.Name = "__DemidaVariant"

    local Driven = (Mode == "Tool" and not Fit) and Painter.DrivenParts(Root, Handle) or {}
    local Drivers = Painter.AssignDrivers(Clone, VariantHandle, Driven)
    local Offsets = {}

    for _, Part in ipairs(Clone:GetDescendants()) do
        if Part:IsA("BasePart") then
            local Driver = Drivers[Part] or VariantHandle
            Offsets[Part] = { Driver, Driver.CFrame:ToObjectSpace(Part.CFrame) }
        end
    end

    if Fit then
        local TargetMin, TargetMax = Painter.Bounds(Root, Handle)
        local VariantMin, VariantMax = Painter.Bounds(Clone, VariantHandle)

        if TargetMin and VariantMin then
            local Transform, Scale = Painter.FitTransform(VariantMin, VariantMax, TargetMin, TargetMax, Flip)

            for Part, Offset in pairs(Offsets) do
                Offset[2] = Transform(Offset[2])

                if Part ~= VariantHandle then
                    Painter.ScalePart(Part, Scale)
                end
            end
        end
    end

    for _, Desc in ipairs(Clone:GetDescendants()) do
        if Desc:IsA("JointInstance") or Desc:IsA("WeldConstraint") or Desc:IsA("LuaSourceContainer") or Desc:IsA("Sound") then
            Desc:Destroy()
        end
    end

    for Part, Offset in pairs(Offsets) do
        local Driver, Relative = Offset[1], Offset[2]
        local Target = Driver == VariantHandle and Handle or Driven[Driver.Name]

        Part.Anchored = Mode == "Preview"
        Part.CanCollide = false
        Part.CanQuery = false
        Part.CanTouch = false
        Part.Massless = true

        if Part == VariantHandle then
            Part.Transparency = 1
        end

        if Mode == "Preview" then
            Part.CFrame = Target.CFrame * Relative
        else
            local Weld = Instance.new("Weld")
            Weld.Part0 = Target
            Weld.Part1 = Part
            Weld.C0 = Relative
            Weld.Parent = Part
        end
    end

    Clone.Parent = Mode == "Display" and Handle.Parent or Root
    table.insert(State.Created, Clone)

    return Clone
end

function Painter.Muzzle(State, Root, Spec)
    local Handle = Painter.FindHandle(Root)
    local Muzzle = Handle and Handle:FindFirstChild("Muzzle")
    if not Muzzle then
        return
    end

    if Spec.Color then
        local Sequence = ColorSequence.new(Spec.Color)

        for _, Effect in ipairs(Muzzle:GetChildren()) do
            if MuzzleClasses[Effect.ClassName] then
                if Effect:IsA("ParticleEmitter") or Effect:IsA("Beam") then
                    Painter.Set(State, Effect, "Color", Sequence)
                elseif Effect:IsA("Sparkles") then
                    Painter.Set(State, Effect, "SparkleColor", Spec.Color)
                else
                    Painter.Set(State, Effect, "Color", Spec.Color)
                end
            end
        end
    end

    if Spec.Sound then
        local Sound = Muzzle:FindFirstChild("FFireSoundTWO")

        if Sound then
            Painter.Set(State, Sound, "SoundId", Spec.Sound)
        else
            Sound = Instance.new("Sound")
            Sound.Name = "FFireSoundTWO"
            Sound.SoundId = Spec.Sound
            Sound.Parent = Muzzle
            table.insert(State.Created, Sound)
        end
    end
end

function Painter.FindNamed(Root, Names, Exclude)
    for _, Name in ipairs(Names) do
        for _, Part in ipairs(Root:GetDescendants()) do
            if Part.Name == Name and Part:IsA("MeshPart") and not (Exclude and Part:IsDescendantOf(Exclude)) then
                return Part
            end
        end
    end
end

function Painter.SwapMeshes(State, Root, Specs)
    for PartName, Spec in pairs(Specs) do
        local Part = Painter.FindNamed(Root, MeshAliases[PartName] or { PartName })
        local Mesh = Part and Meshes.Get(Spec.Mesh)

        if Mesh and not State.Meshes[Part] then
            State.Meshes[Part] = CloneOf(Part)
            Part:ApplyMesh(Mesh)

            if Spec.Texture then
                Painter.Set(State, Part, "TextureID", Spec.Texture)
                Painter.Painted[Spec.Texture] = true

                local Appearance = Part:FindFirstChildOfClass("SurfaceAppearance")
                if Appearance then
                    Painter.Park(State, Appearance)
                end
            end
        end
    end
end

function Painter.Effects(State, Root, Weapon, Mode)
    for _, Entry in ipairs(State.Layers) do
        if Entry.Muzzle and Mode == "Tool" then
            Painter.Muzzle(State, Root, Entry.Muzzle)
        end

        local Callback = (Mode == "Tool") and Entry.Apply or Entry.DisplayApply
        if Callback then
            pcall(Callback, Root)
        end
    end
end

function Painter.Sanitize(Root, Source)
    for _, Desc in ipairs(Root:GetDescendants()) do
        if Desc.Name == "__DemidaVariant" then
            Desc:Destroy()
        end
    end

    local SourceState = Source and Painter.States[Source]
    if not SourceState then
        return
    end

    local Original = {}
    for Part, Transparency in pairs(SourceState.Hidden) do
        Original[Part.Name] = Transparency
    end

    for _, Part in ipairs(Root:GetDescendants()) do
        if Part:IsA("BasePart") and Part.Transparency == 1 and Original[Part.Name] then
            Part.Transparency = Original[Part.Name]
        end
    end
end

function Painter.Apply(Root, Weapon, Layers, Mode, Source)
    if Mode ~= "Preview" then
        Painter.Sanitize(Root, Source)
    end

    local State = Painter.NewState()
    Painter.States[Root] = State

    if Mode ~= "Preview" then
        Painter.Snapshot(State, Root, Weapon, Mode)
    end

    for _, Layer in ipairs(Layers) do
        table.insert(State.Layers, Layer[2])
        Painter.ApplyLayer(State, Root, Weapon, Layer[1], Layer[2], Mode)
    end

    Painter.Effects(State, Root, Weapon, Mode)
end

function Painter.ApplyLayer(State, Root, Weapon, SkinName, Entry, Mode)
    local Overlay = Entry.Variant and Painter.Attach(State, Root, Entry.Variant, Mode, Entry.Fit, Registry.Flips[Weapon])

    if Overlay and not Entry.Addon then
        Painter.HideOriginals(State, Root, Overlay, Mode ~= "Preview")
    end

    if Overlay and Mode ~= "Preview" then
        Painter.AddMirror(State, Root, Overlay)
    end

    if Entry.Texture then
        if Overlay and not Entry.Addon then
            Painter.Texture(State, Overlay, Entry.Texture)
        else
            Painter.Texture(State, Root, Entry.Texture, Overlay, Entry.Legacy)
            if Overlay then
                Painter.Texture(State, Overlay, Entry.AddonTexture or Entry.Texture)
            end
        end
    elseif Overlay and Entry.AddonTexture then
        Painter.Texture(State, Overlay, Entry.AddonTexture)
    end

    if Entry.Meshes then
        Painter.SwapMeshes(State, Root, Entry.Meshes)
    end

    if Overlay then
        for _, Part in ipairs(Overlay:GetDescendants()) do
            if Part:IsA("BasePart") then
                if Entry.PlasticTint and (Part.Material == Enum.Material.Plastic or Part.Material == Enum.Material.SmoothPlastic) then
                    Part.Color = Entry.PlasticTint
                end

                if Entry.Glow and table.find(Entry.Glow.Names, Part.Name) then
                    local Appearance = Part:FindFirstChildOfClass("SurfaceAppearance")
                    if Appearance then
                        Appearance:Destroy()
                    end
                    Part.Material = Enum.Material.Neon
                    Part.Color = Entry.Glow.Color
                    Part.Transparency = 0
                end

                if Entry.Hide and table.find(Entry.Hide, Part.Name) then
                    Part.Transparency = 1
                end
            end
        end
    end

    if Entry.FixedMag then
        for _, Part in ipairs(Root:GetDescendants()) do
            if Part:IsA("BasePart") then
                if Part.Name == "MagPart" or Part.Name == "BasePart" then
                    Painter.Set(State, Part, "Transparency", 1)
                elseif Part.Name == "FixedMagPart" or Part.Name == "BasePart2" then
                    Painter.Set(State, Part, "Transparency", 0)
                end
            end
        end
    end

    if Entry.Legacy and GlockWeapons[Weapon] then
        Painter.Sights(State, Root, SkinName)
    end

    return Overlay
end

function Painter.Restore(Root)
    local State = Painter.States[Root]
    if not State then
        return
    end

    Painter.States[Root] = nil

    for _, Connection in ipairs(State.Connections) do
        Connection:Disconnect()
    end

    for Part, Transparency in pairs(State.Hidden) do
        Part.Transparency = Transparency
    end

    for _, Instance in ipairs(State.Created) do
        Instance:Destroy()
    end

    for Part, Original in pairs(State.Meshes) do
        if Part.Parent then
            pcall(Part.ApplyMesh, Part, Original)
        end
        Original:Destroy()
    end

    for Instance, Properties in pairs(State.Saved) do
        for Property, Value in pairs(Properties) do
            pcall(function()
                Instance[Property] = Value
            end)
        end
    end

    for Appearance, Parent in pairs(State.Parked) do
        if Parent and Parent.Parent then
            Appearance.Parent = Parent
        end
    end

    for _, Record in ipairs(State.Appearances) do
        local Appearance, Parent, Copy = Record[1], Record[2], Record[3]

        if Parent and Parent.Parent and (not Appearance or Appearance.Parent ~= Parent) then
            local Moved = Appearance and pcall(function()
                Appearance.Parent = Parent
            end)

            if not Moved and Copy then
                Copy.Parent = Parent
                Copy = nil
            end
        end

        if Copy then
            Copy:Destroy()
        end
    end

    for _, Sound in ipairs(Root:GetDescendants()) do
        if Sound:IsA("Sound") and Sound.Name == "FFireSoundTWO" and not State.Sounds[Sound] then
            Sound:Destroy()
        end
    end
end

local SkinChanger = {
    Enabled = false,
    ModelsEnabled = false,
    Loadout = {},
    Models = {},
    Applied = {},
    SeenAt = {},
    Dropped = {},
    Tracked = {},
    PendingDrops = {},
    Repairs = {},
    CharacterConns = {},
    Watchers = {},
    Clean = {},
    EquipHooks = {},
    Running = true,
}

function SkinChanger.FindTool(Weapon)
    local Character = LocalPlayer.Character
    local Backpack = LocalPlayer:FindFirstChildOfClass("Backpack")

    for _, Container in pairs({ Character, Backpack }) do
        local Tool = Container:FindFirstChild(Weapon)
        if Tool and Tool:IsA("Tool") then
            return Tool
        end
    end
end

function SkinChanger.FindViewTool(Weapon)
    local Camera = workspace.CurrentCamera
    local ViewModel = Camera and Camera:FindFirstChild("ViewModel")
    local ViewTool = ViewModel and ViewModel:FindFirstChildOfClass("Tool")
    local Character = LocalPlayer.Character
    local Held = Character and Character:FindFirstChildOfClass("Tool")

    if ViewTool and Held and Held.Name == Weapon then
        return ViewTool, Held
    end
end

function SkinChanger.FindDisplay(Weapon)
    local Character = LocalPlayer.Character
    local Items = Character and Character:FindFirstChild("DisplayItems")
    return Items and Items:FindFirstChild(Weapon)
end

function SkinChanger.RememberClean(Weapon, Tool)
    if SkinChanger.Clean[Weapon] or Painter.States[Tool] then
        return
    end

    local Ok, Copy = pcall(CloneOf, Tool)
    if Ok and Copy then
        for _, Desc in ipairs(Copy:GetDescendants()) do
            if Desc:IsA("LuaSourceContainer") or Desc:IsA("Sound") or Desc:IsA("RemoteEvent") or Desc:IsA("RemoteFunction") then
                Desc:Destroy()
            end
        end
        SkinChanger.Clean[Weapon] = Copy
    end
end

function SkinChanger.HookEquip(Tool, Weapon)
    if SkinChanger.EquipHooks[Tool] then
        return
    end

    SkinChanger.EquipHooks[Tool] = Tool.Equipped:Connect(function()
        for _, Delay in ipairs({ 0, 0.1, 0.4 }) do
            task.delay(Delay, function()
                local State = Painter.States[Tool]
                if State and Tool.Parent then
                    Painter.Effects(State, Tool, Weapon, "Tool")
                end
            end)
        end
    end)
end

function SkinChanger.Layers(Weapon, Mode)
    local Layers, Key = {}, {}

    local SkinName = SkinChanger.Loadout[Weapon]
    local Skin = SkinChanger.Enabled and Registry.Get(Weapon, SkinName)
    if Skin then
        table.insert(Layers, { SkinName, Skin })
        table.insert(Key, SkinName)
    end

    local ModelName = SkinChanger.Models[Weapon]
    local Model = SkinChanger.ModelsEnabled and Registry.GetModel(Weapon, ModelName)
    if Model then
        table.insert(Layers, { ModelName, Model })
        table.insert(Key, "#" .. ModelName)
    end

    return Layers, #Layers > 0 and table.concat(Key, "|") or nil
end

function SkinChanger.Sync(Weapon)
    local Tool = SkinChanger.FindTool(Weapon)
    if Tool then
        SkinChanger.RememberClean(Weapon, Tool)
    end

    local Targets = {
        { Tool, "Tool" },
        { SkinChanger.FindDisplay(Weapon), "Display" },
    }

    for Dropped, Name in pairs(SkinChanger.Dropped) do
        if Name == Weapon and Dropped.Parent and Dropped ~= Tool then
            table.insert(Targets, { Dropped, "Tool" })
        end
    end

    local ViewTool, Held = SkinChanger.FindViewTool(Weapon)
    if ViewTool then
        table.insert(Targets, { ViewTool, "Tool", Held })
    end

    for _, Target in ipairs(Targets) do
        local Root, Mode, Source = Target[1], Target[2], Target[3]
        local Layers, Wanted = SkinChanger.Layers(Weapon, Mode)

        local Current = Root and SkinChanger.Applied[Root]
        local Stale = Root and Wanted and Current == Wanted and SkinChanger.CanRepair(Root) and not Painter.IsIntact(Root)

        if Stale then
            SkinChanger.NoteRepair(Root)
        elseif Root and Current ~= Wanted then
            SkinChanger.Repairs[Root] = nil
        end

        if Root and (Current ~= Wanted or Stale) and SkinChanger.IsReady(Root, Wanted) then
            local Ok, Err = pcall(function()
                Painter.Restore(Root)

                if Wanted then
                    Painter.Apply(Root, Weapon, Layers, Mode, Source)

                    if Mode == "Tool" then
                        SkinChanger.HookEquip(Root, Weapon)
                    end
                end
            end)

            if not Ok then
                Log(string.format("sync %s failed: %s", Root:GetFullName(), tostring(Err)))
            end

            SkinChanger.Applied[Root] = Wanted
        end
    end
end

function SkinChanger.CanRepair(Root)
    local Repair = SkinChanger.Repairs[Root]
    return not Repair or (Repair.Count < Config.MaxRepairs and os.clock() - Repair.Last >= Config.RepairCooldown)
end

function SkinChanger.NoteRepair(Root)
    local Repair = SkinChanger.Repairs[Root] or { Count = 0, Last = 0 }
    Repair.Count += 1
    Repair.Last = os.clock()
    SkinChanger.Repairs[Root] = Repair
end

function SkinChanger.IsReady(Root, Wanted)
    if not Wanted then
        return true
    end

    local SeenAt = SkinChanger.SeenAt[Root]
    if not SeenAt then
        SkinChanger.SeenAt[Root] = os.clock()
        task.delay(Config.SettleTime, SkinChanger.SyncAll)
        return false
    end

    return os.clock() - SeenAt >= Config.SettleTime
end

function SkinChanger.IsMine(Instance)
    local Character = LocalPlayer.Character
    local Backpack = LocalPlayer:FindFirstChildOfClass("Backpack")

    return (Character and Instance:IsDescendantOf(Character)) or (Backpack and Instance:IsDescendantOf(Backpack)) or false
end

function SkinChanger.Track(Tool)
    if SkinChanger.Tracked[Tool] then
        return
    end

    SkinChanger.Tracked[Tool] = Tool.AncestryChanged:Connect(function()
        if not Tool.Parent then
            if not SkinChanger.Dropped[Tool] then
                local Handle = Painter.FindHandle(Tool)
                table.insert(SkinChanger.PendingDrops, {
                    Name = Tool.Name,
                    Time = os.clock(),
                    Position = Handle and Handle.Position,
                })
            end

            SkinChanger.Dropped[Tool] = nil
            return
        end

        if SkinChanger.IsMine(Tool) then
            SkinChanger.Dropped[Tool] = nil
            return
        end

        local Holder = Tool:FindFirstAncestorOfClass("Model")
        local Owner = Holder and Players:GetPlayerFromCharacter(Holder)

        if Owner and Owner ~= LocalPlayer then
            SkinChanger.Dropped[Tool] = nil
            pcall(Painter.Restore, Tool)
            SkinChanger.Applied[Tool] = nil
        elseif Tool:IsDescendantOf(workspace) then
            SkinChanger.Dropped[Tool] = Tool.Name
            SkinChanger.Force(Tool)
        end
    end)
end

function SkinChanger.Force(Tool)
    if not Tool:IsA("Tool") then
        return
    end

    SkinChanger.Track(Tool)

    if not SkinChanger.Weapons()[Tool.Name] then
        return
    end

    SkinChanger.SeenAt[Tool] = os.clock()

    task.delay(Config.SettleTime, function()
        if Tool.Parent then
            SkinChanger.Applied[Tool] = false
            SkinChanger.Sync(Tool.Name)
        end
    end)
end

function SkinChanger.ClaimDrop(Instance)
    if not (Instance:IsA("Tool") or Instance:IsA("Model")) or SkinChanger.IsMine(Instance) then
        return
    end

    for Index, Pending in ipairs(SkinChanger.PendingDrops) do
        if Pending.Name == Instance.Name and os.clock() - Pending.Time < 3 then
            task.delay(0.1, function()
                local Handle = Painter.FindHandle(Instance)
                local Near = not Pending.Position or (Handle and (Handle.Position - Pending.Position).Magnitude < 25)

                if Near and Instance.Parent and not SkinChanger.IsMine(Instance) then
                    table.remove(SkinChanger.PendingDrops, table.find(SkinChanger.PendingDrops, Pending) or Index)
                    SkinChanger.Dropped[Instance] = Instance.Name
                    SkinChanger.SeenAt[Instance] = os.clock()
                    task.delay(Config.SettleTime, SkinChanger.Sync, Instance.Name)
                end
            end)
            return
        end
    end
end

function SkinChanger.WatchContainer(Container)
    if not Container then
        return
    end

    if SkinChanger.BackpackConn then
        SkinChanger.BackpackConn:Disconnect()
    end

    SkinChanger.BackpackConn = Container.ChildAdded:Connect(SkinChanger.Force)
end

function SkinChanger.Watch()
    local function OnCharacter(Character)
        for _, Connection in ipairs(SkinChanger.CharacterConns) do
            Connection:Disconnect()
        end
        table.clear(SkinChanger.CharacterConns)

        table.insert(SkinChanger.CharacterConns, Character.ChildAdded:Connect(SkinChanger.Force))
        table.insert(SkinChanger.CharacterConns, Character.ChildAdded:Connect(function(Child)
            if Child:IsA("Tool") and SkinChanger.OnHeld then
                task.spawn(SkinChanger.OnHeld, Child.Name)
            end
        end))

        local Items = Character:WaitForChild("DisplayItems", 10)
        if Items then
            table.insert(SkinChanger.CharacterConns, Items.ChildAdded:Connect(function(Item)
                if SkinChanger.Weapons()[Item.Name] then
                    SkinChanger.SeenAt[Item] = os.clock()
                    task.delay(Config.SettleTime, SkinChanger.Sync, Item.Name)
                end
            end))
        end
    end

    table.insert(SkinChanger.Watchers, LocalPlayer.CharacterAdded:Connect(OnCharacter))
    table.insert(SkinChanger.Watchers, workspace.CurrentCamera.DescendantAdded:Connect(function(Instance)
        if Instance:IsA("Tool") and Instance.Parent and Instance.Parent.Name == "ViewModel" then
            SkinChanger.SeenAt[Instance] = os.clock()

            task.delay(0.15, function()
                local Character = LocalPlayer.Character
                local Held = Character and Character:FindFirstChildOfClass("Tool")
                if Held and SkinChanger.Weapons()[Held.Name] then
                    SkinChanger.SeenAt[Instance] = os.clock() - Config.SettleTime
                    SkinChanger.Sync(Held.Name)
                end
            end)
        end
    end))
    table.insert(SkinChanger.Watchers, workspace.DescendantAdded:Connect(function(Instance)
        if #SkinChanger.PendingDrops > 0 then
            SkinChanger.ClaimDrop(Instance)
        end
    end))
    table.insert(SkinChanger.Watchers, LocalPlayer.ChildAdded:Connect(function(Child)
        if Child:IsA("Backpack") then
            SkinChanger.WatchContainer(Child)
        end
    end))

    SkinChanger.WatchContainer(LocalPlayer:FindFirstChildOfClass("Backpack"))

    for _, Container in pairs({ LocalPlayer.Character, LocalPlayer:FindFirstChildOfClass("Backpack") }) do
        for _, Tool in ipairs(Container:GetChildren()) do
            if Tool:IsA("Tool") then
                SkinChanger.Track(Tool)
            end
        end
    end

    if LocalPlayer.Character then
        task.spawn(OnCharacter, LocalPlayer.Character)
    end
end

function SkinChanger.Weapons()
    local Weapons = {}

    for Weapon in pairs(SkinChanger.Loadout) do
        Weapons[Weapon] = true
    end

    for Weapon in pairs(SkinChanger.Models) do
        Weapons[Weapon] = true
    end

    return Weapons
end

function SkinChanger.Refresh(Weapon)
    local Tool, Display = SkinChanger.FindTool(Weapon), SkinChanger.FindDisplay(Weapon)

    if Tool then
        SkinChanger.Applied[Tool] = false
    end

    if Display then
        SkinChanger.Applied[Display] = false
    end

    task.spawn(SkinChanger.Sync, Weapon)
end

function SkinChanger.Prune()
    for Index = #SkinChanger.PendingDrops, 1, -1 do
        if os.clock() - SkinChanger.PendingDrops[Index].Time > 3 then
            table.remove(SkinChanger.PendingDrops, Index)
        end
    end

    for Root in pairs(Painter.States) do
        if not Root.Parent then
            Painter.States[Root] = nil
        end
    end

    for _, Map in ipairs({ SkinChanger.Applied, SkinChanger.SeenAt, SkinChanger.Dropped, SkinChanger.Repairs }) do
        for Root in pairs(Map) do
            if not Root.Parent then
                Map[Root] = nil
            end
        end
    end

    for _, Map in ipairs({ SkinChanger.Tracked, SkinChanger.EquipHooks }) do
        for Root, Connection in pairs(Map) do
            if not Root.Parent then
                Connection:Disconnect()
                Map[Root] = nil
            end
        end
    end
end

function SkinChanger.SyncAll()
    for Weapon in pairs(SkinChanger.Weapons()) do
        task.spawn(SkinChanger.Sync, Weapon)
    end
end

function SkinChanger.MarkReady(Weapon)
    local Ready = os.clock() - Config.SettleTime * 2
    local Tool, Display, ViewTool = SkinChanger.FindTool(Weapon), SkinChanger.FindDisplay(Weapon), SkinChanger.FindViewTool(Weapon)

    for _, Root in pairs({ Tool, Display, ViewTool }) do
        SkinChanger.SeenAt[Root] = Ready
    end
end

function SkinChanger.SetSkin(Weapon, SkinName)
    SkinChanger.Loadout[Weapon] = SkinName ~= NoneSkin and SkinName or nil
    SkinChanger.MarkReady(Weapon)
    task.spawn(SkinChanger.Sync, Weapon)
end

function SkinChanger.SetModel(Weapon, ModelName)
    SkinChanger.Models[Weapon] = ModelName ~= NoneSkin and ModelName or nil
    SkinChanger.MarkReady(Weapon)
    task.spawn(SkinChanger.Sync, Weapon)
end

function SkinChanger.SetEnabled(Skins, Models)
    if Skins ~= nil then
        SkinChanger.Enabled = Skins
    end

    if Models ~= nil then
        SkinChanger.ModelsEnabled = Models
    end

    for Weapon in pairs(SkinChanger.Weapons()) do
        SkinChanger.Sync(Weapon)
    end
end

function SkinChanger.Save()
    if not writefile then
        return false
    end

    return pcall(writefile, Config.SaveFile, HttpService:JSONEncode({
        Loadout = SkinChanger.Loadout,
        Models = SkinChanger.Models,
        Flips = Registry.Flips,
    }))
end

function SkinChanger.Load()
    if not (isfile and isfile(Config.SaveFile)) then
        return false
    end

    local Ok, Data = pcall(function()
        return HttpService:JSONDecode(readfile(Config.SaveFile))
    end)

    if not Ok or type(Data) ~= "table" then
        return false
    end

    if type(Data.Loadout) ~= "table" then
        Data = { Loadout = Data }
    end

    for Weapon, Flip in pairs(Data.Flips or {}) do
        Registry.Flips[Weapon] = Flip == true or nil
    end

    for Weapon, SkinName in pairs(Data.Loadout) do
        if Registry.Get(Weapon, SkinName) then
            SkinChanger.Loadout[Weapon] = SkinName
        end
    end

    for Weapon, ModelName in pairs(Data.Models or {}) do
        if Registry.GetModel(Weapon, ModelName) then
            SkinChanger.Models[Weapon] = ModelName
        end
    end

    SkinChanger.SyncAll()
    return true
end

function SkinChanger.CountLoadout()
    local Skins, Models = 0, 0

    for _ in pairs(SkinChanger.Loadout) do
        Skins += 1
    end

    for _ in pairs(SkinChanger.Models) do
        Models += 1
    end

    return Skins, Models
end

Registry.LoadLegacy()
Registry.LoadModels(Registry.LoadCatalog())
task.spawn(Meshes.Preload)

table.insert(SkinChanger.Watchers, game:GetService("RunService").RenderStepped:Connect(Painter.SyncMirrors))

task.spawn(function()
    while SkinChanger.Running do
        SkinChanger.Prune()

        if SkinChanger.Enabled or SkinChanger.ModelsEnabled then
            SkinChanger.SyncAll()
        end
        task.wait(Config.SweepInterval)
    end
end)

local Window = Library:CreateWindow({
    Title = "demid | skins",
    Center = true,
    AutoShow = true,
    TabPadding = 6,
    MenuFadeTime = 0.15,
    Size = UDim2.fromOffset(470, 430),
})

local Tabs = {
    Skins = Window:AddTab("Skins"),
    Visuals = Window:AddTab("Visuals"),
    Misc = Window:AddTab("Misc"),
    Settings = Window:AddTab("Settings"),
}

local SelectBox = Tabs.Skins:AddLeftGroupbox("Skins")
local PreviewBox = Tabs.Skins:AddRightGroupbox("Preview")
local ModelBox = Tabs.Skins:AddRightGroupbox("Custom Models")

local Preview = PreviewBox:AddPreview("SkinPreview", {
    Height = 150,
    Speed = 0.5,
    EmptyText = "no 3d model",
})

local InfoLabel = PreviewBox:AddLabel("Skins: 0 | Models: 0")

local UI = { Updating = false, Token = 0 }

function UI.RefreshInfo()
    local Skins, Models = SkinChanger.CountLoadout()
    InfoLabel:SetText(string.format("Skins: %d | Models: %d", Skins, Models))
end

function UI.Selected(Option)
    local Value = Options[Option] and Options[Option].Value
    return Value ~= NoneSkin and Value or nil
end

function UI.PreviewSource(Weapon, Layers)
    local Source = SkinChanger.Clean[Weapon] or DisplayModels:FindFirstChild(Weapon)
    if Source then
        return Source, Layers
    end

    for Index, Layer in ipairs(Layers) do
        local Entry = Layer[2]
        if Entry.Variant and not Entry.Addon then
            Layers[Index] = { Layer[1], setmetatable({ Variant = false, Fit = false }, { __index = Entry }) }
            return Registry.GetVariant(Entry.Variant), Layers
        end
    end
end

function UI.ShowPreview()
    UI.Token += 1
    local Token = UI.Token

    local Weapon = Options.SkinWeapon and Options.SkinWeapon.Value
    if not Weapon then
        Preview:Clear()
        Preview:SetText("")
        return
    end

    local SkinName, ModelName = UI.Selected("SkinName"), UI.Selected("SkinModel")
    local Layers = {}
    local Skin = Registry.Get(Weapon, SkinName)
    local Model = Registry.GetModel(Weapon, ModelName)

    if Skin then
        table.insert(Layers, { SkinName, Skin })
    end

    if Model then
        table.insert(Layers, { ModelName, Model })
    end

    local Caption = Weapon .. " | " .. (SkinName or NoneSkin)
    if ModelName then
        Caption ..= " + " .. ModelName
    end
    Preview:SetText(Caption)

    task.spawn(function()
        local Source, PaintLayers = UI.PreviewSource(Weapon, Layers)
        if not Source then
            Preview:Clear()
            return
        end

        local Built = CloneOf(Source)

        if #PaintLayers > 0 then
            local Ok, Err = pcall(Painter.Apply, Built, Weapon, PaintLayers, "Preview")
            if not Ok then
                Log("preview failed: " .. tostring(Err))
            end
        end

        Painter.States[Built] = nil

        if Token ~= UI.Token then
            Built:Destroy()
            return
        end

        Preview:SetModel(Built, true)
    end)
end

function UI.RefreshWeapon()
    if Options.SkinWeapon then
        Options.SkinWeapon:SetValue(Options.SkinWeapon.Value)
    end
end

SelectBox:AddToggle("SkinEnabled", {
    Text = "Enabled",
    Default = false,
})

SelectBox:AddToggle("FollowHeld", {
    Text = "Follow held weapon",
    Default = true,
})

SelectBox:AddDropdown("SkinClass", {
    Text = "Class",
    Values = ClassOrder,
    Default = "Pistols",
})

SelectBox:AddDropdown("SkinWeapon", {
    Text = "Weapon",
    Values = Registry.GetWeapons("Pistols"),
    Default = 1,
})

SelectBox:AddDropdown("SkinName", {
    Text = "Skin",
    Values = { NoneSkin },
    Default = 1,
})

SelectBox:AddButton("Reset weapon", function()
    if Options.SkinWeapon.Value then
        Options.SkinName:SetValue(NoneSkin)
        Options.SkinModel:SetValue(NoneSkin)
    end
end)

SelectBox:AddButton("Reset all", function()
    for Weapon in pairs(SkinChanger.Weapons()) do
        SkinChanger.Loadout[Weapon] = nil
        SkinChanger.Models[Weapon] = nil
        task.spawn(SkinChanger.Sync, Weapon)
    end

    UI.Updating = true
    Options.SkinName:SetValue(NoneSkin)
    Options.SkinModel:SetValue(NoneSkin)
    UI.Updating = false

    UI.ShowPreview()
    UI.RefreshInfo()
end)

SelectBox:AddDivider()

SelectBox:AddButton({
    Text = "Save",
    Func = function()
        Library:Notify(SkinChanger.Save() and "Loadout saved" or "Save failed", 2)
    end,
}):AddButton({
    Text = "Load",
    Func = function()
        Library:Notify(SkinChanger.Load() and "Loadout loaded" or "Nothing to load", 2)
        UI.RefreshInfo()
        UI.RefreshWeapon()
    end,
})

ModelBox:AddToggle("ModelsEnabled", {
    Text = "Custom models",
    Default = false,
})

ModelBox:AddToggle("CrossModels", {
    Text = "Models on any gun",
    Default = true,
})

ModelBox:AddDropdown("SkinModel", {
    Text = "Model",
    Values = { NoneSkin },
    Default = 1,
})

ModelBox:AddButton("Flip model", function()
    local Weapon = Options.SkinWeapon.Value
    if not Weapon then
        return
    end

    Registry.Flips[Weapon] = not Registry.Flips[Weapon] or nil
    SkinChanger.Refresh(Weapon)
    UI.ShowPreview()
end)

function UI.SelectWeapon(Weapon)
    local Bucket = Registry.Weapons[Weapon]
    if not Bucket or Options.SkinWeapon.Value == Weapon then
        return
    end

    if Options.SkinClass.Value ~= Bucket.Class then
        Options.SkinClass:SetValue(Bucket.Class)
    end

    Options.SkinWeapon:SetValue(Weapon)
end

SkinChanger.OnHeld = function(Weapon)
    if SkinChanger.Running and Toggles.FollowHeld and Toggles.FollowHeld.Value then
        UI.SelectWeapon(Weapon)
    end
end

Toggles.SkinEnabled:OnChanged(function(Value)
    task.spawn(SkinChanger.SetEnabled, Value, nil)
end)

Toggles.ModelsEnabled:OnChanged(function(Value)
    task.spawn(SkinChanger.SetEnabled, nil, Value)
end)

Toggles.CrossModels:OnChanged(function(Value)
    Registry.CrossEnabled = Value
    UI.RefreshWeapon()
end)

Options.SkinClass:OnChanged(function(Class)
    local Weapons = Registry.GetWeapons(Class)

    Options.SkinWeapon:SetValues(Weapons)
    Options.SkinWeapon:SetValue(Weapons[1])
end)

Options.SkinWeapon:OnChanged(function(Weapon)
    UI.Updating = true

    Options.SkinName:SetValues(Weapon and Registry.GetSkins(Weapon) or { NoneSkin })
    Options.SkinName:SetValue(Weapon and SkinChanger.Loadout[Weapon] or NoneSkin)

    Options.SkinModel:SetValues(Weapon and Registry.GetModels(Weapon) or { NoneSkin })
    Options.SkinModel:SetValue(Weapon and SkinChanger.Models[Weapon] or NoneSkin)

    UI.Updating = false

    UI.ShowPreview()
end)

Options.SkinName:OnChanged(function(SkinName)
    if UI.Updating then
        return
    end

    local Weapon = Options.SkinWeapon.Value
    if Weapon then
        SkinChanger.SetSkin(Weapon, SkinName)
        UI.RefreshInfo()
    end

    UI.ShowPreview()
end)

Options.SkinModel:OnChanged(function(ModelName)
    if UI.Updating then
        return
    end

    local Weapon = Options.SkinWeapon.Value
    if Weapon then
        SkinChanger.SetModel(Weapon, ModelName)
        UI.RefreshInfo()
    end

    UI.ShowPreview()
end)

local Stamina = {
    Attribute = "ZSPRN_M",
    Enabled = false,
    Connections = {},
}

function Stamina.Disconnect()
    for _, Connection in ipairs(Stamina.Connections) do
        Connection:Disconnect()
    end
    table.clear(Stamina.Connections)
end

function Stamina.Bind(Character)
    local Humanoid = Character and Character:WaitForChild("Humanoid", 10)
    if not (Humanoid and Stamina.Enabled) then
        return
    end

    Humanoid:SetAttribute(Stamina.Attribute, true)

    table.insert(Stamina.Connections, Humanoid:GetAttributeChangedSignal(Stamina.Attribute):Connect(function()
        if Stamina.Enabled and not Humanoid:GetAttribute(Stamina.Attribute) then
            Humanoid:SetAttribute(Stamina.Attribute, true)
        end
    end))
end

function Stamina.SetEnabled(Bool)
    Stamina.Enabled = Bool
    Stamina.Disconnect()

    local Character = LocalPlayer.Character
    local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")

    if not Bool then
        if Humanoid then
            Humanoid:SetAttribute(Stamina.Attribute, nil)
        end
        return
    end

    table.insert(Stamina.Connections, LocalPlayer.CharacterAdded:Connect(function()
        Stamina.SetEnabled(true)
    end))

    if Character then
        task.spawn(Stamina.Bind, Character)
    end
end

local Esp = {
    Enabled = false,
    Color = Color3.fromRGB(255, 255, 255),
    MaxDistance = 1500,
    HealthColorOn = false,
    MinWidth = 6,
    MinHeight = 10,
    Boxes = {},
    Connections = {},
    Available = type(Drawing) == "table" and type(Drawing.new) == "function",
}

function Esp.NewSquare(Color, Thickness, ZIndex)
    local Square = Drawing.new("Square")
    Square.Filled = false
    Square.Color = Color
    Square.Thickness = Thickness
    Square.Transparency = 1
    Square.ZIndex = ZIndex
    Square.Visible = false
    return Square
end

function Esp.Get(Player)
    local Box = Esp.Boxes[Player]

    if not Box then
        Box = {
            Outline = Esp.NewSquare(Color3.new(0, 0, 0), 3, 1),
            Main = Esp.NewSquare(Esp.Color, 1, 2),
            Shown = false,
        }
        Esp.Boxes[Player] = Box
    end

    return Box
end

function Esp.HealthColor(Character)
    local Humanoid = Character:FindFirstChildOfClass("Humanoid")
    local Ratio = Humanoid and Humanoid.MaxHealth > 0 and math.clamp(Humanoid.Health / Humanoid.MaxHealth, 0, 1) or 1
    return Color3.fromRGB(255, 0, 0):Lerp(Color3.fromRGB(0, 255, 0), Ratio)
end

function Esp.SetBoxColor(Box, Color)
    if Box.Color ~= Color then
        Box.Color = Color
        Box.Main.Color = Color
    end
end

function Esp.Hide(Box)
    if Box.Shown then
        Box.Shown = false
        Box.Outline.Visible = false
        Box.Main.Visible = false
    end
end

function Esp.Remove(Player)
    local Box = Esp.Boxes[Player]
    if Box then
        Box.Outline:Remove()
        Box.Main:Remove()
        Esp.Boxes[Player] = nil
    end
end

function Esp.Step()
    local Camera = workspace.CurrentCamera
    if not Camera then
        return
    end

    local CameraPosition = Camera.CFrame.Position

    for _, Player in ipairs(Players:GetPlayers()) do
        if Player ~= LocalPlayer then
            local Character = Player.Character
            local Root = Character and Character:FindFirstChild("HumanoidRootPart")
            local Box = Esp.Get(Player)

            if not Root or (Root.Position - CameraPosition).Magnitude > Esp.MaxDistance then
                Esp.Hide(Box)
            else
                local Top = Camera:WorldToViewportPoint(Root.Position + Vector3.new(0, 3, 0))
                local Bottom = Camera:WorldToViewportPoint(Root.Position - Vector3.new(0, 3.5, 0))
                local Viewport = Camera.ViewportSize

                local OnScreen = Top.Z > 0 and Bottom.Z > 0
                    and Top.X > -50 and Top.X < Viewport.X + 50
                    and math.max(Top.Y, Bottom.Y) > -50 and math.min(Top.Y, Bottom.Y) < Viewport.Y + 50

                if OnScreen then
                    local Height = math.max(math.floor(math.abs(Bottom.Y - Top.Y) + 0.5), Esp.MinHeight)
                    local Width = math.max(math.floor(Height * 0.6 + 0.5), Esp.MinWidth)
                    local CenterY = (Top.Y + Bottom.Y) / 2
                    local Position = Vector2.new(math.floor(Top.X - Width / 2 + 0.5), math.floor(CenterY - Height / 2 + 0.5))
                    local Size = Vector2.new(Width, Height)

                    Esp.SetBoxColor(Box, Esp.HealthColorOn and Esp.HealthColor(Character) or Esp.Color)

                    Box.Outline.Position = Position
                    Box.Outline.Size = Size
                    Box.Main.Position = Position
                    Box.Main.Size = Size

                    if not Box.Shown then
                        Box.Shown = true
                        Box.Outline.Visible = true
                        Box.Main.Visible = true
                    end
                else
                    Esp.Hide(Box)
                end
            end
        end
    end
end

function Esp.SetColor(Color)
    Esp.Color = Color
    if not Esp.HealthColorOn then
        for _, Box in pairs(Esp.Boxes) do
            Esp.SetBoxColor(Box, Color)
        end
    end
end

function Esp.SetEnabled(Bool)
    Esp.Enabled = Bool

    for _, Connection in ipairs(Esp.Connections) do
        Connection:Disconnect()
    end
    table.clear(Esp.Connections)

    if not Bool then
        for Player in pairs(Esp.Boxes) do
            Esp.Remove(Player)
        end
        return
    end

    if not Esp.Available then
        Library:Notify("Drawing API not available", 3)
        return
    end

    table.insert(Esp.Connections, game:GetService("RunService").RenderStepped:Connect(Esp.Step))
    table.insert(Esp.Connections, Players.PlayerRemoving:Connect(Esp.Remove))
end

local EspBox = Tabs.Visuals:AddLeftGroupbox("ESP")

EspBox:AddToggle("EspBoxes", {
    Text = "Box",
    Default = false,
}):AddColorPicker("EspColor", {
    Default = Esp.Color,
    Title = "Box color",
}):AddKeyPicker("EspKey", {
    Default = "None",
    SyncToggleState = true,
    Mode = "Toggle",
    Text = "Box",
    NoUI = false,
})

EspBox:AddToggle("EspHealthColor", {
    Text = "Color based on health",
    Default = false,
})

EspBox:AddSlider("EspDistance", {
    Text = "Max distance",
    Default = Esp.MaxDistance,
    Min = 100,
    Max = 5000,
    Rounding = 0,
    Suffix = " st",
})

Toggles.EspBoxes:OnChanged(function(Value)
    Esp.SetEnabled(Value)
end)

Toggles.EspHealthColor:OnChanged(function(Value)
    Esp.HealthColorOn = Value
    if not Value then
        Esp.SetColor(Esp.Color)
    end
end)

Options.EspColor:OnChanged(function(Value)
    Esp.SetColor(Value)
end)

Options.EspDistance:OnChanged(function(Value)
    Esp.MaxDistance = Value
end)

local MovementBox = Tabs.Misc:AddLeftGroupbox("Movement")

MovementBox:AddToggle("InfiniteStamina", {
    Text = "Infinite Stamina",
    Default = false,
})

Toggles.InfiniteStamina:OnChanged(function(Value)
    Stamina.SetEnabled(Value)
end)

local MenuBox = Tabs.Settings:AddLeftGroupbox("Menu")

MenuBox:AddLabel("Menu key"):AddKeyPicker("MenuKeybind", {
    Default = "RightShift",
    NoUI = true,
    Text = "Menu keybind",
})

MenuBox:AddToggle("PreviewRotate", {
    Text = "Rotate preview",
    Default = true,
})

MenuBox:AddButton("Unload", function()
    Library:Unload()
end)

Library.ToggleKeybind = Options.MenuKeybind

Toggles.PreviewRotate:OnChanged(function(Value)
    Preview:SetAutoRotate(Value)
end)

Library:OnUnload(function()
    Stamina.SetEnabled(false)
    Esp.SetEnabled(false)
    SkinChanger.Running = false
    SkinChanger.SetEnabled(false, false)

    for _, Connection in pairs(SkinChanger.EquipHooks) do
        Connection:Disconnect()
    end

    for _, Connection in ipairs(SkinChanger.Watchers) do
        Connection:Disconnect()
    end

    for _, Connection in ipairs(SkinChanger.CharacterConns) do
        Connection:Disconnect()
    end

    if SkinChanger.BackpackConn then
        SkinChanger.BackpackConn:Disconnect()
    end

    for _, Connection in pairs(SkinChanger.Tracked) do
        Connection:Disconnect()
    end

    for Tool in pairs(SkinChanger.Dropped) do
        pcall(Painter.Restore, Tool)
    end

    for _, Copy in pairs(SkinChanger.Clean) do
        Copy:Destroy()
    end

    Preview:Clear()
end)

SkinChanger.Watch()
SkinChanger.Load()
UI.RefreshInfo()
UI.RefreshWeapon()

do
    local Character = LocalPlayer.Character
    local Held = Character and Character:FindFirstChildOfClass("Tool")
    if Held then
        SkinChanger.OnHeld(Held.Name)
    end
end

task.spawn(Registry.PruneDead, function()
    if SkinChanger.Running then
        UI.RefreshWeapon()
    end
end)

Environment.Demida = { Registry = Registry, Painter = Painter, SkinChanger = SkinChanger, Meshes = Meshes, Esp = Esp, Stamina = Stamina }

Log("skins ready")
