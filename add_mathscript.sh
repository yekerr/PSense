if [ "$(uname)" == "Darwin" ]; then
    echo 'export PATH=/Applications/Mathematica.app/Contents/MacOS:$PATH' >> ~/.bash_profile      
elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
    # Do something under GNU/Linux platform
elif [ "$(expr substr $(uname -s) 1 10)" == "MINGW32_NT" ]; then
    setx path "%path%;%ProgramFiles%\Wolfram Research\Mathematica\11.1\wolfram"
elif [ "$(expr substr $(uname -s) 1 10)" == "MINGW64_NT" ]; then
    setx path "%path%;%ProgramFiles%\Wolfram Research\Mathematica\11.1\wolfram"
fi