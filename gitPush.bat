@echo off
git pull
git add .
set /p comment="Saisir le commentaire: "
git commit -m "%comment%"
git push