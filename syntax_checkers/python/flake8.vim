"============================================================================
"File:        flake8.vim
"Description: Syntax checking plugin for syntastic.vim
"Authors:     Sylvain Soliman <Sylvain dot Soliman+git at gmail dot com>
"             kstep <me@kstep.me>
"
"============================================================================
function! SyntaxCheckers_python_flake8_IsAvailable()
    return executable('flake8')
endfunction

function! SyntaxCheckers_python_flake8_GetHighlightRegex(i)
    if match(a:i['text'], 'is assigned to but never used') > -1
                \ || match(a:i['text'], 'imported but unused') > -1
                \ || match(a:i['text'], 'undefined name') > -1
                \ || match(a:i['text'], 'redefinition of') > -1
                \ || match(a:i['text'], 'referenced before assignment') > -1
                \ || match(a:i['text'], 'duplicate argument') > -1
                \ || match(a:i['text'], 'after other statements') > -1
                \ || match(a:i['text'], 'shadowed by loop variable') > -1

        let term = split(a:i['text'], "'", 1)[1]
        return '\V\<'.term.'\>'
    endif
    return ''
endfunction

function! SyntaxCheckers_python_flake8_GetLocList()
    let makeprg = syntastic#makeprg#build({
                \ 'exe': 'flake8',
                \ 'subchecker': 'flake8' })
    let errorformat = '%E%f:%l: could not compile,%-Z%p^,%E%f:%l:%c: %m,%W%f:%l: %m,%-G%.%#'
    return SyntasticMake({ 'makeprg': makeprg, 'errorformat': errorformat })
endfunction

call g:SyntasticRegistry.CreateAndRegisterChecker({
    \ 'loclistFunc': function("SyntaxCheckers_python_flake8_GetLocList"),
    \ 'highlightRegexFunc': function("SyntaxCheckers_python_flake8_GetHighlightRegex"),
    \ 'filetype': 'python',
    \ 'name': 'flake8',
    \ 'isAvailableFunc': function("SyntaxCheckers_python_flake8_IsAvailable")} )
