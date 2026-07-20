#!/bin/bash

set -e

echo "======================================="
echo " Organizing P1-ALU Repository"
echo "======================================="

# Create directory structure
mkdir -p rtl
mkdir -p tb
mkdir -p simulation
mkdir -p results
mkdir -p docs

echo "[1/7] Moving RTL files..."

mv -f alu.v rtl/ 2>/dev/null || true
mv -f addsub.v rtl/ 2>/dev/null || true
mv -f logicop.v rtl/ 2>/dev/null || true
mv -f comparator.v rtl/ 2>/dev/null || true
mv -f shifter.v rtl/ 2>/dev/null || true

echo "[2/7] Moving testbench..."

mv -f alu_tb.v tb/ 2>/dev/null || true

echo "[3/7] Moving GTKWave layout..."

mv -f alu.gtkw simulation/ 2>/dev/null || true

echo "[4/7] Creating placeholder files..."

touch docs/.gitkeep
touch results/.gitkeep

echo "[5/7] Repository structure"

tree -L 2

echo
echo "[6/7] Git status"
git status

echo
read -p "Commit these changes? (y/n): " ans

if [[ "$ans" == "y" || "$ans" == "Y" ]]; then

    git add .

    git commit -m "Organize project directory structure"

    git push origin main

    echo
    echo "======================================="
    echo " Repository Updated Successfully!"
    echo "======================================="

else

    echo
    echo "No changes committed."

fi
