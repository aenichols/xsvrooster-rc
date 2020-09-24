syn region foldBraces start=/{\|\/\/.*{/ end=/}/ transparent fold keepend extend


setl foldmethod=syntax
set fillchars=fold:\ 


function! FoldText()

	let line = getline(v:foldstart)
	let sub = substitute(line, '{.*\|\/\/.*{.*', '{...}', '')
	
	let clrwssub = substitute(sub, '\t', '    ', 'g')
	
	let oneLessDash = strpart(string(v:folddashes),1,len(string(v:folddashes))-2)
    let foldlinecount = foldclosedend(v:foldstart) - foldclosed(v:foldstart) + 1
    let lineCount = " (" . string(foldlinecount) . " lines)"
    return clrwssub . lineCount
	
endfunction

setl foldtext=FoldText()

"set foldmethod=expr foldexpr=getline(v:lnum)=~'^\\s*'.&commentstring[0]