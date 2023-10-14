#!/bin/bash

REPO_PATH=/Users/arabica/projects/ecwid

if [ $# -ne 2 ]; then
  echo "Использование: $0 <имя_вашей_ветки> <имя_ветки_для_проверки_конфликтов_(например_stable)>"
  exit 1
fi

branch="$1"
merge_branch="$2"

git -C "$REPO_PATH" fetch

# Перейти в проверяемую ветку
git -C "$REPO_PATH" checkout $branch > /dev/null 2>&1
# git -C "$REPO_PATH" pull

# Попытаться выполнить мерж с веткой merge_branch
git -C "$REPO_PATH" merge origin/$merge_branch > /dev/null 2>&1

# Проверить статус мержа
if [ $? -ne 0 ]; then
  echo "Мерж завершился с конфликтами. Вот список конфликтующих файлов:"  
  git -C "$REPO_PATH" diff --name-only --diff-filter=U

  # Отменить мерж
  git -C "$REPO_PATH" merge --abort
  echo "Мерж отменен."
else
  if [ -f "$REPO_PATH/.git/MERGE_HEAD" ]; then
    git -C "$REPO_PATH" merge --abort	
  fi
  echo "Мерж успешно завершен без конфликтов."
fi

