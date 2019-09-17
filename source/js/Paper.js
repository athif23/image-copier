const Konva = require('konva');
const convertTo = require('../helpers/index').Utils.convertTo;
const jsPDF = require('jspdf');
// DEFAULT VALUES
const DEFAULT_SIZE = {
	width: 400,
	height: 600
};
const DEFAULT_MARGIN = { x: 25, y: 25 };
const DEFAULT_SPACE = { x: 1, y: 1 };

export class PaperS extends Konva.Shape {
	constructor(config) {
		super(config);
		this.unit = config.unit || "mm";
		this.image = config.image || {};
		this.copies = config.copies || 1;
		this.margin = config.margin || DEFAULT_MARGIN;
		this.space = config.space || DEFAULT_SPACE;
		this.autoFit = config.autoFit || false;
		this.autoFill = config.autoFill || false;
		this.justifyContent = config.justifyContent || false;
		this.lockAspectRatio = config.lockAspectRatio || false;
		this.dpi = config.dpi || 72;
		this._isChanged = false;
		this._scaleBy = 1.1;
	}

	/* Convert config's unit to @unit. 
	   Used in jsPDF's renderer */
	_convertThis(unit) {
		// We don't want to change the real config, as it's need to be always px.
		return {
			size: {
				width: Math.round(convertTo({ from: "px", to: unit }, this.width(), this.dpi)),
				height: Math.round(convertTo({ from: "px", to: unit }, this.height(), this.dpi))
			},
			margin: {
				x: (convertTo({ from: "px", to: unit }, this.margin.x, this.dpi)),
				y: (convertTo({ from: "px", to: unit }, this.margin.y, this.dpi))
			},
			space: {
				x: (convertTo({ from: "px", to: unit }, this.space.x, this.dpi)),
				y: (convertTo({ from: "px", to: unit }, this.space.y, this.dpi))
			}
		}
	}
	
	/* Margin lines */
	_marginLines(shape) {
		if (this._groupMarginLines && !this._isChanged) return;
		this._groupMarginLines && this._groupMarginLines.destroy()

		let margin = [this.margin.x, this.margin.y]
		let dashLines = [3,3];

		this._groupMarginLines = new Konva.Group();

		const leftSide = new Konva.Line({
			points: [this.x() + margin[0], this.y(), this.x() + margin[0], this.y() + this.height() + 1],
			stroke: 'green',
			strokeWidth: 1,
			lineJoin: 'round',
			dash: dashLines
		});

		const rightSide = new Konva.Line({
			points: [this.x() + this.width() - margin[0], this.y(), this.x() + this.width() - margin[0], this.y() + this.height() + 1],
			stroke: 'green',
			strokeWidth: 1,
			lineJoin: 'round',
			dash: dashLines
		});

		const topSide = new Konva.Line({
			points: [this.x(), this.y() + margin[1], this.x() + this.width(), this.y() + margin[1]],
			stroke: 'green',
			strokeWidth: 1,
			lineJoin: 'round',
			dash: dashLines
		});

		const bottomSide = new Konva.Line({
			points: [this.x(), this.y() + this.height() - margin[1], this.x() + this.width(), this.y() + this.height() - margin[1]],
			stroke: 'green',
			strokeWidth: 1,
			lineJoin: 'round',
			dash: dashLines
		});

		this._groupMarginLines.add(leftSide);
		this._groupMarginLines.add(rightSide);
		this._groupMarginLines.add(topSide);
		this._groupMarginLines.add(bottomSide);

		shape.getLayer().add(this._groupMarginLines)
  	}

