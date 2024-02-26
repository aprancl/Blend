<template>
	<div class="skewbox-parent" v-if="maintainSkewbox || windowWidth >= 1200">
		<div class="bgs">
			<div class="bg" :style="leftBG"></div>
			<div class="bg" :style="rightBG" style="right: 0 !important"></div>
		</div>
		<div class="poly--holder">
			<div class="poly-item" :style="'background: ' + leftColor">
				<div class="poly-content poly-left">
					<slot name="left"></slot>
				</div>
			</div>
			<div class="poly-item" :style="'background: ' + rightColor">
				<div class="poly-content poly-right">
					<slot name="right"></slot>
				</div>
			</div>
		</div>
	</div>
	<div v-else class="h-100">
		<div
			:style="
				'transform: scaleY(' +
				(invert ? '-' : '') +
				'1); background-position: center; background-size: cover; background-image: ' +
				(pictureSide == 'right'
					? rightBG.backgroundImage
					: leftBG.backgroundImage)
			"
			style="width: 100% !important; height: 100% !important"
		>
			<div
				:style="
					'transform: scaleY(' +
					(invert ? '-' : '') +
					'1); display: flex; align-items: center; background: ' +
					mobileColor +
					'; backdrop-filter: blur(7px); height: 100%; width: 100%;'
				"
			>
				<div class="container">
					<slot
						:name="pictureSide == 'right' ? 'left' : 'right'"
					></slot>
				</div>
			</div>
		</div>
        <div
            v-if="displayBothSides"
			:style="
				'transform: scaleY(' +
				(invert ? '-' : '') +
				'1); background-position: center; background-size: cover; background-image: ' +
				(pictureSide == 'right'
					? leftBG.backgroundImage
					: rightBG.backgroundImage)
			"
			style="width: 100% !important; height: 100% !important"
		>
			<div
				:style="
					'transform: scaleY(' +
					(invert ? '-' : '') +
					'1); display: flex; align-items: center; background: transparent; height: 100%; width: 100%;'
				"
			>
				<div class="container">
					<slot
						:name="pictureSide == 'left' ? 'left' : 'right'"
					></slot>
				</div>
			</div>
		</div>
	</div>
</template>

<script>
export default {
	props: {
		leftColor: {
			type: String,
			required: false,
			default: "var(--FSCred)",
		},
		rightColor: {
			type: String,
			required: false,
			default: "var(--FSCblue)",
		},
		leftBG: {
			type: Object,
			required: false,
			default: {},
		},
		rightBG: {
			type: Object,
			required: false,
			default: {},
		},
		divisionPosition: {
			type: Number,
			required: false,
			default: 50,
		},
		height: {
			type: Number,
			required: false,
			default: 500,
		},
		padding: {
			type: String,
			required: false,
			default: "0 0 0 0",
		},
		opacity: {
			type: Number,
			default: 0,
			required: false,
		},
		overlayColor: {
			type: String,
			default: "0, 0, 0",
			required: false,
		},
		pictureSide: {
			type: String,
			default: "right",
			required: false,
		},
        displayBothSides: {
			type: Boolean,
			default: true,
			required: false,
		},
		maintainSkewbox: {
			type: Boolean,
			default: true,
			required: false,
		},
		invert: {
			type: Boolean,
			default: false,
			required: false,
		},
		mobileColor: {
			type: String,
			default: "hsla(0, 0%, 0%, 0.6)",
			required: false,
		},
	},
	data() {
		return {
			x: 0,
			cssHeight: "",
			windowHeight: "",
			windowWidth: "",
		};
	},
	methods: {
		getWindowSize() {
			this.windowHeight = window.innerHeight;
			this.windowWidth = window.innerWidth;
		},
	},
	created() {
		window.addEventListener("resize", this.getWindowSize);
	},
	destroyed() {
		window.removeEventListener("resize", this.getWindowSize);
	},
	beforeMount() {
		this.getWindowSize();
	},
	mounted() {
		this.x = Math.tan((10 * Math.PI) / 180) * (this.height / 2) + "px";
		this.cssHeight = this.height + "px";
	},
};
</script>

