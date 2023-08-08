return {
  {
    "williamboman/mason.nvim",
    cmd = {
      "Mason",
      "MasonInstall",
      "MasonUninstall",
      "MasonUninstallAll",
      "MasonLog",
    },
    dependencies = {
      {
        "AstroNvim/astrocore",
        opts = function(_, opts)
          local maps = opts.mappings
          local cmd = opts.commands
          if require("astrocore").is_available "mason.nvim" then
            maps.n["<Leader>pm"] = { function() require("mason.ui").open() end, desc = "Mason Installer" }
            maps.n["<Leader>pM"] = { function() require("astrocore.mason").update_all() end, desc = "Mason Update" }
            cmd.AstroMasonUpdate = {
              function(options) require("astrocore.mason").update(options.fargs) end,
              nargs = "*",
              desc = "Update Mason Package",
              complete = function(arg_lead)
                local _ = require "mason-core.functional"
                return _.sort_by(
                  _.identity,
                  _.filter(_.starts_with(arg_lead), require("mason-registry").get_installed_package_names())
                )
              end,
            }
            cmd.AstroMasonUpdateAll =
              { function() require("astrocore.mason").update_all() end, desc = "Update Mason Packages" }
          end
        end,
      },
    },
    opts = {
      ui = {
        icons = {
          package_installed = "✓",
          package_uninstalled = "✗",
          package_pending = "⟳",
        },
      },
    },
    build = ":MasonUpdate",
    config = function(...) require "astronvim.plugins.configs.mason"(...) end,
  },
}
