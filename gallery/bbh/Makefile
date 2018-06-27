
PLOTS = trajectories.png waveform.png ReI.png ImI.png RePsi4.png Strain.png

-include make.conf

ifdef SIMULATIONS_DIRECTORY
PLOTFLAGS = --simulations-directory $(SIMULATIONS_DIRECTORY)
endif

all: $(PLOTS) stats.json

$(PLOTS): %.png: %.m
	MathematicaScript -script $< $(PLOTFLAGS)

stats.json: stats.m
	MathematicaScript -script $<

clean:
	rm -f $(PLOTS) stats.json
