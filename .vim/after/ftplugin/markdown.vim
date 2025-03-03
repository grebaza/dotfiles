" enable text objects inside markdown (useful for Pandoc work)
" see 'text objects' at https://github.com/lervag/vimtex?tab=readme-ov-file#features
call vimtex#options#init()
call vimtex#text_obj#init_buffer()

omap <silent><buffer> i$ <plug>(vimtex-i$)
omap <silent><buffer> a$ <plug>(vimtex-a$)
xmap <silent><buffer> i$ <plug>(vimtex-i$)
xmap <silent><buffer> a$ <plug>(vimtex-a$)
