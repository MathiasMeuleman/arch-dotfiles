set number
set relativenumber
set tabstop=4
set shiftwidth=0
set expandtab

call plug#begin('~/.local/share/nvim/plugged')

" Code formatting
Plug 'tpope/vim-sleuth'
Plug 'tmsvg/pear-tree'

" Plugins for file tree
Plug 'kyazdani42/nvim-web-devicons'
Plug 'kyazdani42/nvim-tree.lua'

" Edit restricted files with sudo automatically
Plug 'lambdalisue/suda.vim'

" Color scheme
Plug 'joshdick/onedark.vim'
" Airline
Plug 'vim-airline/vim-airline'

" CtrlP fuzzy file search
Plug 'ctrlpvim/ctrlp.vim'

" Rust plugins
Plug 'rust-lang/rust.vim'

" LSP visualize
Plug 'j-hui/fidget.nvim'

" Completions
Plug 'neovim/nvim-lspconfig'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/nvim-cmp'
" Snippet plugins
Plug 'hrsh7th/cmp-vsnip'
Plug 'hrsh7th/vim-vsnip'

call plug#end()

""""""""""""""
" Key mappings
""""""""""""""

" Leader key
let mapleader="\<Space>"

 " Move up/down display lines (with wrap on), instead of full lines
nnoremap j gj
nnoremap k gk
vnoremap j gj
vnoremap k gk   

noremap <leader><leader> <C-^>
" Resize key bindings
noremap <C-S-Left> :vertical resize -5<CR>
noremap <C-S-Right> :vertical resize +5<CR>
noremap <C-S-Up> :resize -5<CR>
noremap <C-S-Down> :resize +5<CR>

" File tree settings
nnoremap <C-m> :NvimTreeToggle<CR>
nnoremap <C-n> :NvimTreeFocus<CR>
nnoremap <leader>r :NvimTreeRefresh<CR>
nnoremap <leader>n :NvimTreeFindFile<CR>

" Tab navigation
nnoremap <leader>l :bnext<CR>
nnoremap <leader>h :bprev<CR>
nnoremap <leader>bq :bp <BAR> bd #<CR>
nnoremap <leader>bl :ls<CR>

" Add semicolon to end of line
nnoremap <leader>; m`A;<Esc>``

" Clear search query
noremap <silent> <C-_> :let @/ = ""<CR>

set completeopt=menu,menuone,noselect
""""""""""
" Auto bracket closing
""""""""""
let g:pear_tree_repeatable_expand = 0

""""""""""
" SudaVim automatically elevate permissions
""""""""""
let g:suda_smart_edit = 1

""""""""""
" Airline setup
""""""""""
set hidden
" Enable tabline view
let g:airline#extensions#tabline#enabled = 1
" Filename formatter
let g:airline#extensions#tabline#formatter = 'unique_tail_improved'

""""""""""
" Color scheme Setup
""""""""""
"Use 24-bit (true-color) mode in Vim/Neovim when outside tmux.
"If you're using tmux version 2.2 or later, you can remove the outermost $TMUX check and use tmux's 24-bit color support
"(see < http://sunaku.github.io/tmux-24bit-color.html#usage > for more information.)
if (empty($TMUX))
  if (has("nvim"))
    "For Neovim 0.1.3 and 0.1.4 < https://github.com/neovim/neovim/pull/2198 >
    let $NVIM_TUI_ENABLE_TRUE_COLOR=1
  endif
  "For Neovim > 0.1.5 and Vim > patch 7.4.1799 < https://github.com/vim/vim/commit/61be73bb0f965a895bfb064ea3e55476ac175162 >
  "Based on Vim patch 7.4.1770 (`guicolors` option) < https://github.com/vim/vim/commit/8a633e3427b47286869aa4b96f2bfc1fe65b25cd >
  " < https://github.com/neovim/neovim/wiki/Following-HEAD#20160511 >
  if (has("termguicolors"))
    set termguicolors
  endif
endif

syntax on
colorscheme onedark

"""""""""""
" Completion Setup
"""""""""""
lua << EOF
-- Completion setup.
local cmp = require'cmp'
    -- Global setup.
    cmp.setup({
      snippet = {
        expand = function(args)
          vim.fn["vsnip#anonymous"](args.body)
        end,
      },
      mapping = {
        ['<C-d>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
        ['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),
        ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
        ['<C-e>'] = cmp.mapping({
          i = cmp.mapping.abort(),
          c = cmp.mapping.close(),
        }),
       -- This little snippet will confirm with tab, and if no entry is selected, will confirm the first item
       ["<Tab>"] = cmp.mapping(function(fallback)
         if cmp.visible() then
           cmp.select_next_item()
         elseif vim.fn["vsnip#available"](1) == 1 then
           feedkey("<Plug>(vsnip-expand-or-jump)", "")
         elseif has_words_before() then
           cmp.complete()
         else
           fallback() -- The fallback function sends a already mapped key. In this case, it's probably `<Tab>`.
         end
       end, { "i", "s" }),

       ["<S-Tab>"] = cmp.mapping(function()
         if cmp.visible() then
           cmp.select_prev_item()
         elseif vim.fn["vsnip#jumpable"](-1) == 1 then
           feedkey("<Plug>(vsnip-jump-prev)", "")
         end
       end, { "i", "s" }),
       -- ["<Tab>"] = cmp.mapping(function(fallback)
       --     if cmp.visible() then
       --         local entry = cmp.get_selected_entry()
       --         if not entry then
       --             cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
       --         else
       --             cmp.confirm()
       --         end
       --     else
       --         fallback()
       --     end
       -- end, {"i","s","c",}),
        -- Accept currently selected item. If none selected, `select` first item.
        -- Set `select` to `false` to only confirm explicitly selected items.
        ['<CR>'] = cmp.mapping.confirm({ select = false }),
      },
      sources = cmp.config.sources({
        { name = 'nvim_lsp' },
        { name = 'vsnip' },
      }, {
        { name = 'buffer' },
      })
    })
    -- `/` cmdline setup.
    cmp.setup.cmdline('/', {
      sources = {
        { name = 'buffer' }
      }
    })
    -- `:` cmdline setup.
    cmp.setup.cmdline(':', {
      sources = cmp.config.sources({
        { name = 'path' }
      }, {
        { name = 'cmdline' }
      })
    })

    -- Setup lspconfig.
    local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
    
require('lspconfig').rls.setup {
  capabilities = capabilities,
  settings = {
    rust = {
      unstable_features = true,
      build_on_save = false,
      all_features = true,
    }
  }
}

require'nvim-tree'.setup {
  view = {
    auto_resize = true,
  }
}

EOF

""""""""""""
" Rust setup
""""""""""""
let g:rustfmt_autosave = 1
