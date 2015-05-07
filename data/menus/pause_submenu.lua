-- Base class of each submenu.

local submenu = {}

function submenu:new(game, submenus)
  local o = { game = game, pause_submenus = submenus }
  setmetatable(o, self)
  self.__index = self
  return o
end

function submenu:on_started()

  self.background_surfaces = sol.surface.create("pause_submenus.png", true)
  self.background_surfaces:set_opacity(216)

  local dialog_font = 'la'
  local menu_font = 'minecraftia'

  self.question_text_1 = sol.text_surface.create{
    horizontal_alignment = "center",
    vertical_alignment = "middle",
    color = {8, 8, 8},
    font = dialog_font,
  }
  self.question_text_2 = sol.text_surface.create{
    horizontal_alignment = "center",
    vertical_alignment = "middle",
    color = {8, 8, 8},
    font = dialog_font,
  }

  self.game:set_custom_command_effect("action", nil)
  self.game:set_custom_command_effect("attack", "save")
end

function submenu:next_submenu()

  sol.audio.play_sound("pause_closed")
  sol.menu.stop(self)
  local submenus = self.pause_submenus
  local submenu_index = self.game:get_value("pause_last_submenu")
  submenu_index = (submenu_index % #submenus) + 1
  self.game:set_value("pause_last_submenu", submenu_index)
  submenus[submenu_index].from = 'left'
  sol.menu.start(self.game, submenus[submenu_index], false)
end

function submenu:previous_submenu()

  sol.audio.play_sound("pause_closed")
  sol.menu.stop(self)
  local submenus = self.pause_submenus
  local submenu_index = self.game:get_value("pause_last_submenu")
  submenu_index = (submenu_index + 2) % #submenus + 1
  self.game:set_value("pause_last_submenu", submenu_index)
  submenus[submenu_index].from = 'right'
  sol.menu.start(self.game, submenus[submenu_index], false)
end

function submenu:draw_background(dst_surface)

  local submenu_index = self.game:get_value("pause_last_submenu")
  local width, height = dst_surface:get_size()
  self.background_surfaces:draw_region(
      320 * (submenu_index - 1), 0, 320, 240,
      dst_surface, (width - 320) / 2, (height - 240) / 2)
end

function submenu:on_command_pressed(command)
    if command == 'attack' then
        self.game:save()
        sol.main.reset()
    end
    return false
end

return submenu