  	/* Function to calculate all stuff for the funcs' renderer */
	_calculateRender(ispdf, config) {
		const { margin, space, image, justifyContent } = config;
		const x = !ispdf ? this.x() : 0,
			  y = !ispdf ? this.y() : 0,
			  width = ispdf ? config.size.width : this.width(),
			  height = ispdf ? config.size.height : this.height();

		const paperSizeW = width - margin.x * 2;
		const paperSizeH = height - margin.y * 2;
		
		let imagesInC = Math.trunc(paperSizeW / (image.width() + space.x)), 
			imagesInR = Math.trunc(paperSizeH / (image.height() + space.y)), 
			imagesInRC = 0,
			imagesInRR = 0;
		
		let totalImagesInColumn = (imagesInC * (image.width() + space.x));
		
		let remainSpace = (paperSizeW - totalImagesInColumn);
		// Do the remain space bigger or equal to image's height...
		if (remainSpace >= image.height()) {
			imagesInRC = remainSpace === image.height() ? 1 : Math.trunc(remainSpace / (image.height() + space.x));
			imagesInRR = paperSizeH === image.width() ? 1 : Math.trunc(paperSizeH / (image.width() + space.y));
		}

		if (justifyContent) {
			totalImagesInColumn = (imagesInRC * image.height()) + (imagesInC * (image.width()));
			space.x = (paperSizeW - totalImagesInColumn) / (imagesInRC + imagesInC - 1)
		}
		
		return {
			x,
			y,
			width,
			height,
			paperSizeW,
			paperSizeH,
			imagesInR,
			imagesInRR,
			imagesInC,
			imagesInRC,
			totalImagesInColumn,
			remainSpace
		};
	}

	/* When autoFill is true */
	_autoFillRenderer(shape, ispdf, config) {
		if (this._groupOfImages && !this._isChanged) return;
		this._groupOfImages && this._groupOfImages.destroy()

		const { margin, space, image, justifyContent } = config;

		if (!!image.file === false) return;

		const {
			x,
			y,
			width,
			height,
			paperSizeW,
			paperSizeH,
			imagesInR,
			imagesInRR,
			imagesInC,
			imagesInRC,
			remainSpace,
		} = this._calculateRender(ispdf, config);
		
		(!ispdf && (this._groupOfImages = new Konva.Group()));
		
		let posX = x + margin.x,
			posY = y + margin.y,
			lposX = posX;
		
		// Normal
		if (imagesInC > 0) {
			for (let i = 1; i <= imagesInR; i++) {
				for (let j = 1; j <= imagesInC; j++) {
					if (!ispdf) {
						let newImage = new Konva.Image({
							image: image.file,
							x: posX,
							y: posY,
							width: image.width(),
							height: image.height()
						});
						this._groupOfImages.add(newImage);
					} else {
						shape.addImage(image.file, 'JPEG', posX, posY, image.width(), image.height())
					}

					posX += image.width() + space.x;
					lposX = posX;
				}
				posX = x + margin.x
				posY += image.height() + space.y;
			}
		}
		
		// Rotated
		posY = ispdf ? (y + margin.y - image.height()) : (y + margin.y);
		if (imagesInRC > 0) {
			for (let i = 1; i <= imagesInRC; i++) {
				for (let j = 1; j <= imagesInRR; j++) {
					if (!ispdf) {
						let rImage = new Konva.Image({
							image: image.file,
							x: lposX,
							y: posY,
							width: image.width(),
							height: image.height()
						});
						rImage.offsetY(image.height())
						rImage.rotate(90);
						this._groupOfImages.add(rImage);
					} else {
						shape.addImage(image.file, 'JPEG', lposX, posY, image.width(), image.height(), '', 'NONE', 270)
					}

					posY += image.width() + space.y;
				}
				posY = ispdf ? (y + margin.y - image.height()) : (y + margin.y);
				lposX += image.height() + space.x;
			}
		}
		
		if (imagesInC * imagesInR > 25) {
			this._groupOfImages.cache();
			this.isCached = true;
		}

		(!ispdf && (shape.getLayer().add(this._groupOfImages)));
		this._isChanged = false;
	}

