#! /bin/bash
sudo apt update

# Make passwordless sudo work
export SUDO_ASKPASS=/bin/true

# Install neovim
NVIM_VERSION=0.9.0
sudo apt install -y fuse libfuse2 sqlite3
mkdir $HOME/bin
curl -L -o $HOME/bin/nvim https://github.com/neovim/neovim/releases/download/v${NVIM_VERSION}/nvim.appimage
chmod a+x $HOME/bin/nvim


current_dir="$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)"
dotfiles_source="${current_dir}/home_files"

while read -r file; do

	relative_file_path="${file#"${dotfiles_source}"/}"
	target_file="${HOME}/${relative_file_path}"
	target_dir="${target_file%/*}"

	if test ! -d "${target_dir}"; then
		mkdir -p "${target_dir}"
	fi

	printf 'Installing dotfiles symlink %s\n' "${target_file}"
	ln -sf "${file}" "${target_file}"

done < <(find "${dotfiles_source}" -type f)

