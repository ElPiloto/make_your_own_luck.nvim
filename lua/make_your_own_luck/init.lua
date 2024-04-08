local random = math.random
local io = require("io")
local async = require("plenary.async")

local M = {}

M.BASE_DIR = "/home/elpiloto/coding/lua/make_your_own_luck/resources/"


local function from_base_dir(s)
  return M.BASE_DIR .. "/" .. s
end


local function get_cached(file_path)
  -- Check if cached version exists
  local cached_file = file_path .. ".cached"
  local file = io.open(cached_file, "r")
  if file then
    local content = file:read()
    io.close(file)
    return content
  end
  return nil
end

-- Function to pick a random item from a file
local function pick_random_item(file_path)
  -- Read all lines from the main file
  local file_path_abs = io.open(file_path, "r")
  if not file_path_abs then
    return nil
  end

  local lines = {}
  for line in file_path_abs:lines() do
    table.insert(lines, line)
  end

  if #lines > 0 then
    -- Pick a random line and return the item
    return lines[random(#lines)]
  end

  return nil
end

-- Function to update the cache asynchronously
local function update_cache(file_path)
  local item = pick_random_item(file_path)
  if item then
    local file = io.open(file_path .. ".cached", "w")
    file:write(item)
    io.close(file)
  end
end

-- Function to get a random item for a specific type
function M.get_random_item(item_type)
  local file_path = item_type .. "/short.txt"
  file_path = from_base_dir(file_path)
  local picked = get_cached(file_path)
  if not picked then
    picked = pick_random_item(file_path)
  end

  async.run(function() update_cache(file_path) end)

  return picked
end

local default_box_chars = {
  top_left = "┌",
  top_right = "┐",
  bottom_left = "└",
  bottom_right = "┘",
  vertical = "│",
  horizontal = "─",
  vertical_left = "│",
  vertical_right = "│",
  horizontal_top = "─",
  horizontal_bottom = "─",
}
-- default_box_chars = {
--   top_left = "🬕",
--   top_right = "🬨",
--   bottom_left = "🬲",
--   bottom_right = "🬷",
--   vertical = "▋",
--   horizontal = "─",
--
--   vertical_left = "▍",
--   vertical_right = "🮈",
--
--   horizontal_top = "🬂",
--   horizontal_bottom = "🬭",
-- }

function M.wrap_in_box(lines, target_line_length, box_chars)
  -- Handle missing arguments
  target_line_length = target_line_length or 80
  if not lines then
    return error("Missing required arguments: lines")
  end
  box_chars = box_chars or default_box_chars

  -- Calculate box dimensions
  local box_width = math.max(target_line_length, #box_chars.horizontal + 2)

  -- Build the box
  local box = {}

  -- Top line
  box[#box + 1] = box_chars.top_left .. string.rep(box_chars.horizontal_top, box_width - 2) .. box_chars.top_right

  -- Middle lines
  for _, line in ipairs(lines) do
    local content_width = math.min(#line, target_line_length - 4) -- Allow space for padding and vertical lines
    local padding_width = (box_width - content_width - 4) / 2 + 1
    box[#box + 1] = box_chars.vertical_left ..
        string.rep(" ", padding_width) .. line:sub(1, content_width) .. string.rep(
          " ", padding_width
        ) .. box_chars.vertical_right
  end

  -- Bottom line
  box[#box + 1] = box_chars.bottom_left ..
      string.rep(box_chars.horizontal_bottom, box_width - 2) .. box_chars.bottom_right

  return box
end

return M