	/* When autoFill is false and copies > 0 */
	_normalRenderer(shape, ispdf, config) {
		if (this._groupOfImages && !this._isChanged) return;
		this._groupOfImages && this._groupOfImages.destroy()

		const { margin, space, image, justifyContent } = config;

		if (!!image.file === false) return;

		const {
			x,
			y,
			width,
			height,
			paperSizeW,
			paperSizeH,
			imagesInR,
			imagesInRR,
			imagesInC,
			imagesInRC,
			remainSpace,
		} = this._calculateRender(ispdf, config);

		this._overSize = false;
		(this._removeSizeAlert && this._removeSizeAlert());

		if (imagesInC <= 0 && imagesInRC <= 0) {
			this._overSize = true;
			this._removeSizeAlert = this._showAlertBox('size', "Size is too big! This paper can't contain it.", "Use bigger paper or just make image smaller.");
			return;
		}

		(!ispdf && (this._groupOfImages = new Konva.Group()));

		let copies = this.copies,
			posX = x + margin.x,
			posY = y + margin.y,
			lposX = posX;

		// If there's something to copy
		if (copies > 0) {
			// Save the copies limit to check on "files-field.imba"
			this._copiesLimit = imagesInC * imagesInR + imagesInRR * imagesInRC;
			(this._removeCopiesAlert && this._removeCopiesAlert());

			// Normal
			for (let i = 1; i <= this.copies; i++) {
				if (i > (imagesInC * imagesInR)) {
					break;
				}

				if (!ispdf) {
					let newImage = new Konva.Image({
						image: image.file,
						x: posX,
						y: posY,
						width: image.width(),
						height: image.height()
					});
					this._groupOfImages.add(newImage);
				} else {
					shape.addImage(image.file, 'JPEG', posX, posY, image.width(), image.height())
				}

				if ((i % imagesInC) === 0) {
					// Save the latest x position
					lposX = posX + image.width() + space.x;
					posX = x + margin.x;
					posY += image.height() + space.y;
				} else {
					posX += image.width() + space.x;
				}

				copies--;
			}

			// Rotated
			posY = ispdf ? (y + margin.y - image.height()) : (y + margin.y);
			for (let i = 1; i <= copies; i++) {
				if (i > (imagesInRC * imagesInRR)) {
					this._removeCopiesAlert = this._showAlertBox('copies');
					break;
				}
				if (!ispdf) {
					let rImage = new Konva.Image({
						image: image.file,
						x: lposX,
						y: posY,
						width: image.width(),
						height: image.height()
					});
					rImage.offsetY(image.height())
					rImage.rotate(90);
					this._groupOfImages.add(rImage);
				} else {
					shape.addImage(image.file, 'JPEG', lposX, posY, image.width(), image.height(), '', 'NONE', 270)
				}
				if ( (i % imagesInRR) === 0 ) {
					posY = ispdf ? (y + margin.y - image.height()) : (y + margin.y);
					lposX += image.height() + space.x;
				} else {
					posY += image.width() + space.y;
				}
			}
		}

		if (imagesInC * imagesInR > 25) {
			this._groupOfImages.cache();
			this.isCached = true;
		}

		(!ispdf && (shape.getLayer().add(this._groupOfImages)));
		this._isChanged = false;
	}
	
	/* Print to canvas */
	_sceneFunc(ctx, shape) {
		const { margin, space, justifyContent } = this;

		ctx.beginPath();
	    ctx.rect(0, 0, shape.getAttr('width'), shape.getAttr('height'));

		// Draw margin lines
	    this._marginLines(shape)
	    
	    if (this.image.width() <= 0 || this.image.height() <= 0) {
	    	this._zeroSize = this._showAlertBox('size', "Sizes is too small.", "Can't be lower than 1.")
	    } else {
	    	this._zeroSize && this._zeroSize()
	    }

		if (this.autoFill) {
			// Remove alert box and warning style
			this._removeCopiesAlert && this._removeCopiesAlert()
			document.querySelector('div.copies').classList.remove('warning')

			this._autoFillRenderer(shape, false, { margin, space, image: this.image, justifyContent });
		} else if (!this.autoFill && this.copies >= 1) {
			this._normalRenderer(shape, false, { margin, space, image: this.image, justifyContent });
		}

	    ctx.fillStrokeShape(shape);
	}

	/* Print to pdf file */
	_printPDF(filename) {
		let jspdf = new jsPDF({
			orientation: "p",
			unit: this.unit,
			format: "a4",
			putOnlyUsedFonts: true
		});

		let { margin, space, size } = this._convertThis(this.unit);
		const image = this.image.convertPX(this.unit);

		if (image.file.result) {
			image.file = jspdf.extractImageFromDataUrl(image.file.result).data;
		}

		this._isChanged = true;

		if (this.autoFill) {
			this._autoFillRenderer(jspdf, true, { size, margin, space, image, justifyContent: this.justifyContent });
		} else if (!this.autoFill && this.copies >= 1) {
			this._normalRenderer(jspdf, true, { size, margin, space, image, justifyContent: this.justifyContent });
		}

		let button = document.querySelector('.generate-button');
		this._isLoading = true;
		button.classList.add('loading')

		// Just to make it a litle bit cooler
		setTimeout(() => {
			jspdf.save(`${filename}.pdf`, { returnPromise: true }).then(data => {
				button.classList.remove('loading');
				this._isLoading = false;
				Imba.commit()
			});
		}, 2000)

		this._isChanged = true;
	}

