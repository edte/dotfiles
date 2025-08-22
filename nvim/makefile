all:
	# mkdir -p ~/.config/nvim
	# mv ~/.config/nvim ~/.config/nvim.bk_`date +%Y-%m-%d-%H:%M:%S`
	rm -rf ~/.config/nvim
	mkdir -p ~/.config/nvim
	stow . -t ~/.config/nvim

mini:
	rm -rf ~/.config/nvim
	mkdir -p ~/.config/nvim
	ln -s ~/dotfiles/nvim/mini.lua ~/.config/nvim/init.lua

clean:
	rm -rf ~/.config/nvim

backup:
	mv ~/.config/nvim ~/.config/nvim.bk_`date +%Y-%m-%d-%H:%M:%S`
