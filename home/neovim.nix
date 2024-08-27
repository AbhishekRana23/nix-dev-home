{ flake, pkgs, ... }:
let
  #TODO: split extraPlugins
  guihua = pkgs.stdenv.mkDerivation {
    name = "test";
    buildInputs = with pkgs; [ gnumake ];
    src = pkgs.fetchFromGitHub {
      owner = "ray-x";
      repo = "guihua.lua";
      rev = "9fb6795474918b492d9ab01b1ebaf85e8bf6fe0b";
      sha256 = "sha256-0fpcYEdWfpy8MatH8cjalGOQ7/tau6ciiuSV1t09BlY=";
    };
    dontInstall = true;
    buildCommand = ''
      mkdir -p $out
      cp -r $src/* .
      chmod -R +w .
      make -C lua/fzy
      cp -r . $out;
    '';
  };
  sad-nvim = pkgs.vimUtils.buildVimPlugin {
    name = "sad";
    src = pkgs.fetchFromGitHub {
      owner = "ray-x";
      repo = "sad.nvim";
      rev = "869c7f3ca3dcd28fd78023db6a7e1bf8af0f4714";
      sha256 = "sha256-uwXldYA7JdZHqoB4qfCnZcQW9YBjlRWmiz8mKb9jHuI=";
    };
  };
  vim-resize-mode = pkgs.vimUtils.buildVimPlugin {
    name = "vim-resize-mode";
    src = pkgs.fetchFromGitHub {
      owner = "sedm0784";
      repo = "vim-resize-mode";
      rev = "0f3997d1a57c43113979df1f5fda1925f55a219b";
      sha256 = "sha256-l3g4pRsNTeVX/X26we2+yhSi4sUNUBy8PrdG/GE20UA=";
    };
  };
  telescope-themes = pkgs.vimUtils.buildVimPlugin {
    name = "telescope-themes";
    src = builtins.fetchTarball {
      url =
        "https://github.com/andrew-george/telescope-themes/archive/master.tar.gz";
      sha256 = "sha256:0vmvrjk1bw9cgdwb1cmgk1v353842ccsl59x6gn4ggp55i1nlwzy";
    };
  };
  kanagawa = pkgs.vimUtils.buildVimPlugin {
    name = "kanagawa";
    src = pkgs.fetchFromGitHub {
      owner = "rebelot";
      repo = "kanagawa.nvim";
      rev = "bfa818c7bf6259152f1d89cf9fbfba3554c93695";
      sha256 = "sha256-eSrng/h+hN8iSu2nLLfqSMvnOmBXE2Rwwil4KWSZWU4=";
    };
  };
  git-blame = pkgs.vimUtils.buildVimPlugin {
    name = "git-blame";
    src = pkgs.fetchFromGitHub {
      owner = "f-person";
      repo = "git-blame.nvim";
      rev = "fb84fad97cd4b51caee3c865e8a33a0d413b77a8";
      sha256 = "sha256-LSGDTeDpL4nF9iKYADb86UXVEQKuaiLapSz30ygIxHo=";
    };
  };
in {
  imports = [ flake.inputs.nixvim.homeManagerModules.nixvim ];

  programs.nixvim = {
    enable = true;

    # theme
    colorschemes.catppuccin = {
      enable = true;
      settings.flavour = "mocha";
      settings.dimInactive = {
        enabled = true;
        shade = "dark";
        percentage = 0.15;
      };
      settings.integrations = {
        notify = true;
        fidget = true;
        barbar = true;
        # Enable this once dropbar in enabled
        # dropbar = {
        #   enabled = true;
        #   color_mode = false;
        # };
      };
    };

    # settings
    opts = {
      expandtab = true;
      shiftwidth = 2;
      smartindent = true;
      tabstop = 2;
      number = true;
      spell = true;
      spelllang = [ "en_us" ];
      clipboard = "unnamedplus";
      undofile = true;
      foldcolumn = "1";
      foldlevel = 99;
      foldlevelstart = 99;
      foldenable = true;
      fillchars = {
        eob = " ";
        fold = " ";
        foldopen = "";
        foldsep = " ";
        foldclose = "";
      };
    };

    luaLoader.enable = true;

    autoCmd = [
      {
        event = [ "TermOpen" ];
        pattern = [ "*" ];
        command = "startinsert";
        desc = "Enable insert mode to interact with opened terminal window";
      }
      {
        event = [ "BufRead" "BufNewFile" ];
        pattern = [ "Jenkinsfile" ];
        command = "set filetype=groovy";
        desc = "set Jenkinsfile to groovy filetype";
      }
    ];

    # keymaps
    globals = {
      mapleader  = " ";
      better_whitespace_ctermcolor = "black";
      better_whitespace_guicolor = "#EF5350";
    };

    keymaps = [
      {
        key = "<leader>ft";
        action = "<cmd>Telescope buffers<cr>";
        options = { desc = "nvim tabs"; };
      }
      {
        key = "<leader>e";
        action = "<cmd>Neotree toggle<cr>";
        options = { desc = "toggle neotree"; };
      }
      {
        key = "<leader>ff";
        action = "<cmd>Telescope live_grep<cr>";
        options = { desc = "file live grep"; };
      }
      {
        key = "<leader>gd";
        action = "<cmd>lua require('telescope.builtin').git_status()<cr>";
        options = { desc = "git status"; };
      }
      {
        key = "<leader>gg";
        action = "<cmd>terminal lazygit<cr>";
        options = { desc = "lazygit"; };
      }
      {
        key = "<leader><Tab>";
        action = "<cmd>BufferLineCycleNext<cr>";
        options = { desc = "switch to next buffer"; };
      }
      {
        key = "<leader><S-Tab>";
        action = "<cmd>BufferLineCyclePrev<cr>";
        options = { desc = "switch to previous buffer"; };
      }
      {
        key = "<leader>bp";
        action = "<cmd>BufferLinePick<cr>";
        options = { desc = "pick buffer"; };
      }
      {
        key = "<leader>bc";
        action = "<cmd>BufferLinePickClose<cr>";
        options = { desc = "pick buffer to close"; };
      }
      {
        key = "<leader>x";
        action = "<cmd>bd<cr>";
        options = { desc = "close buffer"; };
      }
      {
        key = "<leader>q";
        action = "<cmd>bd!<cr>";
        options = { desc = "close current buffer"; };
      }
      {
        key = "<leader>p";
        action = "<cmd>Telescope projects<cr>";
        options = { desc = "open projects"; };
      }
      {
        key = "//";
        action = ":noh<CR>";
        options = {
          desc = "disable highlighting";
          silent = true;
        };
      }
      {
        key = "<leader>ll";
        action = "<cmd>lua require('lsp_lines').toggle()<CR>";
        options = { desc = "toggle lsp lines"; };
      }
      {
        key = "<leader>la";
        action = "<cmd>lua vim.lsp.buf.code_action()<CR>";
        options = { desc = "open code action"; };
      }
      {
        key = "<leader>lh";
        action = "<cmd>lua vim.lsp.buf.hover()<CR>";
        options = { desc = "open hover definition"; };
      }
      {
        key = "<leader>ld";
        action = "<cmd>lua vim.lsp.buf.definition()<CR>";
        options = { desc = "goto definition"; };
      }
      {
        key = "<leader><S-p>";
        action = "<cmd>Telescope commands<CR>";
        options = { desc = "list commands"; };
      }
      {
        key = "<leader>b]";
        action = "<cmd>BufferLineMoveNext<CR>";
        options = { desc = "move buffer tab to right"; };
      }
      {
        key = "<leader>b[";
        action = "<cmd>BufferLineMovePrev<CR>";
        options = { desc = "move buffer tab to left"; };
      }
      {
        key = "<leader>gs";
        action = "<cmd>Gitsigns preview_hunk<CR>";
        options = { desc = "Preview changes under cursor"; };
      }
      {
        key = "<leader>gw";
        action = "<cmd>Gitsigns toggle_deleted<CR>";
        options = { desc = "Show deleted lines"; };
      }
      {
        key = "<leader>n";
        action = "<cmd>enew<CR>";
        options = { desc = "open new buffer"; };
      }
    ];
    plugins = {

      # UI
      # plugins.bufferline.settings.highlights.tab_separator_selected
      lualine.enable = true;
      bufferline = {
        enable = true;
        settings = {
          highlights = {
            tab_separator_selected = {
              underline = true;
              sp = "red";
            };
          };
          options = {
            diagnostics = "nvim_lsp";
            separatorStyle = "slope";
            offsets = [{
              filetype = "neo-tree";
              text = "File Explorer";
              highlight = "Directory";
              separator = true;
            }];
          };
        };
      };
      treesitter = {
        enable = true;
        nixGrammars = true;
      };
      barbecue = {
        enable = true;
        theme = "catppuccin-mocha";
      };
      ts-context-commentstring.enable = true;
      hmts.enable = true; # Enables syntax highlighting inside string
      which-key.enable = true;
      gitsigns.enable = true;
      diffview.enable = true;
      notify.enable = true;
      trouble.enable = true;
      #lsp-format.enable = true;
      inc-rename.enable = true;
      fidget = {
        enable = true;
        notification = { window = { winblend = 0; }; };
        integration = { nvim-tree = { enable = false; }; };
      };
      lspkind.enable = true;
      lsp-lines.enable = true;
      comment.enable = true;
      wilder = {
        enable = true;
        modes = [ "/" ];
      };
      vim-matchup.enable = true;
      markdown-preview.enable = true;
      nix.enable = true;
      nvim-autopairs = { enable = true; };
      todo-comments = {
        enable = true;
        settings = {
          highlight = {
            comments_only = true;
          };
        };
      };
      project-nvim = {
        enable = true;
        enableTelescope = true;
      };
      cmp = {
        enable = true;
        settings = {
          sources = [
            {
              name = "nvim_lsp";
              group_index = 1;
            }
            {
              name = "buffer";
              group_index = 2;
            }
            { name = "treesitter"; }
            { name = "async_path"; }
            { name = "nvim_lsp_signature_help"; }
            { name = "spell"; }
          ];
          mapping = {
            "<Tab>" = "cmp.mapping(cmp.mapping.select_next_item(), {'i', 's'})";
            "<S-Tab>" =
              "cmp.mapping(cmp.mapping.select_prev_item(), {'i', 's'})";
            "<CR>" = "cmp.mapping.confirm({ select = true })";
          };
        };
      };

      noice = {
        enable = true;
        presets = {
          bottom_search = true;
          command_palette = true;
          long_message_to_split = true;
          inc_rename = true;
        };
      };

      telescope = {
        enable = true;
        keymaps = {
          "<leader><space>" = {
            options.desc = "file finder";
            action = "find_files";
          };
        };
        extensions = {
          fzf-native = {
            enable = true;
            settings.caseMode = "ignore_case";
          };
          frecency.enable = true;
          undo.enable = true;
        };
      };

      # Dev
      lsp = {
        enable = true;
        servers = {
          hls.enable = true;
          marksman.enable = true;
          nil-ls.enable = true;
          bashls.enable = true;
          lua-ls.enable = true;
          rust-analyzer = {
            enable = true;
            installCargo = false;
            installRustc = false;
          };
        };
      };

      neo-tree = {
        enable = true;
        autoCleanAfterSessionRestore = true;
        closeIfLastWindow = false;
        eventHandlers = {
          file_opened = ''
            function(file_path)
              --auto close
              require("neo-tree").close_all()
            end
          '';
        };
      };

      mini = {
        enable = true;
        modules = {
          indentscope = { };
          surround = { };
          starter = {
            items = [
              { __raw = "require('mini.starter').sections.builtin_actions()"; }
              {
                name = "Projects";
                action = "Telescope projects";
                section = "Telescope";
              }
              {
                name = "Files";
                action = "Telescope find_files";
                section = "Telescope";
              }
              {
                name = "Live Grep";
                action = "Telescope live_grep";
                section = "Telescope";
              }
              {
                __raw =
                  "require('mini.starter').sections.recent_files(10, false, false)";
              }
            ];
          };
          move = { };
        };
      };

      # plugins.conform-nvim.settings.formatters_by_ft
      conform-nvim = {
        enable = true;
        settings = {
        formattersByFt = {
          lua = [ "stylua" ];
          python = [ "black" ];
          javascript = [ "prettierd" ];
          ts = [ "prettierd" ];
          json = [ "jq" ];
          markdown = [ "prettierd" ];
          nix = [ "nixfmt" ];
          cabal = [ "cabal-fmt" ];
          rust = [ "rustfmt" ];
          haskell = [ "hindent" ];
          make = [ "cmake_format" ];
          yaml = [ "prettierd" ];
          "*" = [ "codespell" ];
          "_" = [ "trim_whitespace" ];
          };
        formatters = {
          hindent = { command = "/Users/abhishek/.nix-profile/bin/hindent"; };
          cabal-fmt = {
            command = "/Users/abhishek/.nix-profile/bin/cabal-fmt";
          };
        };
        };
      };
      zen-mode = {
        enable = true;
        settings = {
          window = { width = 0.85; };
          plugins = { tmux.enabled = true; };
        };
      };
      nvim-ufo.enable = true;
      rainbow-delimiters = {
        enable = true;
        highlight = [
          "RainbowDelimiterRed"
          "RainbowDelimiterYellow"
          "RainbowDelimiterBlue"
          "RainbowDelimiterOrange"
          "RainbowDelimiterViolet"
          "RainbowDelimiterCyan"
        ];
      };

      #lazy = {
      #  enable = true;
      #  plugins = [{ pkg = kanagawa; }];
      #};
    };

    extraConfigLua =
      #lua
      ''
        require("sad").setup()
        require("dressing").setup({})
        require("git-conflict").setup({})
        require('telescope').load_extension('themes')
        wilder.set_option('renderer', wilder.popupmenu_renderer(
          wilder.popupmenu_border_theme({
            highlights = {
              border = 'Normal',
            },
            border = 'rounded',
            pumblend = 20,
          })
        ))
        vim.api.nvim_create_user_command("Format", function(args)
          local range = nil
          if args.count ~= -1 then
            local end_line = vim.api.nvim_buf_get_lines(0, args.line2 - 1, args.line2, true)[1]
            range = {
              start = { args.line1, 0 },
              ["end"] = { args.line2, end_line:len() },
            }
          end
          require("conform").format({ async = false, lsp_fallback = true, range = range })
        end, { range = true })
        local builtin = require 'statuscol.builtin'
        require('statuscol').setup {
          relculright = true,
          segments = {
            { text = { builtin.foldfunc }, click = 'v:lua.ScFa' },
            { text = { '%s' }, click = 'v:lua.ScSa' },
            { text = { builtin.lnumfunc, ' ' }, click = 'v:lua.ScLa' },
          }
        }
      '';

    extraPlugins = with pkgs.vimPlugins; [
      vim-visual-multi # Multi-Cursor edits
      guihua # sad-nvim dependency
      sad-nvim # Find and replace across project
      vim-resize-mode # Faster resize
      zen-mode-nvim # Fullscreen buffer
      dressing-nvim # UI for input and dropdown
      vim-better-whitespace # Highlight whitespaces
      git-conflict-nvim # Solve git conflicts
      telescope-themes # Preview themes
      vim-startuptime # Profile startup time
      git-blame #for blamming who did that
      kanagawa # colorscheme
      statuscol-nvim # Needed to remove fold numbers on sidebar
      # dropbar-nvim # Try once neovim is upgraded to 0.10
      # (pkgs.vimUtils.buildVimPlugin {
      #   name = "tmuxjump";
      #   src = pkgs.fetchFromGitHub {
      #     owner = "shivamashtikar";
      #     repo = "tmuxjump.vim";
      #     rev = "17a0bda4264c9a69810193e0625e06180dba9339";
      #     sha256 = "sha256-tMwB/U74aawoXaev/ySQXtNWSi28JWxV80hoHyO8KXk=";
      #   };
      # })
    ];
  };
}