<style scoped>
/*
███████ ██   ██ ███████ ██     ██ ██████   ██████  ██   ██ 
██      ██  ██  ██      ██     ██ ██   ██ ██    ██  ██ ██  
███████ █████   █████   ██  █  ██ ██████  ██    ██   ███   
     ██ ██  ██  ██      ██ ███ ██ ██   ██ ██    ██  ██ ██  
███████ ██   ██ ███████  ███ ███  ██████   ██████  ██   ██ 
*/
.skewbox-parent {
	--propHeight: v-bind(cssHeight);
	height: var(--propHeight);
	overflow: hidden;
}

.poly--holder {
	overflow: hidden !important;
	height: var(--propHeight) !important;
	transform: translateY(calc(-1 * var(--propHeight)));
	--left: calc(-1% * (100 - v-bind(divisionPosition)));
	--right: calc(1% * v-bind(divisionPosition));
	--leftWidth: calc(1vw * (v-bind(divisionPosition) - 10));
	--rightWidth: calc(1vw * ((100 - v-bind(divisionPosition)) - 10));
}

.poly--holder .poly-item {
	box-sizing: border-box;
	margin: 0;
	transform: skewX(-10deg) translateX(10px);
	-moz-transform: skewX(-10deg);
	-webkit-transform: skewX(-10deg);
	width: 100vw !important;
	height: var(--propHeight) !important;
	padding: v-bind(padding);
	z-index: 50;
}

.poly--holder .poly-item:nth-of-type(1) {
	margin: 0;
	transform: translateX(var(--left)) skewX(-10deg);
}

.poly--holder .poly-item:nth-of-type(2) {
	margin: 0;
	transform: translateX(var(--right)) translateY(calc(-1 * var(--propHeight)))
		skewX(-10deg);
}

.bgs {
	z-index: -10 !important;
	height: var(--propHeight);
	overflow-y: hidden;
}
.bg {
	width: 100% !important;
	height: var(--propHeight);
	box-shadow: inset 0 0 0 2000px rgba(v-bind(overlayColor), v-bind(opacity));
}

.bgs .bg:nth-of-type(2) {
	transform: translateY(calc(-1 * var(--propHeight)));
	float: right;
}

.poly-content {
	transform: skewX(10deg);
	padding: 1rem;
	margin-left: 2rem;
	overflow: hidden;
	height: 100%;
}

.poly-left {
	width: var(--leftWidth) !important;
	float: right;
	margin-right: calc(v-bind(x));
}

.poly-right {
	width: var(--rightWidth) !important;
	margin-left: calc(v-bind(x));
}

.row.poly--holder {
	margin: 0 !important;
}

/*
███    ███ ███████ ██████  ██  █████       ██████  ██    ██ ███████ ██████  ██ ███████ ███████ 
████  ████ ██      ██   ██ ██ ██   ██     ██    ██ ██    ██ ██      ██   ██ ██ ██      ██      
██ ████ ██ █████   ██   ██ ██ ███████     ██    ██ ██    ██ █████   ██████  ██ █████   ███████ 
██  ██  ██ ██      ██   ██ ██ ██   ██     ██ ▄▄ ██ ██    ██ ██      ██   ██ ██ ██           ██ 
██      ██ ███████ ██████  ██ ██   ██      ██████   ██████  ███████ ██   ██ ██ ███████ ███████ 
*/
@media (max-width: 1199.9px) {
	.skewbox-parent {
		--propHeight: calc((0.7 * v-bind(cssHeight)) + 1px);
	}

	.poly-content {
		padding: 0;
	}

	.poly-right {
		padding-right: 1rem;
	}

	.poly-left {
		padding-left: 1rem;
	}
}

@media (max-width: 767.9px) {
	.skewbox-parent {
		--propHeight: calc(0.6999 * v-bind(cssHeight));
	}

	.poly-content {
		padding: 0;
	}

	.poly-right {
		transform: skew(10deg) translateX(-20px);
	}

	.poly-left {
		transform: skew(10deg) translateX(20px);
	}

	.content {
		padding: 0 !important;
	}
}

@media (max-width: 575.9px) {
	.skewbox-parent {
		--propHeight: calc(0.5999 * v-bind(cssHeight));
	}

	.poly-right {
		transform: skew(10deg) translateX(-35px);
	}

	.poly-left {
		transform: skew(10deg) translateX(35px);
	}
}
</style>
