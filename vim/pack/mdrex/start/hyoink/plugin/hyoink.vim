" Highlight yoinked text
"
" Created by the fine people here:
"   https://gist.github.com/girishji/a149db1c382f3631ee6006d603ba8c21
"   https://github.com/vim/vim/issues/14848
"
" Adopted by: Max Drexler
" Date: 2024-12-12
"

if !has('vim9script') ||  v:version < 900
    finish
endif

vim9script noclear

if exists('g:hyoink_loaded')
    finish
endif
g:hyoink_loaded = 1

if !exists('g:hyoink_hlgroup')
    g:hyoink_hlgroup = 'Folded'
endif

def HYoink(hlgroup = g:hyoink_hlgroup, duration = 250)
    if v:event.operator ==? 'y'
        # Don't highlight yoinks in visual mode
        if visualmode() != null_string
            visualmode(1)
            return
        endif

        var [beg, end] = [getpos("'["), getpos("']")]
        var type = v:event.regtype ?? 'v'
        var pos = getregionpos(beg, end, {type: type})
        var end_offset = (type == 'V' || v:event.inclusive) ? 1 : 0
        var m = matchaddpos(hlgroup, pos->mapnew((_, v) => {
            var col_beg = v[0][2] + v[0][3]
            var col_end = v[1][2] + v[1][3] + end_offset
            return [v[0][1], col_beg, col_end - col_beg]
        }))
        var winid = win_getid()
        timer_start(duration, (_) => m->matchdelete(winid))
    endif
enddef
augroup hyoink | autocmd!
    autocmd TextYankPost * HYoink()
augroup END
