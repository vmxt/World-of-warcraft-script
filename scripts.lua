﻿

-- UNITFRAMES

-- UF positions
local a = CreateFrame("Frame")
a:SetScript("OnEvent", function(self, event)
if event == "PLAYER_ENTERING_WORLD" then
PlayerFrame:ClearAllPoints()
PlayerFrame:SetPoint("CENTER", -430, 100)
RuneFrame:ClearAllPoints()
RuneFrame:SetPoint("CENTER", -377, 145)
TargetFrame:ClearAllPoints()
TargetFrame:SetPoint("CENTER", -330, 55)
FocusFrame:ClearAllPoints()
FocusFrame:SetPoint("CENTER", 300, -175)
PetFrame:ClearAllPoints()
PetFrame:SetPoint("CENTER", -75, 75)
PartyMemberFrame1:ClearAllPoints()
PartyMemberFrame1:SetScale(1.25)
PartyMemberFrame1:SetPoint("RIGHT", UIParent, "CENTER", -425, 75)
PartyMemberFrame2:ClearAllPoints()
PartyMemberFrame2:SetScale(1.25)
PartyMemberFrame2:SetPoint("RIGHT", UIParent, "CENTER", -425, 25)
PartyMemberFrame3:ClearAllPoints()
PartyMemberFrame3:SetScale(1.25)
PartyMemberFrame3:SetPoint("RIGHT", UIParent, "CENTER", -425, -25)
PartyMemberFrame4:ClearAllPoints()
PartyMemberFrame4:SetScale(1.25)
PartyMemberFrame4:SetPoint("RIGHT", UIParent, "CENTER", -425, -75)
end
end)

a:RegisterEvent("PLAYER_ENTERING_WORLD")

-- Change name color on UF
for i, f in pairs({TargetFrame, PlayerFrame, FocusFrame, PetFrame, PartyMemberFrame1, PartyMemberFrame2, PartyMemberFrame3, PartyMemberFrame4}) do f.name:SetVertexColor(1,10,10) end

-- Target/Focus background
hooksecurefunc("TargetFrame_CheckFaction", function(self)
    self.nameBackground:SetVertexColor(0.0, 0.0, 0.0, 0.5);
end)

-- Class icons instead of portraits
hooksecurefunc("UnitFramePortrait_Update",function(self)
    if self.portrait then
        if UnitIsPlayer(self.unit) then
            local t = CLASS_ICON_TCOORDS[select(2, UnitClass(self.unit))]
            if t then
                self.portrait:SetTexture("Interface\\TargetingFrame\\UI-Classes-Circles")
                self.portrait:SetTexCoord(unpack(t))
            end
        else
            self.portrait:SetTexCoord(0,1,0,1)
        end
    end
end)

-- Class colors in hp bars
local function colour(statusbar, unit)
    local _, class, c
    if UnitIsPlayer(unit) and UnitIsConnected(unit) and unit == statusbar.unit and UnitClass(unit) then
        _, class = UnitClass(unit)
        c = CUSTOM_CLASS_COLORS and CUSTOM_CLASS_COLORS[class] or RAID_CLASS_COLORS[class]
        statusbar:SetStatusBarColor(c.r, c.g, c.b)
        PlayerFrameHealthBar:SetStatusBarColor(0,1,0)
    end
end

hooksecurefunc("UnitFrameHealthBar_Update", colour)
hooksecurefunc("HealthBar_OnValueChanged", function(self)
    colour(self, self.unit)
end)

-- Combat sign on UF
CTT=CreateFrame("Frame")
CTT:SetParent(TargetFrame)
CTT:SetPoint("Right",TargetFrame,-10,5)
CTT:SetSize(25,25)
CTT.t=CTT:CreateTexture(nil,BORDER)
CTT.t:SetAllPoints()
CTT.t:SetTexture("Interface\\Icons\\ABILITY_DUALWIELD")
CTT:Hide()
local function FrameOnUpdate(self) if UnitAffectingCombat("target") then self:Show() else self:Hide() end end
local g = CreateFrame("Frame") g:SetScript("OnUpdate", function(self) FrameOnUpdate(CTT) end)
CFT=CreateFrame("Frame")
CFT:SetParent(FocusFrame)
CFT:SetPoint("Left",FocusFrame,-30,5)
CFT:SetSize(25,25)
CFT.t=CFT:CreateTexture(nil,BORDER)
CFT.t:SetAllPoints()CFT.t:SetTexture("Interface\\Icons\\ABILITY_DUALWIELD")
CFT:Hide()
local function FrameOnUpdate(self) if UnitAffectingCombat("focus") then self:Show() else self:Hide() end end
local g = CreateFrame("Frame") g:SetScript("OnUpdate", function(self) FrameOnUpdate(CFT) end)

local frame=CreateFrame("Frame")
frame:RegisterEvent("ADDON_LOADED")

