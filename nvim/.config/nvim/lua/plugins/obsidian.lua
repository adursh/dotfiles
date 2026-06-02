return {
  "obsidian-nvim/obsidian.nvim",
  version = "*",
  lazy = true,
  ft = "markdown",
  opts = {
    workspaces = {
      {
        name = "personal",
        path = "~/Library/Mobile Documents/iCloud~md~obsidian/Documents",
      },
    },
    daily_notes = {
      enabled = true,
      folder = "Journal",
      date_format = "YYYY-MM-DD",
      template = "daily-note.md",
      default_tags = { "journal" },
      workdays_only = false,
    },
    templates = {
      folder = "Templates",
      date_format = "YYYY-MM-DD",
      time_format = "HH:mm",
    },
    frontmatter = {
      enabled = true,
      func = function(note)
        local out = {}
        if note.metadata and note.metadata.created then
          out.created = note.metadata.created
        else
          out.created = os.date("%Y-%m-%d %H:%M")
        end
        out.modified = os.date("%Y-%m-%d %H:%M")
        if note.metadata then
          for k, v in pairs(note.metadata) do
            if out[k] == nil then
              out[k] = v
            end
          end
        end
        return out
      end,
      sort = { "created", "modified" },
    },
    preferred_link_style = "wiki",
    open_notes_in = "current",
    note_id_func = function(title)
      if title ~= nil then
        return title
      end
      return tostring(os.date("%Y%m%d%H%M%S"))
    end,
  },
}
