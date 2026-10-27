return {
  "windwp/nvim-autopairs",
  event = "InsertEnter",
  dependencies = {
    "hrsh7th/nvim-cmp",
  },
  config = function()
    local npairs = require("nvim-autopairs")
    local Rule = require('nvim-autopairs.rule')
    npairs.setup()
    npairs.add_rules({
      Rule("$", "$", "tex")
      : with_pair(function(opts)
          return true
      end),
      Rule("\\[", "\\]", "tex")
      : with_pair(function() 
        return true 
      end): with_move(function(opts)
        return opts.char == "\\]"
      end)
    })

    local cmp_autopairs =
      require("nvim-autopairs.completion.cmp")
    local cmp = require("cmp")

    cmp.event:on(
      "confirm_done",
      cmp_autopairs.on_confirm_done()
    )
  end,
}