-- Actionbars scale
MainMenuBar:SetScale(0.9)
MultiBarBottomLeft:SetScale(0.9)
MultiBarBottomRight:SetScale(0.9)

-- Move pet actionbar
PetActionBarFrame:ClearAllPoints()
PetActionBarFrame:SetPoint ("CENTER", UIParent , 413, -497)
PetActionBarFrame:SetScale(.9)
PetActionBarFrame.ClearAllPoints = function () end
PetActionBarFrame.SetPoint = function () end

-- Out of range
hooksecurefunc("ActionButton_OnEvent",function(self, event, ...)
                if ( event == "PLAYER_TARGET_CHANGED" ) then
                        self.newTimer = self.rangeTimer
                end
        end)

        hooksecurefunc("ActionButton_UpdateUsable",function(self)
                local icon = _G[self:GetName().."Icon"]
                local valid = IsActionInRange(self.action)

                if ( valid == 0 ) then
                        icon:SetVertexColor(1.0, 0.1, 0.1)
                end
        end)

        hooksecurefunc("ActionButton_OnUpdate",function(self, elapsed)
                local rangeTimer = self.newTimer

                if ( rangeTimer ) then
                        rangeTimer = rangeTimer - elapsed

                        if ( rangeTimer <= 0 ) then
                                ActionButton_UpdateUsable(self)
                                rangeTimer = TOOLTIP_UPDATE_TIME
                        end

                        self.newTimer = rangeTimer
                end
        end)


-- HIDE GRAPHICS

-- Hide gryphons
MainMenuBarLeftEndCap:Hide()
MainMenuBarRightEndCap:Hide()

-- Hide hotkey labels
for i=1, 12 do
    _G["ActionButton"..i.."HotKey"]:SetAlpha(0)
    _G["MultiBarBottomRightButton"..i.."HotKey"]:SetAlpha(0)
    _G["MultiBarBottomLeftButton"..i.."HotKey"]:SetAlpha(0)
    _G["MultiBarRightButton"..i.."HotKey"]:SetAlpha(0)
    _G["MultiBarLeftButton"..i.."HotKey"]:SetAlpha(0)
end

-- Hide macro labels
for i=1, 12 do
    _G["ActionButton"..i.."Name"]:SetAlpha(0)
    _G["MultiBarBottomRightButton"..i.."Name"]:SetAlpha(0)
    _G["MultiBarBottomLeftButton"..i.."Name"]:SetAlpha(0)
    _G["MultiBarRightButton"..i.."Name"]:SetAlpha(0)
    _G["MultiBarLeftButton"..i.."Name"]:SetAlpha(0)
end

-- Hide error frame
UIErrorsFrame:SetAlpha(0)

-- Hide pvp timer
PlayerPVPTimerText:SetAlpha(0)

-- Hide faction/PvP icon
PlayerPVPIcon:SetAlpha(0)
TargetFrameTextureFramePVPIcon:SetAlpha(0)
FocusFrameTextureFramePVPIcon:SetAlpha(0)

-- Disable group number frame
PlayerFrameGroupIndicator.Show = function() return end

-- Disable healing/damage spam over player/pet frame
PlayerHitIndicator.Show = function() end
PetHitIndicator.Show = function() end

-- Hide attack/rest glow
hooksecurefunc("PlayerFrame_UpdateStatus", function()
if IsResting("player") then
PlayerStatusTexture:Hide()
PlayerRestIcon:Hide()
PlayerRestGlow:Hide()
PlayerStatusGlow:Hide()
elseif PlayerFrame.inCombat then
PlayerStatusTexture:Hide()
PlayerAttackIcon:Hide()
PlayerRestIcon:Hide()
PlayerAttackGlow:Hide()
PlayerRestGlow:Hide()
PlayerStatusGlow:Hide()
PlayerAttackBackground:Hide() end end)

-- Hide pet name
PetName:Hide()


-- MINIMAP

local CF=CreateFrame("Frame")
	CF:RegisterEvent("PLAYER_ENTERING_WORLD")
	CF:SetScript("OnEvent", function(self, event)
		if not (IsAddOnLoaded("SexyMap")) then
			for i,v in pairs({
				MinimapBorder,
				MiniMapMailBorder,
				QueueStatusMinimapButtonBorder,
				select(1, TimeManagerClockButton:GetRegions()),
				select(1, GameTimeFrame:GetRegions()),
              		}) do
                 		v:SetVertexColor(.3, .3, .3)
			end
			MinimapBorderTop:Hide()
			MinimapZoomIn:Hide()
			MinimapZoomOut:Hide()
			MiniMapWorldMapButton:Hide()
			GameTimeFrame:Hide()
			GameTimeFrame:UnregisterAllEvents()
			GameTimeFrame.Show = kill
			MiniMapTracking:Hide()
			MiniMapTracking.Show = kill
			MiniMapTracking:UnregisterAllEvents()
			MinimapZoneText:SetPoint("TOPLEFT","MinimapZoneTextButton","TOPLEFT", 5, 5)
			Minimap:EnableMouseWheel(true)
			Minimap:SetScript("OnMouseWheel", function(self, z)
				local c = Minimap:GetZoom()
				if(z > 0 and c < 5) then
					Minimap:SetZoom(c + 1)
				elseif(z < 0 and c > 0) then
					Minimap:SetZoom(c - 1)
				end
			end)
			Minimap:SetScript("OnMouseUp", function(self, btn)
				if btn == "RightButton" then
					_G.GameTimeFrame:Click()
				elseif btn == "MiddleButton" then
					_G.ToggleDropDownMenu(1, nil, _G.MiniMapTrackingDropDown, self)
				else
					_G.Minimap_OnClick(self)
				end
			end)
		end
	end)


