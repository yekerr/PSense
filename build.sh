if [ "$(uname)" == "Darwin" ]; then
    echo 'export PATH="/Applications/Mathematica.app/Contents/MacOS:$PATH"' >> ~/.bash_profile      
elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
    cd .
    # echo 'export PATH="/usr/local/Wolfram/Mathematica/11.1:$PATH"' >> ~/.bash_profile
    # echo 'export PATH="/usr/local/Wolfram/Mathematica/11.2:$PATH"' >> ~/.bash_profile
elif [ "$(expr substr $(uname -s) 1 10)" == "MINGW32_NT" ]; then
    setx path "%path%;%ProgramFiles%\Wolfram Research\Mathematica\11.1\wolfram"
elif [ "$(expr substr $(uname -s) 1 10)" == "MINGW64_NT" ]; then
    setx path "%path%;%ProgramFiles%\Wolfram Research\Mathematica\11.1\wolfram"
fi

if [ "$(uname)" == "Darwin" ] || [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
    echo "alias psense='python3 $PWD/psense.py'" >> ~/.bash_profile     
fi
