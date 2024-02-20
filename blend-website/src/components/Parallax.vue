<template>
	<div class="parallax" :style="image" style="width: 100%; overflow-x: hidden!important;">
		<slot></slot>
	</div>
</template>

<script>
	export default {
		props: {
			image: {
				type: Object,
				required: true,
			},
			height: {
				type: String,
				default: "500px",
				required: false,
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
		},
	};
</script>

<style>
	.parallax {
		/* Set a specific height */
		min-height: v-bind(height);

		/* Create the parallax scrolling effect */
		background-attachment: fixed;
		background-position: center;
		background-repeat: no-repeat;
		background-size: cover;
		/* background-blend-mode: overlay; */
		box-shadow: inset 0 0 0 2000px rgba(v-bind(overlayColor), v-bind(opacity));
	}
</style>