	// Creating alert box to element
	_showAlertBox(elementId, text1, text2) {
		let className = elementId
		if (elementId === 'size') className = 'height';

		let element = document.querySelector(`div.${className}`);
		if (element && element.querySelector('div.alertBox')) element.querySelector('div.alertBox').remove()

 		let alertBox = document.createElement('div');
		alertBox.className = "alertBox";
		alertBox.style.left = `${element.getBoundingClientRect().x + element.getBoundingClientRect().width + 15}px`;
		alertBox.style.transform = "translateY(-30px)";

		let p = document.createElement("p"),
			p1 = document.createElement("p"),
			warningText = document.createTextNode(text1 || "Too much! It's getting out of the paper."),
			warningText1 = document.createTextNode(text2 || "Use 'Auto Fill' if you don't know the limit.")
		
		p1.className = "small-info";
		p.appendChild(warningText)
		p1.appendChild(warningText1)
		alertBox.appendChild(p)
		alertBox.appendChild(p1)

		// <
		let arrow = document.createElement('div');
		arrow.className = 'small-arrow';

		alertBox.appendChild(arrow);
		element.appendChild(alertBox)

		if (elementId === 'size') {
			element.parentNode.classList.add('warning')
		} else {
			element.classList.add('warning');
		}

		alertBox.addEventListener('click', (e) => {
			alertBox.remove();
		})

		// Return function to remove the alert box.
		return () => {
			alertBox.remove();

			if (elementId === 'size') {
				element.parentNode.classList.remove('warning');
			} else {
				element.classList.remove('warning');
			}
		}
	}

	_zoom(state, isBtn) {
		let oldScale = this.getStage().scaleX(),
			pointerPos;

		if (oldScale > 2 && this.isCached) {
			this._groupOfImages.clearCache();
		} else if (this.isCached){
			this._groupOfImages.cache();
		}

		if (!isBtn) {
			pointerPos = {
				x: this.getStage().getPointerPosition().x,
				y: this.getStage().getPointerPosition().y
			}
		} else {
			pointerPos = {
				x: this.getStage().width() / 2,
				y: this.getStage().height() / 2
			}
		}

		let mousePointTo = {
			x: pointerPos.x / oldScale - this.getStage().x() / oldScale,
			y: pointerPos.y / oldScale - this.getStage().y() / oldScale
		}

		let newScale = state === 'in' ? (oldScale * this._scaleBy) : (oldScale / this._scaleBy) 

		this.getStage().scale({ x: newScale, y: newScale })

		let newPos = {
			x: -(mousePointTo.x - pointerPos.x / newScale) * newScale,
			y: -(mousePointTo.y - pointerPos.y / newScale) * newScale
		}

		this.getStage().position(newPos)
		this.getStage().batchDraw()
	}

	/* SETTER FUNCTIONS */
	setDpi(val) { 
		this.dpi = val;
		this._isChanged = true;
	}
	setUnit(val) { 
		this.unit = val;
		this._isChanged = true;	
	}
	setCopies(val, unit) { 
		if (val > -1) {
			this.copies = val; 
		} else {
			this.copies = 0	
		}
		this._isChanged = true;
	}
	setMargin(val) { 
		this.margin = {
			x: val.x > (this.width() / 2) ? (this.width() / 2) - 10 : val.x,
			y: val.y > (this.height() / 2) ? (this.height() / 2) - 10 : val.y
		};
		this._isChanged = true;
	}
	setSpace(val) { 
		this.space = {
			x: val.x,
			y: val.y
		};
		this._isChanged = true;
	}
	setImageSize(val) { 
		this.image.width(val.width);
		this.image.height(val.height);
		this._isChanged = true;
	}
	setImageFile(val) { 
		this.image.file = val;
		this._isChanged = true;
	}
	setAutoFill(val) { 
		this.autoFill = !!val; 
		this._isChanged = true;
	}
	setJustifyContent(val) { 
		this.justifyContent = !!val; 
		this._isChanged = true;
	}
	setLockAspectRatio(val) { 
		this.lockAspectRatio = !!val;
		this._isChanged = true;
	}
}