#!/usr/bin/bash

ISSUE_URL="https://github.com/project-portable/silver-spork/issues/4"

issue=$(echo -e $(gh issue view ${ISSUE_URL} --json body | cut -d\" -f4))

name=$(echo "${issue}" | sed -n '3p')
url=$(echo "${issue}" | sed -n '7p')
pattern=$(echo "${issue}" | sed -n '11p')

type=$(echo "${issue}" | sed -n '15p')

[ "${type}" = "Abrir um site no navegador" ] && {
  type="website"
  url=$(echo "${url}" | sed 's/{pesquisa}/%u/g')
}|| {
  [ "${type}" = "Executar um comando" ] && {
    url="exo-open --launch TerminalEmulator /usr/share/tiger-shell/scripts/enhanced-open-in-terminal ${url}"
  }
  type="command"
  url=$(echo "${url}" | sed 's/{pesquisa}/%s/g')
}

file_name=$(echo -n "${name}" | tr '[:upper:]' '[:lower:]' | tr '[:space:]' '-').yml

gh issue comment "${ISSUE_URL}" --body-file commit.md

echo -e "@daigoasuka sugestão de ação de nome \`${file_name}\` contendo:\n\n"'```'"yaml\nname: ${name}\npattern: ${pattern}\ntype: ${type}\nicon: org.xfce.terminalemulator\nurl: ${url}\n"'```' > commit.md
