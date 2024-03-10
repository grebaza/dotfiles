venv_up(){
  . env/bin/activate && [ -f .env ] && { set -a; . .env; set +a; }
}

venv_down(){
  while read p; do
    echo "unset $p"
    unset $p
  done < <(sed -e '/^\s*#/d;s/^\(.*\)=.*$/\1/' .env)
  deactivate
}
