# ===========================================================================
#   PSVirtualEnv_Ini.ps1 ----------------------------------------------------
# ===========================================================================

#   default -----------------------------------------------------------------
# ---------------------------------------------------------------------------

$default_config_string = "
; ===========================================================================
;   config.ini --------------------------------------------------------------
; ===========================================================================

; user settings -------------------------------------------------------------
; ---------------------------------------------------------------------------
[user]

; default path where virtual environments are located
venv-work-dir = 

; default download path for python packages
venv-local-dir =  

; default path for the requirements
venv-require-dir = 

; default python distribution
python = 

; internal settings ---------------------------------------------------------
; ---------------------------------------------------------------------------
[psvirtualenv]

; relative path of the virtual environement executable 
venv = Scripts\python.exe

; relative path of the virtual environement activation script 
venv-activation = Scripts\activate.ps1

; command of deactivation virtual environment
venv-deactivation = deactivate

"