-- DARK FRAMES

frame:SetScript("OnEvent", function(self, event, addon)
        if (addon == "Blizzard_TimeManager") then
                for i, v in pairs({PlayerFrameTexture, PetFrameTexture, TargetFrameTextureFrameTexture, FocusFrameTextureFrameTexture, PartyMemberFrame1Texture, PartyMemberFrame2Texture, PartyMemberFrame3Texture,
				        PartyMemberFrame4Texture, PartyMemberFrame1PetFrameTexture, PartyMemberFrame2PetFrameTexture, PartyMemberFrame3PetFrameTexture, PartyMemberFrame4PetFrameTexture,
                        MainMenuBarTexture0, MainMenuBarTexture1, MainMenuBarTexture2, MainMenuBarTexture3, MainMenuMaxLevelBar0, MainMenuMaxLevelBar1, MainMenuMaxLevelBar2, MainMenuMaxLevelBar3,
                        ChatFrame1EditBoxLeft, ChatFrame1EditBoxRight, ChatFrame1EditBoxMid, ChatFrame2EditBoxLeft, ChatFrame2EditBoxRight, ChatFrame2EditBoxMid, ChatFrame3EditBoxLeft, ChatFrame3EditBoxRight, ChatFrame3EditBoxMid,
                        select(1, TimeManagerClockButton:GetRegions())
                }) do
                        v:SetVertexColor(.4, .4, .4)
                end

                for i,v in pairs({ select(2, TimeManagerClockButton:GetRegions()) }) do
                        v:SetVertexColor(1, 1, 1)
                end

                self:UnregisterEvent("ADDON_LOADED")
                frame:SetScript("OnEvent", nil)
        end
end)

for i, v in pairs({ MainMenuBarLeftEndCap, MainMenuBarRightEndCap }) do
        v:SetVertexColor(.35, .35, .35)
end


-- BUFFTRACKER

bl={57623, 49222, 53365, 67773}

bs=25;xb=-15;yb=-140;br=2;bdr="BORDER"be="UNIT_AURA"cbf=CreateFrame;gi=GetSpellInfo;bm=math.ceil;fm=math.floor;st=STANDARD_TEXT_FONT;function cu(s) return UnitBuff("player",gi(s))end

function Cb(i,s)local _,_,t3=gi(s)local f=cbf("Frame")f:SetSize(bs,bs)f.t=f:CreateTexture(nil,bdr)f.t:SetAllPoints(true)f.t:SetTexture(t3)f.f=f:CreateFontString(nil,bdr)f.f:SetFont(st,12,"OUTLINE")f.f:SetPoint("BOTTOMRIGHT",0,0)return f;end

function vb(s,i,row)local b1,_,_,b4=cu(s)local f=_G["B"..i]if b1 then f:Show()f:SetPoint("CENTER",xb+(bs+5)*bm((row-1)%br),yb-(bs+15)*bm(row/br))if(b4>1)then f.f:SetText(b4)end row=row+1;end return row;end

function ub()for i,s in ipairs(bl)do local b,_,_,_,_,_,k=cu(s)if b then local vt=fm(k-GetTime())if (vt>=60)then vt=bm(vt/60)_G["B"..i].c:SetText(vt.."m")elseif vt >= 0 then _G["B"..i].c:SetText(vt.."s")end end end end

function Cc(f)f.c=f:CreateFontString(nil,bdr)f.c:SetFont(st,12,"OUTLINE")f.c:SetPoint("CENTER",0,-20)end function db()for i in ipairs(bl)do _G["B"..i]:Hide()end end

for i,s in ipairs(bl)do _G["B"..i]=Cb(i,s)Cc(_G["B"..i])_G["B"..i]:Hide()end function bb()db()local bw=1;for i,s in ipairs(bl)do bw=vb(s,i,bw)end end bk=cbf("Frame")bk:SetScript("OnEvent",bb)bk:SetScript("OnUpdate",ub)bk:RegisterEvent(be)