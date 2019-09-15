const Konva = require('konva');
const convertTo = require('../helpers/index').Utils.convertTo;

export class ImageS extends Konva.Shape {
	constructor(config) {
		super(config);
		this.origWidth = config.origWidth || 0;
		this.origHeight = config.origHeight || 0;
		this.unit = config.unit || "px";
		this.file = config.file || "";
	}

	convertPX(unit) {
		return {
			width: () => Math.round(convertTo({ from: "px", to: unit }, this.width(), 72)),
			height: () => Math.round(convertTo({ from: "px", to: unit }, this.height(), 72)),
			file: this.file
		}
	}
}