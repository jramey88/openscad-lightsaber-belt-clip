@echo off
echo Building lightsaber belt clip model
echo Started at %date%-%time%

set outpath=renders
set models=(belt_clip_knob belt_clip_face belt_clip_spring belt_clip_body belt_clip_hook)
rem set models=(belt_clip_knob)

if not exist "%outpath%" mkdir "%outpath%"

for %%m in %models% do (
	echo Rendering %%m
	"C:\Program Files\OpenSCAD\openscad.com" -o "%outpath%\%%m.stl" -D "render_model_name=\"%%m\"" belt_clip.scad
	echo "Generated %outpath%\%%m.stl"
)

echo Finished at %date%-%time%
pause