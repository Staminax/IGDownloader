# IGDownloader with Python & Delphi!

This project mixes a simple python script with an even simpler and intuitive GUI interface to download photos from Instagram.

## Using
* Python 3.8
* Delphi 10.3 Rio

## Installing

Make sure to install all the requirements for the Python Script, located in the /Python folder.

```python
pip install -r requirements.txt
```

you can also generate the .exe file for the Python script so you can share with your friends that doesn't have Python on their computers!


# PyInstaller
```python
pip install pyinstaller
pip install --upgrade pyinstaller
```
# Generating the .exe version of the script
```python
pyinstaller IGDownloader.py --onefile --windowed
```
# Configuration
Make sure to have a 'Scripts' folder inside Win32/Win64(Depending on the Delphi compiled settings) and throw the Python script in there.

This configuration is not needed if you cloned the repository, since it is already structured.

You can also change the main .pas file 'uDownload.pas' to use the .py or .exe version of the script:

* .exe
```pascal
Script := 'Scripts\IGDWNLDR.exe -l ' + AResource + ' -x ' + FType;
ShellExecute(Application.Handle, 'open', 'cmd', PChar('/c ' + Script), Nil, SW_HIDE);
```

*.py
```pascal
Script := 'Scripts\IGDWNLDR.py -l ' + AResource + ' -x ' + FType;
ShellExecute(Application.Handle, 'open', 'cmd', PChar('/c ' + Script), Nil, SW_HIDE);
```
