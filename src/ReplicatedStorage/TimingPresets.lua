local TimingPresets = {
	["Lenient"] = { ---Robeats Accuracy stage 1
		NoteBadMaxMS = 142;
		NoteBadMinMS = -142;

		NoteGoodMaxMS = 118;
		NoteGoodMinMS = -118;

		NoteGreatMaxMS = 88;
		NoteGreatMinMS = -88;

		NotePerfectMaxMS = 55;
		NotePerfectMinMS = -55;

		NoteMarvelousMaxMS = 16;
		NoteMarvelousMinMS = -16;
	},
	["Standard"] = { --Stepmania J4
		NoteBadMaxMS = 136;
		NoteBadMinMS = -136;
		
		NoteGoodMaxMS = 112;
		NoteGoodMinMS = -112;
		
		NoteGreatMaxMS = 82;
		NoteGreatMinMS = -82;
		
		NotePerfectMaxMS = 49;
		NotePerfectMinMS = -49;
		
		NoteMarvelousMaxMS = 16;
		NoteMarvelousMinMS = -16;
	},
	["Strict"] = { --Stepmania Judge 5, slight modification
		NoteBadMaxMS = 130;
		NoteBadMinMS = -130;

		NoteGoodMaxMS = 106;
		NoteGoodMinMS = -106;

		NoteGreatMaxMS = 76;
		NoteGreatMinMS = -76;

		NotePerfectMaxMS = 36;
		NotePerfectMinMS = -36;

		NoteMarvelousMaxMS = 16;
		NoteMarvelousMinMS = -16;
	},
	["Extreme"] = { --Stepmania judge 7
		NoteBadMaxMS = 90;
		NoteBadMinMS = -90;

		NoteGoodMaxMS = 68;
		NoteGoodMinMS = -68;

		NoteGreatMaxMS = 45;
		NoteGreatMinMS = -45;

		NotePerfectMaxMS = 23;
		NotePerfectMinMS = -23;

		NoteMarvelousMaxMS = 11;
		NoteMarvelousMinMS = -11;
	}
}

return TimingPresets
