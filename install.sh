#!/bin/sh

echo "change hypr nvim zellij p10k and zshrc?"
echo "y/n"
read -r $REPLY

while :
do
  if [[ $REPLY == "y" ]]; then
    mkdir ~/.config/bak
    mv ~/.config/hypr ~/.config/bak
    mv ~/.config/nvim ~/.config/bak
    mv ~/.config/zellij ~/.config/bak
    mv ~/.p10k.zsh ~/.config/bak
    mv ~/.zshrc ~/.config/bak

    #copy config files that aren't managed by home-manger(you crazy if you think I'll manage EVERYTHING)
    cp -r ./config/nix/* ~/.config/
    cp ./config/.p10k.zsh ~
    cp ./config/.zshrc ~

    git clone https://github.com/Grandkahuna43325/Neovim_config ~/.config/nvim

    break
  elif [[ $REPLY == "n" ]]; then
    break
  else
    echo u stupid? 'y' or 'n' ONLY
  fi
done


echo "installng flakes"
home-manager switch --flake . && sudo nixos-rebuild switch --flake .



echo "do you want to keep config/bak after installation?"
echo "if not this files will be deleted"
ls ~/.config/bak
echo "y/n"
read -r $REPLY

while :
do
  if [[ $REPLY == "y" ]]; then
    rm -fr ~/.config/bak
    break
  elif [[ $REPLY == "n" ]]; then
    break
  else
    echo u stupid? 'y' or 'n' ONLY
  fi
done
