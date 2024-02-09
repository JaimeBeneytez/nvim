return {
	'andrewradev/switch.vim',
	config = function()
		vim.cmd([[
			let g:switch_custom_definitions = [
			\   switch#NormalizedCase(['open', 'closed', 'model']),
			\   switch#NormalizedCase(['row', 'column']),
			\   switch#NormalizedCase(['correct', 'incorrect', 'suggestion']),
			\   switch#NormalizedCase(['positive', 'capitalization', 'punctuation', 'spelling', 'accuracy', 'empty' ]),
			\   switch#NormalizedCase(['audio', 'video', 'image', 'text']),
			\   switch#NormalizedCase(['foo', 'bar', 'baz']),
			\   switch#NormalizedCase(['public', 'private', 'protected', 'readonly']),
			\   switch#NormalizedCase(['block', 'inline', 'inline-block', 'flex', 'grid']),
			\ ]
		]])
	end,
}
